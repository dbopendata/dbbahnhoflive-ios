//
//  MBMapView.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 11.08.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "MBMapView.h"
#import "MBGPSLocationManager.h"
#import "MBMarker.h"

#import "RIMapPoi.h"
#import "MBStation.h"
#import "RIMapFilterCategory.h"
#import "RIMapManager.h"
#import "MBMapInternals.h"
#import "FacilityStatus.h"

@interface MBMapView()

@property (nonatomic, strong) GMSMapView *gmsMapView;

@property (nonatomic, strong) GMSMarker *userMarker;
@property (nonatomic, strong) GMSMarker *stationMarker;
@property (nonatomic, strong) MBMarker *destinationMarker;
@property (nonatomic, strong) CLLocation *currentUserLocation;

@property (nonatomic, strong) MBMapFlyout *flyout;
@property (nonatomic, strong) GMSCameraPosition *cameraPosition;

@property (nonatomic, strong) GMSTileLayer *tileLayer;
@property (nonatomic, strong) GMSTileLayer *indoorLayer;

@property (nonatomic, assign) BOOL displayOutdoor;

@property (nonatomic, assign) double currentZoomLevel;
@property (nonatomic, strong) NSString* currentIndoorLevelString;

@property (nonatomic, strong) NSMutableArray *mobilityMarker;
@property (nonatomic, strong) NSMutableArray *facilityMarker;
@property (nonatomic, strong) NSMutableArray *poiMarker;
@property (nonatomic, strong) NSMutableArray *nearbyStationsMarker;

//these arrays contain the markers that are available for the current filter settings. They may be shown on the map or hidden (depending on the zoom level and selected level)
@property (nonatomic, strong) NSMutableArray *outdoorMarkers;
@property (nonatomic, strong) NSArray *indoorMarkers;
@property (nonatomic, strong) NSArray *allIndoorAndOutdoorMarkersForCurrentFilter;

@property (nonatomic, strong) NSArray*poiDetailList;

@property(nonatomic,strong) MBMarker* lastSelectedMarker;

@property(nonatomic,strong) UILabel* zoomDebugLabel;

@end

@implementation MBMapView


static const NSInteger outdoorLevel = 15;//changed from 17
static const NSInteger skyHighLevel = 13;//changed from 14


- (id)sharedMapViewForFrame:(CGRect)frame withPosition:(GMSCameraPosition*)cameraPosition
{
    GMSMapView *mapView = [[GMSMapView alloc] initWithFrame:frame];
    mapView.camera = cameraPosition;
    
    mapView.frame = frame;
    mapView.selectedMarker = nil;
    self.showLinkToDetail = YES;
    
    self.currentZoomLevel = DEFAULT_ZOOM_LEVEL_WITHOUT_INDOOR;
    
    return mapView;
}

- (instancetype) initWithFrame:(CGRect)frame forCameraPosition:(GMSCameraPosition*)cameraPosition
{
    if (self = [super initWithFrame:frame]) {
        self.indoorMarkers  = [NSArray array];
        self.outdoorMarkers = [NSMutableArray array];
        self.mobilityMarker = [NSMutableArray array];
        self.facilityMarker = [NSMutableArray array];
        self.poiMarker = [NSMutableArray array];
        
        BOOL debugZoomLevel = NO;
        if(debugZoomLevel){
            self.zoomDebugLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 20)];
            self.zoomDebugLabel.textColor = [UIColor blackColor];
            self.zoomDebugLabel.backgroundColor = [UIColor whiteColor];
        }

        self.cameraPosition = cameraPosition;
        if (!self.gmsMapView) {
            self.gmsMapView = [self sharedMapViewForFrame:frame withPosition:self.cameraPosition];
        }
        [self enableDefaultMapViewSettings];

        [self addSubview:self.gmsMapView];
        self.defaultZoomLevel = DEFAULT_ZOOM_LEVEL_WITHOUT_INDOOR;
        [self addIndoorMap];
        
        if(_zoomDebugLabel){
            [self addSubview:self.zoomDebugLabel];
        }
    }
    return self;
}

- (instancetype) initMapViewWithFrame:(CGRect)frame
{
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(51.404930, 9.923518) zoom:6];
    if (self = [self initWithFrame:frame forCameraPosition:cameraPosition]) {}
    return self;
}


