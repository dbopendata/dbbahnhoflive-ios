//
//  MBFacilityDeleteAllTableViewCell.m
//  MeinBahnhof
//
//  Created by Marc O'Connor on 13.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "MBFacilityDeleteAllTableViewCell.h"

@interface MBFacilityDeleteAllTableViewCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *trash;
@property (nonatomic, strong) UILabel *deleteLabel;
@end

@implementation MBFacilityDeleteAllTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self configureCell];
    return self;
}

- (void)configureCell {
    UIView *backView = [UIView new];
    self.backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:backView];
        
    self.trash = [[UIButton alloc] init];
    [self.trash setImage:[UIImage db_imageNamed:@"app_loeschen"] forState:UIControlStateNormal];
    [self.trash addTarget:self action:@selector(deleteAll:) forControlEvents:UIControlEventTouchUpInside];
    self.trash.backgroundColor = [UIColor whiteColor];
    self.trash.layer.shadowOffset = CGSizeMake(1.0, 2.0);
    self.trash.layer.shadowColor = [[UIColor db_dadada] CGColor];
    self.trash.layer.shadowRadius = 1.5;
    self.trash.layer.shadowOpacity = 1.0;
    [backView addSubview:self.trash];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont db_RegularSixteen];
    label.textColor = [UIColor db_333333];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"Liste leeren";
    [backView addSubview:label];
    self.deleteLabel = label;
        
}

- (void)deleteAll:(UIButton *)sender {
    [self.delegate deleteAllFacilities];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.trash.frame = CGRectMake(0, 0, 40, 40);
    self.trash.layer.cornerRadius = self.trash.frame.size.height / 2.0;
    [self.trash centerViewVerticalInSuperView];
    [self.trash setGravityRight:16];
    
    [self.deleteLabel sizeToFit];
    [self.deleteLabel setLeft:self.trash withPadding:8];
    [self.deleteLabel centerViewVerticalInSuperView];
    
}

@end