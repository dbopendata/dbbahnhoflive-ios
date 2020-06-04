//
//  MBMapFlyout.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 07.10.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import "MBMapFlyout.h"

#import "MBLinkButton.h"

#import "SharedMobilityMappable.h"

#import "FacilityStatus.h"
#import "MBParkingInfo.h"

#import "FacilityStatusManager.h"
#import "AppDelegate.h"

#import "RIMapPoi.h"

#import "TimetableManager.h"
#import "HafasRequestManager.h"
#import "HafasTimetable.h"
#import "MBMapDepartureRequestManager.h"
#import "MBButtonWithData.h"
#import "MBLargeButton.h"
#import "MBTimetableViewController.h"
#import "MBRootContainerViewController.h"
#import "MBContentSearchResult.h"

@interface MBMapFlyout()
@property (nonatomic) BOOL isCentral;//some flyouts change their layout when they are central or not
@property (nonatomic, strong) NSObject* payload;
@property (nonatomic, strong) MBMarker *poi;
@property (nonatomic, strong) CLLocation *poiLocation;
@property (nonatomic, weak) MBStation *station;

//global properties
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* headerIcon;
// optional distance, only used for nearby stations
@property (nonatomic, strong) UILabel *distanceLabel;
// optional button and icon for extending the flyout to the top
@property (nonatomic, strong) UIButton* headerButton;
@property (nonatomic, strong) UIImageView* headerOpenImage;
@property (nonatomic) BOOL moveableContentIsOpened;

@property (nonatomic,strong) UIView* header;
@property (nonatomic,strong) UIScrollView* contentScrollView;
@property (nonatomic,strong) UIView* moveableContentView;

@property (nonatomic, strong) MobilityMappable *mobilityMappable;
@property (nonatomic, strong) FacilityStatus *facilityStatusItem;
@property (nonatomic, strong) MBParkingInfo* parkingStatusItem;

@property (nonatomic, assign) BOOL supportsIndoorNavigation;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableArray *abfahrtLabels;
@property (nonatomic, strong) UILabel* infoLabelDepartureNotAvailable;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureForTimetable;

@property (nonatomic, strong) TimetableManager *localTimeTableManager;
@property (nonatomic, strong) HafasRequestManager *localHafasManager;

@property(nonatomic,weak) UIViewController* viewController;

@end

@implementation MBMapFlyout

+ (instancetype) flyoutForPOI:(id)poi inSuperView:(UIView*)superView controller:(UIViewController*)vc supportingNavigation:(BOOL)supportsIndoorNavigation detailLink:(BOOL)displayDetailLink central:(BOOL)central station:(MBStation*)station
{
    MBMapFlyout *flyout = nil;
    
    MBMarker *marker = (MBMarker*)poi;
    id payloadPOI = [marker.userData objectForKey:@"venue"];
    
    flyout = [[MBMapFlyout alloc] initWithFrame:CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height)];
    flyout.viewController = vc;
    flyout.isCentral = central;
    flyout.station = station;
    flyout.payload = payloadPOI;
    
    flyout.poi = marker;
    flyout.poiLocation = [[CLLocation alloc] initWithLatitude:flyout.poi.position.latitude longitude:flyout.poi.position.longitude];
    
    [flyout setupForMarker];
    
    return flyout;
}

- (void)handleTap {
    // NSLog(@"tap on %@",self.poi.userData);    
    if([self.delegate respondsToSelector:@selector(showTimetableForStationId:stationName:evas:location:opnvStation:)]) {
        if (nil != [self.poi.userData valueForKey:@"id"]) {
            [self.delegate showTimetableForStationId:[self.poi.userData valueForKey:@"id"] stationName:[self.poi.userData valueForKey:@"name"] evas:[self.poi.userData valueForKey:@"eva_ids"] location:[self.poi.userData valueForKey:@"location"] opnvStation:nil];
        } else if (nil != [self.poi.userData valueForKey:@"hafas_id"]) {
            MBOPNVStation* opnvStation = [self.poi.userData objectForKey:@"MBOPNVStation"];
            [self.delegate showTimetableForStationId:[self.poi.userData valueForKey:@"hafas_id"] stationName:[self.poi.userData valueForKey:@"name"] evas:nil location:nil opnvStation:opnvStation];
        }
    } else {
        // NSLog(@"no station, no delegate implementation, delegate is %@",self.delegate);
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        self.header = header;
        header.backgroundColor = [UIColor db_HeaderColor];
        [self addSubview:header];
        
        CGFloat distanceLabelWidth = 70.0;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 0, self.frame.size.width-43-10, header.frame.size.height)];
        self.titleLabel.font = [UIFont db_BoldSixteen];
        self.titleLabel.textColor = [UIColor db_333333];
        self.titleLabel.accessibilityTraits = UIAccessibilityTraitHeader;
        self.titleLabel.accessibilityHint = @"Zur Anzeige weiterer Einträge nach rechts und links scrollen.";

        [header addSubview:self.titleLabel];
        
        self.headerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(13, 12, 24, 24)];
        self.headerIcon.contentMode = UIViewContentModeScaleAspectFit;
        [header addSubview:self.headerIcon];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-distanceLabelWidth-10, 0, distanceLabelWidth, header.frame.size.height)];
        self.distanceLabel.font = [UIFont db_RegularSixteen];
        self.distanceLabel.textColor = [UIColor db_333333];
        self.distanceLabel.hidden = YES;
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        [header addSubview:self.distanceLabel];
        
        self.headerOpenImage = [[UIImageView alloc] initWithImage:[UIImage db_imageNamed:@"app_nachoben_pfeil"]];
        [header addSubview:self.headerOpenImage];
        [self.headerOpenImage centerViewVerticalInSuperView];
        [self.headerOpenImage setGravityRight:10];
        self.headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, header.frame.size.height)];
        self.headerButton.backgroundColor = [UIColor clearColor];
        [self.headerButton addTarget:self action:@selector(headerOpenCloseTapped) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:self.headerButton];
        //by default headerOpenImage and button are hidden!
        self.headerOpenImage.hidden = self.headerButton.hidden = YES;
        
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, header.sizeHeight, self.frame.size.width, self.frame.size.height-header.sizeHeight)];
        [self addSubview:self.contentScrollView];
    }
    return self;
}

