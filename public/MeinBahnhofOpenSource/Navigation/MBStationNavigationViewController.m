//
//  MBStationNavigationViewController.m
//  MeinBahnhof
//
//  Created by Marc O'Connor on 19.09.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import "MBStationNavigationViewController.h"

@interface MBStationNavigationViewController ()
@property (nonatomic, assign) BOOL behindViewSmall;
@property (nonatomic, assign) BOOL behindViewHuge;
@property (nonatomic, strong) UIView* contentSearchButtonShadow;//the shadow should not be visible above the image but only below, that's why we need a separate view for it

@property (nonatomic, strong) UIView *redBar;

@end

@implementation MBStationNavigationViewController

#define TAG_SEARCH_MAGNIFIER 142
#define TAG_SEARCH_TEXT 143

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.redBar = [UIView new];
    [self.redBar setBackgroundColor:[UIColor db_mainColor]];
    [self.redBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.showRedBar = NO;
    
    self.behindViewSmall = NO;
    UINavigationBar *navBar = self.navigationBar;
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    
    navBar.tintColor = [UIColor db_333333];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont db_RegularSixteen],
                                 NSForegroundColorAttributeName:[UIColor db_333333]};
    navBar.titleTextAttributes = attributes;
    navBar.barTintColor = [UIColor whiteColor];
    navBar.translucent = NO;
    
    self.behindView = [[MBStationTopView alloc] initWithFrame:CGRectZero];
    self.behindView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.behindView addSubview:self.redBar];
    NSDictionary *redbarViews = @{@"redbar":self.redBar};
    NSArray *redbarHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[redbar]|"
                                                                          options:0 metrics:nil views:redbarViews];
    NSArray *redbarVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[redbar]|"
                                                                          options:0 metrics:nil views:redbarViews];
    NSLayoutConstraint *redbarHeightConstraint = [NSLayoutConstraint constraintWithItem:self.redBar
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:2.0];
    NSMutableArray *redBarConstraints = [[NSMutableArray alloc] initWithArray:redbarHConstraints];
    [redBarConstraints addObjectsFromArray:redbarVConstraints];
    [redBarConstraints addObject:redbarHeightConstraint];
    [self.behindView addConstraints:redBarConstraints];
    
    [self.view insertSubview:self.behindView belowSubview:navBar];
    
    NSDictionary *views = @{@"behind":self.behindView};
    NSArray *navbarHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[behind]|"
                                                                          options:0 metrics:nil views:views];
    NSArray *navbarVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[behind]"
                                                                          options:0 metrics:nil views:views];
    self.behindHeightConstraint = [NSLayoutConstraint constraintWithItem:self.behindView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                            constant:STATION_NAVIGATION_PICTURE_HEIGHT];
    NSMutableArray *constraints = [[NSMutableArray alloc] initWithArray:navbarHConstraints];
    [constraints addObjectsFromArray:navbarVConstraints];
    [constraints addObject:self.behindHeightConstraint];
    
    [self.view addConstraints:constraints];
    
    //NOTE: this is set in layoutcode!
    self.contentSearchButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.contentSearchButton.hidden = YES;
    self.contentSearchButton.accessibilityLabel = @"Suche am Bahnhof";
    //[self.contentSearchButton addTarget:self action:@selector(openContentSearch) forControlEvents:UIControlEventTouchUpInside];
    self.contentSearchButton.backgroundColor = [UIColor whiteColor];
    
    self.contentSearchButtonShadow = [[UIView alloc]initWithFrame:CGRectZero];
    self.contentSearchButtonShadow.hidden = YES;
    self.contentSearchButtonShadow.isAccessibilityElement = NO;
    self.contentSearchButtonShadow.backgroundColor = [UIColor whiteColor];
    self.contentSearchButtonShadow.layer.shadowColor = [[UIColor db_dadada] CGColor];
    self.contentSearchButtonShadow.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    self.contentSearchButtonShadow.layer.shadowRadius = 2;
    self.contentSearchButtonShadow.layer.shadowOpacity = 1.0;
    [self.view insertSubview:self.contentSearchButtonShadow belowSubview:self.behindView];
    
    UIImageView* lupeImg = [[UIImageView alloc] initWithImage:[UIImage db_imageNamed:@"app_lupe"]];
    lupeImg.tag = TAG_SEARCH_MAGNIFIER;
    [self.contentSearchButton addSubview:lupeImg];
    
    UILabel* text = [[UILabel alloc] initWithFrame:CGRectZero];
    text.isAccessibilityElement = NO;
    text.tag = TAG_SEARCH_TEXT;
    text.text = STATION_SEARCH_PLACEHOLDER;
    text.font = [UIFont db_RegularFourteen];
    text.textColor = [UIColor db_787d87];
    text.alpha = 0.8;
    [text sizeToFit];
    [self.contentSearchButton addSubview:text];
    
    [self.view addSubview:self.contentSearchButton];


    
}

