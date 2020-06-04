//
//  MBCouponCategory.h
//  MeinBahnhof
//
//  Created by Heiko on 02.12.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNews.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBCouponCategory : NSObject

-(NSString*)title;
+(UIImage*)image;
@property(nonatomic,strong) NSArray<MBNews*>* items;

@end

NS_ASSUME_NONNULL_END