-(void)configureMapForStation:(MBStation*)station{
    self.station = station;
    [self setLevels:station.levels];
    BOOL fallbackToUserPosition = NO;
    if(CLLocationCoordinate2DIsValid(station.positionAsLatLng)){
        GMSCameraPosition* cam = [GMSCameraPosition cameraWithTarget:station.positionAsLatLng zoom:self.defaultZoomLevel];
        [self moveCameraTo:cam animated:NO];
    } else {
        fallbackToUserPosition = YES;
    }
    if(station.displayStationMap){
        [self setPOIs:station.riPois];
    }
    [self setStationMarker:[station markerForStation]];
    [self updateFacilityMarker];
    
    if(fallbackToUserPosition){
        self.currentUserLocation = [[MBGPSLocationManager sharedManager] lastKnownLocation];
        
        GMSCameraPosition* cam = [GMSCameraPosition cameraWithTarget:self.currentUserLocation.coordinate zoom:self.defaultZoomLevel];
        [self moveCameraTo:cam animated:NO];
    }
}




-(void)addIndoorMap{
    if(![MBMapInternals indoorTileURLForLevel:@"0" zoom:0 x:0 y:0]){
        return;//no indoor tile pattern available
    }
    
    if(!self.indoorLayer){
        // Implement GMSTileURLConstructor
        // Returns a Tile based on the x,y,zoom coordinates, and the requested floor
        __weak MBMapView* weakSelf = self;
        GMSTileURLConstructor urls = ^(NSUInteger x, NSUInteger y, NSUInteger zoom) {
            //indoor map
            //NSString* indoorLevel = [_currentLevel.levelString uppercaseString];
            NSString* url = [MBMapInternals indoorTileURLForLevel:weakSelf.currentIndoorLevelString zoom:zoom x:x y:y];
            
            //NSLog(@"get tile for zoom %lu, %@",(unsigned long)zoom,url);
            return [NSURL URLWithString:url];
        };
        
        if (!self.tileLayer) {
            // Create the GMSTileLayer if it doesn't exist
            self.indoorLayer = [GMSURLTileLayer tileLayerWithURLConstructor:urls];
            self.indoorLayer.tileSize = 512; //[UIScreen mainScreen].scale = 512; //256 : 512;
            
            // Display on the map at a specific zIndex
            self.indoorLayer.zIndex = 100;
        }
    }
    self.indoorLayer.map = self.gmsMapView;
    self.gmsMapView.indoorEnabled = NO;//disable googles "indoor"
}


//

- (void)userDidTapOnPinToUserButton:(id)sender
{
    self.cameraFollowsUser = YES;
    if (self.currentUserLocation) {
        if(!sender){
            //don't animate, its forced from code and not the user
            [self showUserMarkerAtLocation:self.currentUserLocation animate:NO];
            GMSCameraPosition* cam = [GMSCameraPosition cameraWithTarget:self.currentUserLocation.coordinate zoom:self.currentZoomLevel];
            [self moveCameraTo:cam animated:NO];
        } else {
            [self showUserMarkerAtLocation:self.currentUserLocation animate:YES];
            [self moveCameraTo:self.userMarker.position atZoomLevel:self.currentZoomLevel];
        }
        
    } else {
        // inactive
        
    }
    
    [[MBGPSLocationManager sharedManager] getOneShotLocationUpdate];
}

//

- (void)toggleMapType{
    MAP_TYPE newMapType;
    
    if (self.currentMapType == OSM) {
        newMapType = GOOGLE;
    } else {
        newMapType = OSM;
    }
    
    if (newMapType == self.currentMapType) {
        return;
    }
    [self setMapType:newMapType];
}
-(void)setMapType:(MAP_TYPE)newMapType{
    [self toggleTileSource:newMapType];
    [self saveTileSource:newMapType];
}

- (void) saveTileSource:(MAP_TYPE)tileSource
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:tileSource forKey:@"map_tile_source"];
    [userDefaults synchronize];
}

- (MAP_TYPE) storedMapSource
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger mapSource = [userDefaults integerForKey:@"map_tile_source"];
    if (mapSource == OSM) {
        return OSM;
    } else {
        return GOOGLE;
    }
}

- (void) toggleTileSource:(MAP_TYPE)type
{
    if (type == OSM) {
        if(![self enableOSMTileLayer]){
            //failure
            type = GOOGLE;
        }
    } else if (type == GOOGLE) {
        self.tileLayer.map = nil;
        //[self.tileLayer clearTileCache];
        self.gmsMapView.mapType = kGMSTypeNormal;
    }
    
    [self layoutIfNeeded];
    self.currentMapType = type;
    if(self.currentMapType == OSM && self.levels.count == 0){
        [self.gmsMapView setMinZoom:0 maxZoom:MAX_ZOOM_NOINDOOR_OSM-1];
    } else {
        [self.gmsMapView setMinZoom:0 maxZoom:MAX_ZOOM_REST];
    }

}



