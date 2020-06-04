//
//  MBEinkaufsbahnhofManager.h
//  MeinBahnhof
//
//  Created by Heiko on 19.04.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBEinkaufsbahnhofManager : NSObject

+ (instancetype)sharedManager;

- (void)requestEinkaufPOI:(NSNumber*)stationId
                       forcedByUser:(BOOL)forcedByUser
                            success:(void (^)(NSArray *pois))success
                       failureBlock:(void (^)(NSError *error))failure;

-(void)requestAllEinkaufsbahnhofIdsForcedByUser:(BOOL)forcedByUser success:(void (^)(NSArray<NSNumber*> *))success failureBlock:(void (^)(NSError *))failure;
@end
