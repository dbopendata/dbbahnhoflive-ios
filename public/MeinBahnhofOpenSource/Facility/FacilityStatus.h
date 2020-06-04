//
//  FacilityStatus.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 09.11.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <CoreLocation/CoreLocation.h>

enum State : NSUInteger {
    UNKNOWN = 0,
    ACTIVE  = 1,
    INACTIVE = 2
};

enum Type : NSUInteger {
    ESCALATOR = 0,
    ELEVATOR  = 1
};

@interface FacilityStatus : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *equipmentNumber;
@property (nonatomic, assign, readwrite) enum Type type;
@property (nonatomic, assign, readwrite) enum State state;
@property (nonatomic, copy) NSString *shortDescription;
@property (nonatomic, copy) NSNumber *geoCoordinateX;
@property (nonatomic, copy) NSNumber *geoCoordinateY;
@property (nonatomic, copy) NSNumber *stationNumber;

@property (nonatomic, assign, readwrite) CLLocationCoordinate2D centerLocation;

- (UIImage*)iconForState;
- (NSString*)title;

-(BOOL)isSameFacility:(FacilityStatus*)another;

@end
