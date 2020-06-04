//
//  MBParkingManager.h
//  MeinBahnhof
//
//  Created by Heiko on 14.11.16.
//  Copyright © 2016 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "MBParkingInfo.h"

@interface MBParkingManager : AFHTTPSessionManager


+ (instancetype)client;
- (NSURLSessionTask *)requestParkingStatus:(NSNumber*)stationId
                              forcedByUser:(BOOL)forcedByUser
                                    success:(void (^)(NSArray<MBParkingInfo*> *parkingInfoItems))success
                               failureBlock:(void (^)(NSError *error))failure;


@end
