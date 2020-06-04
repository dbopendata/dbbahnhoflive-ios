//
//  MBStationCollectionViewCell.m
//  MeinBahnhof
//
//  Created by Marc O'Connor on 07.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "MBStationCollectionViewCell.h"

@interface MBStationCollectionViewCell()

@end

@implementation MBStationCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    self.backgroundColor = [UIColor whiteColor];

    self.layer.shadowColor = [[UIColor db_dadada] CGColor];
    self.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOpacity = 1.0;
    
    return self;
}

@end
