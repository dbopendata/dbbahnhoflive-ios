//
//  SharedMobilityAPI.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 04.09.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "SharedMobilityAPI.h"
#import "SharedMobilityMappable.h"


@implementation SharedMobilityAPI

- (instancetype) init
{
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)client
{
    static SharedMobilityAPI *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:@""];
        sharedClient = [[self alloc] initWithBaseURL:baseUrl];
    });
    return sharedClient;
}

- (NSURLSessionTask *)getMappables:(CLLocationCoordinate2D)coordinate
                                              success:(void (^)(NSArray<MobilityMappable*> *mappables))success
                                 failureBlock:(void (^)(NSError *error))failureBlock
{
    return nil;
}

@end
