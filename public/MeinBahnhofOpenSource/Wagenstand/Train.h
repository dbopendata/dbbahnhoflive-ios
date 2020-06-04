//
//  Train.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Train : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSDictionary *destination;
@property (nonatomic, copy) NSArray *sections;

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *type;

- (NSString *)destinationStation;
- (NSArray *)destinationVia;

- (NSString *)sectionRangeAsString;
- (NSString *) destinationViaAsString;

@end
