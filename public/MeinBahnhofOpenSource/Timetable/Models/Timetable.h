//
//  Timetable.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 28.05.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimetableParser.h"
#import "Stop.h"

//debug features
#define TIMETABLE_USE_SIMULATED_DATE NO
#define TIMETABLE_USE_STATIC_TESTFILES NO
#define TIMETABLE_FORCE_STATIC_TESTFILES NO


@interface Timetable : NSObject

@property (nonatomic, strong) NSMutableArray *stops;

@property (nonatomic, strong) NSArray *arrivalStops;
@property (nonatomic, strong) NSArray *departureStops;

@property (nonatomic, strong) NSDate* lastRequestedDate;
@property (nonatomic, assign) NSInteger additionalRequestHours;

- (void) initializeTimetableFromData:(NSData*)data;
- (void) updateTimetableFromData:(NSData*)data;

- (void) clearTimetable;
- (BOOL) hasTimetableData;

-(void)generateTestdata;//for debugging

+(NSDate*)now;

- (NSArray*) availablePlatformsForDeparture:(BOOL)departure;
- (NSArray*) availableTransportTypesForDeparture:(BOOL)departure;
@end
