//
//  UIButton+AttributableButton.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 13.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributableButton : UIButton

@property (nonatomic, strong) NSString *actionValue;
@property (nonatomic, strong) NSString *actionType;

@end
