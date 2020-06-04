//
//  MBMarkerMerger.m
//  MeinBahnhof
//
//  Created by Heiko on 06.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "MBMarkerMerger.h"
#import "MBMapFlyout.h"
#import "MBStation.h"
#import "MBTimetableViewController.h"
#import "MBRootContainerViewController.h"
#import "TimetableManager.h"
#import "MBTutorialManager.h"
#import "MBOPNVStation.h"
#import "MBMarker.h"

@interface MBMarkerMerger ()

@property(nonatomic,strong) NSArray* trainMarkers;
@property(nonatomic,strong) NSArray* oepnvMarkers;

@end

@implementation MBMarkerMerger

#define MAX_NUMBER_OF_ENTRIES 20

- (void)setTrainStations:(NSArray<MBPTSStationFromSearch*> *)trainStations {
    _trainStations = trainStations;
    // create markers and fill markers array (merge with existing data if available, and sort by distance)
    // take 6 train stations
    NSMutableArray *trainMarkers = [NSMutableArray new];
    for (MBPTSStationFromSearch* ptsstation in trainStations){
        NSDictionary *fakeDict = ptsstation.dictRepresentation;
        
        MBStation* station = [[MBStation alloc] initWithId:ptsstation.stationId name:ptsstation.title evaIds:ptsstation.eva_ids location:ptsstation.location];
                
        MBMarker *marker = (MBMarker *)[station markerForStation];
//        marker.station = station;
        marker.zoomLevel = DEFAULT_ZOOM_LEVEL_WITHOUT_INDOOR;
        marker.markerType = STATION_SELECTABLE;
        marker.userData = @{@"name":fakeDict[@"title"],
                            @"title":fakeDict[@"title"],
                            @"eva_ids":fakeDict[@"eva_ids"],
                            @"distanceInKm":fakeDict[@"distanceInKm"],
                            @"id": fakeDict[@"id"],
                            @"location": fakeDict[@"location"],
                            };
        //marker.category = @"Bahnhöfe";
        //marker.secondaryCategory = @"Fernverkehr";
        
        [trainMarkers addObject:marker];
        if(trainMarkers.count == MAX_NUMBER_OF_ENTRIES){
            break;
        }
    }
    self.trainMarkers = trainMarkers;
    [self mergeMarkers];
}

- (void)mergeMarkers{
    NSMutableArray* updatedMarkers = nil;
    
    //sort trains and OEPNV individually by distance
    NSMutableArray* sortedTrains = [self.trainMarkers mutableCopy];
    [sortedTrains sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        MBMarker *marker1 = obj1;
        MBMarker *marker2 = obj2;
        return [[marker1.userData valueForKey:@"distanceInKm"] doubleValue] < [[marker2.userData valueForKey:@"distanceInKm"] doubleValue] ? NSOrderedAscending : NSOrderedDescending;
    }];
    NSMutableArray* sortedOepnv = [self.oepnvMarkers mutableCopy];
    [sortedOepnv sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        MBMarker *marker1 = obj1;
        MBMarker *marker2 = obj2;
        return [[marker1.userData valueForKey:@"distanceInKm"] doubleValue] < [[marker2.userData valueForKey:@"distanceInKm"] doubleValue] ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    //only use the nearest 3
    if(sortedOepnv.count > MAX_NUMBER_OF_ENTRIES){
        NSRange range = NSMakeRange(MAX_NUMBER_OF_ENTRIES, sortedOepnv.count-MAX_NUMBER_OF_ENTRIES);
        [sortedOepnv removeObjectsInRange:range];
    }
    
    //start with OEPNV
    updatedMarkers = sortedOepnv;
    if(sortedTrains.count > 0){
        //add nearest DB station in front
        [updatedMarkers insertObject:sortedTrains.firstObject atIndex:0];
    }


    // NSLog(@"update marker %@ with %@",self.markers,updatedMarkers);
    self.markers = updatedMarkers;

}

- (void)setOepnvStations:(NSArray<MBOPNVStation*> *)oepnvStations {
    _oepnvStations = oepnvStations;
    self.oepnvMarkers = [MBMarkerMerger oepnvStationsToMBMarkerList:oepnvStations];
    [self mergeMarkers];
}

+(NSArray*)oepnvStationsToMBMarkerList:(NSArray<MBOPNVStation*>*)oepnvStations{
    NSMutableArray *trainMarkers = [NSMutableArray new];
    for (MBOPNVStation *station in oepnvStations) {
        MBMarker *marker = [MBMarker markerWithPosition:station.coordinate andType:OEPNV_SELECTABLE];
        marker.zoomLevel = DEFAULT_ZOOM_LEVEL_WITHOUT_INDOOR;
        marker.icon = [UIImage db_imageNamed:@"app_karte_haltestelle"];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.userData = @{@"distanceInKm":@(station.distanceInKM),
                            @"name":station.name,
                            @"title":station.name,
                            @"hafas_id":station.stationId,
                            };
        
        [trainMarkers addObject:marker];
        if(trainMarkers.count == MAX_NUMBER_OF_ENTRIES){
            break;
        }
    }
    return trainMarkers;
}

-(void)removeStations{
    self.oepnvMarkers = @[];
    self.trainMarkers = @[];
    self.markers = @[];
}




@end
