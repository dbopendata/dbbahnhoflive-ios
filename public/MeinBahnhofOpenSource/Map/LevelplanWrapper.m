//
//  LevelplanWrapper.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 17.11.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import "LevelplanWrapper.h"

@implementation LevelplanWrapper

- (instancetype) initWithLevelNumber:(NSInteger)levelNumber levelString:(NSString*)levelString
{
    if (self = [super init]) {
        self.levelNumber = levelNumber;
        self.levelString = levelString;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"LevelplanWrapper: levelNumber=%ld, levelString=%@",(long)_levelNumber,_levelString];
}


@end
