//
//  MBTutorialManager.h
//  MeinBahnhof
//
//  Created by Heiko on 25.11.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBTutorial.h"



@interface MBTutorialManager : NSObject

+ (MBTutorialManager*)singleton;

//properties/methods for settings
@property(nonatomic) BOOL userDisabledTutorials;
-(BOOL)userDidCloseAllTutorials;

- (void)displayTutorialIfNecessary:(MBTutorialViewType)type;
- (void)displayTutorialIfNecessary:(MBTutorialViewType)type withOffset:(NSInteger)y;
- (void)hideTutorials;//ignored tutorials
-(void)userClosedTutorial:(MBTutorial*)tutorial;
-(void)markTutorialAsObsolete:(MBTutorialViewType)type;

@end
