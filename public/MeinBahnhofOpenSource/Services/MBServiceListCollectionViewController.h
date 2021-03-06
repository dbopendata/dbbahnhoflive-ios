//
//  MBServiceListCollectionViewController.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 15.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBStation.h"
#import "MBStationTabBarViewController.h"
#import "MBMapViewController.h"

@class MBContentSearchResult;

@interface MBServiceListCollectionViewController : UIViewController<MBMapViewControllerDelegate>

@property (nonatomic, strong) MBContentSearchResult* searchResult;
@property (nonatomic) BOOL openChatBotScreen;
@property (nonatomic) BOOL openPickPackScreen;
@property (nonatomic, strong) MBStation *station;
@property (nonatomic, assign) BOOL showsBackButton;

@property (nonatomic, strong) MBStationTabBarViewController *tabBarViewController;

/// @param type NSString @"info" for Bahnhofsinformationen, @"shopping" for Shoppen & Schlemmen
- (instancetype)initWithType:(NSString *)type;

@end
