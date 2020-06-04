//
//  HafasCacheManager.h
//  MeinBahnhof
//
//  Created by Heiko on 07.12.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define CACHE_TIME_STATION_REQUEST (60*60*24)
#define CACHE_TIME_DEPARTURE_REQUEST (60*5)
#define CACHE_TIME_JOURNEY_REQUEST (60*5)
#define CACHE_MIN_DISTANCE_TO_CURRENT_POSITION 100 // Metres

#define CACHE_KEY_NEARBY_STATIONS @"bahnhoflive.nearby_stations_request_cache"

@interface HafasCacheManager : NSObject

+ (instancetype)sharedManager;

@property(nonatomic,strong) NSMutableArray* knownEvaIds;
-(void)addKnownEvaIds:(NSArray *)ids;

-(NSDictionary*)cachedDepartureRequest:(NSString*)cacheUrl;
-(void)storeDepartureRequest:(NSDictionary*)dict url:(NSString*)url;

-(NSDictionary*)cachedStationRequest:(NSString*)cacheUrl;
-(void)storeStationRequest:(NSDictionary*)dict url:(NSString*)url;

-(NSDictionary*)cachedJourneyRequest:(NSString*)cacheUrl;
-(void)storeJourneyRequest:(NSDictionary*)dict url:(NSString*)url;

-(NSDictionary *)cachedRequestForNearbyStation:(CLLocationCoordinate2D)coordinate;


@end
