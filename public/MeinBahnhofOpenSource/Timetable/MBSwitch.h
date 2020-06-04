//
//  MBSwitch.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 26.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSwitch : UIControl

@property (nonatomic, assign, getter=isOn) BOOL on;

@property (nonatomic, assign) BOOL noShadow;
@property (nonatomic, assign) BOOL noRoundedCorners;
@property (nonatomic, strong) UIFont *activeLabelFont;
@property (nonatomic, strong) UIFont *inActiveLabelFont;
@property (nonatomic, strong) UIColor *activeTextColor;
@property (nonatomic, strong) UIColor *inActiveTextColor;

- (instancetype)initWithFrame:(CGRect)frame onTitle:(NSString *)onTitle offTitle:(NSString *)offTitle onState:(BOOL)onState;

@end
