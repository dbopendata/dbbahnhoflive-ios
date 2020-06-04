//
//  MBPTSTravelcenter.h
//  MeinBahnhof
//
//  Created by Heiko on 17.09.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface MBPTSTravelcenter : NSObject

-(instancetype)initWithDict:(NSDictionary*)json;

-(CLLocationCoordinate2D)coordinate;
-(CLLocation*)location;

-(NSString*)title;
-(NSString*)address;
-(NSString*)postCode;
-(NSString*)city;
-(NSString*)openingTimes;

@end

