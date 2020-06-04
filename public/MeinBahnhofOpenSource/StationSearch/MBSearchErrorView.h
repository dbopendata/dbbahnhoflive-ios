//
//  MBSearchErrorView.h
//  MeinBahnhof
//
//  Created by Heiko on 11.08.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBSearchErrorView;

@protocol MBSearchErrorViewDelegate
-(void)searchErrorDidPressActionButton:(MBSearchErrorView*)errorView;
@end

@interface MBSearchErrorView : UIView

-(void)setHeaderText:(NSString*)headerText bodyText:(NSString*)bodyText actionButton:(NSString*)actionText;
@property(nonatomic,weak) id<MBSearchErrorViewDelegate> delegate;
@end
