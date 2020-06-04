//
//  MBLinkButton.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 20.08.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBLinkButton : UIButton

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *labelText;
@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, strong) UIColor *titleColor;


+ (instancetype) buttonWithLeftImage:(NSString*)imageName;
+ (instancetype) buttonWithRightImage:(NSString*)imageName;
+ (instancetype) buttonWithRedLink;
@end
