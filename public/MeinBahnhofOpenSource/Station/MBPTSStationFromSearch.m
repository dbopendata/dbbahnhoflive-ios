//
//  MBPTSStationFromSearch.m
//  MeinBahnhof
//
//  Created by Heiko on 21.01.20.
//  Copyright © 2020 ScholzVolkmer. All rights reserved.
//

#import "MBPTSStationFromSearch.h"

@implementation MBPTSStationFromSearch

- (id)copyWithZone:(NSZone *)zone
{
    MBPTSStationFromSearch *copy = [[[self class] allocWithZone:zone] init];
    copy.stationId = self.stationId;
    copy.coordinate = self.coordinate;
    copy.distanceInKm = self.distanceInKm;
    copy.eva_ids = self.eva_ids;
    copy.hafas_id = self.hafas_id;
    copy.stationId = self.stationId;
    copy.title = self.title;
    return copy;
}

-(NSDictionary *)dictRepresentation{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:6];
    if(_stationId){
        dict[@"id"] = _stationId;
    }
    if(_title){
        dict[@"title"] = _title;
    }
    if(_eva_ids){
        dict[@"eva_ids"] = _eva_ids;
    }
    if(_coordinate.latitude != 0){
        dict[@"location"] = [self location];
    }
    if(_distanceInKm){
        dict[@"distanceInKm"] = _distanceInKm;
    } else {
        dict[@"distanceInKm"] = @0;
    }
    if(_hafas_id){
        dict[@"hafas_id"] = _hafas_id;
    }
    return dict;
}
-(NSArray*)location{
    return @[[NSNumber numberWithDouble:_coordinate.latitude],[NSNumber numberWithDouble:_coordinate.longitude]];
}

@end
