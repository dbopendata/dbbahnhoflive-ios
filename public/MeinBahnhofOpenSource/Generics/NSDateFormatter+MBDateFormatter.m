//
//  NSDateFormatter+MBDateFormatter.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 03.07.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "NSDateFormatter+MBDateFormatter.h"

@implementation NSDateFormatter (MBDateFormatter)

static NSDateFormatter *formatter;

+ (NSDateFormatter*) cachedDateFormatter
{
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    return formatter;
}

+ (NSString*) formattedDate:(NSDate*)date forPattern:(NSString*)pattern
{
    [[NSDateFormatter cachedDateFormatter] setDateFormat:pattern];
    return [[NSDateFormatter cachedDateFormatter] stringFromDate:date];
}

+ (NSDate*) dateFromString:(NSString*)dateString forPattern:(NSString*)pattern
{
    [[NSDateFormatter cachedDateFormatter] setDateFormat:pattern];
    return [[NSDateFormatter cachedDateFormatter] dateFromString:dateString];
}

@end
