//
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import "MBPTSTravelCenterRequestManager.h"
#import "MBCacheManager.h"
#import "Constants.h"

@interface MBPTSTravelCenterRequestManager()

@end

@implementation MBPTSTravelCenterRequestManager

+ (instancetype)sharedInstance
{
    static MBPTSTravelCenterRequestManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:[Constants kBusinessHubProdBaseUrl]];
        sharedClient = [[self alloc] initWithBaseURL:baseUrl];
        
    });
    return sharedClient;
}



-(NSURLSessionTask *)requestTravelcenter:(NSNumber *)stationId location:(CLLocationCoordinate2D)location forcedByUser:(BOOL)forcedByUser success:(void (^)(MBPTSTravelcenter *response))success failureBlock:(void (^)(NSError *))failure{

    //NOTE: our cache uses NSDictionary but this api returns NSArray so we wrap the array in a dict
    //second note: we use the station id as a cache key even though the API uses the station
    //             location for searching. We expect the station location to be permanent.
    
    MBCacheResponseType type = MBCacheResponseTravelCenter;
    MBCacheState cacheState = [[MBCacheManager sharedManager] cacheStateForStationId:stationId type:type];
    if(forcedByUser && cacheState == MBCacheStateValid){
        cacheState = MBCacheStateOutdated;
    }
    if(cacheState == MBCacheStateValid){
        NSDictionary* cachedResponse = [[MBCacheManager sharedManager] cachedResponseForStationId:stationId type:type];
        if(cachedResponse){
            NSLog(@"using travelcenter data from cache!");
            NSArray* responseArray = cachedResponse[@"response"];
            success([self getNearestTravelCenter:responseArray toLocation:location]);
            return nil;
        }
    }
    
    NSString* endPoint = [NSString stringWithFormat:@"%@/%@/travelcenter/loc/%f/%f/1", [Constants kBusinessHubProdBaseUrl], [Constants kPTSPath], location.latitude,location.longitude];
    NSLog(@"endPoint %@",endPoint);
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:[Constants kBusinesshubKey] forHTTPHeaderField:@"key"];
    
    return [self GET:endPoint parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionTask *operation, id responseObject) {
        //we expect an array with dictionary
        if([responseObject isKindOfClass:NSArray.class]){
            NSDictionary* cacheDict = @{@"response":responseObject};
            [[MBCacheManager sharedManager] storeResponse:cacheDict forStationId:stationId type:type];
            NSArray* responseArray = (NSArray*)responseObject;
            success([self getNearestTravelCenter:responseArray toLocation:location]);
            return;
        }
        failure(nil);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        //NSData* data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        //NSLog(@"data: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

        if(cacheState == MBCacheStateOutdated){
            NSDictionary* cachedResponse = [[MBCacheManager sharedManager] cachedResponseForStationId:stationId type:type];
            if(cachedResponse){
                NSLog(@"using outdated travelcenter data from cache!");
                NSArray* responseArray = cachedResponse[@"response"];
                success([self getNearestTravelCenter:responseArray toLocation:location]);
                return;
            }
        }
  
        failure(error);
    }];
}

-(MBPTSTravelcenter*)getNearestTravelCenter:(NSArray*)responseArray toLocation:(CLLocationCoordinate2D)location{
    
    NSMutableArray<MBPTSTravelcenter*>* travelCenters = [NSMutableArray arrayWithCapacity:responseArray.count];
    for(NSDictionary* travelCenterDict in responseArray){
        MBPTSTravelcenter* travelCenter = [[MBPTSTravelcenter alloc] initWithDict:travelCenterDict];
        [travelCenters addObject:travelCenter];
    }
    CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    [travelCenters sortUsingComparator:^NSComparisonResult(MBPTSTravelcenter* obj1, MBPTSTravelcenter* obj2) {
        //sort by distance to our station
        CLLocation *travelCenterLocation1 = obj1.location;
        CLLocationDistance dist1 = [travelCenterLocation1 distanceFromLocation:stationLocation];
        CLLocation *travelCenterLocation2 = obj2.location;
        CLLocationDistance dist2 = [travelCenterLocation2 distanceFromLocation:stationLocation];
        NSLog(@"Sort %@, %@",obj1.title,obj2.title);
        NSLog(@"dist %f, %f",dist1,dist2);
        if(dist1 == dist2){
            return NSOrderedSame;
        } else if(dist1 < dist2){
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    return travelCenters.firstObject;
}

@end
