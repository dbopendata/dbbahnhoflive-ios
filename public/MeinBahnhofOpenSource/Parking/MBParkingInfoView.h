//
//  MBParkingInfoView.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 15.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBParkingInfo.h"

@class MBParkingInfo;

@protocol MBParkingInfoDelegate <NSObject>

@optional
- (void) didOpenOverviewForParking:(MBParkingInfo *)parking;
- (void) didOpenTarifForParking:(MBParkingInfo *)parking;
- (void) didStartNavigationForParking:(MBParkingInfo *)parking;

@end

@interface MBParkingInfoView : UIView

@property (nonatomic, weak) id<MBParkingInfoDelegate> delegate;
- (instancetype)initWithParkingItem:(MBParkingInfo *)item;

@end
