//
//  MBMapLevelPicker.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 15.10.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelplanWrapper.h"

@class MBMapLevelPicker;

@protocol MBMapLevelPickerDelegate <NSObject>

- (void) picker:(MBMapLevelPicker*)picker didChangeToLevel:(LevelplanWrapper*)level;
- (void) userDidSelectLevel:(LevelplanWrapper*)level onPicker:(MBMapLevelPicker*)picker;

@end

@interface MBMapLevelPicker : UIView

@property (nonatomic, strong) LevelplanWrapper *currentLevel;
@property (nonatomic, strong) NSArray *levels;

@property (nonatomic, weak) id<MBMapLevelPickerDelegate> delegate;

- (instancetype) initWithLevels:(NSArray*)levels;

- (void) setCurrentLevelByLevelNumber:(NSInteger)levelNumber forced:(BOOL)forced;

@end
