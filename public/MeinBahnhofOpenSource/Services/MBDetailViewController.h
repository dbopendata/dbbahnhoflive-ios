//
//  MBDetailViewController.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 25.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBUIViewController.h"
#import "MBTextView.h"

#import "MBService.h"

#import "MBDetailViewDelegate.h"

#import "MBStaticServiceView.h"
#import "MBMapViewController.h"

@interface MBDetailViewController : MBUIViewController <MBDetailViewDelegate,MBMapViewControllerDelegate>

@property (nonatomic, strong) id item;
@property (nonatomic, strong) NSArray *levels;
@property (nonatomic, assign) BOOL indoorNavigationEnabled;

- (instancetype) initWithService:(MBService*)service;

@end
