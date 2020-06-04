//
//  WaggonCell.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Waggon.h"
#import "SymbolTagView.h"

@interface WaggonCell : UITableViewCell

@property (nonatomic, strong) Waggon *waggon;

+(CGFloat)widthOfLegendPartForWidth:(CGFloat)totalWidth;

@end
