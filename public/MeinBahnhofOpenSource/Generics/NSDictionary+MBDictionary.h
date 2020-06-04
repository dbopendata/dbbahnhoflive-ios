//
//  NSDictionary+MBDictionary.h
//  MeinBahnhof
//
//  Created by Heiko on 10.05.20.
//  Copyright © 2020 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (MBDictionary)

-(NSArray*)db_arrayForKey:(NSString*)key;
-(NSDictionary*)db_dictForKey:(NSString*)key;
-(NSString*)db_stringForKey:(NSString*)key;
-(NSNumber*)db_numberForKey:(NSString*)key;


@end

NS_ASSUME_NONNULL_END
