//
//  NSString+MBString.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 07.07.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MBString)

- (NSMutableAttributedString*) attributedHtmlString;
- (NSMutableAttributedString*) rawHtmlString;

- (CGSize) calculateSizeConstrainedTo:(CGSize)constraints;
- (CGSize) calculateSizeConstrainedTo:(CGSize)constraints andFont:(UIFont*)font;

- (NSAttributedString*) convertFonts:(NSDictionary*)options;

- (NSString *)MD5String;

- (CGFloat)fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
