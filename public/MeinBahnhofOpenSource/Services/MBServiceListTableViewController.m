//
//  MBServiceListTableViewController.m
//  MeinBahnhof
//
//  Created by Marc O'Connor on 04.10.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "MBServiceListTableViewController.h"
#import "MBMenuItem.h"

#import "MBEinkaufsbahnhofCategory.h"
#import "MBEinkaufsbahnhofStore.h"
#import "MBService.h"
#import "MBServiceCell.h"
#import "MBDetailViewDelegate.h"
#import "MBUIViewController.h"
#import "MBStationNavigationViewController.h"
#import "MBNavigationController.h"
#import "MBPXRShopCategory.h"
#import "RIMapPoi.h"
#import "MBMapViewController.h"
#import "MBTutorialManager.h"
#import "MBContentSearchResult.h"
#import "MBCouponCategory.h"
#import "MBCouponTableViewCell.h"

@interface MBServiceListTableViewController () <MBDetailViewDelegate,MBMapViewControllerDelegate>

@property (nonatomic, strong) id item;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSArray *subItems;
@property (nonatomic, strong) NSIndexPath *selectedRow;
@property (nonatomic, assign) CGFloat additionalHeightForExpandedCell;
@property (nonatomic) BOOL ignoreTableUpdateOnSelect;
@end

@implementation MBServiceListTableViewController

#define SERVICETYPE_SHOPPING_EINK @"shopping-eink"
#define SERVICETYPE_SHOPPING_PXR @"shopping-pxr"
#define SERVICETYPE_INFO @"info"
#define SERVICETYPE_COUPONS @"coupons"

