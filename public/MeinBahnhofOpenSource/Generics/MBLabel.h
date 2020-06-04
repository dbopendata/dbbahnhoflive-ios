//
//  MBLabel.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 22.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+MBString.h"

@interface MBLabel : UILabel

//@property (nonatomic, strong) NSString *htmlString;

//- (void) convertFonts;
+ (MBLabel *)labelWithTitle:(NSString *)title andText:(NSString *)text;

@end
