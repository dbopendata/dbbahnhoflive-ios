//
//  MBTriangleView.m
//  MeinBahnhof
//
//  Created by Heiko on 11.08.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import "MBTriangleView.h"

@implementation MBTriangleView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        UIBezierPath* trianglePath = [UIBezierPath bezierPath];
        [trianglePath moveToPoint:CGPointMake(0, self.frame.size.height)];
        [trianglePath addLineToPoint:CGPointMake(self.frame.size.width,self.frame.size.height)];
        [trianglePath addLineToPoint:CGPointMake(self.frame.size.width/2, 0)];
        [trianglePath closePath];
        CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
        [triangleMaskLayer setPath:trianglePath.CGPath];
        self.layer.mask = triangleMaskLayer;
    }
    return self;
}

@end