-(void)swipeGestureUpInTracks:(UISwipeGestureRecognizer*)swipe{
    if(swipe.state == UIGestureRecognizerStateRecognized && !self.moveableContentIsOpened){
        [self headerOpenCloseTapped];
    }
}
-(void)swipeGestureDownInTracks:(UISwipeGestureRecognizer*)swipe{
    if(swipe.state == UIGestureRecognizerStateRecognized && self.moveableContentIsOpened){
        [self headerOpenCloseTapped];
    }
}

-(void)headerOpenCloseTapped{
    NSLog(@"open/close flyout!");
    if(self.moveableContentIsOpened){
        if([self.delegate respondsToSelector:@selector(mapFlyout:wantsToCloseView:)]){
            self.moveableContentIsOpened = NO;
            self.headerOpenImage.image = [UIImage db_imageNamed:@"app_nachoben_pfeil"];
            [self.delegate mapFlyout:self wantsToCloseView:self.moveableContentView];
        }
    } else {
        if([self.delegate respondsToSelector:@selector(mapFlyout:wantsToExtendView:)]){
            self.moveableContentIsOpened = YES;
            self.headerOpenImage.image = [UIImage db_imageNamed:@"app_nachunten_pfeil"];
            [self.delegate mapFlyout:self wantsToExtendView:self.moveableContentView];
        }
    }
}
-(void)tapAbfahrtstafel:(id)sender{
    NSLog(@"open Abfahrtstafel for this track!");
    NSString* track = self.poi.riMapPoi.name;
    [self.delegate mapFlyout:self wantsToOpenTimetableWithTrack:track train:nil];
}
-(void)wagenstandForTrain:(MBButtonWithData*)sender{
    NSLog(@"open Abfahrtstafel and then wagenreihung for %@",sender.data);
    NSString* track = self.poi.riMapPoi.name;
    [self.delegate mapFlyout:self wantsToOpenTimetableWithTrack:track train:sender.data];
}

- (void) setupAbfahrtsTafel{
    if(self.poi.markerType != STATION_SELECTABLE && self.poi.markerType != OEPNV_SELECTABLE){
        return;
    }
    if (nil == self.tapGestureForTimetable) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
        self.tapGestureForTimetable = tap;
    }
    if (nil == self.spinner) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    [self addSubview:self.spinner];
    [self.spinner centerViewVerticalInSuperView];
    [self.spinner centerViewHorizontalInSuperView];
    [self.spinner startAnimating];

    //instead of updating here directly we delay it...
    //[self updateDepartures];
    
    [[MBMapDepartureRequestManager sharedManager] registerUpdateForFlyout:self];
}

-(void)updateDepartures{
    NSArray *eva_ids = [self.poi.userData objectForKey:@"eva_ids"];
    NSString *hafas_id = [self.poi.userData objectForKey:@"hafas_id"];
    //NSLog(@"updateDepartures: %@, %@",hafas_id, eva_ids);
    if (nil != eva_ids && eva_ids.count > 0) {
        [self.spinner startAnimating];
        if (nil == self.localTimeTableManager) {
            self.localTimeTableManager = [[TimetableManager alloc] init];
        }
        [self.localTimeTableManager setEvaIds:eva_ids];
        [self.localTimeTableManager startTimetableScheduler];
    } else if (nil != hafas_id) {
        [self.spinner startAnimating];
        // may be Hafas
        if (nil == self.localHafasManager) {
            self.localHafasManager = [[HafasRequestManager alloc] init];
        }
        //NSLog(@"load departures for %@ in %@ with %@",hafas_id,self,self.localHafasManager);
        //NSLog(@"DEPARTURE, load for map flyout");
        HafasTimetable* timetable = [[HafasTimetable alloc] init];
        MBOPNVStation* opnvStation = [self.poi.userData objectForKey:@"MBOPNVStation"];
        if(opnvStation){//this is a map view from the OPNV-Overlay->Departures->MapView
            timetable.opnvStationForFiltering = opnvStation;
            timetable.includedSTrains = YES;
        }
        [self.localHafasManager loadDeparturesForStopId:hafas_id timetable:timetable withCompletion:^(HafasTimetable *timetable) {
            [self setupViewsForHafas:timetable];
        }];
    } else {
        [self.spinner stopAnimating];
    }
}

