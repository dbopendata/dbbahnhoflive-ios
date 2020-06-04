//
//  MBTrackingManager.m
//  MeinBahnhofOpenSource
//
//  Created by Heiko on 08.01.20.
//  Copyright © 2020 Scholz & Volkmer GmbH. All rights reserved.
//

#import "MBTrackingManager.h"

@implementation MBTrackingManager

+(void)setup{}
+(void)setCurrentStationForCrashTracking:(NSInteger)stationId{}
+(void)trackPushMessageClick:(NSDictionary *)userInfo{}
+ (void)setOptOut:(BOOL)optOut{}
+ (NSArray *)stationInfoArray{ return nil; }
+(NSString *)mapShopTitleToTrackingName:(NSString *)internalName{
    return @"";
}
+(NSString *)mapMainMenuTypeToTrackingName:(NSString *)type{
    return @"";
}
+(NSString *)mapInternalServiceToTrackingName:(NSString *)internalName{
    return @"";
}
+(void)trackAction:(NSString *)action{}
+(void)trackActions:(NSArray *)actions{}
+(void)trackActionWithStationInfo:(NSString *)action{}
+(void)trackActionsWithStationInfo:(NSArray *)actions{}
+(void)trackActions:(NSArray *)states withStationInfo:(BOOL)stationInfo additionalVariables:(NSDictionary *)variables{}

+ (void)trackState:(NSString *)state{}
+(void)trackStates:(NSArray *)states{}
+(void)trackStateWithStationInfo:(NSString *)state{}
+(void)trackStatesWithStationInfo:(NSArray *)states{}

@end
