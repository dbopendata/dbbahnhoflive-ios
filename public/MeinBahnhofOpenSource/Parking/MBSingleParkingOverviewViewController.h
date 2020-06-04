//
//  MBSingleParkingOverviewViewController.h
//  MeinBahnhof
//
//  Created by Heiko on 16.11.16.
//  Copyright © 2016 ScholzVolkmer. All rights reserved.
//

#import "MBUIViewController.h"
#import "MBParkingInfo.h"
#import "MBTextView.h"
#import "MBOverlayViewController.h"

@interface MBSingleParkingOverviewViewController : MBOverlayViewController <MBTextViewDelegate>

@property(nonatomic,strong) MBParkingInfo* parking;

@property(nonatomic) BOOL showTarif;

@end
