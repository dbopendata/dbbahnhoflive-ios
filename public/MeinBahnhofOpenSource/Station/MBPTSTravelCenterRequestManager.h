//
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "MBPTSTravelcenter.h"
@import CoreLocation;

@interface MBPTSTravelCenterRequestManager  : AFHTTPSessionManager

+ (instancetype)sharedInstance;

-(NSURLSessionTask *)requestTravelcenter:(NSNumber *)stationId location:(CLLocationCoordinate2D)location forcedByUser:(BOOL)forcedByUser success:(void (^)(MBPTSTravelcenter *response))success failureBlock:(void (^)(NSError *))failure;
@end
