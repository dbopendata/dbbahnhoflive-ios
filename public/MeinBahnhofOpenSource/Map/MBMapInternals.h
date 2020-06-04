//
//  MBMapInternals.h
//  MeinBahnhof
//
//  Created by Heiko on 19.01.20.
//  Copyright © 2020 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBMapInternals : NSObject

+(NSString*)kGoogleMapsApiKey;
+(NSString*)backgroundTileURLForZoom:(int)zoom x:(int)x y:(int)y;
+(NSString*)indoorTileURLForLevel:(NSString*)level zoom:(NSUInteger)zoom x:(NSUInteger)x y:(NSUInteger)y;

@end

NS_ASSUME_NONNULL_END
