//
//  MBUIViewController.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 13.07.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBStation.h"

#import "MBMapView.h"

@interface MBUIViewController : MBUITrackableViewController

@property (nonatomic, strong) MBStation *station;

@property (nonatomic, assign) BOOL swipeBackGestureEnabled;

- (instancetype) initWithRootBackButton;
- (instancetype) initWithBackButton:(BOOL)showBackButton;

+ (void) addBackButtonToViewController:(UIViewController*)vc andActionBlockOrNil:(void (^) (void))backHandler;
+ (void) removeBackButton:(UIViewController*)viewController;

- (void) showFacilityFavorites;
- (void) showFacilityForStation;


- (void) showWagenstandForUserInfo:(NSDictionary*)userInfo;

@end
