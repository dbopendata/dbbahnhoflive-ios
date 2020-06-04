//
//  MBStationTabBarView.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 12.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBStationTabView.h"

@protocol MBStationTabBarViewDelegate <NSObject>

- (void)didSelectTabAtIndex:(NSUInteger)index;

@end

@interface MBStationTabBarView : UIView <MBStationTabViewDelegate>

@property (nonatomic, weak) id<MBStationTabBarViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame tabBarImages:(NSArray *)templateImages titles:(NSArray*)titles;
- (void)selectTabIndex:(NSUInteger)index;
- (void)disableTabIndex:(NSUInteger)index;
- (void)enableTabIndex:(NSUInteger)index;

@end
