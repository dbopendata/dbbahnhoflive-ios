//
//  MBNews.h
//  MeinBahnhof
//
//  Created by Heiko on 19.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBNewsType) {
    MBNewsTypeUndefined = 0,
    MBNewsTypeOffer = 1,//coupon
    MBNewsTypeDisruption = 2,
    MBNewsTypePoll = 3,
    MBNewsTypeProductsServices = 4,
};

#define DEBUG_LOAD_UNPUBLISHED_NEWS NO

@interface MBNews : NSObject

-(BOOL)validWithData:(NSDictionary*)json;

-(nullable UIImage*)image;
-(MBNewsType)newsType;
-(NSString*)title;
-(NSString*)content;
-(NSString*)link;
-(BOOL)hasLink;
-(BOOL)hasValidTime;
-(NSComparisonResult)compare:(MBNews *)news;

+(NSArray*)debugData;

@end

NS_ASSUME_NONNULL_END