-(void)setupForMarker{
    MBMarker* poi = self.poi;
    int y = 10;
    
    UIColor* green = [UIColor db_76c030];
    UIColor* red   = [UIColor db_mainColor];
    UIColor* gray  = [UIColor db_787d87];
    UIColor* black = [UIColor db_333333];
    
    switch(poi.markerType) {
        case RIMAPPOI:
        {
            RIMapPoi* riMapPoi = poi.riMapPoi;
            self.titleLabel.text = riMapPoi.title;
            self.headerIcon.image = [riMapPoi iconImageForFlyout:YES];
            BOOL isTrack = NO;
            if(riMapPoi.hasOpeningInfo){
                NSTimeInterval isTimeOpen = riMapPoi.isOpenTime;
                if(isTimeOpen >= 0){
                    NSInteger hour = isTimeOpen/60./60.;
                    NSInteger minu = (isTimeOpen-hour*60*60)/60.;
                    y = [self addStatusLineWithIcon:@"app_check" text:[NSString stringWithFormat:@"Noch %02ld:%02ld Std. geöffnet.",(long)hour,(long)minu] color:green externalLink:nil orSwitch:nil atY:y];
                } else {
                    y = [self addStatusLineWithIcon:@"app_kreuz" text:@"Geschlossen" color:red externalLink:nil orSwitch:nil atY:y];
                }
            } else if(riMapPoi.isTrack){
                // tracks use a different layout, instead of the contentScrollView they create their own view in
                // moveableContentView which is larger and may be moved up to show more details
                isTrack = YES;
                [self setupTrackLayout:riMapPoi];
            }
            if(!isTrack){
                //add the level string
                y = [self addStatusLineWithIcon:nil text:[NSString stringWithFormat:@"%@",[RIMapPoi levelCodeToDisplayString:poi.riMapPoi.levelcode]] color:black externalLink:nil orSwitch:nil atY:y];
            }
            //add internal links
            if(riMapPoi.isDBInfoPOI && self.station.stationDetails.hasDBInfo){
                UIButton* internalLinkButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 60, 60)];
                [internalLinkButton setImage:[UIImage db_imageNamed:@"MapInternalLinkButton"] forState:UIControlStateNormal];
                [internalLinkButton addTarget:self action:@selector(internalLink:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentScrollView addSubview:internalLinkButton];
                [internalLinkButton setGravityRight:10];
                [internalLinkButton setGravityTop:y];
            }
            break;
        }
        case FACILITY:
        {
            FacilityStatus* status = (FacilityStatus*)_payload;
            self.facilityStatusItem = status;
            self.titleLabel.text = status.title;
            self.headerIcon.image = [UIImage db_imageNamed:@"rimap_aufzug_grau"];//[status iconForState];
            if(status.state == ACTIVE){
                y = [self addStatusLineWithIcon:@"app_check" text:@"In Betrieb" color:green externalLink:nil orSwitch:nil atY:y];
            } else if(status.state == UNKNOWN){
                y = [self addStatusLineWithIcon:@"app_unbekannt" text:@"Status unbekannt" color:gray externalLink:nil orSwitch:nil atY:y];
            } else {
                y = [self addStatusLineWithIcon:@"app_kreuz" text:@"Nicht in Betrieb" color:red externalLink:nil orSwitch:nil atY:y];
            }
            y = [self addStatusLineWithIcon:@"app_achtung" text:status.shortDescription color:gray externalLink:nil orSwitch:nil atY:y];
            
            UISwitch* pushSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
            pushSwitch.on = [[FacilityStatusManager client] isPushActiveForFacility:self.facilityStatusItem.equipmentNumber.description];
            [pushSwitch addTarget:self action:@selector(pushSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            
            y = [self addStatusLineWithIcon:nil text:@"Aufzug der Merkliste hinzugefügt" color:black externalLink:nil orSwitch:pushSwitch atY:y];
            break;
        }
        case MOBILITY:
        {
            self.mobilityMappable = (MobilityMappable*) _payload;
            self.titleLabel.text = self.mobilityMappable.translatedTypeName;
            self.headerIcon.image = [self.mobilityMappable pinForProvider];
            SEL selector = nil;
            if(self.mobilityMappable.appStoreUrlForProvider){
                selector = @selector(openAppForProvider:);
            }
            
            if (![self.mobilityMappable isBikeOffer]) {
                y = [self addStatusLineWithIcon:@"app_unbekannt" text:[NSString stringWithFormat:@"%@", self.mobilityMappable.name] color:gray externalLink:nil orSwitch:nil atY:y];
                y = [self addStatusLineWithIcon:@"app_unbekannt" text:[NSString stringWithFormat:@"Tank: %@", [self.mobilityMappable fuelStatus]] color:gray externalLink:nil orSwitch:nil atY:y];
                y = [self addStatusLineWithIcon:@"app_unbekannt" text:[NSString stringWithFormat:@"Getriebe: %@", [self.mobilityMappable gearBox]] color:gray externalLink:nil orSwitch:nil atY:y];
                y = [self addStatusLineWithIcon:nil text:[NSString stringWithFormat:@"Standort: %@", [self.mobilityMappable.address stringByReplacingOccurrencesOfString:@"\U0000fffd" withString:@"ß"]] color:black externalLink:selector orSwitch:nil atY:y];
            } else {
                y = [self addStatusLineWithIcon:nil text:[NSString stringWithFormat:@"Standort: %@", self.mobilityMappable.name] color:black externalLink:selector orSwitch:nil atY:y];
            }
            break;
        }
        case PARKING:
        {
            self.parkingStatusItem = (MBParkingInfo*) _payload;
            self.titleLabel.text = self.parkingStatusItem.name;
            self.headerIcon.image = [UIImage db_imageNamed:[[self.parkingStatusItem iconForType] stringByAppendingString:@"_grau"]];
            if (self.parkingStatusItem.isOutOfOrder) {
                y = [self addStatusLineWithIcon:@"app_kreuz" text:self.parkingStatusItem.outOfOrderText color:red externalLink:nil orSwitch:nil atY:y];
            } else {
                NSString* textAllocation = self.parkingStatusItem.textForAllocation;
                if(textAllocation.length > 0){
                    y = [self addStatusLineWithIcon:@"app_check" text:textAllocation color:green externalLink:nil orSwitch:nil atY:y];
                } else if(self.parkingStatusItem.openingTimes.length > 0) {
                    y = [self addStatusLineWithIcon:nil text:[NSString stringWithFormat:@"Öffnungszeiten: %@", self.parkingStatusItem.openingTimes] color:black externalLink:nil orSwitch:nil atY:y];
                }
                if(self.parkingStatusItem.maximumParkingTime.length > 0){
                    y = [self addStatusLineWithIcon:@"app_uhrzeit_klein" text:[NSString stringWithFormat:@"Maximale Parkdauer: %@", self.parkingStatusItem.maximumParkingTime] color:gray externalLink:nil orSwitch:nil atY:y];
                }
                if(self.parkingStatusItem.accessDescription.length > 0){
                    y = [self addStatusLineWithIcon:nil text:[NSString stringWithFormat:@"Zufahrt: %@", self.parkingStatusItem.accessDescription] color:black externalLink:@selector(routeButtonPressed) orSwitch:nil atY:y];
                }
            }

            break;
        }
        case SERVICESTORE:
        {
            
            break;
        }
        case STATION:
            break;//this is not selectable!
        case OEPNV_SELECTABLE:
        case STATION_SELECTABLE:
        {
            CGFloat originTop = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 16.0;
            CGFloat originLeft = 16.0;
            self.abfahrtLabels = [NSMutableArray new];
            for (int i = 0; i < 2; i++) {
                NSMutableDictionary *abfahrtDict = [NSMutableDictionary new];
                UILabel *timeLabel = [[UILabel alloc] init];
                timeLabel.font = [UIFont db_BoldSixteen];
                timeLabel.textColor = [UIColor db_333333];
                timeLabel.text = @"PHOL";
                timeLabel.hidden = YES;
                [timeLabel sizeToFit];
                [self addSubview:timeLabel];
                [abfahrtDict setObject:timeLabel forKey:@"timeLabel"];
                [timeLabel setGravityTop:originTop];
                [timeLabel setGravityLeft:originLeft];
                
                UILabel *expTimeLabel = [[UILabel alloc] init];
                expTimeLabel.font = [UIFont db_RegularFourteen];
                expTimeLabel.textColor = [UIColor db_333333];
                expTimeLabel.text = @"PHOL";
                expTimeLabel.hidden = YES;
                [expTimeLabel sizeToFit];
                [self addSubview:expTimeLabel];
                [abfahrtDict setObject:expTimeLabel forKey:@"expectedTimeLabel"];
                [expTimeLabel setBelow:timeLabel withPadding:8.0];
                [expTimeLabel setGravityLeft:originLeft];
                
                UILabel *destLabel = [UILabel new];
                destLabel.font = [UIFont db_RegularSixteen];
                destLabel.textColor = [UIColor db_333333];
                destLabel.text = @"PLACEHOLDER";
                [destLabel sizeToFit];
                destLabel.hidden = YES;
                [self addSubview:destLabel];
                [abfahrtDict setObject:destLabel forKey:@"destLabel"];
                [destLabel setGravityTop:originTop];
                [destLabel setRight:timeLabel withPadding:30.0];
                CGFloat labelWidth = self.frame.size.width - originLeft - timeLabel.frame.size.width - 30.0 - originLeft;
                CGRect destFrame = destLabel.frame;
                destFrame.size.width = labelWidth;
                destLabel.frame = destFrame;
                UILabel *lineLabel = [UILabel new];
                lineLabel.font = [UIFont db_RegularFourteen];
                lineLabel.textColor = [UIColor db_787d87];
                lineLabel.text = @"Placeholder";
                [lineLabel sizeToFit];
                lineLabel.hidden = YES;
                [self addSubview:lineLabel];
                [abfahrtDict setObject:lineLabel forKey:@"lineLabel"];
                [lineLabel setBelow:timeLabel withPadding:8.0];
                [lineLabel setGravityLeft:destLabel.frame.origin.x-2];
                
                UIImageView* warnIcon = [[UIImageView alloc] initWithImage:[UIImage db_imageNamed:@"app_warndreieck"]];
                warnIcon.hidden = YES;
                [self addSubview:warnIcon];
                [abfahrtDict setObject:warnIcon forKey:@"warnIcon"];
                [warnIcon setBelow:timeLabel withPadding:8.0];
                [warnIcon setGravityLeft:originLeft];

                [self.abfahrtLabels addObject:abfahrtDict];

                timeLabel.isAccessibilityElement = NO;
                lineLabel.isAccessibilityElement = NO;
                destLabel.isAccessibilityElement = NO;
                warnIcon.isAccessibilityElement = NO;
                UILabel* accessibilityView = [[UILabel alloc] initWithFrame:CGRectMake(0, originTop, self.frame.size.width, 60)];
                accessibilityView.hidden = YES;
                accessibilityView.accessibilityHint = @"Zur Anzeige weiterer Abfahrten und Details doppeltippen.";
                [self addSubview:accessibilityView];
                //this label never has a text, only an acc-label
                [abfahrtDict setObject:accessibilityView forKey:@"accLabel"];
                
                originTop += (timeLabel.frame.size.height + 8.0 + lineLabel.frame.size.height + 16.0);

            }

            self.titleLabel.text = [poi.userData valueForKey:@"name"];
            self.headerIcon.image = poi.icon;
            if([poi.userData valueForKey:@"distanceInKm"]){
                double distanceInKm = [[poi.userData valueForKey:@"distanceInKm"] doubleValue];
                
                NSString *distanceText = [NSString stringWithFormat:@"%.1f km", distanceInKm];
                if (distanceInKm < 1) {
                    distanceText = [NSString stringWithFormat:@"%ld m", (long) round(distanceInKm * 1000.0)];
                }
                if (distanceInKm > 10) {
                    distanceText = [NSString stringWithFormat:@"%.0f km", round(distanceInKm)];
                }
                self.distanceLabel.text = distanceText;
                self.distanceLabel.accessibilityLabel = [NSString stringWithFormat:@"Entfernung: %@.",distanceText];
                self.distanceLabel.hidden = NO;
                [self.titleLabel setWidth:self.frame.size.width-43-10-self.distanceLabel.sizeWidth-10];
            } else {
                self.distanceLabel.text = @"";
                [self.titleLabel setWidth:self.frame.size.width-43-10];
            }
            
            break;
        }
        case USER:
        case VENUE:
            //should never be called
            break;
    }
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.sizeWidth, y+5);
    
}

