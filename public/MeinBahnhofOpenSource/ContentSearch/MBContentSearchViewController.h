//
//  MBContentSearchViewController.h
//  MeinBahnhof
//
//  Created by Heiko on 09.04.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBStation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBContentSearchViewController : UIViewController

@property (nonatomic, strong) MBStation *station;

@end

NS_ASSUME_NONNULL_END
