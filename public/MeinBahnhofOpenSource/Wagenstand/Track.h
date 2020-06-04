//
//  Track.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.02.16.
//  Copyright © 2016 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mantle/Mantle.h>

@interface Track : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *number;
@property (nonatomic, copy, readonly) NSString *name;

+ (NSArray*)trackNumbers:(NSArray*)tracks;

@end
