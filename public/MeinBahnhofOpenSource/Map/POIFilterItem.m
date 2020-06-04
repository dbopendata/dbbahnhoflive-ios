//
//  POIFilterItem.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 23.11.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import "POIFilterItem.h"

@implementation POIFilterItem

- (instancetype) init
{
    if (self = [super init]) {
        self.active = YES;
    }
    return self;
}

- (instancetype) initWithTitle:(NSString*)title andIconKey:(NSString*)iconKey;
{
    if (self = [super init]) {
        self.title = title;
        self.active = YES;
        self.subItems = nil;
        self.iconKey = iconKey;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    POIFilterItem* copy = [[[self class] alloc] init];
    if (copy) {
        copy.title = [self.title copyWithZone:zone];
        copy.active = self.active;
        copy.iconKey = [self.iconKey copyWithZone:zone];
        if(self.subItems){
            copy.subItems = [[NSArray alloc] initWithArray:self.subItems copyItems:YES];
        }
    }
    return copy;
}

@end
