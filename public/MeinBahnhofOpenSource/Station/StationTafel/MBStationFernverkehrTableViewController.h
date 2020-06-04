//
//  MBStationFernverkehrTableViewController.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 13.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBStationFernverkehrTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *trains;

- (instancetype)initWithTrains:(NSArray *)trains;

@end
