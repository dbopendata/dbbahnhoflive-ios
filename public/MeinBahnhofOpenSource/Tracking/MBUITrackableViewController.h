//
//  MBUITrackableViewController.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 23.10.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBUITrackableViewController : UIViewController

@property (nonatomic, strong) NSString *trackingTitle;

@property(nonatomic,assign) MBUITrackableViewController* parentTrackingViewController;

@end
