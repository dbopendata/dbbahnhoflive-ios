//
//  MBNewsRequestManager.h
//  MeinBahnhof
//
//  Created by Heiko on 19.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "MBNewsResponse.h"

@interface MBNewsRequestManager : AFHTTPSessionManager

+ (MBNewsRequestManager*)sharedInstance;
- (NSURLSessionTask *)requestNewsForStation:(NSNumber*)stationId
                            forcedByUser:(BOOL)forcedByUser
                                 success:(void (^)(MBNewsResponse *response))success
                            failureBlock:(void (^)(NSError *error))failure;


@end
