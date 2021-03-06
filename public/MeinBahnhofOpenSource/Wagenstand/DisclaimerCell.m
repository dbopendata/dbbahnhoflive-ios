//
//  DisclaimerCell.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 07.01.16.
//  Copyright © 2016 ScholzVolkmer. All rights reserved.
//

#import "DisclaimerCell.h"

@interface DisclaimerCell()

@property (nonatomic, strong) UILabel *disclaimerLabel;

@end

@implementation DisclaimerCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.disclaimerLabel = [[UILabel alloc] init];
        self.disclaimerLabel.text = @"Daten laut Aushangplan.";
        self.disclaimerLabel.font = [UIFont db_HelveticaNine];
        self.disclaimerLabel.textColor = [UIColor blackColor];
        [self.disclaimerLabel sizeToFit];
        

    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.disclaimerLabel centerViewHorizontalInSuperView];
    [self.disclaimerLabel setGravityTop:10];
}

@end
