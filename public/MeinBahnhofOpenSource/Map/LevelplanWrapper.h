//
//  LevelplanWrapper.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 17.11.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LevelplanWrapper : NSObject

@property (nonatomic, assign) NSInteger levelNumber;
@property (nonatomic, strong) NSString* levelString;

- (instancetype) initWithLevelNumber:(NSInteger)levelNumber levelString:(NSString*)levelString;

@end
