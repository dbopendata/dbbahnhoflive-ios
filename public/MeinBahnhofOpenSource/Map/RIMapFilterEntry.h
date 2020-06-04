//
//  RIMapFilterEntry.h
//  MeinBahnhof
//
//  Created by Heiko on 18.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface RIMapFilterEntry : MTLModel <MTLJSONSerializing>

@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSString* menucat;
@property(nonatomic,strong) NSString* menusubcat;
@property(nonatomic,strong) NSArray* presets;

@end
