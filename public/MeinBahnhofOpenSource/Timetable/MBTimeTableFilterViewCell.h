//
//  MBTimeTableFilterViewCell.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 25.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTimeTableFilterViewCell;
@protocol MBTimeTableFilterViewCellDelegate <NSObject>

- (void)filterCellWantsToFilter;

@optional
- (void)filterCell:(MBTimeTableFilterViewCell *)cell setsAbfahrt:(BOOL)abfahrt;

@end

@interface MBTimeTableFilterViewCell : UITableViewCell

@property (nonatomic, weak) id<MBTimeTableFilterViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL filterOnly;
@property (nonatomic, assign) BOOL filterActive;
-(void)setFilterHidden:(BOOL)hidden;
-(void)switchToDeparture;
-(void)switchToArrival;
@end
