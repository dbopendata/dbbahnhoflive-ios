//
//  MBNewsRequestManager.m
//  MeinBahnhof
//
//  Created by Heiko on 19.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBNewsRequestManager.h"
@implementation MBNewsRequestManager

+ (MBNewsRequestManager*)sharedInstance
{
    static MBNewsRequestManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:@"https://"];
        sharedClient = [[self alloc] initWithBaseURL:baseUrl];
        
    });
    return sharedClient;
}

-(NSURLSessionTask *)requestNewsForStation:(NSNumber *)stationId forcedByUser:(BOOL)forcedByUser success:(void (^)(MBNewsResponse *))success failureBlock:(void (^)(NSError *))failure{
    failure(nil);
    return nil;
}

@end
