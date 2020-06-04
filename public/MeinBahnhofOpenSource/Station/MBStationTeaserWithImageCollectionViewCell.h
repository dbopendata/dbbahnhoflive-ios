//
//  MBStationTeaserWithImageCollectionViewCell.h
//  MeinBahnhof
//
//  Created by Heiko on 12.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBStationCollectionViewCell.h"
#import "MBStationKachel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBStationTeaserWithImageCollectionViewCell : MBStationCollectionViewCell

-(void)setKachel:(MBStationKachel *)kachel;
@property(nonatomic) MBStationTeaserType type;

@end

NS_ASSUME_NONNULL_END
