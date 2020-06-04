//
//  NSDateFormatter+MBDateFormatter.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 03.07.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (MBDateFormatter)

+ (NSDateFormatter*) cachedDateFormatter;
+ (NSString*) formattedDate:(NSDate*)date forPattern:(NSString*)pattern;
+ (NSDate*) dateFromString:(NSString*)dateString forPattern:(NSString*)pattern;

@end
