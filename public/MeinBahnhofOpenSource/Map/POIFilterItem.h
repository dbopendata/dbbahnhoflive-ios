//
//  POIFilterItem.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 23.11.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POIFilterItem : NSObject<NSCopying>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconKey;
@property (nonatomic, strong) NSArray *subItems;
@property (nonatomic, assign) BOOL active;

- (instancetype) initWithTitle:(NSString*)title andIconKey:(NSString*)iconKey;

@end
