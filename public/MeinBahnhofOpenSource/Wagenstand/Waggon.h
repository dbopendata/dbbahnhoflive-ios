//
//  Waggon.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 01.12.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "SymbolTagView.h"

@class Train;

@interface Waggon : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *differentDestination;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, copy) NSArray *sections;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSArray *symbols;//old api
@property (nonatomic, copy) NSArray *fahrzeugausstattung;
@property (nonatomic, copy) NSString *type; 
@property (nonatomic, assign, assign) BOOL waggon;

@property (nonatomic, assign) Train *train;

- (UIColor*) colorForType;
- (UIColor*) secondaryColor;

- (CGFloat) heightOfCell;
- (NSString*)classOfWaggon;

- (BOOL) waggonHasMultipleClasses;

- (BOOL) bottomHalfCell;
- (BOOL) isTrainHead;
- (BOOL) isTrainBack;
- (BOOL) isTrainBackWithDirection;
- (BOOL) isTrainHeadWithDirection;
- (BOOL) isTrainBothWays;
-(BOOL)isTrainBothWithLeft;
-(BOOL)isTrainBothWithRight;
- (BOOL) isRestaurant;

+ (NSString*)descriptionForSymbol:(NSString*)symbol;


-(NSArray*)setupTagViewsForWidth:(CGFloat)width;
-(void)setupTagViewsY:(CGFloat)width;
@end
