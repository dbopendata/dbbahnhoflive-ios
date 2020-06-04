//
//  RIMapMetaData.h
//  MeinBahnhof
//
//  Created by Heiko on 20.01.20.
//  Copyright © 2020 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RIMapMetaData : NSObject

@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic,strong) NSArray<NSNumber*>* evaNumbers;

@end

NS_ASSUME_NONNULL_END
