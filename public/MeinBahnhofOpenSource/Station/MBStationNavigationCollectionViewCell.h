//
//  MBStationNavigationCollectionViewCell.h
//  MeinBahnhof
//
//  Created by Heiko on 21.08.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBStationCollectionViewCell.h"
#import "MBStationKachel.h"

@interface MBStationNavigationCollectionViewCell : MBStationCollectionViewCell

@property (nonatomic, strong) MBStationKachel *kachel;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic) BOOL imageAsBackground;


@end
