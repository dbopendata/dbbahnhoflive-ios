//
//  MBNewsOverlayViewController.h
//  MeinBahnhof
//
//  Created by Heiko on 22.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBOverlayViewController.h"
#import "MBNews.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBNewsOverlayViewController : MBOverlayViewController

@property(nonatomic,strong) MBNews* news;

@end

NS_ASSUME_NONNULL_END