- (BOOL) enableOSMTileLayer
{
    if(![MBMapInternals backgroundTileURLForZoom:0 x:0 y:0]){
        self.tileLayer.map = nil;
        self.gmsMapView.mapType = kGMSTypeNormal;
        return false;
    }
    
    // Implement GMSTileURLConstructor
    // Returns a Tile based on the x,y,zoom coordinates, and the requested floor
    GMSTileURLConstructor urls = ^(NSUInteger x, NSUInteger y, NSUInteger zoom) {
        //background map
        NSString* url = [MBMapInternals backgroundTileURLForZoom:(int)round(zoom) x:(int)x y:(int)y];
        //NSLog(@"get tile for zoom %lu, %@",(unsigned long)zoom,url);
        return [NSURL URLWithString:url];
    };

    if (!self.tileLayer) {
        // Create the GMSTileLayer if it doesn't exist
        self.tileLayer = [GMSURLTileLayer tileLayerWithURLConstructor:urls];
        self.tileLayer.tileSize = 512; //[UIScreen mainScreen].scale = 512; //256 : 512;

        // Display on the map at a specific zIndex
        self.tileLayer.zIndex = 10;
    }
    //[self.tileLayer clearTileCache];
    self.tileLayer.map = self.gmsMapView;
    self.gmsMapView.mapType = kGMSTypeNone;
    return true;
}


- (void) resume
{
    self.currentUserLocation = [[MBGPSLocationManager sharedManager] lastKnownLocation];
    
    if (self.currentUserLocation) {
        [self showUserMarkerAtLocation:self.currentUserLocation animate:NO];
    }
}

/**
 Call this method before the map becomes invisible (viewDidDisappear:)
 This makes sure, that all added features are removed and the mapview instance is clean for re-use
 **/
- (void) suspend
{
    [self.flyout hideAnimated];
}

- (void) moveCameraToUser:(GMSCameraPosition*)cameraPosition animated:(BOOL)animated;
{
    if (self.cameraFollowsUser) {
        [self moveCameraTo:cameraPosition animated:animated];
    }
}

- (void) moveCameraTo:(GMSCameraPosition*)cameraPosition animated:(BOOL)animated;
{
    if (cameraPosition) {
        
        self.cameraPosition = cameraPosition;
                
        if (animated) {
            [self.gmsMapView animateToCameraPosition:self.cameraPosition];
        } else {
            [self.gmsMapView moveCamera:[GMSCameraUpdate setCamera:self.cameraPosition]];
        }
    }
}

- (void) enableDefaultMapViewSettings
{
    self.filterMarkerByLevel = YES;
    self.gmsMapView.delegate = self;
    self.gmsMapView.settings.indoorPicker = NO;
    self.gmsMapView.settings.consumesGesturesInView = NO;
    self.gmsMapView.settings.compassButton = NO;
    
    [self.gmsMapView setPadding:UIEdgeInsetsMake(40, 0, 0, 0)];
    
    [self.gmsMapView setIndoorEnabled:NO];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.gmsMapView.frame = CGRectMake(0,0, self.frame.size.width, self.sizeHeight);

}

-(void)setCurrentLevel:(LevelplanWrapper *)level{
    _currentLevel = level;
    self.currentIndoorLevelString = [level.levelString uppercaseString];
    if (level) {
        //self.indoorLayer.indoorLevel = [level.levelString uppercaseString];
        if(self.indoorLayer.map){
            //reset the map link to force reloading
            self.indoorLayer.map = nil;
            self.indoorLayer.map = self.gmsMapView;
        }
        [self showMarkersForLevel:level];
        [self updateUserMarkerVisibility:self.currentUserLocation];
        [self updatePOIDetailList];

        if ([self.delegate respondsToSelector:@selector(mapView:didChangeLevelTo:)]) {
            [self.delegate mapView:self didChangeLevelTo:level];
        }
    }

}


- (void) setLevels:(NSArray *)levels
{
    _levels = levels;
    //configure google map style, style created with https://mapstyle.withgoogle.com/
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *styleUrl = [mainBundle URLForResource:@"MapStyle" withExtension:@"json"];
    
    if(levels.count == 0){
        //if the station has no indoor map, we should limit the zoom-factor to 16 and remove the indoorLayer.map
        self.indoorLayer.map = nil;
        
        self.defaultZoomLevel = DEFAULT_ZOOM_LEVEL_WITHOUT_INDOOR;
        
        if(self.currentMapType == OSM){
            [self.gmsMapView setMinZoom:0 maxZoom:MAX_ZOOM_NOINDOOR_OSM-1];
        } else {
            [self.gmsMapView setMinZoom:0 maxZoom:MAX_ZOOM_REST];
        }
        
        styleUrl = [mainBundle URLForResource:@"mapstyle_noindoor" withExtension:@"json"];
    } else {
        
        self.defaultZoomLevel = DEFAULT_ZOOM_LEVEL_WITH_INDOOR;
        
        if(self.indoorLayer.map == nil){
            [self addIndoorMap];
        }
        
        [self.gmsMapView setMinZoom:0 maxZoom:MAX_ZOOM_REST];
    }
    
    // Set the map style by passing the URL for style.json.
    NSError *error;
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    
    if (!style) {
        // NSLog(@"The style definition could not be loaded: %@", error);
    } else {
        self.gmsMapView.mapStyle = style;
    }

}

