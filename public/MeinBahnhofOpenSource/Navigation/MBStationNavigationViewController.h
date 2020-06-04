//
//  MBStationNavigationViewController.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 19.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBStationTopView.h"
#import "MBStation.h"

#define STATION_NAVIGATION_PICTURE_HEIGHT 280

@interface MBStationNavigationViewController : UINavigationController

@property (nonatomic, strong) UIButton* contentSearchButton;

@property (nonatomic, strong) MBStationTopView *behindView;
@property (nonatomic, strong) NSLayoutConstraint *behindHeightConstraint;
@property (nonatomic, strong) MBStation *station;
@property (nonatomic, assign) BOOL showRedBar;
@property (nonatomic, assign) BOOL hideEverything;

- (void)showBackgroundImage:(BOOL)showBackground;
- (void)hideNavbar:(BOOL)hidden;

@property(nonatomic,strong) UIColor* behindViewBackgroundColor;

#define STATION_SEARCH_PLACEHOLDER @"Suchen Sie etwas am Bahnhof?"

@end
