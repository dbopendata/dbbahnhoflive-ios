//
//  MBServiceCollectionViewCell.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 07.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBStationKachel.h"

@interface MBServiceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MBStationKachel *kachel;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic) BOOL imageAsBackground;


@end
