//
//  MBTrainPositionViewController.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 02.03.15.
//  Copyright (c) 2015 Scholz & Volkmer. All rights reserved.
//

#import "MBTrainPositionViewController.h"
#import "WaggonCell.h"
#import "HeadCell.h"
#import "MBWagenstandHeaderRedesigned.h"
#import "WagenstandPushHeader.h"
#import "WagenstandRequestManager.h"
#import "AppDelegate.h"
#import "MBStationNavigationViewController.h"
#import "MBMapViewController.h"
#import "RIMapPoi.h"

@interface MBTrainPositionViewController ()<MBMapViewControllerDelegate>

@property (nonatomic, strong) UITableView *wagenstandTable;
@property (nonatomic, strong) UIRefreshControl* refreshControl;

@property (nonatomic, strong) SectionIndicatorView *sectionIndicator;
@property (nonatomic, strong) NSArray *headerViews;
@property (nonatomic, strong) WagenstandPushHeader* pushHeader;

@property (nonatomic, strong) UIView* headerBackgroundView;//necessary for the shadow

@property (nonatomic, strong) UILabel* updateTimestampLabel;
@property (nonatomic, strong) UIView* updateTimestampView;

@end

@implementation MBTrainPositionViewController

static NSString *kWaggonCell = @"WaggonCell_Default";
static NSString *kHeadCell = @"HeadCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.trackingTitle = @"d3";
    if(self.wagenstand){
        [MBTrackingManager trackStatesWithStationInfo:@[self.trackingTitle,
                                                        @"wagenreihung",
                                                        ]];
    }
    
    //NSLog(@"init controller with wagenstand %@",self.wagenstand);
    //NSLog(@"traintypes %@",self.wagenstand.traintypes);
    //NSLog(@"trainnumbers %@",self.wagenstand.trainNumbers);
    //NSLog(@"subtrains %@",self.wagenstand.subtrains);
    //NSLog(@"wagons %@",self.wagenstand.waggons);
    
    
    [self updateTitle];
    
    self.headerBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.headerBackgroundView.backgroundColor = [UIColor whiteColor];
    self.headerBackgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerBackgroundView.layer.shadowOffset = CGSizeMake(0,1);
    self.headerBackgroundView.layer.shadowOpacity = 0.3;
    self.headerBackgroundView.layer.shadowRadius = 2;

    [self.view addSubview:self.headerBackgroundView];
    
    self.wagenstandTable = [[UITableView alloc] init];
    self.wagenstandTable.backgroundColor = [UIColor whiteColor];
    [self.wagenstandTable registerClass:WaggonCell.class forCellReuseIdentifier:kWaggonCell];
    [self.wagenstandTable registerClass:HeadCell.class forCellReuseIdentifier:kHeadCell];
    self.wagenstandTable.delegate = self;
    self.wagenstandTable.dataSource = self;
    
    if (@available(iOS 11.0, *)) {
        self.wagenstandTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    if(ISIPAD){
        //cells will generate their own separator
        self.wagenstandTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    [self updateHeaderViews];
    
    UIView *updateTimestampView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.sizeWidth,40)];
    self.updateTimestampView = updateTimestampView;
    UILabel *updateTimestampLabel = [[UILabel alloc] init];
    if(!self.wagenstand.isISTData){
        //soll-data has two lines text
        [updateTimestampView setHeight:60];
        updateTimestampLabel.numberOfLines = 0;
        [updateTimestampLabel setSize:CGSizeMake(self.view.sizeWidth-2*15, 40)];
    }
    self.updateTimestampLabel = updateTimestampLabel;
    self.updateTimestampLabel.isAccessibilityElement = NO;
    updateTimestampLabel.font = [UIFont db_RegularTwelve];
    updateTimestampLabel.textColor = [UIColor db_787d87];
    [self updateReloadTime];
    [updateTimestampView addSubview:updateTimestampLabel];
    
    if(self.wagenstand.isISTData){
        UIImageView* reloadImg = [[UIImageView alloc] initWithImage:[UIImage db_imageNamed:@"ReloadBtn"]];
        [updateTimestampView addSubview:reloadImg];
        [reloadImg centerViewVerticalInSuperView];
        [reloadImg setGravityLeft:20-5];
        [updateTimestampLabel centerViewVerticalInSuperView];
        [updateTimestampLabel setRight:reloadImg withPadding:7];
    } else {
        [updateTimestampLabel centerViewVerticalInSuperView];
        [updateTimestampLabel setGravityLeft:15];
    }
    [self updateReloadTime];//update again to set correct text for accessibility!
    
    [self.view addSubview:self.updateTimestampView];
    
    if([Wagenstand isValidTrainTypeForIST:[Wagenstand getTrainTypeForWagenstand:_wagenstand]]){
        self.pushHeader = [[WagenstandPushHeader alloc] initWithFrame:CGRectMake(0,0,self.view.sizeWidth,34)];
        
    } 
    
    self.sectionIndicator = [[SectionIndicatorView alloc] initWithWagenstand:self.wagenstand
                                                                    andFrame:CGRectMake(0, 0, self.view.sizeWidth, 70)];
    self.sectionIndicator.backgroundColor = [UIColor whiteColor];
    self.sectionIndicator.delegate = self;
    
    //[self.view addSubview:self.sectionIndicator];
    [self.view insertSubview:self.sectionIndicator belowSubview:self.headerBackgroundView];
    [self.view addSubview:self.pushHeader];
