//
//  MBContentSearchTableViewCell.m
//  MeinBahnhof
//
//  Created by Heiko on 17.04.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBContentSearchTableViewCell.h"

@implementation MBContentSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}
-(instancetype)init{
    self = [super init];
    [self setup];
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setup];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setup{
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.contentView addSubview:self.iconView];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.titleLabel.font = [UIFont db_RegularFourteen];
    self.titleLabel.textColor = [UIColor db_333333];
    [self.contentView addSubview:self.titleLabel];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.iconView setGravityLeft:30];
    [self.titleLabel setRight:self.iconView withPadding:10];
    [self.titleLabel setWidth:self.frame.size.width-self.titleLabel.originX-20];
    [self.iconView centerViewVerticalInSuperView];
    [self.titleLabel centerViewVerticalInSuperView];
}


@end
