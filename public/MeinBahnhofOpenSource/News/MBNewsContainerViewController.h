//
//  MBNewsContainerViewController.h
//  MeinBahnhof
//
//  Created by Heiko on 20.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBNews.h"
#import "MBStation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBNewsContainerViewController : UIViewController

@property(nonatomic,strong) NSArray<MBNews*>* newsList;
@property(nonatomic,strong) MBStation* station;
@end

NS_ASSUME_NONNULL_END
