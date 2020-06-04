//
//  MBOverlayViewController.h
//  MeinBahnhof
//
//  Created by Heiko on 27.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MBOverlayViewController : UIViewController

@property(nonatomic,strong,readonly) UIView* headerView;
@property(nonatomic,strong,readonly) UILabel* titleLabel;
@property(nonatomic,strong,readonly) UIView* contentView;
@property(nonatomic) BOOL overlayIsPresentedAsChildViewController;

-(void)hideOverlay;
-(NSInteger)expectedContentHeight;
@end
