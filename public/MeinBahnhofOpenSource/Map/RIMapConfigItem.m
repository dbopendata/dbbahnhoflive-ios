//
//  RIMapConfigItem.m
//  MeinBahnhof
//
//  Created by Heiko on 24.07.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "RIMapConfigItem.h"

@implementation RIMapConfigItem


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"menucat": @"menucat",
             @"menusubcat": @"menusubcat",
             @"zoom": @"zoom",
             @"icon": @"icon",
             @"showLabelAtZoom": @"showLabelAtZoom",
             };
}


@end
