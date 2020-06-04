//
//  RIMapFilterEntry.m
//  MeinBahnhof
//
//  Created by Heiko on 18.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "RIMapFilterEntry.h"

@implementation RIMapFilterEntry

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title": @"title",
             @"menucat": @"menucat",
             @"menusubcat": @"menusubcat",
             @"presets": @"presets",
             };
}

@end
