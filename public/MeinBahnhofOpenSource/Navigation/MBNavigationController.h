//
//  MBNavigationController.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 23.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNavigationController : UINavigationController <UIGestureRecognizerDelegate, UIBarPositioningDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) UIColor *navigationBarColor;
@property (nonatomic, assign) BOOL swipeBackGestureEnabled;
@property (nonatomic, assign) BOOL rotationEnabled;


- (void) showLaunchImage;
- (void) hideLaunchImage;


@end
