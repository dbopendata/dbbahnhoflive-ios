//
//  MBServiceCell.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 03.07.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBLabel.h"
#import "MBDetailViewDelegate.h"
#import "MBStaticServiceView.h"
#import "MBShopDetailCellView.h"
#import "MBExpandableTableViewCell.h"

@interface MBServiceCell : MBExpandableTableViewCell 

@property (nonatomic, strong) id item;
@property (nonatomic, strong) id itemCategory;

@property (nonatomic, weak) id<MBDetailViewDelegate> delegate;
@property (nonatomic, strong) MBStaticServiceView *staticServiceView;
@property (nonatomic, strong) MBShopDetailCellView *shopDetailView;
// only visible in expanded view, and when the shop contains contact information
@property (nonatomic, strong) UIView *contactAddonView;


-(void)setItem:(id)item andCategory:(id)category;

@end
