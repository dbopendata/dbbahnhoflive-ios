//
//  MBSettingViewController.h
//  MeinBahnhof
//
//  Created by Heiko on 27.11.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBUIViewController.h"
#import "MBStation.h"


@interface MBSettingViewController : UIViewController

@property(nonatomic,strong) MBStation* currentStation;

@end
