//
//  MBTextView.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 08.07.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+MBString.h"

@protocol MBTextViewDelegate <UITextViewDelegate>

- (void) didInteractWithURL:(NSURL*)url;

@end

@interface MBTextView : UITextView <UITextViewDelegate>

@property (nonatomic, weak) id<MBTextViewDelegate>delegado;
@property (nonatomic, strong) NSString *htmlString;

- (void) convertFonts;

@end
