//
//  WagenstandRequestManager.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WAGENSTAND_TYPETRAIN @"traintype"
#define WAGENSTAND_TRAINNUMBER @"trainnumber"
#define WAGENSTAND_EVAS_NR @"evasNr"
#define WAGENSTAND_TIME @"time"

@class Wagenstand;

@interface WagenstandRequestManager : NSObject

+ (instancetype) sharedManager;


-(void)loadISTWagenstandWithWagenstand:(Wagenstand*)wagenstand completionBlock:(void (^)(Wagenstand *istWagenstand))completion;
-(void)loadISTWagenstandWithTrain:(NSString*)trainNumber type:(NSString*)trainType departure:(NSString*)departure evaIds:(NSArray*)evaIds completionBlock:(void (^)(Wagenstand *istWagenstand))completion;

@end
