//
//  MBInputField.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 22.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "MBContentSearchInputField.h"

@implementation MBContentSearchInputField

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
    self.edgeInsets = UIEdgeInsetsMake(0, 20, 0, 15);
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
    CGRect rightBounds = CGRectMake(self.sizeWidth - (self.rightView.sizeWidth+15),
                                    self.sizeHeight/2-self.rightView.sizeHeight/2,
                                    self.rightView.sizeWidth, self.rightView.sizeHeight);
    return rightBounds;
}


@end
