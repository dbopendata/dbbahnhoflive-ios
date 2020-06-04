//
//  MBInputField.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 22.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "MBInputField.h"

@implementation MBInputField

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configureDefaults];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        [self configureDefaults];
    }
    return self;
}

- (void) configureDefaults
{
    self.backgroundColor = [UIColor whiteColor];
    self.edgeInsets = UIEdgeInsetsMake(0, 15, 0, 10);
    self.font = [UIFont db_RegularFourteen];
    self.textColor = [UIColor db_333333];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightBounds = CGRectMake(self.sizeWidth - (self.rightView.sizeWidth+10),
                                    self.sizeHeight/2-self.rightView.sizeHeight/2,
                                    self.rightView.sizeWidth, self.rightView.sizeHeight);
    return rightBounds;
}


@end
