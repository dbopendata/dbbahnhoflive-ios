//
//  RIMapFilterCategory.h
//  MeinBahnhof
//
//  Created by Heiko on 18.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "RIMapFilterEntry.h"
@interface RIMapFilterCategory : MTLModel <MTLJSONSerializing>

@property(nonatomic,strong) NSString* appcat;
@property(nonatomic,strong) NSArray* presets;
@property(nonatomic,strong) NSArray* items;

@end
