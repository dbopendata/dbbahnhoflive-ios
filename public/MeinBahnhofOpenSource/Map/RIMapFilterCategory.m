//
//  RIMapFilterCategory.m
//  MeinBahnhof
//
//  Created by Heiko on 18.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "RIMapFilterCategory.h"

@implementation RIMapFilterCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"appcat": @"appcat",
             @"presets": @"presets",
             @"items": @"items",
             };
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:RIMapFilterEntry.class];
}


@end
