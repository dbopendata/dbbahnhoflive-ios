//
//  MBStationViewController.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 07.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBStation.h"
#import "MBStationKachel.h"
#import "MBRootContainerViewController.h"
#import "MBMapViewController.h"

@interface MBStationViewController : UIViewController<MBRootContainerViewControllerDelegate,MBMapViewControllerDelegate>

-(void)updateMapMarkersForFacilities;
-(void)openOPNV;
-(void)openStationFeatures;

@property (nonatomic, strong) MBStation *station;
@property (nonatomic, strong) MBStationTabBarViewController *tabBarViewController;


@end
