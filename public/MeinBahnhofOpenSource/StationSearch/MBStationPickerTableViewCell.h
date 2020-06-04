//
//  MBStationPickerTableViewCell.h
//  MeinBahnhof
//
//  Created by Heiko on 19.11.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBStationPickerTableViewCell;

@protocol MBStationPickerTableViewCellDelegate <NSObject>

@optional
- (void) stationPickerCell:(MBStationPickerTableViewCell*)cell changedFavStatus:(BOOL)favStatus;
- (void) stationPickerCellDidLongPress:(MBStationPickerTableViewCell*)cell;
- (void) stationPickerCellDidTapDeparture:(MBStationPickerTableViewCell*)cell;

@end

@interface MBStationPickerTableViewCell : UITableViewCell

@property(nonatomic,strong) NSDictionary* station;
@property(nonatomic,weak) id<MBStationPickerTableViewCellDelegate> delegate;
@property(nonatomic) BOOL showDetails;
@property(nonatomic) BOOL showDistance;

@end
