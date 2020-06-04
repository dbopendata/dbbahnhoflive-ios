//
//  MBPoiFilterView.h
//  MeinBahnhof
//
//  Created by Heiko on 20.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POIFilterItem.h"

@class MBPoiFilterView;


@protocol MBPoiFilterViewDelegate <NSObject>

- (void) poiFilterWantsClose:(MBPoiFilterView*)view;
- (void) poiFilterDidChangeFilter:(MBPoiFilterView*)view;

@end

@interface MBPoiFilterView : UIView

-(instancetype)initWithFrame:(CGRect)frame categories:(NSArray*)categories;

@property (nonatomic, weak) id<MBPoiFilterViewDelegate> delegate;

-(void)animateInitialView;

-(NSArray*)currentFilterCategories;

@end
