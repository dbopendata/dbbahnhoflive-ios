//
//  MBDepartureRequestManager.h
//  MeinBahnhof
//
//  Created by Heiko on 26.02.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBMapFlyout.h"

@interface MBMapDepartureRequestManager : NSObject

+ (id)sharedManager;

-(void)registerUpdateForFlyout:(MBMapFlyout*)mapFlyout;

@end