- (void)setSupportsIndoor:(BOOL)supportsIndoor
{
    _supportsIndoor = supportsIndoor;
    
}

- (void) setShowFilterToggle:(BOOL) showFilterToggle
{
    _showFilterToggle = showFilterToggle;
}

- (void) setCurrentZoomLevel:(double)currentZoomLevel
{
    _currentZoomLevel = currentZoomLevel;
    if(_zoomDebugLabel){
        self.zoomDebugLabel.text = [NSString stringWithFormat:@"%f -> %f",_gmsMapView.camera.zoom,currentZoomLevel];
    }
}

- (BOOL) isOutdoor
{
    return self.currentZoomLevel <= outdoorLevel;
}

- (void) setFilterMarkerByLevel:(BOOL)filterByLevel
{
    _filterMarkerByLevel = filterByLevel;
}

- (void) setIndoorMarkers:(NSArray *)indoorMarkers
{
    [self clearIndoorPOIs];
    _indoorMarkers = indoorMarkers;
    
    
}

- (void) updateOutdoorMarkers:(NSArray *)markers
{
    [self.outdoorMarkers enumerateObjectsUsingBlock:^(GMSMarker *marker, NSUInteger idx, BOOL * _Nonnull stop) {
        marker.map = nil;
    }];
    [self.outdoorMarkers removeAllObjects];
    [self.outdoorMarkers addObjectsFromArray:markers];
    
    
}

- (void)setStationMarker:(GMSMarker *)stationMarker
{
    _stationMarker = stationMarker;
    _stationMarker.zIndex = 12;
    _stationMarker.map = self.gmsMapView;
}

#pragma -
#pragma MBFlyoutDelegate

- (void)startNavigationTo:(id)poi
{
    [self.delegate showRoutingControllerFor:(MBMarker*)self.gmsMapView.selectedMarker];
}

- (void)showRoutingForParking:(MBParkingInfo *)parking
{
    [self.delegate showRoutingForParking:parking];
}


- (void)showFacilityFavorites
{
    [self.delegate showFacilityFavorites];
}


#pragma -
#pragma MBMapPickerDelegate


- (void) reloadMapView
{
    BOOL skyHigh = self.currentZoomLevel < skyHighLevel;
    if(skyHigh){
        [self clearIndoorPOIs];
        [self clearOutdoorPOIs];
        [self showOnlyNearbyPOIs];
    } else {
        LevelplanWrapper *level = self.currentLevel;
        [self showMarkersForLevel:level];
        
    }
    // general state handling
    self.stationMarker.map = self.gmsMapView;
    [self updateUserMarkerVisibility:self.currentUserLocation];
    
    [self updatePOIDetailList];
    if (self.lastSelectedMarker) {
        [self configureMarkerIconDisabled:self.lastSelectedMarker];
    }
}


- (void) showUserMarkerAtLocation:(CLLocation*)location animate:(BOOL)animate
{
    NSLog(@"showUserMarkerAtLocation: %@ %d",location,animate);
    self.currentUserLocation = location;
    
    double oldBearing = 0;

    if (self.userMarker) {
        oldBearing = self.userMarker.rotation;
    } else {
        self.userMarker = [MBMarker markerWithPosition:location.coordinate andType:USER];
        self.userMarker.icon = [UIImage db_imageNamed:@"UserLocationPin"];
        self.userMarker.groundAnchor = CGPointMake(.5,.5);
        self.userMarker.zIndex = 999;
    }
    
    [self updateUserMarkerVisibility:location];
    
    if (self.cameraFollowsUser && animate) {
        [self moveCameraTo:self.currentUserLocation.coordinate atZoomLevel:self.gmsMapView.camera.zoom];
    }
    
    self.userMarker.rotation = oldBearing;
    
    if(animate){
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.8];
    }
    self.userMarker.position = location.coordinate;
    if(animate){
        [CATransaction commit];
    }
}

