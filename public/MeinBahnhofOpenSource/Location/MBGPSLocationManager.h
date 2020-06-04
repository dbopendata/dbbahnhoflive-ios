//
//  MBGPSLocationManager.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 14.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define NOTIF_GPS_AUTH_CHANGED @"gps.authorization"
#define NOTIF_GPS_LOCATION_UPDATE @"gps.location"

#define kGPSNotifLocationPayload @"gps.location"

@interface MBGPSLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic) BOOL isGettingOneShotLocation;

+ (MBGPSLocationManager*)sharedManager;

-(CLAuthorizationStatus)authStatus;
-(void)requestAuthorization;
-(BOOL)isLocationManagerAuthorized;

- (void) stopPositioning;
- (void) stopAllUpdates;
- (void) getOneShotLocationUpdate;

- (CLLocation*) lastKnownLocation;

@end
