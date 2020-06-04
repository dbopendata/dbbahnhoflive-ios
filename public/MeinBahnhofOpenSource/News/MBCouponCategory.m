//
//  MBCouponCategory.m
//  MeinBahnhof
//
//  Created by Heiko on 02.12.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBCouponCategory.h"

@implementation MBCouponCategory

-(NSString *)title{
    return @"Rabatt Coupons";
}
+(UIImage *)image{
    return [UIImage db_imageNamed:@"coupon"];
}


@end
