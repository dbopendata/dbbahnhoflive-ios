//
//  RIMapManager.h
//  MeinBahnhof
//
//  Created by Heiko on 19.07.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class RIMapPoi;
@class RIMapMetaData;
@class LevelplanWrapper;

@interface RIMapManager : AFHTTPSessionManager

+ (instancetype)client;
+(NSString*)accesskey;

- (NSURLSessionTask *)requestMapPOI:(NSNumber*)stationId
                       forcedByUser:(BOOL)forcedByUser
                            success:(void (^)(NSArray<RIMapPoi*> *pois))success
                       failureBlock:(void (^)(NSError *error))failure;

- (NSURLSessionTask *)requestMapStatus:(NSNumber*)stationId eva:(NSString*)evaId
                          forcedByUser:(BOOL)forcedByUser 
                               success:(void (^)(NSArray<LevelplanWrapper*> *levels, RIMapMetaData* additionalData))success
                          failureBlock:(void (^)(NSError *error))failure;


@end
