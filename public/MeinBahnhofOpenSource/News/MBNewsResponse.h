//
//  MBNewsResponse.h
//  MeinBahnhof
//
//  Created by Heiko on 19.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNews.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBNewsResponse : NSObject

-(instancetype)initWithResponse:(NSDictionary*)json;
-(BOOL)isValid;
-(NSArray<MBNews*>*)currentNewsItems;
-(NSArray<MBNews*>*)currentOfferItems;

@end

NS_ASSUME_NONNULL_END
