//
//  RIMapConfigItem.h
//  MeinBahnhof
//
//  Created by Heiko on 24.07.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface RIMapConfigItem : MTLModel <MTLJSONSerializing>

@property(nonatomic,strong) NSString* menucat;
@property(nonatomic,strong) NSString* menusubcat;
@property(nonatomic,strong) NSNumber* zoom;
@property(nonatomic,strong) NSString* icon;
@property(nonatomic,strong) NSNumber* showLabelAtZoom;


@end
