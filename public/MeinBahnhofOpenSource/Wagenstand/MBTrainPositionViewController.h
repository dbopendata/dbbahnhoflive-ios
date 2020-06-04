//
//  MBTrainPositionViewController.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 02.03.15.
//  Copyright (c) 2015 Scholz & Volkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBUIViewController.h"
#import "WagenstandRequestManager.h"
#import "Wagenstand.h"
#import "Waggon.h"
#import "MBStation.h"
#import "SectionIndicatorView.h"

#define NOTIFICATION_USERSETTINGS_REGISTERED @"NOTIFICATION_USERSETTINGS_REGISTERED"

#define WAGENSTAND_QUERY_TYPE @"type"
#define WAGENSTAND_QUERY_NUMBER @"number"
#define WAGENSTAND_QUERY_PLATFORM @"platform"

@interface MBTrainPositionViewController : MBUIViewController <UITableViewDelegate, UITableViewDataSource, SectionIndicatorDelegate>

@property (nonatomic) BOOL isOpenedFromTimetable;
@property (nonatomic, strong) Wagenstand *wagenstand;
@property (nonatomic, strong) NSString *waggonNumber;

@property (nonatomic, strong) NSDictionary* queryValues;

@end
