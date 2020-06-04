//
//  RIMapMetaData.m
//  MeinBahnhof
//
//  Created by Heiko on 20.01.20.
//  Copyright © 2020 ScholzVolkmer. All rights reserved.
//

#import "RIMapMetaData.h"

@implementation RIMapMetaData

-(instancetype)init{
    self = [super init];
    if(self){
        self.coordinate = kCLLocationCoordinate2DInvalid;
    }
    return self;
}

@end
