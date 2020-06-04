//
//  MBExpandableTableViewCell.h
//  MeinBahnhof
//
//  Created by Heiko on 05.12.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBExpandableTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL expanded;
-(void)updateStateAfterExpandChange;
@end
