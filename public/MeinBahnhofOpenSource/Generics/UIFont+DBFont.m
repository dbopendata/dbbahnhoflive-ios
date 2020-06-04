//
//  UIFont+DBFont.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 06.08.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "UIFont+DBFont.h"

@implementation UIFont (DBFont)

#define IPAD_INCREASE (2.5f)

#define FONT_REGULAR @"DBSans-Regular"
#define FONT_BOLD @"DBSans-Bold"

+(UIFont *)db_RegularWithSize:(CGFloat)size{
    UIFont* f = [UIFont fontWithName:FONT_REGULAR size:size];
    if(!f){
        return [UIFont systemFontOfSize:size];
    }
    return f;
}
+(UIFont *)db_BoldWithSize:(CGFloat)size{
    UIFont* f = [UIFont fontWithName:FONT_BOLD size:size];
    if(!f){
        return [UIFont boldSystemFontOfSize:size];
    }
    return f;
}

+(UIFont *)dbHeadBlackWithSize:(CGFloat)size{
    UIFont* f = [UIFont fontWithName:@"DBHead-Black" size:size];
    if(!f){
        return [UIFont boldSystemFontOfSize:size];
    }
    return f;
}
+(UIFont *)dbHeadLightWithSize:(CGFloat)size{
    UIFont* f = [UIFont fontWithName:@"DBHead-Light" size:size];
    if(!f){
        return [UIFont systemFontOfSize:size];
    }
    return f;
}


+ (UIFont *)db_BoldTen { return [self db_BoldWithSize:10 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_BoldTwelve { return [self db_BoldWithSize:12 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_BoldFourteen { return [self db_BoldWithSize:14 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_BoldFiveteen { return [self db_BoldWithSize:15 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_BoldSixteen { return [self db_BoldWithSize:16.f + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_BoldSeventeen { return [self db_BoldWithSize:17.f + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_BoldEighteen { return [self db_BoldWithSize:18 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_BoldTwenty { return [self db_BoldWithSize:20 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_BoldTwentyTwo { return [self db_BoldWithSize:22 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_BoldTwentyFive { return [self db_BoldWithSize:25 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_BoldThirtyTwo { return [self db_BoldWithSize:32.f + (ISIPAD ? IPAD_INCREASE : 0)]; }

+ (UIFont *)db_RegularEight { return [self db_RegularWithSize:8]; }

+ (UIFont *)db_RegularTen { return [self db_RegularWithSize:10.0 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_RegularTwelve { return [self db_RegularWithSize:12.0 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_RegularFourteen { return [self db_RegularWithSize:14.0 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_RegularFiveteen { return [self db_RegularWithSize:15.0 + (ISIPAD ? IPAD_INCREASE : 0)]; };
+ (UIFont *)db_RegularSixteen { return [self db_RegularWithSize:16.f + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_RegularSeventeen { return [self db_RegularWithSize:17.f + (ISIPAD ? IPAD_INCREASE : 0)]; }

+ (UIFont *)db_RegularTwenty { return [self db_RegularWithSize:20.f + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_RegularTwentyTwo { return [self db_RegularWithSize:22.f + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont*)db_RegularTwentyFour { return [self db_RegularWithSize:24.f + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont*)db_RegularTwentyFive { return [self db_RegularWithSize:25.f + (ISIPAD ? IPAD_INCREASE : 0)]; }

+ (UIFont *)db_HelveticaBoldNine { return [UIFont fontWithName:@"HelveticaNeue-Bold" size:9 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_HelveticaBoldTwelve { return [UIFont fontWithName:@"HelveticaNeue-Bold" size:12 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_HelveticaBoldFourteen { return [UIFont fontWithName:@"HelveticaNeue-Bold" size:14 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_HelveticaBoldFifteen { return [UIFont fontWithName:@"HelveticaNeue-Bold" size:15 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_HelveticaBoldSixteen { return [UIFont fontWithName:@"HelveticaNeue-Bold" size:16 + (ISIPAD ? IPAD_INCREASE : 0)]; }

+ (UIFont *)db_HelveticaNine { return[UIFont fontWithName:@"HelveticaNeue" size:9 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_HelveticaTwelve { return[UIFont fontWithName:@"HelveticaNeue" size:12 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_HelveticaFourteen { return [UIFont fontWithName:@"HelveticaNeue" size:14 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_HelveticaFifteen { return [UIFont fontWithName:@"HelveticaNeue" size:15 + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_HelveticaSixteen { return [UIFont fontWithName:@"HelveticaNeue" size:16.f + (ISIPAD ? IPAD_INCREASE : 0)]; }
+ (UIFont *)db_HelveticaTwentyFour { return [UIFont fontWithName:@"HelveticaNeue" size:24.f + (ISIPAD ? IPAD_INCREASE : 0)]; }



@end