- (void) updateUserMarkerVisibility:(CLLocation*)location
{
    if (self.userMarker == nil) {
        return;
    }

    BOOL showUserMarker = YES;
    BOOL mapIsExpanded = self.sizeHeight == self.superview.sizeHeight;

    
    if (!showUserMarker || !mapIsExpanded) {
        self.userMarker.map = nil;
    } else {
        self.userMarker.map = self.gmsMapView;
    }
}

- (void) showOutdoorMarkers
{
    float zoomLevel = self.gmsMapView.camera.zoom;
    LevelplanWrapper *level = self.currentLevel;
    
    for (GMSMarker *outdoorMarker in self.outdoorMarkers) {
        if (outdoorMarker && outdoorMarker.userData) {
            outdoorMarker.flat = NO;
            //outdoorMarker.zIndex = 13;
            if(self.filterMarkerByLevel && [outdoorMarker isKindOfClass:[MBMarker class]]){
                MBMarker* outdoor = (MBMarker*)outdoorMarker;
                NSNumber *markerLevelNumber = [outdoor.userData objectForKey:@"level"];
                BOOL levelOk = !markerLevelNumber || markerLevelNumber.integerValue == level.levelNumber;
                if(outdoor.zoomLevel <= zoomLevel && levelOk){
                    outdoorMarker.map = self.gmsMapView;
                } else {
                    if(levelOk && (outdoor.markerType == OEPNV_SELECTABLE || outdoor.markerType == STATION_SELECTABLE)){
                        //always show these
                        outdoorMarker.map = self.gmsMapView;
                    } else {
                        outdoorMarker.map = nil;
                    }
                }
            } else {
                outdoorMarker.map = self.gmsMapView;
            }
            if(outdoorMarker.map){
                [self configureMarkerIconDisabled:(MBMarker*)outdoorMarker];
            }
        }
    }
}

- (void) showMarkersForLevel:(LevelplanWrapper*)level
{
    float zoomLevel = self.gmsMapView.camera.zoom;
    for (MBMarker *indoorMarker in self.indoorMarkers) {
        
        if (indoorMarker && indoorMarker.userData) {
            indoorMarker.map = nil;
            indoorMarker.zIndex = 13;
            
            NSNumber *markerLevelNumber = [indoorMarker.userData objectForKey:@"level"];
            if (!self.filterMarkerByLevel) {
                indoorMarker.map = self.gmsMapView;
            } else {
                if (level.levelNumber == [markerLevelNumber integerValue] && indoorMarker.zoomLevel <= zoomLevel) {
                    indoorMarker.map = self.gmsMapView;
                }
            }
            
            if(indoorMarker.zoomForIconWithText != 0){
                indoorMarker.icon = indoorMarker.zoomForIconWithText <= zoomLevel ? indoorMarker.iconWithText : indoorMarker.iconWithoutText;
            }
            
            [self configureMarkerIconDisabled:indoorMarker];
        }
    }
    
    [self showOutdoorMarkers];
}


#pragma -
#pragma GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    self.cameraPosition = position;
    //NSLog(@"changed map zoom from %f to %f",self.currentZoomLevel,mapView.camera.zoom);
    NSInteger lastZoom = self.currentZoomLevel;//clip!
    NSInteger nextZoom = mapView.camera.zoom;
    BOOL zoomChanged = lastZoom != nextZoom;
    self.currentZoomLevel = (int) mapView.camera.zoom;
    
    // compare old state with new
    if(zoomChanged){
        // NSLog(@"zoomed to %f",self.currentZoomLevel);
        [self reloadMapView];
    }
    
    // notify delegate that mapview did move
    
    if ([self.delegate respondsToSelector:@selector(mapViewIdleAtLocation:)]) {
        [self.delegate mapViewIdleAtLocation:mapView.camera.target];
    }
    
}
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    if(_zoomDebugLabel){
        self.zoomDebugLabel.text = [NSString stringWithFormat:@"%f -> %f",_gmsMapView.camera.zoom,_currentZoomLevel];
    }
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if (gesture) {
        self.cameraFollowsUser = NO;
    }
}

- (void) clearIndoorPOIs
{
    [self.indoorMarkers enumerateObjectsUsingBlock:^(GMSMarker *marker, NSUInteger idx, BOOL * _Nonnull stop) {
        marker.map = nil;
    }];
}

- (void) clearOutdoorPOIs
{
    [self.outdoorMarkers enumerateObjectsUsingBlock:^(GMSMarker *marker, NSUInteger idx, BOOL * _Nonnull stop) {
        marker.map = nil;
    }];
}

