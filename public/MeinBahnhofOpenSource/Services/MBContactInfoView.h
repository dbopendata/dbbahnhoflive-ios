//
//  MBContactInfoView.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 10.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueExtraField.h"
#import "MBDetailViewDelegate.h"

@interface MBContactInfoView : UIView

@property (nonatomic, weak) id<MBDetailViewDelegate>delegate;

- (instancetype)initWithExtraField:(VenueExtraField *)extraField;
- (void)updateButtonConstraints;

@end
