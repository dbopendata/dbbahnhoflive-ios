//
//  MBRootContainerViewController.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 22.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBUIViewController.h"
#import "MBStation.h"
#import "MBStationTabBarViewController.h"

@class MBOverlayViewController;
@class MBTimetableViewController;
@class MBContentSearchResult;

@protocol MBRootContainerViewControllerDelegate <NSObject>

@optional
-(void)didLoadStationData:(BOOL)success;
-(void)didLoadParkingData:(BOOL)success;
-(void)didLoadParkingOccupancy:(BOOL)success;
-(void)didLoadIndoorMapLevels:(BOOL)success;
-(void)didLoadMapPOIs:(BOOL)success;
-(void)didLoadTravelCenter:(BOOL)success;
-(void)didLoadEinkaufData:(BOOL)success;
-(void)didLoadFacilityData:(BOOL)success;
-(void)didFinishAllLoading;

@end

@interface MBRootContainerViewController : MBUIViewController <UIGestureRecognizerDelegate, UIBarPositioningDelegate, MBStationTabBarViewControllerDelegate>

-(void)updateFacilityUI;

-(void)reloadStation;
@property(nonatomic,weak) id<MBRootContainerViewControllerDelegate> rootDelegate;
@property (nonatomic, strong) MBStationTabBarViewController *stationTabBarViewController;
@property(nonatomic) BOOL startWithDepartures;

+(void)presentViewControllerAsOverlay:(MBOverlayViewController*)vc allowNavigation:(BOOL)allowNavigation;
+(void)presentViewControllerAsOverlay:(MBOverlayViewController*)vc;
+(MBRootContainerViewController*)currentlyVisibleInstance;

-(UINavigationController*)stationContainerNavigationController;
-(UINavigationController*)timetableNavigationController;
-(MBTimetableViewController*)timetableVC;
-(void)selectTimetableTab;
-(void)selectTimetableTabAndDeparturesForTrack:(NSString*)track trainOrder:(Stop*)trainStop;
-(void)cleanup;

-(void)handleSearchResult:(MBContentSearchResult*)search;
@end