//    [self.view addSubview:self.wagenstandTable];
    [self.view insertSubview:self.wagenstandTable belowSubview:self.sectionIndicator];

    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    tableViewController.tableView = self.wagenstandTable;
    tableViewController.refreshControl = self.refreshControl;
    self.wagenstandTable.allowsSelection = NO;
    
    [self.wagenstandTable reloadData];
    
    self.pushHeader.pushSwitch.on = [self findLocalNotification] != nil;

    [self.pushHeader.pushSwitch addTarget:self action:@selector(pushSwitchChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)updateHeaderViews{
    NSMutableArray* headers = [NSMutableArray arrayWithCapacity:self.wagenstand.subtrains.count];
    for(Train* subtrain in self.wagenstand.subtrains){
        MBWagenstandHeaderRedesigned* header = [[MBWagenstandHeaderRedesigned alloc] initWithWagenstand:self.wagenstand train:subtrain andFrame:CGRectZero];
        [headers addObject:header];
        [self.view addSubview:header];
    }
    self.headerViews = headers;
}

-(void)setTitle:(NSString *)atitle{
    if(UIAccessibilityIsVoiceOverRunning()){
        atitle = [atitle stringByReplacingOccurrencesOfString:@"Gl." withString:@"Gleis"];
    }
    [super setTitle:atitle];

}

-(void)updateReloadTime
{
    if(self.wagenstand.isISTData){
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd.MM.YY, HH:mm"];
        NSDate* date = [NSDate date];
        NSString* dateString = [df stringFromDate:date];
        NSString* staticPart = @"Wagenreihungsplan Stand: ";
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",staticPart, dateString ] attributes:@{NSFontAttributeName:[UIFont db_RegularTwelve]}];
        [str addAttributes:@{NSFontAttributeName:[UIFont db_BoldTwelve]} range:NSMakeRange(staticPart.length,str.length-staticPart.length)];
        self.updateTimestampLabel.attributedText = str;
    } else {
        //soll data
        NSString* text = @"Dargestellte Wagenreihung gemäß Fahrplan. Bitte achten Sie auf aktuelle Informationen am Gleis.";
        NSString* boldPart = @"aktuelle Informationen am Gleis.";
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont db_RegularTwelve]}];
        [str addAttributes:@{NSFontAttributeName:[UIFont db_BoldTwelve]} range:NSMakeRange(text.length-boldPart.length,boldPart.length)];
        self.updateTimestampLabel.attributedText = str;
    }
    [self.updateTimestampLabel sizeToFit];

}

