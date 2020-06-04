//
//  MBMarker.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 12.11.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>


@class RIMapPoi;

enum MarkerType : NSUInteger
{
    MOBILITY = 1,
    VENUE = 2,
    FACILITY = 3,
    USER = 4,
    STATION = 5,//this is the currently opened station, it is not selectable on the map
    PARKING = 6,
    SERVICESTORE = 7,
    RIMAPPOI = 8,
    STATION_SELECTABLE = 9,
    OEPNV_SELECTABLE = 10,
};

@interface MBMarker : GMSMarker <NSCopying>

@property (nonatomic, assign) enum MarkerType markerType;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *secondaryCategory;
@property (nonatomic, assign) BOOL outdoor;

@property (nonatomic, strong) RIMapPoi* riMapPoi;
@property (nonatomic) NSInteger zoomLevel;

@property (nonatomic, strong) UIImage* iconWithoutText;
@property (nonatomic, strong) UIImage* iconWithText;
@property (nonatomic) NSInteger zoomForIconWithText;

@property(nonatomic,strong) UIImage* iconNormal;
@property(nonatomic,strong) UIImage* iconLarge;


+ (instancetype)markerWithPosition:(CLLocationCoordinate2D)position andType:(enum MarkerType)type;
- (id)copyWithZone:(NSZone *)zone;

@end
