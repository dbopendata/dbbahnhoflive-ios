//
//  MBServiceListTableViewController.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 04.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBContentSearchResult;

@interface MBServiceListTableViewController : UITableViewController

- (instancetype)initWithItem:(id)item;

@property (nonatomic, strong) NSString *trackingTitle;
@property (nonatomic, strong) MBContentSearchResult* searchResult;


@end
