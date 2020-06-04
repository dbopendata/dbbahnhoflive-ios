//
//  Stop.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 28.05.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "Message.h"
#import "TransportCategory.h"

@interface Stop : NSObject

@property (nonatomic, strong) NSString* stopId;

@property (nonatomic, strong) TransportCategory* transportCategory;
@property (nonatomic, strong) TransportCategory* changedTransportCategory;
@property (nonatomic, strong) TransportCategory* oldTransportCategory;
@property (nonatomic) BOOL isReplacementTrain;
@property (nonatomic) BOOL isExtraTourTrain;

@property (nonatomic, strong) Event *arrival;
@property (nonatomic, strong) Event *departure;
@property (nonatomic, strong) Message *message;

@property (nonatomic, strong) NSString *junctionType;
@property (nonatomic, strong) NSString *stopIndex;

// this will be added in TimetableViewController if this stop is a Reference to another
@property (nonatomic, strong) NSString *referenceSplitMessage;

- (NSString*) formattedTransportType:(NSString*)lineIdentifier;
- (NSString*) replacementTrainMessage:(NSString*)lineIdentifier;
- (NSString*) changedTrainMessage:(NSString*)lineIdentifier;

- (Event*)eventForDeparture:(BOOL)departure;
- (NSDictionary*) requestParamsForWagenstandWithEvent:(Event*)event;

@end