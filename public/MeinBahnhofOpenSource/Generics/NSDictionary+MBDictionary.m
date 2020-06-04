//
//  NSDictionary+MBDictionary.m
//  MeinBahnhof
//
//  Created by Heiko on 10.05.20.
//  Copyright © 2020 ScholzVolkmer. All rights reserved.
//

#import "NSDictionary+MBDictionary.h"

@implementation NSDictionary (MBDictionary)

-(NSDictionary *)db_dictForKey:(NSString *)key{
    if(![self isKindOfClass:NSDictionary.class])
        return nil;
    id something = self[key];
    if([something isKindOfClass:NSDictionary.class])
        return something;
    return nil;
}

-(NSArray *)db_arrayForKey:(NSString *)key{
    if(![self isKindOfClass:NSDictionary.class])
        return nil;
    id something = self[key];
    if([something isKindOfClass:NSArray.class])
        return something;
    return nil;
}

-(NSNumber *)db_numberForKey:(NSString *)key{
    if(![self isKindOfClass:NSDictionary.class])
        return nil;
    id something = self[key];
    if([something isKindOfClass:NSNumber.class])
        return something;
    return nil;
}

-(NSNumber *)db_stringForKey:(NSString *)key{
    if(![self isKindOfClass:NSDictionary.class])
        return nil;
    id something = self[key];
    if([something isKindOfClass:NSString.class])
        return something;
    return nil;
}

@end