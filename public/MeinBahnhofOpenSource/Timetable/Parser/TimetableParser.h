//
//  TimetableParser.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 29.05.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timetable.h"
#import "Stop.h"
#import "Event.h"
#import "TBXML.h"

@interface TimetableParser : NSObject

+ (NSArray*) parseTimeTableFromData:(NSData*)data;
+ (NSArray*) parseChangesForTimetable:(NSData*)data;

@end
