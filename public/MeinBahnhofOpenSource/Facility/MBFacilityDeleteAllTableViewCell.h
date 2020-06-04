//
//  MBFacilityDeleteAllTableViewCell.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 13.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBFacilityDeleteAllTableViewCellDelegate
- (void)deleteAllFacilities;
@end

@interface MBFacilityDeleteAllTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MBFacilityDeleteAllTableViewCellDelegate> delegate;

@end
