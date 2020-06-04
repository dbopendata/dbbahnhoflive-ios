//
//  HafasTimetable.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 17.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HafasDeparture.h"

@class MBOPNVStation;

@interface HafasTimetable : NSObject

@property(nonatomic,strong) MBOPNVStation* opnvStationForFiltering;

@property (nonatomic, strong) NSArray<HafasDeparture*> *departureStops;
@property (nonatomic, strong) NSString *currentStopLocationId;
@property(nonatomic) BOOL includedSTrains;
@property (nonatomic, assign) NSInteger requestDuration;//in minutes
@property (nonatomic) BOOL isBusy;
@property (nonatomic) BOOL needsInitialRequest;

- (void)initializeTimetableFromArray:(NSArray<NSDictionary*> *)departures mergeData:(BOOL)merge date:(NSDate*)loadingDate;
- (NSArray*) availableTransportTypes;
-(NSDate *)lastRequestedDate;

@end
