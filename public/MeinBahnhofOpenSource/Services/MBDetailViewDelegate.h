//
//  MBDetailViewDelegate.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 11.08.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//
@class Venue;

@protocol MBDetailViewDelegate <NSObject>

@optional
- (void) didOpenUrl:(NSURL*)url;
- (void) didTapOnPhoneLink:(NSString*)phoneNumber;
- (void) didTapOnEmailLink:(NSString*)mailAddress;

@end
