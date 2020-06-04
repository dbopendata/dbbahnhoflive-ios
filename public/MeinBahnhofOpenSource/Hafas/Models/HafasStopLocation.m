//
//  HafasStopLocation.m
//  MeinBahnhof
//
//  Created by Marc O'Connor on 17.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "HafasStopLocation.h"

@implementation HafasStopLocation

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    if (self = [super initWithDictionary:dictionaryValue error:error]) {
    }
    return self;
}

- (CLLocationCoordinate2D) positionAsLatLng
{
    return CLLocationCoordinate2DMake([self.lat doubleValue], [self.lon doubleValue]);
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"stopId": @"id",
             @"name": @"name",
             @"extId": @"extId",
             @"lon": @"lon",
             @"lat": @"lat",
             };
}

@end
