//
//  MBLargeButton.m
//  MeinBahnhof
//
//  Created by Heiko on 08.01.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBLargeButton.h"

@implementation MBLargeButton

-(instancetype)initWithFrame:(CGRect)frame{
    if(frame.size.height == 0){
        frame.size = CGSizeMake(frame.size.width, 60);
    }
    self = [super initWithFrame:frame];
    if(self){
        self.layer.cornerRadius = self.sizeHeight/2;
        [self setTitle:@"Title" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor db_GrayButton]];
        [self.titleLabel setFont:[UIFont db_BoldEighteen]];
        self.layer.shadowOffset = CGSizeMake(1.0, 2.0);
        self.layer.shadowColor = [[UIColor db_dadada] CGColor];
        self.layer.shadowRadius = 1.5;
        self.layer.shadowOpacity = 1.0;
    }
    return self;
}

@end