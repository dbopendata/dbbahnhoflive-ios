//
//  AppDelegate.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 27.05.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "AppDelegate.h"

#import "FacilityStatusManager.h"

#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>

#import "MBStationNavigationViewController.h"

#import "MBStationSearchViewController.h"

#import "TimetableManager.h"

#import "MBGPSLocationManager.h"

#import "SharedMobilityAPI.h"
#import "MBMapInternals.h"

#import "MBStationNavigationViewController.h"
#import "MBTrainPositionViewController.h"
#import "MBParkingInfo.h"
#import "Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    // NSLog(@"didFinishLaunching with %@",launchOptions);
    [Constants setup];
    [self increaseAppStartCount];

    [self registerDefaultsFromSettingsBundle];

    // Setup app-wide shared cache
    NSUInteger capacity = 20 * 1024 * 1024;
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:capacity diskCapacity:capacity diskPath:nil];
    [NSURLCache setSharedURLCache:cache];
    
    [MBTrackingManager setup];


    // initialize Google Maps
    [GMSServices provideAPIKey:[MBMapInternals kGoogleMapsApiKey]];

    [self configureReportingAndAnalytics];

    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];

    self.window = [[UIWindow alloc] initWithFrame:mainScreenBounds];
    self.viewController = [[MBStationSearchViewController alloc] initWithNibName:nil bundle:nil];
    self.navigationController = [[MBStationNavigationViewController alloc] initWithRootViewController:self.viewController];

    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    if(launchOptions){
        UILocalNotification* notif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if(notif){
            [self handleLocalNotification:notif];
        }
    }
    
    
    
   
    return YES;
}

- (void) configureReportingAndAnalytics
{
    
    BOOL trackingEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled_tracking"] boolValue];
    [MBTrackingManager setOptOut:!trackingEnabled];
}

- (NSDictionary*) selectedStation
{
    MBStationSearchViewController* vc = (MBStationSearchViewController*) self.viewController;
    return vc.selectedStation;
}



- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // NSLog(@"didRegisterUserNotificationSettings:");
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USERSETTINGS_REGISTERED object:notificationSettings];
}



- (void) applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[TimetableManager sharedManager] stopTimetableScheduler];
    
    [[MBGPSLocationManager sharedManager] stopAllUpdates];
    

}


- (void) increaseAppStartCount
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSNumber* count = [def objectForKey:@"APP_START_COUNTER"];
    count = [NSNumber numberWithInteger:count.integerValue+1];
    // NSLog(@"update count to %@",count);
    [def setObject:count forKey:@"APP_START_COUNTER"];
    [def synchronize];
}

- (void) applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[TimetableManager sharedManager] startTimetableScheduler];
    BOOL trackingEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled_tracking"] boolValue];
    [MBTrackingManager setOptOut:!trackingEnabled];
    

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    // NSLog(@"didReceiveLocalNotification: %@",notification);
    NSString *url = notification.userInfo[@"pdf"];
    
    if (url) {
        [application openURL:[NSURL URLWithString:url]];
        return;
    }
    [self handleLocalNotification:notification];
}

- (void) handleLocalNotification:(UILocalNotification*)notification
{
    // NSLog(@"handleLocalNotification: %@",notification);
    if([notification.userInfo[@"type"] isEqualToString:@"wagenstand"]){
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            //app running, display alert
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Wagenreihung" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Schließen" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:defaultAction];
            defaultAction = [UIAlertAction actionWithTitle:@"Öffnen" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openWagenstandWithUserInfo:notification.userInfo];
            }];
            [alert addAction:defaultAction];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        } else {
            //should open station and display wagenstand for this train
            [self openWagenstandWithUserInfo:notification.userInfo];
        }
    } else if(notification.userInfo[@"properties"]){
        //handle code for facility manager (when merged from facility branch!)
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            // NSLog(@"Local Notification received by running app - ignore");
        } else {
            //NSLog(@"App opened from Notification, now should go to station %@",notification.userInfo[@"properties"]);
            [[FacilityStatusManager client] openFacilityStatusWithLocalNotification:notification.userInfo];
        }
    }
}

