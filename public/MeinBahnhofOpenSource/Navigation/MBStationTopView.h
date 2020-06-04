//
//  MBStationTopView.h
//  MeinBahnhof
//
//  Created by Marc O'Connor on 10.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBStationTopView : UIView

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSNumber* stationId;

- (void)hideSubviews:(BOOL)hide;

@end
