//
//  MBEinkaufsbahnhofStore.h
//  MeinBahnhof
//
//  Created by Heiko on 19.04.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIMapPoi.h"

@interface MBEinkaufsbahnhofStore : NSObject

+(MBEinkaufsbahnhofStore*)parse:(NSDictionary*)dict;

@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSNumber* category_id;

@property(nonatomic,strong) NSString* web;
@property(nonatomic,strong) NSString* phone;
@property(nonatomic,strong) NSString* email;
@property(nonatomic,strong) NSString* location;
@property(nonatomic,strong) NSArray* paymentTypes;

@property(nonatomic,strong) NSArray* openingTimes;

-(ShopOpenState)isOpen;
@end
