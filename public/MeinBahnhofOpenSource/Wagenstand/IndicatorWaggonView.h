//
//  IndicatorWaggonView.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 19.02.16.
//  Copyright © 2016 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Waggon;

@interface IndicatorWaggonView : UIView

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, strong) NSString *section;

- (instancetype) initWithFrame:(CGRect)frame andWaggon:(Waggon*)waggon;

@end