-(void)internalLink:(id)sender{
    if(self.poi.riMapPoi.isDBInfoPOI){
        [self.viewController dismissViewControllerAnimated:YES completion:^{
            MBContentSearchResult* res = [MBContentSearchResult searchResultWithKeywords:CONTENT_SEARCH_KEY_STATIONINFO_INFOSERVICE_DBINFO];
            MBRootContainerViewController* root = [MBRootContainerViewController currentlyVisibleInstance];
            [root handleSearchResult:res];
        }];

    }
}

-(void)setupTrackLayout:(RIMapPoi*)riMapPoi{
    self.moveableContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.moveableContentView];
    self.moveableContentView.backgroundColor = [UIColor whiteColor];
    [self.moveableContentView addSubview:self.header];
    
    NSArray *allStops = [[[TimetableManager sharedManager] timetable] departureStops];
    //filter for the stops on this track
    NSArray* stopsForTrack = [allStops filteredArrayUsingPredicate:
                              [NSPredicate predicateWithBlock:^BOOL(Stop *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        Event *event = [evaluatedObject eventForDeparture:YES];
        if ([event.actualPlatformNumberOnly isEqualToString:riMapPoi.name]) {
            return YES;
        }
        return NO;
    }]];
    
    //limit the number depending on the display size (iphone4s is not able to display 3 trains)
    NSInteger maxStops = 3;
    if ([UIScreen mainScreen].bounds.size.height == 480){
        maxStops = 2;
    }
    
    stopsForTrack = [stopsForTrack subarrayWithRange:NSMakeRange(0, MIN(stopsForTrack.count,maxStops))];
    
    if(self.isCentral && stopsForTrack.count > 0){
        //NOTE: only the central flyout supports opening!
        self.headerOpenImage.hidden = self.headerButton.hidden = NO;
        UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureUpInTracks:)];
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self.moveableContentView addGestureRecognizer:swipe];
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureDownInTracks:)];
        swipe.direction = UISwipeGestureRecognizerDirectionDown;
        [self.moveableContentView addGestureRecognizer:swipe];
    }
    
    int y = self.header.sizeHeight;
    
    NSLog(@"stops for track: %@",riMapPoi.name);
    self.movableShrinkY = 0;
    for (Stop *stop in stopsForTrack) {
        Event *event = [stop eventForDeparture:YES];
        
        y += 20;
        
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 60, 20)];
        [timeLabel setFont:[UIFont db_BoldSixteen]];
        [timeLabel setTextColor:[UIColor db_333333]];
        timeLabel.text = stop.departure.formattedTime;
        [timeLabel sizeToFit];
        [self.moveableContentView addSubview:timeLabel];
        
        UILabel* destLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, y, self.frame.size.width-80-16, 20)];
        [destLabel setFont:[UIFont db_RegularSixteen]];
        [destLabel setTextColor:[UIColor db_333333]];
        destLabel.text = event.actualStation;
        [destLabel sizeToFit];
        [destLabel setWidth:self.frame.size.width-80-16];
        [self.moveableContentView addSubview:destLabel];
        
        if(event.trainRecordAvailable || [MBTimetableViewController stopShouldHaveTrainRecord:stop]){
            MBButtonWithData* wagenstandButton = [[MBButtonWithData alloc] initWithFrame:CGRectMake(0, y, 50, 50)];
            wagenstandButton.data = stop;
            [wagenstandButton addTarget:self action:@selector(wagenstandForTrain:) forControlEvents:UIControlEventTouchUpInside];
            wagenstandButton.backgroundColor = [UIColor whiteColor];
            wagenstandButton.layer.cornerRadius = wagenstandButton.sizeHeight/2;
            wagenstandButton.layer.shadowOffset = CGSizeMake(1.0, 1.0);
            wagenstandButton.layer.shadowColor = [[UIColor db_dadada] CGColor];
            wagenstandButton.layer.shadowRadius = 4;
            wagenstandButton.layer.shadowOpacity = 1.0;
            [wagenstandButton setImage:[UIImage db_imageNamed:@"app_wagenreihung_grau"] forState:UIControlStateNormal];
            [self.moveableContentView addSubview:wagenstandButton];
            [wagenstandButton setGravityRight:16];
            
            [destLabel setWidth:self.frame.size.width-80-72];
        }
        y += 25;
        
        UILabel* expectedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 60, 20)];
        [expectedTimeLabel setFont:[UIFont db_RegularFourteen]];
        expectedTimeLabel.text = [event formattedExpectedTime];
        if([event roundedDelay] >= 5){
            expectedTimeLabel.textColor = [UIColor db_mainColor];
        } else {
            expectedTimeLabel.textColor = [UIColor db_38a63d];
        }
        [expectedTimeLabel sizeToFit];
        [self.moveableContentView addSubview:expectedTimeLabel];
        //hide time when train is canceled
        expectedTimeLabel.hidden = event.eventIsCanceled;

        
        UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, y, self.frame.size.width-80-72, 20)];
        [lineLabel setFont:[UIFont db_RegularFourteen]];
        [lineLabel setTextColor:[UIColor db_787d87]];
        lineLabel.text = [stop formattedTransportType:event.lineIdentifier];
        [lineLabel sizeToFit];
        [self.moveableContentView addSubview:lineLabel];
        
        y += lineLabel.sizeHeight + 20;
        
        [event updateComposedIrisWithStop:stop];
        UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, y, self.sizeWidth-2*15, 44)];
        messageLabel.numberOfLines = 2;
        messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [messageLabel setFont:[UIFont db_HelveticaTwelve]];
        [messageLabel setTextColor:[UIColor db_mainColor]];
        messageLabel.text = event.composedIrisMessage;
        [messageLabel sizeToFit];
        [self.moveableContentView addSubview:messageLabel];
        
        if(messageLabel.text.length > 0){
            y += messageLabel.sizeHeight;
        }
        y += 25;

        NSLog(@"Train %@, %@, %@, %@",stop.departure.formattedTime, [stop formattedTransportType:event.lineIdentifier], event.actualStation, event.composedIrisMessage);
        
        if(stop == stopsForTrack.firstObject){
            //special case: the first item has always the height of the flyout
            if(y < self.sizeHeight){
                self.movableShrinkY = (self.sizeHeight-y);
                y = self.sizeHeight;
            }
        }
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.sizeWidth, 1)];
        line.backgroundColor = [UIColor db_787d87];
        [self.moveableContentView addSubview:line];
        if(stop == stopsForTrack.firstObject){
            line.tag = MOVABLE_SHRINK_TAG;
        }
    }
    
    if(stopsForTrack.count > 0){
        y += 20;
        MBLargeButton* confirmButton = [[MBLargeButton alloc] initWithFrame:CGRectMake(16, y, self.frame.size.width-2*16, 60)];
        [confirmButton setTitle:@"Abfahrtstafel" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(tapAbfahrtstafel:) forControlEvents:UIControlEventTouchUpInside];
        [self.moveableContentView addSubview:confirmButton];
        y += confirmButton.sizeHeight;
        y += 16;
    } else {
        //display hint text that we have no departures on this track
        y += 25;
        UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, y, self.sizeWidth-2*15, 300)];
        messageLabel.numberOfLines = 0;
        messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [messageLabel setFont:[UIFont db_HelveticaFourteen]];
        [messageLabel setTextColor:[UIColor db_333333]];
        messageLabel.text = @"Keine Abfahrt in den nächsten zwei Stunden.";
        [messageLabel sizeToFit];
        [self.moveableContentView addSubview:messageLabel];
        y += messageLabel.sizeHeight;
    }
    //movable content has a minimum height of the flyout and may be larger
    //when opened it may shrink in size
    [self.moveableContentView setHeight:(MAX(y,self.frame.size.height))-self.movableShrinkY];
}

