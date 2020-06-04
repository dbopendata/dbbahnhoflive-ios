//
//  MBPTSStationResponse.m
//  MeinBahnhof
//
//  Created by Heiko on 17.02.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import "MBPTSStationResponse.h"

@interface MBPTSStationResponse()

@property(nonatomic,strong) NSDictionary* data;

@end

@implementation MBPTSStationResponse

-(instancetype)initWithResponse:(NSDictionary *)json{
    self = [super init];
    if(self){
        if([json isKindOfClass:[NSDictionary class]]){
            self.data = json;
        }
    }
    return self;
}

-(BOOL)isValid{
    return self.data.count > 0 && self.evaIds.count > 0;
}

-(NSString*)getIdentifierForType:(NSString*)type{
    NSArray* identifiers = self.data[@"identifiers"];
    NSString* value = nil;
    for(NSDictionary* identifier in identifiers){
        if([identifier[@"type"] isEqualToString:type]){
            value = identifier[@"value"];
            if(value){
                break;
            }
        }
    }
    return value;
}

-(NSArray<NSString *> *)evaIds{
    NSMutableArray* res = [NSMutableArray arrayWithCapacity:5];
    
    NSString* evaMainId = [self getIdentifierForType:@"EVA"];
    if(!evaMainId){
        return nil;//failure
    }
    [res addObject:evaMainId];

    NSString* stadaId = [self getIdentifierForType:@"STADA"];

    NSDictionary* _embedded = self.data[@"_embedded"];
    NSArray* neighbours = _embedded[@"neighbours"];
    for(NSDictionary* neighbour in neighbours){
        if(![neighbour isKindOfClass:NSDictionary.class]){
            continue;
        }
        
        NSString* belongsToStation = neighbour[@"belongsToStation"];
        if(belongsToStation.length > 0 && ![stadaId isEqualToString:belongsToStation]){
            //this is a neighbour station that belongs to another stada station, ignore it
            continue;
        }
        NSDictionary* links = neighbour[@"_links"];
        NSDictionary* selfDict = links[@"self"];
        NSString* href = selfDict[@"href"];
        NSRange rangeLastSlash = [href rangeOfString:@"/" options:NSBackwardsSearch];
        if(rangeLastSlash.location != NSNotFound && rangeLastSlash.location+1 < href.length){
            NSString* evaSubstring = [href substringFromIndex:rangeLastSlash.location+1];
            if(evaSubstring.length > 1 && [evaSubstring characterAtIndex:0] == '8'){
                NSCharacterSet *searchSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                NSRange r = [evaSubstring rangeOfCharacterFromSet: searchSet];
                if(r.location == NSNotFound){
                    [res addObject:evaSubstring];
                }//else: there are some other characters that are not numbers, ignore this id
            }
        }
    }
    return res;
}

-(NSDictionary*)detailData{
    NSDictionary* res = self.data[@"details"];
    if([res isKindOfClass:NSDictionary.class]){
        return res;
    }
    return nil;
}

-(NSNumber *)category{
    NSDictionary* details = [self detailData];
    NSNumber* num = details[@"ratingCategory"];
    if([num isKindOfClass:NSNumber.class]){
        return num;
    }
    return nil;
}

-(NSArray<NSNumber *> *)position{
    NSDictionary* location = self.data[@"location"];
    NSNumber* lat = location[@"latitude"];
    NSNumber* lng = location[@"longitude"];
    if(lat && lng){
        return @[ lat,lng ];
    } else {
        return nil;
    }
}

-(BOOL)boolValueForKey:(NSString*)key{
    NSDictionary* details = [self detailData];
    NSNumber* obj = details[key];
    if([obj isKindOfClass:NSNumber.class]){
        return [obj boolValue];
    }
    if([obj isKindOfClass:NSString.class]){
        NSString* s = (NSString*)obj;
        return [s isEqualToString:@"YES"] || [s isEqualToString:@"yes"];
    }
    return NO;
}

-(BOOL)hasSteplessAccess{
    return [self boolValueForKey:@"hasSteplessAccess"];//future dev: some stations have "PARTIAL"
}
-(BOOL)hasPublicFacilities{
    return [self boolValueForKey:@"hasPublicFacilities"];
}
-(BOOL)hasWiFi{
    return [self boolValueForKey:@"hasWifi"];
}
-(BOOL)hasLockerSystem{
    return [self boolValueForKey:@"hasLockerSystem"];
}
-(BOOL)hasTravelCenter{
    return [self boolValueForKey:@"hasTravelCenter"];
}
-(BOOL)hasDBLounge{
    return [self boolValueForKey:@"hasDbLounge"];
}
-(BOOL)hasTravelNecessities{
    return [self boolValueForKey:@"hasTravelNecessities"];
}
-(BOOL)hasParking{
    return [self boolValueForKey:@"hasParking"];
}
-(BOOL)hasBicycleParking{
    return [self boolValueForKey:@"hasBicycleParking"];
}
-(BOOL)hasTaxiRank{
    return [self boolValueForKey:@"hasTaxiRank"];
}
-(BOOL)hasCarRental{
    return [self boolValueForKey:@"hasCarRental"];
}
-(BOOL)hasLostAndFound{
    return [self boolValueForKey:@"hasLostAndFound"];
}

-(BOOL)hasRailwayMission{
    return [self boolValueForKey:@"hasRailwayMission"];
}

-(BOOL)hasMobilityService{
    NSString* text = [[self detailData] objectForKey:@"mobilityService"];
    return text && ![text isEqualToString:@"no"];
}
-(NSString*)mobilityServiceText{
    return [[self detailData] objectForKey:@"mobilityService"];
}
-(BOOL)hasLocalServiceStaff{
    return [[self detailData] objectForKey:@"localServiceStaff"] != nil;
}

-(BOOL)hasDBInfo{
    return [[self detailData] objectForKey:@"dbInformation"] != nil;
}
-(MBPTSAvailabilityTimes *)dbInfoAvailabilityTimes{
    NSDictionary* obj = [[self detailData] objectForKey:@"dbInformation"];
    NSArray* availability = [obj objectForKey:@"availability"];
    return [[MBPTSAvailabilityTimes alloc] initWithArray:availability];
}
-(MBPTSAvailabilityTimes*)localServiceStaffAvailabilityTimes{
    NSDictionary* obj = [[self detailData] objectForKey:@"localServiceStaff"];
    NSArray* availability = [obj objectForKey:@"availability"];
    return [[MBPTSAvailabilityTimes alloc] initWithArray:availability];
}

-(BOOL)has3SZentrale{
    NSDictionary* _embedded = self.data[@"_embedded"];
    return [_embedded objectForKey:@"tripleSCenter"] != nil;
}
-(NSString*)phoneNumber3S{
    NSDictionary* _embedded = self.data[@"_embedded"];
    NSDictionary* tripleSCenter = [_embedded objectForKey:@"tripleSCenter"];
    return [tripleSCenter objectForKey:@"publicPhoneNumber"];
}

@end
