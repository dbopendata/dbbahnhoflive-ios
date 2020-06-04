//
//  HeadCell.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Waggon.h"
#import "Train.h"

@interface HeadCell : UITableViewCell

@property (nonatomic, strong) UIImageView *trainIconView;
@property (nonatomic, strong) Waggon *waggon;
@property (nonatomic, strong) Train *train;

@property (nonatomic, assign) BOOL head;

- (void) setWaggon:(Waggon *)waggon lastPosition:(BOOL)lastPosition;

@end
