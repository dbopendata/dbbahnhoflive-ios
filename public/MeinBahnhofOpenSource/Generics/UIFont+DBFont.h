//
//  UIFont+DBFont.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 06.08.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (DBFont)

+ (UIFont*)dbHeadLightWithSize:(CGFloat)size;
+ (UIFont*)dbHeadBlackWithSize:(CGFloat)size;


+ (UIFont*)db_BoldTen;
+ (UIFont*)db_BoldTwelve;
+ (UIFont*)db_BoldFourteen;
+ (UIFont*)db_BoldFiveteen;
+ (UIFont*)db_BoldSixteen;
+ (UIFont*)db_BoldSeventeen;
+ (UIFont*)db_BoldEighteen;
+ (UIFont*)db_BoldTwenty;
+ (UIFont*)db_BoldTwentyTwo;
+ (UIFont*)db_BoldTwentyFive;
+ (UIFont*)db_BoldThirtyTwo;

+ (UIFont*)db_RegularWithSize:(CGFloat)size;
+ (UIFont*)db_BoldWithSize:(CGFloat)size;

+ (UIFont*)db_RegularEight;
+ (UIFont*)db_RegularTen;
+ (UIFont*)db_RegularTwelve;
+ (UIFont*)db_RegularFourteen;
+ (UIFont*)db_RegularFiveteen;
+ (UIFont*)db_RegularSixteen;
+ (UIFont*)db_RegularSeventeen;

+ (UIFont*)db_RegularTwenty;
+ (UIFont*)db_RegularTwentyTwo;
+ (UIFont*)db_RegularTwentyFour;
+ (UIFont*)db_RegularTwentyFive;

+ (UIFont*)db_HelveticaBoldNine;
+ (UIFont*)db_HelveticaBoldTwelve;
+ (UIFont*)db_HelveticaBoldFourteen;
+ (UIFont*)db_HelveticaBoldFifteen;
+ (UIFont*)db_HelveticaBoldSixteen;

+ (UIFont*)db_HelveticaNine;
+ (UIFont*)db_HelveticaTwelve;
+ (UIFont*)db_HelveticaFourteen;
+ (UIFont*)db_HelveticaFifteen;
+ (UIFont*)db_HelveticaSixteen;
+ (UIFont*)db_HelveticaTwentyFour;
@end
