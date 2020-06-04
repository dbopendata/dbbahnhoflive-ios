//
//  MBFavoriteStationManager.h
//  MeinBahnhof
//
//  Created by Heiko on 06.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBFavoriteStationManager : NSObject

+ (id)client;

-(void)addStation:(NSDictionary*)dict;
-(void)removeStation:(NSDictionary*)dict;
-(BOOL)isFavorite:(NSDictionary*)dict;

-(NSArray*)favoriteStationsList;

@end
