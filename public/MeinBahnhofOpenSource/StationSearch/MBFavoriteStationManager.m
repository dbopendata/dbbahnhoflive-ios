//
//  MBFavoriteStationManager.m
//  MeinBahnhof
//
//  Created by Heiko on 06.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "MBFavoriteStationManager.h"

@interface MBFavoriteStationManager()

@property(nonatomic,strong) NSMutableArray* favoriteStations;

@end

@implementation MBFavoriteStationManager

+ (id)client
{
    static MBFavoriteStationManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[self alloc] init];
    });
    return sharedClient;
}
-(instancetype)init{
    self = [super init];
    if(self)
    {
        self.favoriteStations = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"FAVORITE_STATIONS"] mutableCopy];
        if(!self.favoriteStations){
            self.favoriteStations = [NSMutableArray arrayWithCapacity:10];
        }
    }
    return self;
}
-(void)storeFavorites{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    [def setObject:self.favoriteStations forKey:@"FAVORITE_STATIONS"];
    [def synchronize];
}
-(void)addStation:(NSDictionary*)dict{
    if(![self isFavorite:dict]){
        [self.favoriteStations insertObject:dict atIndex:0];
        [self storeFavorites];
    }
}
-(void)removeStation:(NSDictionary*)dict{
    for(int i=0; i<self.favoriteStations.count; i++){
        NSDictionary* station = self.favoriteStations[i];
        if(dict[@"id"] && [station[@"id"] isEqualToNumber:dict[@"id"]]){
            [self.favoriteStations removeObjectAtIndex:i];
            [self storeFavorites];
            return;
        } else if(dict[@"hafas_id"] && [station[@"hafas_id"] isEqualToString:dict[@"hafas_id"]]){
            [self.favoriteStations removeObjectAtIndex:i];
            [self storeFavorites];
            return;
        }
    }
}
-(BOOL)isFavorite:(NSDictionary*)dict{
    for(NSDictionary* station in self.favoriteStations){
        if(dict[@"id"] && [station[@"id"] isEqualToNumber:dict[@"id"]]){
            return YES;
        } else if(dict[@"hafas_id"] && [station[@"hafas_id"] isEqualToString:dict[@"hafas_id"]]){
            return YES;
        }
    }
    return NO;
}
-(NSArray*)favoriteStationsList{
    return self.favoriteStations;
}

@end