-(CGFloat)addStatusLineWithIcon:(NSString*)icon text:(NSString*)text color:(UIColor*)color externalLink:(SEL)linkSelector orSwitch:(UISwitch*)aSwitch atY:(CGFloat)y{
    int x = 13;
    UIImageView* iconView = nil;
    NSInteger textWidth = self.frame.size.width-2*13;
    if(icon){
        UIImage* img = [UIImage db_imageNamed:icon];
        if(img){
            iconView = [[UIImageView alloc] initWithImage:img];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            [iconView setSize:CGSizeMake(24, 24)];
            [self.contentScrollView addSubview:iconView];
            [iconView setGravityTop:y];
            [iconView setGravityLeft:x];
            x = CGRectGetMaxX(iconView.frame)+2;
            textWidth += 10;
            textWidth -= CGRectGetMaxX(iconView.frame);
            y += 5;
        }
    }
    UIButton* externalLinkButton = nil;
    if(linkSelector){
        externalLinkButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 60, 60)];
        [externalLinkButton setImage:[UIImage db_imageNamed:@"MapExternalLinkButton"] forState:UIControlStateNormal];
        [externalLinkButton addTarget:self action:linkSelector forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:externalLinkButton];
        [externalLinkButton setGravityRight:10];
        [externalLinkButton setGravityTop:y];
        textWidth -= externalLinkButton.sizeWidth;
    }
    if(aSwitch){
        [self.contentScrollView addSubview:aSwitch];
        [aSwitch setGravityRight:16];
        [aSwitch setGravityTop:y];
        textWidth -= (aSwitch.sizeWidth+16);
    }
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(x+2, y, textWidth, 300)];
    [self.contentScrollView addSubview:label];
    label.numberOfLines = 0;
    label.text = text;
    label.textColor = color;
    label.font = [UIFont db_RegularFourteen];
    label.size = [label sizeThatFits:label.size];
    
    if(linkSelector){
        //center with text
        [externalLinkButton setY:ceilf(label.frame.origin.y + label.frame.size.height/2 - externalLinkButton.frame.size.height/2)];
        if(externalLinkButton.frame.origin.y < y){
            CGFloat delta = y-externalLinkButton.frame.origin.y;
            //need to move both text+button down
            [externalLinkButton setY:externalLinkButton.frame.origin.y+delta];
            [label setY:label.frame.origin.y+delta];
        }
    }
    if(aSwitch){
        [label setY:label.frame.origin.y+6];
    }
    
    CGFloat newY = MAX( CGRectGetMaxY(iconView.frame), CGRectGetMaxY(externalLinkButton.frame) );
    newY = MAX( newY, CGRectGetMaxY(aSwitch.frame));
    newY = MAX( newY, CGRectGetMaxY(label.frame));
    return newY+4;
}