-(void)updateTitle{
    self.title = [NSString stringWithFormat:@"%@ | Gl. %@",self.wagenstand.time,self.wagenstand.platform];
    if (self.waggonNumber.length > 0) {//I think this is no longer used...
        self.title = [self.title stringByAppendingString:[NSString stringWithFormat:@", Wagen %@", self.waggonNumber]];
    }
}

-(void)refreshData
{
    NSLog(@"refreshData");
    [self.refreshControl beginRefreshing];

    [[WagenstandRequestManager sharedManager] loadISTWagenstandWithWagenstand:self.wagenstand completionBlock:^(Wagenstand *istWagenstand) {
        
        //NSLog(@"IST-Api responded with %@",istWagenstand);
        if(istWagenstand){
            self.wagenstand = istWagenstand;
            [self updateTitle];
            
            [self.headerViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self updateHeaderViews];
            [self.view setNeedsLayout];
            [self.wagenstandTable reloadData];
        } else {
            //keep last data, update time???
        }
        [self updateReloadTime];
        [self.refreshControl endRefreshing];
    }];
}

-(UILocalNotification*)findLocalNotification
{
    NSString* trainNumber = [Wagenstand getTrainNumberForWagenstand:_wagenstand];
    NSString* time = [Wagenstand getDateAndTimeForWagenstand:_wagenstand];
    //iterate over registered notifications and check if we need to cancel one
    for(UILocalNotification* localNotif in [UIApplication sharedApplication].scheduledLocalNotifications){
        //find notification and cancel
        NSDictionary* userInfo = localNotif.userInfo;
        if([[userInfo objectForKey:@"type"] isEqualToString:@"wagenstand"] &&
           [[userInfo objectForKey:WAGENSTAND_TRAINNUMBER] isEqualToString:trainNumber] &&
           [[userInfo objectForKey:WAGENSTAND_TIME] isEqualToString:time]){
            return localNotif;
        }
    }
    return nil;
}

