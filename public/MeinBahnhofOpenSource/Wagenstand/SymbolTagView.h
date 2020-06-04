//
//  SymbolTagView.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SymbolTagView : UIView

@property (nonatomic, strong) NSString *symbolCode;//old api
@property (nonatomic, strong) NSArray *symbolIcons;//new api
@property (nonatomic, strong) NSString *symbolDescription;

-(void)resizeForWidth:(CGFloat)width;

@end
