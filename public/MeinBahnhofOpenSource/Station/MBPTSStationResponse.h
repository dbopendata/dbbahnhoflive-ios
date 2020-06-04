//
//  MBPTSStationResponse.h
//  MeinBahnhof
//
//  Created by Heiko on 17.02.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBPTSAvailabilityTimes.h"

@interface MBPTSStationResponse : NSObject

-(instancetype)initWithResponse:(NSDictionary*)json;
-(BOOL)isValid;

-(NSArray<NSString*>*)evaIds;
-(NSNumber*)category;
-(NSArray<NSNumber*>*)position;

//facility status
-(BOOL)hasSteplessAccess;
-(BOOL)hasPublicFacilities;
-(BOOL)hasWiFi;
-(BOOL)hasLockerSystem;
-(BOOL)hasDBInfo;
-(BOOL)hasTravelCenter;
-(BOOL)hasDBLounge;
-(BOOL)hasTravelNecessities;
-(BOOL)hasParking;
-(BOOL)hasBicycleParking;
-(BOOL)hasTaxiRank;
-(BOOL)hasCarRental;
-(BOOL)hasLostAndFound;

//services
-(BOOL)hasMobilityService;
-(NSString*)mobilityServiceText;

-(BOOL)hasRailwayMission;
-(BOOL)hasLocalServiceStaff;

-(BOOL)has3SZentrale;
-(NSString*)phoneNumber3S;

-(MBPTSAvailabilityTimes*)dbInfoAvailabilityTimes;
-(MBPTSAvailabilityTimes*)localServiceStaffAvailabilityTimes;
@end
