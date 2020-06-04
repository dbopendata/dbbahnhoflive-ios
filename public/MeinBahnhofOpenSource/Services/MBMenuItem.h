//
//  MBMenuItem.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.07.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Mantle/Mantle.h>

@interface MBMenuItem : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSArray *services;
@property (nonatomic, assign, readonly) NSInteger position;

- (UIImage*) iconForType;
- (NSArray*) servicesByPosition;


@end
