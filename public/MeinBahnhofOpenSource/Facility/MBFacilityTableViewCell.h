//
//  MBFacilityTableViewCell.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 12.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacilityStatus.h"

@class MBFacilityTableViewCell;

@protocol MBFacilityTableViewCellDelegate
- (void)facilityCell:(MBFacilityTableViewCell *)cell addsFacility:(FacilityStatus *)status;
- (void)facilityCell:(MBFacilityTableViewCell *)cell removesFacility:(FacilityStatus *)status;
@end

@interface MBFacilityTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MBFacilityTableViewCellDelegate> delegate;
@property (nonatomic, strong) FacilityStatus *status;
@property (nonatomic, strong) NSString *currentStationName;
@property (nonatomic) BOOL expanded;

@end
