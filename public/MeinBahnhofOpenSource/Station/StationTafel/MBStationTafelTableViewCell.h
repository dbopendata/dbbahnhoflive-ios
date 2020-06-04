//
//  MBStationTafelTableViewCell.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 13.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stop.h"
#import "HafasDeparture.h"

@interface MBStationTafelTableViewCell : UITableViewCell

@property (nonatomic, strong) Stop *stop;
@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) HafasDeparture *hafas;

@end
