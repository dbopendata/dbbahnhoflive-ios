//
//  TimetableManager.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 30.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "TimetableManager.h"
//#import "Timetable.h"
#import <AFNetworking/AFNetworking.h>

@interface TimetableManager()

@end

@implementation TimetableManager

+ (TimetableManager*)sharedManager
{
    static TimetableManager *sharedTimetableManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTimetableManager = [[self alloc] init];
    });
    return sharedTimetableManager;
}

- (instancetype) init
{
    if (self = [super init]) {
        self.timetable = [[Timetable alloc] init];
    }
    return self;
}

-(BOOL)canRequestAdditionalData{
    return NO;
}
-(void)requestAdditionalData{

}

- (void) startTimetableScheduler
{
    //start a scheduler that updates the timetable... this is just a simple simulation
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_TIMETABLE_REFRESHING object:nil];
    [self.timetable generateTestdata];
    self.timetableStatus = TimetableStatusIdle;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_TIMETABLE_UPDATE object:self];
}

- (void) stopTimetableScheduler
{
    
}

- (void) manualRefresh
{
    [self startTimetableScheduler];
}



- (void) resetTimetable;
{
    //NSLog(@"clear timetable");
    self.evaIds = @[];
    [self.timetable clearTimetable];
}


@end
