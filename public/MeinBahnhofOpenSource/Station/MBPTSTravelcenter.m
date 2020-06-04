//
//  MBPTSTravelcenter.m
//  MeinBahnhof
//
//  Created by Heiko on 17.09.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBPTSTravelcenter.h"

@interface MBPTSTravelcenter()
@property(nonatomic,strong) NSDictionary* data;
@property(nonatomic,strong) CLLocation* location;
@end

@implementation MBPTSTravelcenter

-(instancetype)initWithDict:(NSDictionary*)json{
    self = [super init];
    if(self){
        if([json isKindOfClass:[NSDictionary class]]){
            self.data = json;
        }
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate{
    NSNumber* lat = self.data[@"lat"];
    NSNumber* lng = self.data[@"lon"];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat.doubleValue, lng.doubleValue);
    return loc;
}
-(CLLocation*)location{
    if(!_location){
        CLLocationCoordinate2D coordinate = [self coordinate];
        _location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    }
    return _location;
}

-(NSString *)title{
    return self.data[@"name"];
}
-(NSString *)address{
    return self.data[@"address"];
}
-(NSString *)postCode{
    return self.data[@"postCode"];
}
-(NSString *)city{
    return self.data[@"city"];
}
-(NSString*)openingTimes{
    NSDictionary* openingDict = self.data[@"openingTimes"];
    if([openingDict isKindOfClass:NSDictionary.class]){
        NSArray* dayKeys = @[@"mon",@"tue",@"wed",@"thu",@"fri",@"sat",@"sun"];
        NSArray* dayVisible = @[@"Montag",@"Dienstag",@"Mittwoch",@"Donnerstag",@"Freitag",@"Samstag",@"Sonntag"];
        NSMutableString* res = [[NSMutableString alloc] init];
        NSInteger index = 0;
        for(NSString* dayKey in dayKeys){
            NSArray* times = openingDict[dayKey];
            if([times isKindOfClass:NSArray.class] && times.count > 0){
                [res appendString:dayVisible[index]];
                [res appendString:@": "];                
                for(int t=0; t<times.count; t++){
                    NSString* time = times[t];
                    if([time isKindOfClass:NSString.class]){
                        [res appendString:time];
                        if(t+1 < times.count){
                            [res appendString:@", "];
                        }
                    }
                }
                [res appendString:@"\n"];
            }
            index++;
        }
        return res;
    }
    return @"-";
}


@end
