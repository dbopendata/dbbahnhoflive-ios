//
//  MBStaticStationInfo.h
//  MeinBahnhof
//
//  Created by Heiko on 17.02.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBService;
@class MBStation;

@interface MBStaticStationInfo : NSObject

+(MBService*)serviceForType:(NSString*)type withStation:(MBStation*)station;
+(NSDictionary*)infoForType:(NSString*)type;
+(NSString*)textForType:(NSString*)type;


@end
