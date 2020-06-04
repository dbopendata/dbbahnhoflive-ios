//
//  MBMapInternals.m
//  MeinBahnhof
//
//  Created by Heiko on 19.01.20.
//  Copyright © 2020 ScholzVolkmer. All rights reserved.
//

#import "MBMapInternals.h"

@implementation MBMapInternals

+(NSString*)kGoogleMapsApiKey{
    return @"";
}

+(NSString*)backgroundTileURLForZoom:(int)zoom x:(int)x y:(int)y{
    return nil;
}

+(NSString *)indoorTileURLForLevel:(NSString*)level zoom:(NSUInteger)zoom x:(NSUInteger)x y:(NSUInteger)y{
    return nil;
}

@end
