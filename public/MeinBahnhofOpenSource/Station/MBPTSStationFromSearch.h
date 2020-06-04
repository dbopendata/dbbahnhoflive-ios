//
//  MBPTSStationFromSearch.h
//  MeinBahnhof
//
//  Created by Heiko on 21.01.20.
//  Copyright © 2020 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MBPTSStationFromSearch : NSObject

@property(nonatomic,strong) NSNumber* stationId;
@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSArray<NSString*>* eva_ids;
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic,strong) NSNumber* distanceInKm;

@property(nonatomic,strong) NSString* hafas_id;

-(NSArray<NSNumber*>*)location;
-(NSDictionary*)dictRepresentation;

@end
