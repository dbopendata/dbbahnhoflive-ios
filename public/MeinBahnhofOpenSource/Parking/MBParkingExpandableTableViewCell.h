//
//  MBParkingExpandableTableViewCell.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 15.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBParkingInfo.h"
#import "MBParkingInfoView.h"

@interface MBParkingExpandableTableViewCell : UITableViewCell <MBParkingInfoDelegate>

@property (nonatomic, strong) MBParkingInfo *item;
@property (nonatomic, weak) id<MBParkingInfoDelegate> delegate;
@property (nonatomic, assign) BOOL expanded;

-(NSInteger)bottomViewHeight;
@end
