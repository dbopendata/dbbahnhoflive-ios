//
//  HafasRequestManager.m
//  MeinBahnhof
//
//  Created by Marc O'Connor on 17.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "HafasRequestManager.h"
#import <AFNetworking/AFNetworking.h>
#import "HafasCacheManager.h"
#import "HafasStopLocation.h"
#import "MBOPNVStation.h"
#import "HafasTimetable.h"


#define USE_DEMO NO

@interface HafasRequestManager()

@end

@implementation HafasRequestManager

+ (instancetype)sharedManager
{
    static HafasRequestManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        
    });
    return sharedManager;
}

- (instancetype) init
{
    if (self = [super init]) {

    }
    return self;
}



/// refresh current timetable
- (void)manualRefresh:(HafasTimetable *)timetable withCompletion:(void (^)(HafasTimetable *))completion{
    completion(timetable);
}

- (void)loadDeparturesForStopId:(NSString *)stationId
                            timetable:(HafasTimetable *)timetable
                       withCompletion:(void (^)(HafasTimetable *))completion
{
    if(!timetable){
        timetable = [[HafasTimetable alloc] init];
    }
    
    timetable.currentStopLocationId = stationId;
    [timetable initializeTimetableFromArray:@[] mergeData:NO date:[NSDate date]];

    timetable.isBusy = NO;
    
    completion(timetable);

}

-(void)requestNearbyStopsForCoordinate:(CLLocationCoordinate2D)coordinate filterOutDBStation:(BOOL)filterOutDBStation withCompletion:(void (^)(NSArray<MBOPNVStation*> * nearbyStations))completion{
    completion(nil);

}




- (void)requestStopsForSearchterm:(NSString *)text withCoordinate:(BOOL)useCoordinat coordinate:(CLLocationCoordinate2D)coordinate completion:(void (^)(NSArray<MBOPNVStation*>* stopLocations))completion{
    
    completion(@[]);
    
}

-(void)requestJourneyDetails:(HafasDeparture *)departure completion:(void(^)(HafasDeparture *, NSError *))completion{
    
    completion(nil,[NSError new]);
    

}

@end
