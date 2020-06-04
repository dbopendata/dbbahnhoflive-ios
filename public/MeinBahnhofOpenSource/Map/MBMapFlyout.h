//
//  MBMapFlyout.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 07.10.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MBParkingInfo.h"
#import "MBStation.h"
#import "TimetableManager.h"

@class MBMapFlyout;
@class MBOPNVStation;

@protocol MBMapFlyoutDelegate <NSObject>

@optional
//- (void) startNavigationTo:(id)poi;
- (void) showRoutingForParking:(MBParkingInfo*)parking;
- (void) showFacilityFavorites;
//- (void) showViewController:(UIViewController*)vc;

- (void)showTimetableForStationId:(NSString *)stationId stationName:(NSString *)stationName evas:(NSArray*)evas location:(NSArray*)location opnvStation:(MBOPNVStation*)opnvStation;
- (void) mapFlyout:(MBMapFlyout*)flyout wantsToExtendView:(UIView*)view;
- (void) mapFlyout:(MBMapFlyout*)flyout wantsToCloseView:(UIView*)view;
- (void) mapFlyout:(MBMapFlyout*)flyout wantsToOpenTimetableWithTrack:(NSString*)track train:(Stop*)trainStop;
@end

@interface MBMapFlyout : UIView <UIAlertViewDelegate>

@property (nonatomic, weak) id<MBMapFlyoutDelegate> delegate;
@property (nonatomic) NSInteger movableShrinkY;

#define MOVABLE_SHRINK_TAG 42

+ (instancetype) flyoutForPOI:(id)poi inSuperView:(UIView*)superView controller:(UIViewController*)vc supportingNavigation:(BOOL)supportsIndoorNavigation detailLink:(BOOL)displayDetailLink central:(BOOL)central station:(MBStation*)station;

- (void) showAnimatedInSuperview:(UIView*)superView;
- (void) hideAnimated;
- (void) setupAbfahrtsTafel;
-(void)updateDepartures;

-(void)headerOpenCloseTapped;
@end
