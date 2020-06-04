//
//  MBTimetableFilterViewController.h
//  MeinBahnhof
//
//  Created by Heiko on 27.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBOverlayViewController.h"

@class MBTimetableFilterViewController;
@class HafasTimetable;

@protocol MBTimetableFilterViewControllerDelegate <NSObject>

-(void)filterView:(MBTimetableFilterViewController*)filterView didSelectTrainType:(NSString*)type track:(NSString*)track;

@end

@interface MBTimetableFilterViewController : MBOverlayViewController

@property (nonatomic,strong) HafasTimetable* hafasTimetable;
@property (nonatomic) BOOL departure;
@property(nonatomic,strong) NSString* initialSelectedPlatform;
@property(nonatomic,strong) NSString* initialSelectedTransportType;
@property (nonatomic) BOOL useHafas;

@property (nonatomic,weak) id<MBTimetableFilterViewControllerDelegate> delegate;

@end
