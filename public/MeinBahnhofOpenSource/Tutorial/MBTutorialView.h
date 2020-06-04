//
//  TutorialView.h
//  MeinBahnhof
//
//  Created by Heiko on 20.09.16.
//  Copyright © 2016 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBTutorial;

@interface MBTutorialView : UIView

@property(nonatomic,strong) MBTutorial* tutorial;
@property(nonatomic) NSInteger viewYOffset;

-(instancetype)initWithTutorial:(MBTutorial*)tutorial;


@end