- (void) openWagenstandWithUserInfo:(NSDictionary*)userInfo
{
    // NSLog(@"now open this wagenstand %@",userInfo);
    NSNumber* stationNumber = userInfo[@"stationNumber"];
    NSString* stationTitle = userInfo[@"stationName"];

    if([self.selectedStation[@"id"] longLongValue] == [stationNumber longLongValue]
       && ![self.navigationController.topViewController isKindOfClass:[MBStationSearchViewController class]]){
        //we already are in this station
        MBStationSearchViewController* vc = (MBStationSearchViewController*) self.viewController;
        // NSLog(@"we are in this station!");
        [vc showWagenstandForUserInfo:userInfo];
    } else {
        // NSLog(@"must open another station OR did display search controller!");
        [self.navigationController popToRootViewControllerAnimated:NO];
        MBStationSearchViewController* vc = (MBStationSearchViewController*) self.viewController;
        [vc openStation:@{ @"title":stationTitle, @"id": [NSNumber numberWithLongLong:[stationNumber longLongValue]] } andShowWagenstand:userInfo];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.

    // clean cached pdfs when app is terminated
    [self clearCachedFiles];
    

    [[MBGPSLocationManager sharedManager] stopAllUpdates];
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
    //
}



- (void) registerDefaultsFromSettingsBundle
{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs synchronize];

    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];

    if(!settingsBundle) {
        return;
    }

    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];

    for (NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if (key) {
            // Check if value is registered or not in userDefaults
            id currentObject = [defs objectForKey:key];
            if (currentObject == nil) {
                // Not registered: set value from Settings.bundle
                id objectToSet = [prefSpecification objectForKey:@"DefaultValue"];
                [defaultsToRegister setObject:objectToSet forKey:key];
            }
        }
    }

    [defs registerDefaults:defaultsToRegister];
    [defs synchronize];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return ISIPAD ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void) clearCachedFiles
{
    NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *mainPath  = myPathList[0];

    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:mainPath error:nil];

    [fileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]] && ([obj rangeOfString:@".pdf"].length != 0)) {
            [fileMgr removeItemAtPath:[mainPath stringByAppendingPathComponent:obj] error:NULL];
        }
    }];
}

//routing

+ (BOOL) hasGoogleMaps
{
    return [[UIApplication sharedApplication] canOpenURL:
            [NSURL URLWithString:@"comgooglemaps://"]];
}

+ (BOOL) hasAppleMaps
{
    return [[UIApplication sharedApplication] canOpenURL:
            [NSURL URLWithString:@"https://maps.apple.com"]];
}

+(void)showRoutingForParking:(MBParkingInfo *)parking fromViewController:(UIViewController*)fromViewController{
    
    NSString* name = parking.name;
    CLLocationCoordinate2D loc = parking.location;
    
    AppDelegate* app = (AppDelegate*) [UIApplication sharedApplication].delegate;
    [app routeToName:name location:loc fromViewController:fromViewController];

}

-(void)routeToName:(NSString *)name location:(CLLocationCoordinate2D)loc fromViewController:(UIViewController*)fromViewController{
    
    if(fromViewController == nil){
        fromViewController = self.viewController;
    }
    
    BOOL hasGoogleMaps = [AppDelegate hasGoogleMaps];
    BOOL hasAppleMaps = [AppDelegate hasAppleMaps];
    if(hasAppleMaps && hasGoogleMaps){
        
        UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            style = UIAlertControllerStyleAlert;
        }
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Routing"
                                                                       message:@"Routing per Apple Karten oder Google Maps?"
                                                                preferredStyle:style];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Apple Karten" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  // NSLog(@"Apple");
                                                                  MKMapItem * item = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:@{
                                                                                                                                                                                          }]];
                                                                  [item setName:name];
                                                                  [item openInMapsWithLaunchOptions:@{}];
                                                                  
                                                              }];
        [alert addAction:defaultAction];
        defaultAction = [UIAlertAction actionWithTitle:@"Google Maps" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   // NSLog(@"Google");
                                                   //NSString* addr = [NSString stringWithFormat:@"%@", parking.name];
                                                   //addr = [addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                   NSString* link = [NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f",
                                                                     loc.latitude,loc.longitude];
                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
                                               }];
        [alert addAction:defaultAction];
        defaultAction = [UIAlertAction actionWithTitle:@"Abbrechen" style:UIAlertActionStyleCancel
                                               handler:nil];
        [alert addAction:defaultAction];
        
        // show action sheet
        [fromViewController presentViewController:alert animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.apple.com/?q=%f,%f",loc.latitude,loc.longitude]]];
    }
}
@end
