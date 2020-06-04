//
//  MBHafasTimetableDataSource.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 22.11.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBTimeTableFilterViewCell.h"
#import "MBTimetableViewController.h"

@class HafasDeparture;

@interface MBHafasTimetableDataSource : NSObject <UITableViewDataSource>

@property (nonatomic,strong) NSDate* lastRequestedDate;
@property (nonatomic, strong) NSIndexPath* selectedRow;
@property (nonatomic, weak) MBTimetableViewController *viewController;
@property (nonatomic, weak) id<MBTimeTableFilterViewCellDelegate> delegate;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) NSString *cellIdentifierHeader;
@property (nonatomic, strong) NSArray<HafasDeparture*> *hafasDepartures;
@property (nonatomic, strong) NSArray *hafasDeparturesByDay;

@end
