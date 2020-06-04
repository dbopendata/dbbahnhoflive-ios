//
//  MBCacheManager.m
//  MeinBahnhof
//
//  Created by Heiko on 18.04.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import "MBCacheManager.h"

@interface MBCacheManager()

@end

@implementation MBCacheManager

+ (instancetype)sharedManager
{
    static MBCacheManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#define MBCACHE_VERSION 3
-(instancetype)init{
    self = [super init];
    if(self){
        NSLog(@"setup cache manager with directory %@",[self applicationDocumentsDirectory]);
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        if([def integerForKey:@"mbcachemanager.version"] < MBCACHE_VERSION){
            [[NSFileManager defaultManager] removeItemAtPath:[self applicationDocumentsDirectory] error:nil];
            NSLog(@"cache version changed, clear cache dir");
            [def setInteger:MBCACHE_VERSION forKey:@"mbcachemanager.version"];
        }
    }
    return self;
}

//cache for 24h = 60*60*24
#define CACHE_TIME_PTS_REQUEST (60*60*1)
#define CACHE_TIME_RIMAP (60*60*1)
#define CACHE_TIME_PARKING (60*60*1)
#define CACHE_TIME_EINKAUFSBAHNHOF (60*60*24)
#define CACHE_TIME_TRAVELCENTER (60*60*24)
#define CACHE_TIME_NEWS (60*5)

-(NSTimeInterval)cacheTimeForType:(MBCacheResponseType)type{
    switch (type) {
        case MBCacheResponsePTS:
            return CACHE_TIME_PTS_REQUEST;
        case MBCacheResponseRIMapStatus:
        case MBCacheResponseRIMapPOIs:
            return CACHE_TIME_RIMAP;
        case MBCacheResponseParking:
            return CACHE_TIME_PARKING;
        case MBCacheResponseEinkaufsbahnhof:
            return CACHE_TIME_EINKAUFSBAHNHOF;
        case MBCacheResponseEinkaufsbahnhofOverview:
            return CACHE_TIME_EINKAUFSBAHNHOF;
        case MBCacheResponseTravelCenter:
            return CACHE_TIME_TRAVELCENTER;
        case MBCacheResponseNews:
            return CACHE_TIME_NEWS;
    }
    return 0;
}

- (NSURL *) applicationDocumentsDirectoryURL
{
    NSArray * urls = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL* url = [urls.firstObject URLByAppendingPathComponent:@"MBCacheManager"];
    return url;
}

- (NSString *) applicationDocumentsDirectory
{
    NSString* path = [self applicationDocumentsDirectoryURL].path;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return path;
}

-(NSString*)cacheFileForStation:(NSNumber*)station type:(MBCacheResponseType)type{
    NSString* filename = @"undefined.json";
    switch (type) {
        case MBCacheResponsePTS:
            filename = @"ptscache.json";
            break;
        case MBCacheResponseRIMapStatus:
            filename = @"rimapstatus.json";
            break;
        case MBCacheResponseRIMapPOIs:
            filename = @"rimappois.json";
            break;
        case MBCacheResponseParking:
            filename = @"parking_v2.json";
            break;
        case MBCacheResponseEinkaufsbahnhof:
            filename = @"einkauf.json";
            break;
        case MBCacheResponseEinkaufsbahnhofOverview:
            filename = @"einkauf_overview.json";
            break;
        case MBCacheResponseTravelCenter:
            filename = @"travelcenter.json";
            break;
        case MBCacheResponseNews:
            filename = @"news.json";
            break;
    }
    filename = [station.stringValue stringByAppendingFormat:@"_%@",filename];
    NSString* path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:filename];
    return path;
}

-(MBCacheState)cacheStateForStationId:(NSNumber*)stationId type:(MBCacheResponseType)type{
    NSString* file = [self cacheFileForStation:stationId type:type];
    NSError* error = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:&error];
    if(attributes.fileModificationDate){
        NSDate* modifyDate = attributes.fileModificationDate;
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        if(((now-modifyDate.timeIntervalSinceReferenceDate)) > [self cacheTimeForType:type]){
            return MBCacheStateOutdated;
        } else {
            return MBCacheStateValid;
        }
    } else {
        return MBCacheStateNone;
    }
}

-(NSDictionary*)cachedResponseForStationId:(NSNumber*)stationId type:(MBCacheResponseType)type{
    NSString* file = [self cacheFileForStation:stationId type:type];
    if(![[NSFileManager defaultManager] fileExistsAtPath:file]){
        return nil;
    }
    NSData* data = [NSData dataWithContentsOfFile:file];
    NSDictionary *cache = nil;
    if(data){
        cache = [NSJSONSerialization JSONObjectWithData:data
                                        options:0
                                          error:nil];
        data = nil;
    }
    NSDictionary* cacheEntry = cache[@"cachedata"];
    cache = nil;
    if(cacheEntry){
        return cacheEntry[@"data"];
    }
    return nil;
}

-(void)storeResponse:(NSDictionary*)responseObject forStationId:(NSNumber*)stationId type:(MBCacheResponseType)type{
    NSString* file = [self cacheFileForStation:stationId type:type];
    NSMutableDictionary *cache = [NSMutableDictionary dictionaryWithCapacity:5];
    [cache setObject:@{ @"date":@([NSDate timeIntervalSinceReferenceDate]), @"data":responseObject } forKey:@"cachedata"];
    if([NSJSONSerialization isValidJSONObject:cache]){
        NSData *dataFromDict = [NSJSONSerialization dataWithJSONObject:cache
                                                               options:0//NSJSONWritingPrettyPrinted
                                                                 error:nil];
        BOOL success = [dataFromDict writeToFile:file atomically:YES];
        NSLog(@"stored cache at %@ with status %d",file,success);
    } else {
        NSLog(@"ERROR: could not store cachedata as json");
    }
}



@end