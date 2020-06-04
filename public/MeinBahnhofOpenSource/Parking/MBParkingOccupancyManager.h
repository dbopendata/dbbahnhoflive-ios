//
//  MBParkingOccupancyManager.h
//  MeinBahnhof
//
//  Created by Heiko on 14.11.16.
//  Copyright © 2016 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface MBParkingOccupancyManager : AFHTTPSessionManager

+ (instancetype)client;
- (NSURLSessionTask *)requestParkingOccupancy:(NSString*)siteId
                                   success:(void (^)(NSNumber *allocationCategory))success
                              failureBlock:(void (^)(NSError *error))failure;



@end
