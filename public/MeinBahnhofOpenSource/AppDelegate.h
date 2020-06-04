//
//  AppDelegate.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 27.05.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@class MBStationNavigationViewController;
@class MBParkingInfo;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) MBStationNavigationViewController *navigationController;


+ (BOOL) hasGoogleMaps;
+ (BOOL) hasAppleMaps;
- (NSDictionary*) selectedStation;

+(void)showRoutingForParking:(MBParkingInfo *)parking fromViewController:(UIViewController*)fromViewController;
-(void)routeToName:(NSString*)name location:(CLLocationCoordinate2D)location  fromViewController:(UIViewController*)fromViewController;
@end

