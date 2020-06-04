//
//  Wagenstand.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "Train.h"
#import "Waggon.h"

@interface Wagenstand : MTLModel <MTLJSONSerializing>

/**
 return @{
 @"days": @"days",
 @"name": @"name",
 @"time": @"time",
 @"trainTypes": @"traintypes",
 @"trainNumbers": @"trainNumbers",
 @"additionalText": @"additionalText",
 @"subtrains": @"subtrains"
 };**/

@property (nonatomic, copy, readonly) NSArray *days; //optional days
@property (nonatomic, copy, readonly) NSString *name; //optional
@property (nonatomic, copy, readonly) NSString *time; // String
@property (nonatomic, copy, readonly) NSString *additionalText; // String

@property (nonatomic, strong) NSString *platform; // String taken from trackRecords
@property (nonatomic, copy) NSString *expectedTime; // String

@property (nonatomic, copy, readonly) NSArray *traintypes; // Array of Strings
@property (nonatomic, copy, readonly) NSArray *trainNumbers; // Array of Numbers
@property (nonatomic, copy, readonly) NSArray *subtrains; // Array of Trains
@property (nonatomic, copy, readonly) NSArray *waggons; // Array of Trains

@property (nonatomic, copy) NSArray* evaIds;//all ids for a station

@property (nonatomic) BOOL isISTData;

@property (nonatomic, strong) NSDate* objectCreationTime;

- (Train*) destinationForWaggon:(Waggon*)waggon;
- (NSArray*) joinedSectionsList;

- (NSInteger) indexOfWaggonForSection:(NSString*)section;
- (NSInteger) indexOfWaggonForWaggonNumber:(NSString*)number;

-(BOOL)isReversed;
-(void)reverse;
-(void)addTrainDirection;
-(void)parseISTJSON:(NSDictionary*)istformation;

+(NSString*)getTrainNumberForWagenstand:(Wagenstand*)wagenstand;
+(NSString*)getTrainTypeForWagenstand:(Wagenstand*)wagenstand;
+(NSString*)getDateAndTimeForWagenstand:(Wagenstand*)wagenstand;
+(BOOL)isValidTrainTypeForIST:(NSString*)trainType;
+(NSString*)makeDateStringForTime:(NSString*)formattedTime;


@end
