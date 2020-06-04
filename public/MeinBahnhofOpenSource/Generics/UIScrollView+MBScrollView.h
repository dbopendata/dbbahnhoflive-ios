//
//  UIScrollView+MBScrollView.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 11.08.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MBScrollView)

- (void) resizeToFitContent;
- (CGSize) calculateContentSize;
- (CGSize) calculateContentSizeHorizontally;

@end