- (void)showOnlyNearbyPOIs
{
    // NSLog(@"showOnlyNearbyPOIs");
    __block GMSMarker *firstMarker = nil;
    [self.outdoorMarkers enumerateObjectsUsingBlock:^(GMSMarker *marker, NSUInteger idx, BOOL * _Nonnull stop) {
        enum MarkerType type = [(MBMarker *)marker markerType];
        if (type == STATION_SELECTABLE || type == OEPNV_SELECTABLE) {
            marker.map = self.gmsMapView;
            if (nil == firstMarker) {
                firstMarker = marker;
            }
        } else {
            marker.map = nil;
        }
    }];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.flyout hideAnimated];
    mapView.selectedMarker = nil;
    
    
    [self configureMarkerIconDisabled:self.lastSelectedMarker];
    self.lastSelectedMarker = nil;
    
    if ([self.delegate respondsToSelector:@selector(didCloseFlyoutMapView:)]) {
        [self.delegate didCloseFlyoutMapView:self];
    }
    
}

-(void)configureMarkerIconDisabled:(MBMarker*)marker{
    marker.icon = marker.iconNormal;
}
-(void)configureMarkerIconEnabled:(MBMarker*)marker{
    marker.icon = marker.iconLarge;
}

-(void)selectAndCenterMarker:(MBMarker*)marker{
    [self selectAndCenterMarker:marker animated:YES];
}
-(void)selectAndCenterMarker:(MBMarker*)marker animated:(BOOL)animated{
    [self configureMarkerIconDisabled:self.lastSelectedMarker];
    [self configureMarkerIconEnabled:marker];
    
    self.gmsMapView.selectedMarker = marker;
    self.lastSelectedMarker = marker;
    [self updatePositionAndZoomForMarker:marker animated:animated];
}
-(void)updatePositionAndZoomForMarker:(MBMarker*)marker animated:(BOOL)animated{
    CGPoint point = [self.gmsMapView.projection pointForCoordinate:marker.position];
    CLLocationCoordinate2D coordinate = [self.gmsMapView.projection coordinateForPoint:point];
    
    double newZoom = self.gmsMapView.camera.zoom;
    if(marker.zoomLevel > newZoom){
        newZoom = marker.zoomLevel;
    }
    
    [self moveCameraTo:[GMSCameraPosition cameraWithTarget:coordinate zoom:newZoom
                                                   bearing:self.gmsMapView.camera.bearing
                                              viewingAngle:self.gmsMapView.camera.viewingAngle] animated:animated];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    [self.flyout hideAnimated];
    
    if (marker == self.userMarker || marker == self.stationMarker) {
        return NO;
    }
    
    if (!marker.userData) {
        return YES;
    }
    
    [self selectAndCenterMarker:(MBMarker*)marker];
    
    [MBTrackingManager trackActionsWithStationInfo:@[@"f1", @"tap", @"pin"]];
    
    //NSLog(@"found marker in swipe list: %d",[self.poiDetailList containsObject:marker]);
    
    if ([self.delegate respondsToSelector:@selector(willOpenFlyoutOnMapView:marker:)]) {
        [self.delegate willOpenFlyoutOnMapView:self marker:(MBMarker*)marker];
    }

    return YES;
}

- (void) moveCameraTo:(CLLocationCoordinate2D)point atZoomLevel:(NSInteger)zoomLevel
{
    GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:point zoom:zoomLevel];
    [self.gmsMapView animateWithCameraUpdate:cameraUpdate];
}

# pragma Filter Actions
- (void)didTapOnFilterToggleButton:(id)sender
{
    [self.delegate didTapOnFilterToggleButton:self];
}

-(void)setPOIs:(NSArray*)riPois{
    // Create POI Pins
    self.filterMarkerByLevel = YES;
    self.showFilterToggle = YES;
    
    [self.poiMarker enumerateObjectsUsingBlock:^(GMSMarker *marker, NSUInteger idx, BOOL * _Nonnull stop) {
        marker.map = nil;
    }];
    [self.poiMarker removeAllObjects];
    for(RIMapPoi* poi in riPois){
        MBMarker* marker = poi.mapMarker;
        [self.poiMarker addObject:marker];
    }
    [self updateMarkers];
}

- (void)updateNearbyStationsMarker {
    if (nil != self.nearbyStationsMarker) {
        [self.nearbyStationsMarker enumerateObjectsUsingBlock:^(GMSMarker *marker, NSUInteger idx, BOOL * _Nonnull stop) {
            marker.map = nil;
        }];
        [self.nearbyStationsMarker removeAllObjects];
    } else {
        self.nearbyStationsMarker = [NSMutableArray new];
    }
    [self.nearbyStationsMarker addObjectsFromArray:self.nearbyStations];
    [self updateMarkers];
}

