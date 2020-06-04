//
//  MBSettingsTableViewCell.h
//  MeinBahnhof
//
//  Created by Heiko on 27.11.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSettingsTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel* mainTitleLabel;
@property(nonatomic,strong) UILabel* subTitleLabel;
@property(nonatomic,strong) UIImageView* mainIcon;
@property(nonatomic,strong) UISwitch* aSwitch;
@property(nonatomic) BOOL showDetails;

@end
