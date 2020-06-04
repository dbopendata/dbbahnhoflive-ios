//
//  WagenstandHeaderTrainCell.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 07.01.16.
//  Copyright © 2016 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Train.h"

@interface WagenstandHeaderTrainCell : UIView

@property (nonatomic, assign) BOOL expanded;

- (instancetype) initCellWithTrain:(Train*)train andFrame:(CGRect)frame splitTrain:(BOOL)splitTrain;

@end
