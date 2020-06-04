//
//  MBStationTabView.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 12.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBStationTabViewDelegate <NSObject>

- (void)didSelectTabAtIndex:(NSUInteger)index;

@end

@interface MBStationTabView : UIButton

//@property (nonatomic) BOOL selected;
//@property (nonatomic) BOOL enabled;
@property (nonatomic) NSUInteger index;
@property (nonatomic, weak) id<MBStationTabViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame templateImage:(UIImage *)image tabIndex:(NSUInteger)index title:(NSString*)title;

@end
