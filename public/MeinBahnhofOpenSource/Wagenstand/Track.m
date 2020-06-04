//
//  Track.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.02.16.
//  Copyright © 2016 ScholzVolkmer. All rights reserved.
//

#import "Track.h"

@implementation Track

+ (NSArray*)trackNumbers:(NSArray*)tracks
{
    NSMutableArray *trackNumbers = [NSMutableArray array];
    for (Track *track in tracks) {
        if ([track.number rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) {
            [trackNumbers addObject:track.number];
        }
    }
    
    trackNumbers = [[trackNumbers sortedArrayUsingComparator:^(NSString *obj1, NSString* obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }] mutableCopy];
    
    //[trackNumbers insertObject:@"-" atIndex:0];
    return trackNumbers;
    
}

+ (NSDictionary*) JSONKeyPathsByPropertyKey
{
    return @{
             @"number": @"number",
             @"name": @"name"
             };
}


@end
