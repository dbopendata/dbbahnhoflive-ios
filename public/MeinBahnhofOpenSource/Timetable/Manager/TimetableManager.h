//
//  TimetableManager.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 30.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timetable.h"


#define NOTIF_TIMETABLE_UPDATE @"bahnhoflive.timetable_update"
#define NOTIF_TIMETABLE_REFRESHING @"bahnhoflive.timetable_refreshing"

typedef NS_ENUM(NSUInteger, TimetableStatus) {
    TimetableStatusIdle = 0,
    TimetableStatusBusy = 1,
    TimetableStatusError  = 2,
};

typedef NS_ENUM(NSUInteger, TimetableResponseStatus) {
    TimetableResponseStatus_EMPTY = 0,
    TimetableResponseStatus_SUCCESS,
    TimetableResponseStatus_ERROR,
    TimetableResponseStatus_FILTER_EMPTY
} ;


@interface TimetableManager : NSObject

@property (nonatomic, strong) NSArray<NSString*> *evaIds;

@property (nonatomic, strong) Timetable *timetable;
@property (nonatomic, assign) TimetableStatus timetableStatus;

+ (TimetableManager*)sharedManager;

- (void) startTimetableScheduler;
- (void) stopTimetableScheduler;
- (void) manualRefresh;

- (void) resetTimetable;

-(BOOL)canRequestAdditionalData;
-(void)requestAdditionalData;
@end