-(void)pushSwitchChanged:(UISwitch*)pushSwitch{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* currentSettings = [UIApplication sharedApplication].currentUserNotificationSettings;
        if((currentSettings.types & UIUserNotificationTypeAlert) == 0){
            //we can't show alerts
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSettingsRegistered:) name:NOTIFICATION_USERSETTINGS_REGISTERED object:nil];
            
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
            return;//wait for callback
        } else {
            NSLog(@"we can show alerts, don't ask again");
        }
    }
    
    [self updateLocalNotif];
}
-(void)updateLocalNotif{
    NSString* trainNumber  =[Wagenstand getTrainNumberForWagenstand:_wagenstand];
    NSString* time = _wagenstand.expectedTime;
    if(!time){
        //fallback to planed time
        time = _wagenstand.time;
    }
    NSLog(@"pushSwitch changed status to %d, must register/remove local notification for train %@ at %@", self.pushHeader.pushSwitch.on, trainNumber, time);
    
    UILocalNotification* localNotif = [self findLocalNotification];
    if(localNotif){
        [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
    }
    
    if(self.pushHeader.pushSwitch.on){
        
        NSDate* fireDate = [NSDateFormatter dateFromString:time forPattern:@"HH:mm"];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:fireDate];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        
        fireDate = [self fireDate:hour minute:minute];
        
        if([fireDate earlierDate:[NSDate date]] == fireDate){
            //this would fire in the past and display immediately, instead display alert
            // NSLog(@"ignore notification with date in past");
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Wagenreihungsplan" message:@"Die Erinnerungsfunktion steht nur bis 10 Minuten vor Einfahrt des Zuges zur Verfügung." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            self.pushHeader.pushSwitch.on = NO;
            return;
        }
        AppDelegate* app = (AppDelegate*) [UIApplication sharedApplication].delegate;
        NSNumber* stationNumber = app.selectedStation[@"id"];
        if(!stationNumber) {
            stationNumber = @0;
        }
        NSString* stationName = app.selectedStation[@"title"];
        if(!stationName) {
            stationName = @"";
        }
        
        NSString *destination = ((Train*)_wagenstand.subtrains.firstObject).destinationStation;
        
        NSString* trainType  =[Wagenstand getTrainTypeForWagenstand:_wagenstand];
        UILocalNotification* localNotif = [[UILocalNotification alloc] init];
        localNotif.userInfo = @{@"type":@"wagenstand",
                                WAGENSTAND_TRAINNUMBER:trainNumber,
                                WAGENSTAND_TIME:time,
                                WAGENSTAND_TYPETRAIN:trainType,
                                @"stationNumber":stationNumber,
                                @"stationName":stationName,
                                WAGENSTAND_EVAS_NR:_wagenstand.evaIds
                                };
        localNotif.alertTitle = @"Bahnhof live";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        // Wagenreihungsplan mit Echtzeitdaten für %@ %@ %@ verfügbar.
        localNotif.alertBody = [NSString stringWithFormat:@"Ihr Zug %@ %@ nach %@ Hbf fährt in Kürze ein. Jetzt Wagenreihung prüfen.",
                                trainType,
                                trainNumber,
                                destination];
        localNotif.fireDate = fireDate;
        //localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:20];// for testing we fire 20s from now
        localNotif.alertAction = @"Öffnen";
        // NSLog(@"now register %@ with text %@",localNotif,localNotif.alertBody);
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
}

-(void)userSettingsRegistered:(NSNotification*)notif{
    NSLog(@"registered notif: %@",notif);
    UIUserNotificationSettings* settings = notif.object;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if((settings.types & UIUserNotificationTypeAlert) == 0){
        self.pushHeader.pushSwitch.on = NO;
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Hinweis" message:@"Sie müssen der App in den Einstellungen Mitteilungen erlauben um diese Funktion nutzen zu können." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Einstellungen" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Schließen" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    [self updateLocalNotif];
}

- (NSDate*) fireDate:(NSInteger)hour minute:(NSInteger)minutes
{
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: hour];
    [components setMinute: minutes];
    
    NSDate *fullDate = [gregorian dateFromComponents: components];
    return [fullDate dateByAddingTimeInterval:-10*60];//10min earlier
}

# pragma -
# pragma UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // standard cell height 160 for length 2.0
    // half cell height 80 for length 1.0
    CGFloat height = 0.f;
    Waggon *waggon = self.wagenstand.waggons[indexPath.item];
    if (waggon) {
        if (waggon.isTrainBothWays && waggon != [self.wagenstand.waggons lastObject] && waggon != [self.wagenstand.waggons firstObject]) {
            height = 130.f;
        } else {
            height = [waggon heightOfCell];
            if(waggon.fahrzeugausstattung.count > 0){
                //maybe update height depending on items...
                double widthOfLegendPart = [WaggonCell widthOfLegendPartForWidth:self.view.frame.size.width];
                NSArray* tags = [waggon setupTagViewsForWidth:widthOfLegendPart];
                UIView* v = tags.lastObject;
                CGFloat spaceAtTheEndOfCell = 10;
                CGFloat maxHeight = CGRectGetMaxY(v.frame) + spaceAtTheEndOfCell;
                if(maxHeight > height){
                    height = maxHeight;
                }
            }
        }
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wagenstand.waggons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Waggon *waggon = self.wagenstand.waggons[indexPath.item];
    Train *train = [self.wagenstand destinationForWaggon:waggon];

    UITableViewCell *tableCell;
    
    if (waggon.isTrainHead || waggon.isTrainBack || waggon.isTrainBothWays) {
        HeadCell *cell = [tableView dequeueReusableCellWithIdentifier:kHeadCell forIndexPath:indexPath];
        [cell setWaggon:waggon lastPosition:indexPath.item==self.wagenstand.waggons.count-1];
        [cell setTrain:train];
        tableCell = cell;
    } else {
        WaggonCell *cell = [tableView dequeueReusableCellWithIdentifier:kWaggonCell forIndexPath:indexPath];
        cell.waggon = waggon;
        tableCell = cell;
    }
    
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return tableCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *visibleIndexPaths = [self.wagenstandTable indexPathsForVisibleRows];
    if (visibleIndexPaths.count > 0) {
        NSArray* sortedIndexPaths = [visibleIndexPaths sortedArrayUsingSelector:@selector(compare:)];
        NSIndexPath *firstVisibleIndexPath = [sortedIndexPaths firstObject];
        
        Waggon *waggon = self.wagenstand.waggons[firstVisibleIndexPath.row];
        NSString *section = [waggon.sections lastObject];
                
        [self.sectionIndicator setActiveSection:section atIndex:firstVisibleIndexPath.row animateTo:YES];
        [self.sectionIndicator setActiveWaggonAtIndex:firstVisibleIndexPath.row animateTo:YES];

    }
}


# pragma -
# pragma Layout

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

//    int y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    int y = 0;
    y += 18;
    for(MBWagenstandHeaderRedesigned* header in self.headerViews){
        CGRect f = header.frame;
        f.origin.y = y;
        header.frame = f;
        [header resizeForWidth:self.view.sizeWidth];
        y += header.frame.size.height;
    }
    
    [self.updateTimestampView setY:y];
    y += self.updateTimestampView.sizeHeight;
    
    if(self.pushHeader){
        self.pushHeader.frame = CGRectMake(0, y-14, self.view.sizeWidth, self.pushHeader.sizeHeight);
        self.sectionIndicator.frame = CGRectMake(0,CGRectGetMaxY(self.pushHeader.frame)+13, self.view.sizeWidth, 70);
        self.wagenstandTable.frame = CGRectMake(0,CGRectGetMaxY(self.sectionIndicator.frame), self.view.sizeWidth, self.view.sizeHeight-(CGRectGetMaxY(self.pushHeader.frame)));
    } else {
        self.sectionIndicator.frame = CGRectMake(0,y, self.view.sizeWidth, 70);
        self.wagenstandTable.frame = CGRectMake(0,CGRectGetMaxY(self.sectionIndicator.frame), self.view.sizeWidth, self.view.sizeHeight-(CGRectGetMaxY(self.sectionIndicator.frame)));
    }
    
    self.headerBackgroundView.frame = CGRectMake(0, 0, self.view.sizeWidth, self.sectionIndicator.frame.origin.y);
    
    self.sectionIndicator.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sectionIndicator.layer.shadowOffset = CGSizeMake(0,1);
    self.sectionIndicator.layer.shadowOpacity = 0.3;
    self.sectionIndicator.layer.shadowRadius = 2;
    
    // Increase the content inset, so we can scroll the last cell to the top of the view.
    // This way we make sure, that we can reach all sections of the train
    if (self.wagenstand.waggons.count > 0) {
        Waggon *waggon = [self.wagenstand.waggons lastObject];
        double heightOfLastWaggon = [waggon heightOfCell];
        self.wagenstandTable.contentInset = UIEdgeInsetsMake(0,
                                                             0,
                                                             self.wagenstandTable.sizeHeight-heightOfLastWaggon
                                                             ,
                                                             0);
    }
}

#pragma -
#pragma SectionIndicatorDelegate

- (void)sectionView:(SectionIndicatorView *)sectionView didSelectSection:(NSString *)section
{
    NSInteger index = [self.wagenstand indexOfWaggonForSection:section];
    
    if (index != -1) {
        [self.wagenstandTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [(MBStationNavigationViewController *)self.navigationController hideNavbar:NO];
    [(MBStationNavigationViewController *)self.navigationController showBackgroundImage:NO];
    [(MBStationNavigationViewController *)self.navigationController setShowRedBar:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //scroll to specific waggon if user has queried for one
    if (self.waggonNumber.length > 0) {
        NSInteger index = [self.wagenstand indexOfWaggonForWaggonNumber:self.waggonNumber];
        [self.wagenstandTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self scrollViewDidScroll:self.wagenstandTable];
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark MBMapViewControllerDelegate


-(id)mapSelectedPOI{
    return [self.station poiForPlatform:self.wagenstand.platform];
}
-(NSArray<NSString *> *)mapFilterPresets{
    return @[ PRESET_DB_TIMETABLE ];
}

@end
