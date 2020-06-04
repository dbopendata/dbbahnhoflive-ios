//
//  MBButtonWithAction.h
//  MeinBahnhof
//
//  Created by Heiko on 06.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MBButtonActionBlock)(void);


@interface MBButtonWithAction : UIButton

@property(nonatomic,copy) MBButtonActionBlock actionBlock;

@end
