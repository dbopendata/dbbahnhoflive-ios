//
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import "MBPTSAvailabilityTimes.h"

@interface MBPTSAvailabilityTimes()

@end

@implementation MBPTSAvailabilityTimes

static NSArray* dayOrder = nil;
static NSArray* displayTitles = nil;

-(instancetype)initWithArray:(NSArray *)availability{
    self = [super init];
    if(self){
        if(!dayOrder){
            dayOrder = @[@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday", @"holiday"];
            displayTitles = @[ @"Montag", @"Dienstag", @"Mittwoch", @"Donnerstag", @"Freitag", @"Samstag", @"Sonntag", @"Feiertags"];
        }
        
        self.availabilityStrings = [NSMutableArray arrayWithCapacity:8];
        NSInteger index = 0;
        for(NSString* dayKey in dayOrder){
            for(NSDictionary* dayDict in availability){
                if([dayDict[@"day"] isEqualToString:dayKey]){
                    NSString* from = [dayDict objectForKey:@"openTime"];
                    NSString* to = [dayDict objectForKey:@"closeTime"];
                    if(dayDict){
                        [self.availabilityStrings addObject:[NSString stringWithFormat:@"%@: %@-%@", displayTitles[index], from,to]];
                    }
                    index++;
                }
            }
        }
    }
    return self;
}

-(NSString *)availabilityString{
    NSMutableString* res = [NSMutableString new];
    for(NSString* str in self.availabilityStrings){
        [res appendString:str];
        [res appendString:@"<br>"];
    }
    return res;
}

@end
