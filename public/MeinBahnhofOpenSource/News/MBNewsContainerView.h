//
//  MBNewsContainerView.h
//  MeinBahnhof
//
//  Created by Heiko on 20.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBNews.h"

@class MBNewsContainerViewController;

NS_ASSUME_NONNULL_BEGIN

@interface MBNewsContainerView : UIView

@property(nonatomic,strong) MBNews* news;
@property(nonatomic,weak) MBNewsContainerViewController* containerVC;

@end

NS_ASSUME_NONNULL_END
