//
//  MBCacheManager.h
//  MeinBahnhof
//
//  Created by Heiko on 18.04.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MBCacheResponseType) {
    MBCacheResponseRIMapStatus = 2,
    MBCacheResponseRIMapPOIs = 3,
    MBCacheResponseParking = 4,
    MBCacheResponseEinkaufsbahnhof = 5,
    MBCacheResponsePTS = 6,
    MBCacheResponseEinkaufsbahnhofOverview = 7,
    MBCacheResponseTravelCenter = 8,
    MBCacheResponseNews = 9,
};

typedef NS_ENUM(NSUInteger, MBCacheState){
    MBCacheStateNone = 0,
    MBCacheStateOutdated = 1,
    MBCacheStateValid = 2
};

@interface MBCacheManager : NSObject

+ (instancetype)sharedManager;
-(MBCacheState)cacheStateForStationId:(NSNumber*)stationId type:(MBCacheResponseType)type;
-(NSDictionary*)cachedResponseForStationId:(NSNumber*)stationId type:(MBCacheResponseType)type;
-(void)storeResponse:(NSDictionary*)responseObject forStationId:(NSNumber*)stationId type:(MBCacheResponseType)type;

@end
