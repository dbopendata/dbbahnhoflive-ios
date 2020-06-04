//
//  SharedMobilityAPI.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 04.09.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

@class MobilityMappable;

@interface SharedMobilityAPI : AFHTTPSessionManager

+ (instancetype)client;
- (NSURLSessionTask *)getMappables:(CLLocationCoordinate2D)coordinate
                                 success:(void (^)(NSArray<MobilityMappable*> *mappables))success
                                 failureBlock:(void (^)(NSError *error))failureBlock;

@end
