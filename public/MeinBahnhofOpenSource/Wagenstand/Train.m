//
//  Train.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import "Train.h"

@implementation Train

+ (NSDictionary*) JSONKeyPathsByPropertyKey
{
    return @{
             @"destination": @"destination",
             @"sections": @"sections"
             };
}

- (NSString *)destinationStation
{
    return [self.destination objectForKey:@"destinationName"];
}

- (NSArray *)destinationVia
{
    return [self.destination objectForKey:@"destinationVia"];
}

- (NSString *) destinationViaAsString
{
    return [self.destinationVia componentsJoinedByString:@", "];
}

- (NSString *)sectionRangeAsString;
{
    return [NSString stringWithFormat:@"%@-%@",[self.sections firstObject], [self.sections lastObject]];
}

@end