-(void)setShowRedBar:(BOOL)showRedBar{
    _showRedBar = showRedBar;
    [self.view setNeedsLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.contentSearchButton.frame = CGRectMake(0, 0, (int)(self.view.sizeWidth*0.872), 60);
    self.contentSearchButton.layer.cornerRadius = self.contentSearchButton.frame.size.height/2;
    
    UIView* magn = [self.contentSearchButton viewWithTag:TAG_SEARCH_MAGNIFIER];
    [magn centerViewInSuperView];
    [magn setGravityRight:30-3];
    UIView* text = [self.contentSearchButton viewWithTag:TAG_SEARCH_TEXT];
    [text centerViewInSuperView];
    [text setGravityLeft:24];
    
    [self.contentSearchButton centerViewHorizontalInSuperView];
    [self.contentSearchButton setGravityTop:self.behindView.sizeHeight- self.contentSearchButton.sizeHeight/2];
    self.contentSearchButton.alpha = self.behindView.alpha;
    if(self.behindView.alpha < 1.0){
        //fade out button quicker
        self.contentSearchButton.alpha = (self.behindView.alpha*2)-1.;
    }
    self.contentSearchButtonShadow.frame = self.contentSearchButton.frame;
    self.contentSearchButtonShadow.layer.cornerRadius = self.contentSearchButton.layer.cornerRadius;
    self.contentSearchButtonShadow.alpha = self.contentSearchButton.alpha;

    self.redBar.hidden = !self.showRedBar;
    self.behindView.hidden = self.hideEverything;
    if (self.hideEverything) {
        self.navigationBarHidden = YES;
    } else if (self.behindViewHuge) {
        self.behindView.stationId = self.station.mbId;
        self.behindView.title = self.station.title;
        [self.behindView hideSubviews:NO];
        self.navigationBarHidden = YES;
    } else {
        if(self.behindViewBackgroundColor){
            self.behindView.backgroundColor = self.behindViewBackgroundColor;
        } else {
            self.behindView.backgroundColor = [UIColor whiteColor];
        }
        [self.behindView hideSubviews:YES];
        if (nil != self.topViewController.title) {
            [self.navigationBar.topItem setTitle:self.topViewController.title];
        } else {
            [self.navigationBar.topItem setTitle:self.station.title];
        }
        self.navigationBarHidden = self.behindViewSmall;
    }
    [self.topViewController.view setNeedsLayout];
}

- (void)showBackgroundImage:(BOOL)showBackground {
    if (showBackground) {
        self.behindViewHuge = YES;
        self.contentSearchButton.hidden = NO;
        self.contentSearchButtonShadow.hidden = NO;
    } else {
        self.behindViewHuge = NO;
        self.contentSearchButton.hidden = YES;
        self.contentSearchButtonShadow.hidden = YES;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view setNeedsLayout];
}

- (void)hideNavbar:(BOOL)hidden {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat navBarHeight = self.navigationBar.frame.size.height;
    if (hidden) {
        self.behindHeightConstraint.constant = statusBarFrame.size.height;
        self.behindViewSmall = YES;
        // hide title
        self.navigationBarHidden = YES;
    } else {
        self.behindHeightConstraint.constant = navBarHeight + 2.0 + statusBarFrame.size.height;
        self.behindViewSmall = NO;
        // show title
        self.navigationBarHidden = NO;
    }
}

-(BOOL)shouldAutorotate{
    return ISIPAD ? YES : NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return ISIPAD ? (UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown) : UIInterfaceOrientationMaskPortrait;
}

@end
