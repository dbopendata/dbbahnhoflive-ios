//
//  MBTimeTableViewCell.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 23.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBLinkButton.h"
#import "MBStationListView.h"
#import "MBButtonWithData.h"

#import "Event.h"

#define kCellHeight 81
#define kInnerPadding 5
#define kTopPadding 5
#define kLeftPadding 20

@interface MBTimeTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *trainLabel;
@property (nonatomic, strong) UILabel *platformLabel;

@property (nonatomic, strong) NSString* trainStringForVoiceOver;
@property (nonatomic, strong) UILabel *stationLabel;
@property (nonatomic, strong) UILabel *expectedTimeLabel;
@property (nonatomic, strong) UILabel *intermediateStationsLabel;

@property (nonatomic, strong) MBStationListView *viaListView;

@property (nonatomic, strong) UIImageView *messageIcon;
@property (nonatomic, strong) UIImageView *messageIconDetail;
@property (nonatomic, strong) UILabel *messageTextLabel;

@property (nonatomic, strong) UIView *messageDetailContainer;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *viaDelimeter;

@property (nonatomic, strong) UIImageView *wagenstandIcon;
@property (nonatomic, strong) UIView *wagenstandButtonContainer;
@property (nonatomic, strong) UIView *wagenstandDelimeter;
@property (nonatomic, strong) MBButtonWithData* wagenstandButton;

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) NSString *currentStation;

@property (nonatomic, assign) BOOL expanded;

- (void) setExpanded:(BOOL)expanded forIndexPath:(NSIndexPath*)indexPath;

@end
