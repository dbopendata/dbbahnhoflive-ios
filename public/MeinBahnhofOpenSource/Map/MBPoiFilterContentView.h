//
//  MBPoiFilterContentView.h
//  MeinBahnhof
//
//  Created by Heiko on 20.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIFilterItem.h"

@class MBPoiFilterContentView;

@protocol MBPoiFilterContentViewDelegate <NSObject>

- (void) poiContent:(MBPoiFilterContentView*)view didSelectCategory:(POIFilterItem*)item;
- (void) poiContent:(MBPoiFilterContentView*)view didToggleAll:(BOOL)selected;
- (void) poiContent:(MBPoiFilterContentView*)view didChangeCategory:(POIFilterItem*)item;

@end


@interface MBPoiFilterContentView : UIView

@property(nonatomic,strong) POIFilterItem* parentCategory;
@property (nonatomic, strong) NSArray *categories;

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray*)items parent:(POIFilterItem*)parent;
-(void)reloadData;
@property(nonatomic,weak) id<MBPoiFilterContentViewDelegate> delegate;

@end
