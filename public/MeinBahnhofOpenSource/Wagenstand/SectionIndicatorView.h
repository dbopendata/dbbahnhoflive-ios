//
//  SectionIndicatorView.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 02.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wagenstand.h"

@class SectionIndicatorView;

@protocol SectionIndicatorDelegate <NSObject>

- (void) sectionView:(SectionIndicatorView*)sectionView didSelectSection:(NSString*)section;

@end

@interface SectionIndicatorView : UIView

@property (nonatomic, weak) id<SectionIndicatorDelegate> delegate;
@property (nonatomic, strong) Wagenstand *wagenstand;

- (instancetype) initWithWagenstand:(Wagenstand*)wagenstand andFrame:(CGRect)frame;
- (UILabel*) setActiveSection:(NSString*)sectionCode;
- (void) setActiveSection:(NSString*)section atIndex:(NSInteger)index animateTo:(BOOL)animateTo;
- (void) setActiveWaggonAtIndex:(NSInteger)index animateTo:(BOOL)animateTo;



@end
