//
//  MeinBahnhof
//
//  Created by Heiko on 06.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBOPNVStation.h"
#import "MBPTSStationFromSearch.h"

@class MBMarker;

@interface MBMarkerMerger : NSObject
@property(nonatomic,strong) NSArray<MBPTSStationFromSearch*>* trainStations;
@property(nonatomic,strong) NSArray<MBOPNVStation*>* oepnvStations;

-(void)removeStations;

@property (nonatomic, strong) NSArray<MBMarker *> *markers;//filled when setting train or oepnv

+(NSArray*)oepnvStationsToMBMarkerList:(NSArray<MBOPNVStation*>*)oepnvStations;

@end