- (void) showRoutingForParking:(MBParkingInfo*)parking
{
    [self.delegate showRoutingForParking:parking];
}


-(void)routeButtonPressed{
    [self showRoutingForParking:self.parkingStatusItem];
}



- (void) pushSwitchChanged:(UISwitch*)pushSwitch
{
    if(pushSwitch.on){
        
        
        AppDelegate* del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSDictionary* station = del.selectedStation;
        
        [[FacilityStatusManager client] enablePushForFacility:self.facilityStatusItem.equipmentNumber.description stationNumber:[[station objectForKey:@"id"] description] stationName:[station objectForKey:@"title"]];
    } else {
        [[FacilityStatusManager client] removeFromFavorites:self.facilityStatusItem.equipmentNumber.description];
    }
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = targetHeight / image.size.height;
    CGFloat targetWidth = image.size.width * scaleFactor;
    CGSize targetSize = CGSizeMake(targetWidth, targetHeight);

    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [[UIScreen mainScreen]scale]);
    [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setupViewsForHafas:(HafasTimetable*)timetable {
    if (self.spinner.isAnimating) {
        [self.spinner stopAnimating];
        [self.spinner removeFromSuperview];
        self.spinner = nil;
    }

    NSMutableArray *departures = [timetable.departureStops mutableCopy];
    // show only some
    NSInteger maxElements = 2;
    if (departures.count > maxElements) {
        NSRange range = NSMakeRange(maxElements, departures.count - maxElements);
        [departures removeObjectsInRange:range];
    }
    [self.infoLabelDepartureNotAvailable removeFromSuperview];
    self.infoLabelDepartureNotAvailable = nil;
    if (departures.count == 0) {
        // show error info label
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        infoLabel.numberOfLines = 0;
        infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *abfahrtDict = [self.abfahrtLabels objectAtIndex:0];
        UILabel *timeLabel = [abfahrtDict objectForKey:@"timeLabel"];
        CGRect infoFrame = timeLabel.frame;
        infoFrame.size.width = self.frame.size.width - 32.0;
        infoLabel.frame = infoFrame;
        infoLabel.text = @"Für diese Haltestelle liegen zur Zeit keine Informationen vor.";
        [self addSubview:infoLabel];
        [infoLabel sizeToFit];
        self.infoLabelDepartureNotAvailable = infoLabel;
        
        for(NSDictionary* abfahrtDict in self.abfahrtLabels){
            UILabel *timeLabel = [abfahrtDict objectForKey:@"timeLabel"];
            UILabel *expectedTimeLabel = [abfahrtDict objectForKey:@"expectedTimeLabel"];
            UILabel *lineLabel = [abfahrtDict objectForKey:@"lineLabel"];
            UILabel *destLabel = [abfahrtDict objectForKey:@"destLabel"];
            UILabel *accLabel = [abfahrtDict objectForKey:@"accLabel"];
            UIImageView* warnIcon = [abfahrtDict objectForKey:@"warnIcon"];
            timeLabel.text = @"";
            expectedTimeLabel.text = @"";
            lineLabel.text = @"";
            destLabel.text = @"";
            accLabel.text = @"";
            warnIcon.hidden = YES;
        }
    }
    for (HafasDeparture *departure in departures) {
        NSDictionary *abfahrtDict = [self.abfahrtLabels objectAtIndex:[departures indexOfObject:departure]];
        UILabel *timeLabel = [abfahrtDict objectForKey:@"timeLabel"];
        // substring gets rid of seconds
        timeLabel.text = [[departure valueForKey:@"time"] substringToIndex:5];
        [timeLabel sizeToFit];
        timeLabel.hidden = NO;
        
        UILabel *expectedTimeLabel = [abfahrtDict objectForKey:@"expectedTimeLabel"];
        // substring gets rid of seconds
        expectedTimeLabel.text = [departure.expectedDeparture substringToIndex:5];
        [expectedTimeLabel sizeToFit];
        expectedTimeLabel.hidden = NO;
        if([departure delayInMinutes] >= 5){
            expectedTimeLabel.textColor = [UIColor db_mainColor];
        } else {
            expectedTimeLabel.textColor = [UIColor db_38a63d];
        }
        
        UILabel *lineLabel = [abfahrtDict objectForKey:@"lineLabel"];
        lineLabel.text = [departure valueForKey:@"name"];
        [lineLabel sizeToFit];
        [lineLabel setBelow:timeLabel withPadding:8.0];
        lineLabel.hidden = NO;
        UILabel *destLabel = [abfahrtDict objectForKey:@"destLabel"];
        destLabel.text = [departure valueForKey:@"direction"];
        destLabel.numberOfLines = 1;
        destLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [destLabel sizeToFit];
        [destLabel setRight:timeLabel withPadding:30.0];
        destLabel.size = CGSizeMake(self.size.width-8-destLabel.frame.origin.x,destLabel.size.height);//ensure max width
        destLabel.hidden = NO;
        
        //UIImageView* warnIcon = [abfahrtDict objectForKey:@"warnIcon"];
        //warnIcon.hidden = NO;//could add a warnicon here...
        
        NSString* line = lineLabel.text;
        line = [line stringByReplacingOccurrencesOfString:@"STR" withString:VOICEOVER_FOR_STR];
        
        UILabel *accLabel = [abfahrtDict objectForKey:@"accLabel"];
        accLabel.accessibilityLabel = [NSString stringWithFormat:@"%@ nach %@, %@ Uhr.",line,destLabel.text,timeLabel.text];
        accLabel.hidden = NO;
    }
}

- (void)didReceiveTimetableUpdate:(NSNotification *)notification {
    if ([notification.object isEqual:self.localTimeTableManager]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.spinner.isAnimating) {
                [self.spinner stopAnimating];
                [self.spinner removeFromSuperview];
                self.spinner = nil;
            }
                        
            NSArray *allStops = [[self.localTimeTableManager timetable] departureStops];
            if(allStops.count > 0){
                self.infoLabelDepartureNotAvailable.hidden = YES;
            } else {
                if(!self.infoLabelDepartureNotAvailable){
                    // show error info label
                    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                    infoLabel.numberOfLines = 0;
                    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *abfahrtDict = [self.abfahrtLabels objectAtIndex:0];
                    UILabel *timeLabel = [abfahrtDict objectForKey:@"timeLabel"];
                    CGRect infoFrame = timeLabel.frame;
                    infoFrame.size.width = self.frame.size.width - 32.0;
                    infoLabel.frame = infoFrame;
                    infoLabel.text = @"Daten nicht verfügbar.";
                    [self addSubview:infoLabel];
                    [infoLabel sizeToFit];
                    self.infoLabelDepartureNotAvailable = infoLabel;
                }
                self.infoLabelDepartureNotAvailable.hidden = NO;
            }
            
            // show only some 
            NSInteger maxElements = 2;
            NSUInteger index = 0;
            for (Stop *stop in allStops) {
                Event *event = [stop eventForDeparture:YES];
                if (maxElements > 0) {
                    maxElements -= 1;
                    // fill in data for "maxElements" stops
                    NSDictionary *abfahrtDict = [self.abfahrtLabels objectAtIndex:index];
                    UILabel *timeLabel = [abfahrtDict objectForKey:@"timeLabel"];
                    timeLabel.text = stop.departure.formattedTime;
                    [timeLabel sizeToFit];
                    timeLabel.hidden = NO;
                    UILabel *expectedTimeLabel = [abfahrtDict objectForKey:@"expectedTimeLabel"];
                    expectedTimeLabel.text = stop.departure.formattedExpectedTime;
                    [expectedTimeLabel sizeToFit];
                    expectedTimeLabel.hidden = NO;
                    if(stop.departure.roundedDelay >= 5){
                        expectedTimeLabel.textColor = [UIColor db_mainColor];
                    } else {
                        expectedTimeLabel.textColor = [UIColor db_38a63d];
                    }
                    //hide time when train is canceled
                    expectedTimeLabel.hidden = event.eventIsCanceled;

                    UILabel *lineLabel = [abfahrtDict objectForKey:@"lineLabel"];
                    lineLabel.text = [stop formattedTransportType:event.lineIdentifier];
                    [lineLabel sizeToFit];
                    [lineLabel setBelow:timeLabel withPadding:8.0];
                    lineLabel.hidden = NO;
                    UILabel *destLabel = [abfahrtDict objectForKey:@"destLabel"];
                    destLabel.text = event.actualStation;
                    [destLabel sizeToFit];
                    [destLabel setRight:timeLabel withPadding:30.0];
                    destLabel.hidden = NO;
                    
                    [event updateComposedIrisWithStop:stop];
                    UIImageView* warnIcon = [abfahrtDict objectForKey:@"warnIcon"];
                    warnIcon.hidden = event.composedIrisMessage.length == 0;
                    if(!warnIcon.hidden){
                        //what icon do we need?
                        if(event.hasOnlySplitMessage){
                            warnIcon.image = [UIImage db_imageNamed:@"app_warndreieck_dunkelgrau"];
                        } else {
                            warnIcon.image = [UIImage db_imageNamed:@"app_warndreieck"];
                            if(event.shouldShowRedWarnIcon){
                                warnIcon.hidden = NO;
                            } else {
                                warnIcon.hidden = YES;
                            }
                        }
                        [warnIcon setX:CGRectGetMaxX(lineLabel.frame)];
                        [warnIcon setBelow:destLabel withPadding:5];
                    }

                    index += 1;
                    
                    NSString* line = lineLabel.text;
                    line = [line stringByReplacingOccurrencesOfString:@"STR" withString:VOICEOVER_FOR_STR];

                    UILabel *accLabel = [abfahrtDict objectForKey:@"accLabel"];
                    accLabel.accessibilityLabel = [NSString stringWithFormat:@"%@ nach %@, %@ Uhr.",line,destLabel.text,timeLabel.text];
                    accLabel.hidden = NO;
                } else {
                    break;
                }
            }
        });
    }
}

