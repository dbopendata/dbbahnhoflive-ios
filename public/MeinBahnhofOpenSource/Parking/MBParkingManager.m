//
//  MBParkingManager.m
//  MeinBahnhof
//
//  Created by Heiko on 14.11.16.
//  Copyright © 2016 ScholzVolkmer. All rights reserved.
//

#import "MBParkingManager.h"
#import "MBParkingInfo.h"
#import "MBParkingOccupancyManager.h"
#import "AppDelegate.h"
#import "MBCacheManager.h"
#import "Constants.h"
#import "NSDictionary+MBDictionary.h"

@implementation MBParkingManager

+ (instancetype)client
{
    static MBParkingManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:[Constants kBusinessHubProdBaseUrl]];
        sharedClient = [[self alloc] initWithBaseURL:baseUrl];
    });
    return sharedClient;
}



-(NSURLSessionTask *)requestParkingStatus:(NSNumber *)stationId forcedByUser:(BOOL)forcedByUser success:(void (^)(NSArray<MBParkingInfo*> *))success failureBlock:(void (^)(NSError *))failure{
    MBCacheResponseType type = MBCacheResponseParking;
    MBCacheState cacheState = [[MBCacheManager sharedManager] cacheStateForStationId:stationId type:type];
    if(forcedByUser && cacheState == MBCacheStateValid){
        cacheState = MBCacheStateOutdated;
    }
    if(cacheState == MBCacheStateValid){
        NSDictionary* cachedResponse = [[MBCacheManager sharedManager] cachedResponseForStationId:stationId type:type];
        if(cachedResponse){
            NSLog(@"using parking data from cache!");
            NSError *error = nil;
            NSArray* response = cachedResponse[@"response"];
            NSArray *parkingInfoItems = [self parseParkingFromArray:response error:&error];
            if(parkingInfoItems.count > 0) {
                success([self sortedSites:parkingInfoItems]);
            } else {
                failure(error);
            }
            return nil;
        }
    }
    
    NSString* endPoint = [NSString stringWithFormat:@"%@/parking-information/v1/parking-facilities?stopPlaceId=%@", [Constants kBusinessHubProdBaseUrl], stationId];
    NSLog(@"endPoint %@",endPoint);
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:[Constants kBusinesshubKey] forHTTPHeaderField:@"key"];

    return [self GET:endPoint parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionTask *operation, id responseObject) {
        //NSLog(@"got parking response: %@",responseObject);
        
        if(![responseObject isKindOfClass:NSDictionary.class]){
            NSLog(@"invalid type in parking request: %@",responseObject);
            failure(nil);
            return;
        }
        NSDictionary* responseDict = responseObject;
        NSArray* list = [responseDict db_arrayForKey:@"_embedded"];
        if(!list){
            NSLog(@"expected _embedded list not found %@",responseDict);
            failure(nil);
            return;
        }
        
        [[MBCacheManager sharedManager] storeResponse:@{@"response":list} forStationId:stationId type:type];
        
        NSError *error = nil;
        NSArray *parkingInfoItems = [self parseParkingFromArray:list
                                                               error:&error];
        if(parkingInfoItems.count > 0) {
            success([self sortedSites:parkingInfoItems]);
        } else {
            failure(error);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"failure in parking: %@",error);
        
        failure(error);
    }];
}

-(NSArray*)parseParkingFromArray:(NSArray*)list error:(NSError**)error{
    if([list isKindOfClass:NSArray.class]){
        NSMutableArray* res = [NSMutableArray arrayWithCapacity:list.count];
        for(NSDictionary* dict in list){
            MBParkingInfo* item = [MBParkingInfo parkingInfoFromServerDict:dict];
            if(item){
                [res addObject:item];
            }
        }
        return res;
    }
    return nil;
}

-(NSArray*)sortedSites:(NSArray*)parkingInfoItems{
    NSArray *sortedSites = [parkingInfoItems sortedArrayUsingComparator:^NSComparisonResult(MBParkingInfo *parkingInfo,
                                                                                            MBParkingInfo *otherParkingInfo) {
        NSInteger lh = parkingInfo.hasPrognosis ? 0 : 1;
        NSInteger rh = otherParkingInfo.hasPrognosis ? 0 : 1;
        
        if (lh == 0 || rh == 0) {
            return lh - rh;
        } else {
            // compare number of places otherwise
            lh = [parkingInfo.numberOfParkingSpaces integerValue];
            rh = [otherParkingInfo.numberOfParkingSpaces integerValue];
            
            return rh - lh;
        }
    }];
    return sortedSites;
}

@end