//
//  MBTimetableViewController.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 23.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBUIViewController.h"
#import "MBLabel.h"
#import "MBMapViewController.h"
#import "TimetableManager.h"
#import "HafasRequestManager.h"
#import "MBOPNVStation.h"

@class MBContentSearchResult;

@interface MBTimetableViewController : MBUIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MBMapViewControllerDelegate>

@property (nonatomic, strong) MBLabel *lastUpdateLabel;

@property (nonatomic, assign) BOOL embeddedInController;
@property (nonatomic, assign) BOOL departure;

@property (nonatomic, assign) BOOL dbOnly;
@property (nonatomic, assign) BOOL oepnvOnly;
@property (nonatomic) BOOL showFernverkehr;
@property(nonatomic) BOOL trackToggleChange;

@property (nonatomic, strong) MBOPNVStation *hafasStation;
@property (nonatomic, strong) HafasTimetable* hafasTimetable;

@property (nonatomic,strong) NSArray* mapMarkers;

-(instancetype)initWithFernverkehr:(BOOL)showFernverkehr;
-(instancetype)initWithBackButton:(BOOL)showBackButton fernverkehr:(BOOL)showFernverkehr;

- (void)reloadTimetable;

- (BOOL)filterIsActive;
-(void)showTrack:(NSString*)track trainOrder:(Stop*)trainStop;
+(BOOL)stopShouldHaveTrainRecord:(Stop*)timetableStop;
-(void)handleSearchResult:(MBContentSearchResult*)search;
@end
