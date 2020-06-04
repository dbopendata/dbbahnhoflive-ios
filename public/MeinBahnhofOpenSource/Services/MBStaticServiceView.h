//
//  MBStaticServiceView.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 11.08.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBService.h"
#import "MBTextView.h"
#import "MBDetailViewDelegate.h"
#import "MBStation.h"

@interface MBStaticServiceView : UIView

@property (nonatomic, weak) id<MBDetailViewDelegate> delegate;

- (instancetype) initWithService:(MBService*)service fullscreenLayout:(BOOL)fullscren andFrame:(CGRect)frame;

-(NSInteger)layoutForSize:(NSInteger)frameWidth;

@end
