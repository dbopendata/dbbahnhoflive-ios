//
//  UIScrollView+MBScrollView.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 11.08.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "UIScrollView+MBScrollView.h"

@implementation UIScrollView (MBScrollView)

- (void) resizeToFitContent
{
    self.contentSize = [self calculateContentSize];
}

- (CGSize) calculateContentSize
{
    UIView *lastView;
    for (UIView *subview in self.subviews) {
        if (!lastView) {
            lastView = subview;
        } else {
            double currentLastviewHeight = lastView.originY+lastView.sizeHeight;
            double subviewHeight = subview.originY+subview.sizeHeight;
            
            if (currentLastviewHeight < subviewHeight) {
                lastView = subview;
            }
        }
    }
    
    return CGSizeMake(self.sizeWidth, lastView.originY+lastView.sizeHeight);
}

- (CGSize) calculateContentSizeHorizontally
{
    UIView *lastView;
    for (UIView *subview in self.subviews) {
        if (!lastView) {
            lastView = subview;
        } else {
            double currentLastviewWidth = lastView.originX+lastView.sizeWidth;
            double subviewWidth = subview.originX+subview.sizeWidth;
            
            if (currentLastviewWidth < subviewWidth) {
                lastView = subview;
            }
        }
    }
    
    return CGSizeMake(lastView.originX+lastView.sizeWidth, self.sizeHeight);
}

@end