-(void)updateFacilityMarker{
    [self.facilityMarker enumerateObjectsUsingBlock:^(GMSMarker *marker, NSUInteger idx, BOOL * _Nonnull stop) {
        marker.map = nil;
    }];
    [self.facilityMarker removeAllObjects];
    [self.facilityMarker addObjectsFromArray:self.station.getFacilityMapMarker];
    [self updateMarkers];
}

-(void)updateMobilityMarker:(NSArray*)mobilityMarker{
    [self.mobilityMarker enumerateObjectsUsingBlock:^(GMSMarker *marker, NSUInteger idx, BOOL * _Nonnull stop) {
        marker.map = nil;
    }];
    [self.mobilityMarker removeAllObjects];
    [self.mobilityMarker addObjectsFromArray:mobilityMarker];
    [self updateMarkers];
}


- (void) updateMarkers
{
    /*NSLog(@"updateMarkers %lu faci, %lu parkin, %lu servstore, %lu mobil, %lu poi. Filter=%@",(unsigned long)self.facilityMarker.count,(unsigned long)self.station.parkingInfoItems.count, (unsigned long)self.station.markersForServiceStores.count, (unsigned long)self.mobilityMarker.count, (unsigned long)self.poiMarker.count,self.filterValues);*/
    NSMutableArray* allOutdoorMarker = [NSMutableArray array];
    NSMutableArray* allIndoorMarker = [NSMutableArray arrayWithCapacity:self.poiMarker.count];
    
    // add nearby stations
    [allOutdoorMarker addObjectsFromArray:self.nearbyStationsMarker];
    
    //add facility
    [allOutdoorMarker addObjectsFromArray:self.facilityMarker];
    //parking
    for (MBParkingInfo* parking in self.station.parkingInfoItems) {
        MBMarker* m = [parking markerForParkingWithSelectable:YES];
        if(m){
            [allOutdoorMarker addObject:m];
        }
    }
    
    [allOutdoorMarker addObjectsFromArray:self.mobilityMarker];
    
    //and for indoor:
    [allIndoorMarker addObjectsFromArray:self.poiMarker];
    
    NSArray* finalIndoorMarker;
    NSArray* finalOutdorMarker;

    if (self.filterValues) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self.category IN %@ OR self.secondaryCategory IN %@)",
                                  self.filterValues, self.filterValues];
        
        
        NSArray *filteredIndoorArray = [allIndoorMarker filteredArrayUsingPredicate:predicate];
        NSArray *filteredOutdoorArray = [allOutdoorMarker filteredArrayUsingPredicate:predicate];
        
        finalIndoorMarker = filteredIndoorArray;
        finalOutdorMarker = filteredOutdoorArray;
    
    } else {
        finalIndoorMarker = allIndoorMarker;
        finalOutdorMarker = allOutdoorMarker;
    }
    [self setIndoorMarkers:finalIndoorMarker];
    [self updateOutdoorMarkers:finalOutdorMarker];
    self.allIndoorAndOutdoorMarkersForCurrentFilter = [[finalIndoorMarker arrayByAddingObjectsFromArray:finalOutdorMarker] mutableCopy];

    [self reloadMapView];
}

-(MBMarker*)preselectMarkerAfterFilterChange{
    //NSLog(@"all markers: %@",self.allIndoorAndOutdoorMarkersForCurrentFilter);
    //NSLog(@"display list: %@",self.poiDetailList);
    NSLog(@"selected marker: %@",self.lastSelectedMarker);
    MBMarker* marker = nil;
    if(self.poiDetailList.count > 0){
        marker = self.poiDetailList.firstObject;
    } else {
        NSLog(@"no detail list, we have no markers to show on this level...");
        for(MBMarker* m in self.allIndoorAndOutdoorMarkersForCurrentFilter){
            if(m.map != nil){
                marker = m;
                NSLog(@"selected a visible marker from list of available markers");
                break;
            }
        }
        if(!marker){
            NSLog(@"no marker visible on map, find one the same level");
            for(MBMarker* m in self.allIndoorAndOutdoorMarkersForCurrentFilter){
                NSNumber *markerLevelNumber = [m.userData objectForKey:@"level"];
                if(self.currentLevel.levelNumber == [markerLevelNumber integerValue]){
                    marker = m;
                    NSLog(@"selected a marker on the current level");
                    break;
                }
            }
        }
        if(!marker){
            NSLog(@"still no marker found, just use the first one");
            marker = self.allIndoorAndOutdoorMarkersForCurrentFilter.firstObject;
        }
    }
    return marker;
}