- (instancetype)initWithItem:(id)item {
    self = [super initWithStyle:UITableViewStylePlain];
    self.item = item;
    if([item isKindOfClass:[MBEinkaufsbahnhofCategory class]]){
        self.type = SERVICETYPE_SHOPPING_EINK;
        self.subItems = [(MBEinkaufsbahnhofCategory*)item shops];
    } else if([item isKindOfClass:[MBMenuItem class]]) {
        self.type = SERVICETYPE_INFO;
        NSArray *subItems = [(MBMenuItem *)item services];
        self.subItems = [subItems sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([[(MBService *)obj1 position] integerValue] > [[(MBService *)obj2 position] integerValue]) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }];
    } else if([item isKindOfClass:[MBPXRShopCategory class]]) {
        self.type = SERVICETYPE_SHOPPING_PXR;
        self.subItems = ((MBPXRShopCategory *)item).items;
    } else if([item isKindOfClass:MBCouponCategory.class]){
        self.type = SERVICETYPE_COUPONS;
        self.subItems = ((MBCouponCategory*)item).items;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBUIViewController addBackButtonToViewController:self andActionBlockOrNil:nil];

    self.selectedRow = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
    if ([self.type isEqualToString:SERVICETYPE_INFO]) {
        NSString *title = [[(MBMenuItem *)self.item title] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        title = [title stringByReplacingOccurrencesOfString:@"- " withString:@""];
        self.title = title;
    } else if([self.type isEqualToString:SERVICETYPE_SHOPPING_PXR]) {
        //shopping-pxr
        self.title = ((MBPXRShopCategory*)self.item).title;
    } else if([self.type isEqualToString:SERVICETYPE_SHOPPING_EINK]) {
        self.title = ((MBEinkaufsbahnhofCategory*)self.item).name;
    } else if([self.type isEqualToString:SERVICETYPE_COUPONS]) {
        self.title = ((MBCouponCategory*)self.item).title;
    }
    [self.tableView registerClass:[MBServiceCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[MBCouponTableViewCell class] forCellReuseIdentifier:@"CouponCell"];

    
    self.tableView.backgroundColor = [UIColor db_f0f3f5];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    if (nil != self.navigationController) {
        if ([self.navigationController isKindOfClass:[MBStationNavigationViewController class]]) {
            [(MBStationNavigationViewController *)self.navigationController showBackgroundImage:NO];
            [(MBStationNavigationViewController *)self.navigationController setShowRedBar:YES];
        }
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[MBTutorialManager singleton] hideTutorials];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.type isEqualToString:SERVICETYPE_INFO]) {
        [[MBTutorialManager singleton] displayTutorialIfNecessary:MBTutorialViewType_D1_ServiceStores_Details withOffset:60];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.trackingTitle){
        [MBTrackingManager trackStatesWithStationInfo:@[@"d1", self.trackingTitle]];
    }

    id searchItem = nil;
    if(self.searchResult.isShopSearch){
        if(self.searchResult.couponItem){
            searchItem = self.searchResult.couponItem;
        } else {
            searchItem = self.searchResult.poi;
            if(!searchItem){
                searchItem = self.searchResult.store;
            }
        }
    } else {
        //must be info search
        searchItem = self.searchResult.service;
    }
    if(searchItem){
        NSInteger index = [self.subItems indexOfObject:searchItem];
        if(index != NSNotFound){
            self.ignoreTableUpdateOnSelect = YES;
            self.selectedRow = [NSIndexPath indexPathForRow:-1 inSection:-1];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            [self.tableView reloadData];
            self.ignoreTableUpdateOnSelect = NO;
        }
    }
    self.searchResult = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBExpandableTableViewCell *cell = nil;
    if([self.type isEqualToString:SERVICETYPE_COUPONS]){
        MBCouponTableViewCell* couponCell = [tableView dequeueReusableCellWithIdentifier:@"CouponCell" forIndexPath:indexPath];
        MBNews* news = [self.subItems objectAtIndex:indexPath.row];
        couponCell.newsItem = news;
        cell = couponCell;
    } else {
        MBServiceCell* serviceCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [serviceCell setItem:[self.subItems objectAtIndex:indexPath.row] andCategory:self.item];
        serviceCell.delegate = self;
        if ([serviceCell.item isKindOfClass:[MBEinkaufsbahnhofStore class]]) {
            serviceCell.shopDetailView = [[MBShopDetailCellView alloc] initWithStore:serviceCell.item];
        } else if([serviceCell.item isKindOfClass:[RIMapPoi class]]){
            serviceCell.shopDetailView = [[MBShopDetailCellView alloc] initWithPXR:serviceCell.item];
        } else if([serviceCell.item isKindOfClass:[MBService class]]) {
                serviceCell.staticServiceView = [[MBStaticServiceView alloc] initWithService:serviceCell.item fullscreenLayout:NO andFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                serviceCell.staticServiceView.delegate = self;
        }
        cell = serviceCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.expanded = self.selectedRow.row == indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath isEqual:self.selectedRow] ? 90.0 + self.additionalHeightForExpandedCell : 90.0;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.ignoreTableUpdateOnSelect){
        [self.tableView beginUpdates];
    }
    MBExpandableTableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"didSelectRowAtIndexPath %@ with selectedRow %@",indexPath,self.selectedRow);
    if (self.selectedRow && self.selectedRow.row == indexPath.row) {
        self.selectedRow = [NSIndexPath indexPathForRow:-1 inSection:-1];
        tableCell.expanded = NO;
    } else {
        self.selectedRow = indexPath;
        for (MBServiceCell *cell in [tableView visibleCells]) {
            cell.expanded = NO;
        }
        tableCell.expanded = YES;
        if([tableCell isKindOfClass:MBServiceCell.class]){
            MBServiceCell* serviceCell = (MBServiceCell*) tableCell;
            if ([serviceCell.item isKindOfClass:[MBEinkaufsbahnhofStore class]] || [serviceCell.item isKindOfClass:[RIMapPoi class]]) {
                CGFloat bottomHeight = ceil(serviceCell.shopDetailView.superview.frame.size.height + 4.0);
                CGFloat addonHeight = 0;
                if(serviceCell.contactAddonView.subviews.count > 0){
                    addonHeight = ceil(serviceCell.contactAddonView.frame.size.height + 4.0);
                }
                self.additionalHeightForExpandedCell = bottomHeight + addonHeight;
            } else if([serviceCell.item isKindOfClass:[MBService class]]) {
                if ([self.type isEqualToString:SERVICETYPE_INFO]) {
                    [[MBTutorialManager singleton] markTutorialAsObsolete:MBTutorialViewType_D1_ServiceStores_Details];
                }
                if (nil != serviceCell.staticServiceView) {
                    self.additionalHeightForExpandedCell = ceil(serviceCell.staticServiceView.superview.frame.size.height + 4.0);
                }
            }
        } else if([tableCell isKindOfClass:MBCouponTableViewCell.class]){
            MBCouponTableViewCell* couponCell = (MBCouponTableViewCell*) tableCell;
            self.additionalHeightForExpandedCell = couponCell.expandableHeight;
        }
    }
    if(!self.ignoreTableUpdateOnSelect){
        [self.tableView endUpdates];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

#pragma mark MBMapViewDelegate

-(id)mapSelectedPOI{
    if ([self.item isKindOfClass:[MBPXRShopCategory class]]) {
        if(self.selectedRow.row >= 0){
            id item = [self.subItems objectAtIndex:self.selectedRow.row];
            if([item isKindOfClass:[RIMapPoi class]]){
                return item;
            }
        } else {
            //try first one
            if(self.subItems.count > 0){
                id item = [self.subItems objectAtIndex:0];
                if([item isKindOfClass:[RIMapPoi class]]){
                    return item;
                }
            }
        }
    }
    return nil;
}

-(NSArray<NSString*>*)mapFilterPresets{
    if ([self.item isKindOfClass:[MBPXRShopCategory class]] && self.selectedRow.row >= 0 && [self mapSelectedPOI]){
        return nil;//no filter when we preselected a poi!
    }
    
    if ([self.item isKindOfClass:[MBEinkaufsbahnhofCategory class]]){
        //we have no POIs on the map, so there is no need to filter anything but we do it anyway to be consistent
        MBEinkaufsbahnhofCategory* ven = (MBEinkaufsbahnhofCategory*)self.item;
        return [RIMapPoi mapShopCategoryToFilterPresets:ven.name];
    } else if([self.item isKindOfClass:[MBPXRShopCategory class]]) {
        MBPXRShopCategory* cat = (MBPXRShopCategory*)self.item;
        return [RIMapPoi mapShopCategoryToFilterPresets:cat.title];
    } else if([self.item isKindOfClass:[MBMenuItem class]]) {
        return @[ PRESET_INFO_ONSITE ];
    } else if([self.item isKindOfClass:MBCouponCategory.class]){
        return @[ PRESET_SHOPPING ];
    }
    return nil;
}


#pragma mark MBDetailViewDelegate

- (void) didTapOnPhoneLink:(NSString *)phoneNumber
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Anrufen" message:phoneNumber preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Anrufen" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@",phoneNumber];
        phoneURLString = [phoneURLString stringByReplacingOccurrencesOfString:@"  " withString:@""];
        phoneURLString = [phoneURLString stringByReplacingOccurrencesOfString:@" " withString:@""];
        phoneURLString = [phoneURLString stringByReplacingOccurrencesOfString:@"/" withString:@""];
        phoneURLString = [phoneURLString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        [[UIApplication sharedApplication] openURL:phoneURL];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Abbrechen" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) didOpenUrl:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];

}

- (void) didTapOnEmailLink:(NSString*)mailAddress;
{
    if ([mailAddress rangeOfString:@"mailto:"].location == NSNotFound) {
        mailAddress = [NSString stringWithFormat:@"mailto:%@",mailAddress];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailAddress]];
}

@end