- (void) showAnimatedInSuperview:(UIView*)superView
{
    [self removeFromSuperview];
    
    self.frame = CGRectMake(0, superView.frame.size.height, superView.frame.size.width, self.sizeHeight);
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, superView.frame.size.height-self.sizeHeight, superView.frame.size.width, self.sizeHeight);
    } completion:^(BOOL finished) {
    }];
    

}

- (void) hideAnimated
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, self.superview.frame.size.height+self.sizeHeight, self.superview.frame.size.width, self.sizeHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

    
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if(newSuperview == nil){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIF_TIMETABLE_UPDATE object:nil];
        [self.localTimeTableManager resetTimetable];
    } else {
        if(self.poi.markerType == STATION_SELECTABLE){
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(didReceiveTimetableUpdate:)
                                                         name:NOTIF_TIMETABLE_UPDATE
                                                       object:nil];
        }
    }
}

- (void) handleLocationUpdate:(NSNotification*)notification
{
   
}

- (void) updateDistanceLabel:(CLLocation*)location
{
   
}



- (void) didTapOnNavigationButton:(id)sender
{
}


# pragma Mobility Actions

- (void) openAppForProvider:(id)sender
{
    if (!self.mobilityMappable) {
        return;
    }
    
    NSURL *urlForProvider = [self.mobilityMappable urlScheme];
    
    BOOL canOpenApp = [[UIApplication sharedApplication] canOpenURL:urlForProvider];
    if (canOpenApp) {
        [[UIApplication sharedApplication] openURL:urlForProvider];
    } else {
        // show dialog and guide to the App Store
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"App nicht installiert" message:@"App jetzt im App Store herunterladen?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Zum App Store" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *storeUrl = self.mobilityMappable.appStoreUrlForProvider;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storeUrl]];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Nein, danke" style:UIAlertActionStyleCancel handler:nil]];
        [self.viewController presentViewController:alert animated:YES completion:nil];
    }
}



@end
