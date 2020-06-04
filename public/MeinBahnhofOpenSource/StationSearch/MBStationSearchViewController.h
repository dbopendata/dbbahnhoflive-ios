//
//  MBStationSearchViewController.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 22.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

//#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#import "MBUIViewController.h"


@class MBRootContainerViewController;

@interface MBStationSearchViewController : MBUIViewController 

@property (nonatomic, strong) NSDictionary* _Nullable selectedStation;
@property (nonatomic, strong) MBRootContainerViewController* _Nullable stationMapController;

- (void) openStationAndShowFacility:(nonnull NSDictionary *)station;
- (void) openStation:(nonnull NSDictionary*)station andShowWagenstand:(nonnull NSDictionary*)wagenstandUserInfo;
- (void) openStation:(nonnull NSDictionary*)station;
-(void)freeStation;

@property(nonatomic) BOOL onBoardingVisible;
@end
