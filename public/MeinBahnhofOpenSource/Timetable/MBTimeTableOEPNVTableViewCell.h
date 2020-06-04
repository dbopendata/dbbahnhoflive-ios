//
//  MBTimeTableOEPNVTableViewCell.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 26.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HafasDeparture.h"

@interface MBTimeTableOEPNVTableViewCell : UITableViewCell

@property (nonatomic, strong) HafasDeparture *hafas;
@property (nonatomic) BOOL expanded;

@end
