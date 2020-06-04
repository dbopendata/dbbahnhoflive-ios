//
//  MBStationTabBarViewController.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 12.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBStationTabBarView.h"
#import "MBStation.h"

@protocol MBStationTabBarViewControllerDelegate <NSObject>

- (void)goBackToSearch;

@end

@interface MBStationTabBarViewController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, weak) id<MBStationTabBarViewControllerDelegate> delegate;
@property (nonatomic, strong) MBStationTabBarView *tabBarView;
@property (nonatomic, strong) NSNumber *topSlack;

- (UIViewController *)selectViewControllerAtIndex:(NSUInteger)index;
- (UIViewController *)visibleViewController; 
- (void)disableTabAtIndex:(NSUInteger)index;
- (void)enableTabAtIndex:(NSUInteger)index;
- (void)showTabbar;
- (instancetype)initWithViewControllers:(NSArray *)viewControllers station:(MBStation*)station;

@end
