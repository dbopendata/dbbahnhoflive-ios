//
//  HafasStopLocation.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 17.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Mantle/Mantle.h>

@interface HafasStopLocation : MTLModel <MTLJSONSerializing>

/// JSON Property "id"
@property (nonatomic, strong) NSString *stopId;
@property (nonatomic, strong) NSString *extId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *lon;
@property (nonatomic, strong) NSNumber *lat;

- (CLLocationCoordinate2D) positionAsLatLng;

@end