-(void)updatePOIDetailList
{
    //NSLog(@"updatePOIDetailList with indoor %lu and outdoor %lu",(unsigned long)self.indoorMarkers.count,(unsigned long)self.outdoorMarkers.count);
    NSMutableArray* list = [NSMutableArray arrayWithCapacity:self.indoorMarkers.count+self.outdoorMarkers.count];
    //this is the list that is used when swiping left/right in the flyout view. It is sorted by the subcategories
    //that we use for the filter
    NSMutableArray* allVisibleMarker = [[self.indoorMarkers arrayByAddingObjectsFromArray:self.outdoorMarkers] mutableCopy];
    for(NSInteger i=allVisibleMarker.count-1; i>=0; i--){
        MBMarker* marker = allVisibleMarker[i];
        if(marker.map == nil){
            //remove from visible list
            [allVisibleMarker removeObjectAtIndex:i];
        } else {
            //this is visible
            //NSLog(@"marker %@ / %@",marker.category,marker.secondaryCategory);
        }
    }
    //NSLog(@"list after removal of markers without map: %@",allVisibleMarker);
    
    //now sort markers by filter categories (markers without a category will be inserted at the beginning!)
    NSArray* filterCategories = [RIMapPoi filterConfig];
    for(RIMapFilterCategory* cat in filterCategories){
        for(RIMapFilterEntry* entry in cat.items){
            NSString* catTitle = cat.appcat;
            NSString* subcatTitle = entry.title;
            //now find this object in the visible markers
            for(NSInteger i=0; i<allVisibleMarker.count; i++){
                MBMarker* marker = allVisibleMarker[i];
                if((marker.category == nil && marker.secondaryCategory == nil)
                   || ([marker.category isEqualToString:catTitle] && [marker.secondaryCategory isEqualToString:subcatTitle])){
                    [list addObject:marker];
                    [allVisibleMarker removeObjectAtIndex:i];
                    i--;
                }
            }
        }
    }
    //NSLog(@"allVisibleMarkers should be empty now: %@",allVisibleMarker);
    self.poiDetailList = list;
//    NSLog(@"sorted detail list:");
//    for(MBMarker* marker in list){
//        NSLog(@"marker %@,%@ with %@",marker.category,marker.secondaryCategory,((NSObject*)marker.userData[@"venue"]).class);
//    }
    //NSLog(@"poiDetailList=%@",self.poiDetailList);
    if([self.delegate respondsToSelector:@selector(didChangeVisiblePOIList)]){
        [self.delegate didChangeVisiblePOIList];
    }
}

-(NSArray<MBMarker*>*)visiblePOIList{
    return self.poiDetailList;
}

-(BOOL)isSameVenue:(id)venue1 venue2:(id)venue2{
    if(venue1 == venue2)
        return YES;
    if([venue1 isKindOfClass:NSObject.class] && [venue2 isKindOfClass:NSObject.class]){
        NSObject* v1 = venue1;
        NSObject* v2 = venue2;
        if([v1.class isEqual:v2.class]){
            if(v1.class == FacilityStatus.class){//isKindOfClass would be better, but fails for unknown reasons
                //special case: compare the internals of the objects
                FacilityStatus* f1 = (FacilityStatus*) v1;
                FacilityStatus* f2 = (FacilityStatus*) v2;
                return [f1 isSameFacility:f2];
            }
        }
    }
    return NO;
}

-(MBMarker*)findMarkerForPOI:(id)poi{
    for(MBMarker* marker in [self.indoorMarkers arrayByAddingObjectsFromArray:self.outdoorMarkers]){
        id venue = marker.userData[@"venue"];
        if([self isSameVenue:venue venue2:poi]){
            return marker;
        }
    }
    return nil;
}
-(void)setPOISelected:(id)poi{
    for(MBMarker* marker in [self.indoorMarkers arrayByAddingObjectsFromArray:self.outdoorMarkers]){
        id venue = marker.userData[@"venue"];
        if([self isSameVenue:venue venue2:poi]){
            
            if (marker == self.userMarker || marker == self.stationMarker) {
                return;
            }
            
            if (!marker.userData) {
                return;
            }
            
            [self selectAndCenterMarker:(MBMarker*)marker animated:NO];//force direct viewing
            
            //NSLog(@"found marker in swipe list: %d",[self.poiDetailList containsObject:marker]);
            
            if ([self.delegate respondsToSelector:@selector(willOpenFlyoutOnMapView:marker:)]) {
                [self.delegate willOpenFlyoutOnMapView:self marker:(MBMarker*)marker];
            }

            return;
        }
    }
}


@end
