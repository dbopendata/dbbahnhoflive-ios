//
//  MBShopDetailCellView.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 10.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueExtraField.h"
#import "RIMapPoi.h"
#import "MBEinkaufsbahnhofStore.h"

@interface MBShopDetailCellView : UIView

@property (nonatomic, strong) RIMapPoi *poi;
@property (nonatomic, strong) MBEinkaufsbahnhofStore *store;

- (instancetype)initWithPXR:(RIMapPoi *)poi;
- (instancetype)initWithStore:(MBEinkaufsbahnhofStore *)poi;

-(BOOL)hasContactLinks;
-(VenueExtraField*)contactLinks;

-(NSInteger)layoutForSize:(NSInteger)frameWidth;
+(NSString*)displayStringOpenTimesForStore:(MBEinkaufsbahnhofStore*)store;

@end
