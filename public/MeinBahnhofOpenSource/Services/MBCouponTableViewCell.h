//
//  MBCouponTableViewCell.h
//  MeinBahnhof
//
//  Created by Heiko on 05.12.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBExpandableTableViewCell.h"
#import "MBNews.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBCouponTableViewCell : MBExpandableTableViewCell

@property(nonatomic,strong) MBNews* newsItem;

-(NSInteger)expandableHeight;
@end

NS_ASSUME_NONNULL_END
