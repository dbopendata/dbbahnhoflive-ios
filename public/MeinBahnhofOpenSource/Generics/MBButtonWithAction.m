//
//  MBButtonWithAction.m
//  MeinBahnhof
//
//  Created by Heiko on 06.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "MBButtonWithAction.h"

@implementation MBButtonWithAction

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if(self){
        [self setup];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}


-(void)setup{
    [self addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnPressed:(id)sender{
    if(self.actionBlock){
        self.actionBlock();
    }
}

@end
