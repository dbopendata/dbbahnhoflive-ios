//
//  MBWagenstandHeaderRedesigned.h
//  MeinBahnhof
//
//  Created by Heiko on 18.11.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Wagenstand;
@class Train;

@interface MBWagenstandHeaderRedesigned : UIView

- (instancetype) initWithWagenstand:(Wagenstand*)wagenstand train:(Train*)train andFrame:(CGRect)frame;

-(void)resizeForWidth:(CGFloat)width;

@end
