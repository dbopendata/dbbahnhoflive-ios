//
//  MBExpandableTableViewCell.m
//  MeinBahnhof
//
//  Created by Heiko on 05.12.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBExpandableTableViewCell.h"

@implementation MBExpandableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setExpanded:(BOOL)expanded {
    _expanded = expanded;
    [self updateStateAfterExpandChange];
}

-(void)updateStateAfterExpandChange{
    
}

@end
