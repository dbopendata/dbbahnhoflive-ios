//
//  MBStationInfrastructureViewController.h
//  MeinBahnhof
//
//  Created by Heiko on 10.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "MBOverlayViewController.h"
#import "MBStation.h"

@interface MBStationInfrastructureViewController : MBOverlayViewController

@property(nonatomic,strong) MBStation* station;

+(BOOL)displaySomeEntriesOnlyWhenAvailable:(MBStation*)station;

@end
