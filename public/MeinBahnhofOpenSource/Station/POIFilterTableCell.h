//
//  POIFilterTableCell.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 10.08.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIFilterItem.h"

@interface POIFilterTableCell : UITableViewCell

@property (nonatomic, strong) POIFilterItem *item;

-(void)setLastCell:(BOOL)isLastCell;

@end
