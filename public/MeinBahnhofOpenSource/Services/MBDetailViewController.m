//
//  MBDetailViewController.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 25.06.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "MBDetailViewController.h"
#import "MBNavigationController.h"



#import "NSString+MBString.h"
#import "MBLabel.h"


#import "MBStationNavigationViewController.h"

@interface MBDetailViewController()

@property (nonatomic, strong) MBService *service;


@property (nonatomic, strong) MBMarker *marker;

@end

@implementation MBDetailViewController

@synthesize item = _item;

- (instancetype) initWithService:(MBService*)service
{
    if (self = [super init]) {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) setItem:(id)item
{
    _item = item;
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if ([item isKindOfClass:MBService.class]) {
        self.service = (MBService*)item;
        self.title = self.service.title;

        [self configureServiceView:self.service];

    }
}

-(NSArray<NSString *> *)mapFilterPresets{
    if([self.item isKindOfClass:[MBService class]]){
        MBService* service = self.item;
        if([service.type isEqualToString:@"stufenfreier_zugang"]){
            return @[PRESET_ELEVATORS];
        }
    }
    return nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    if(self.trackingTitle){
        [MBTrackingManager trackStatesWithStationInfo:@[@"d1", self.trackingTitle]];
    }
    
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (nil != self.navigationController) {
        if ([self.navigationController isKindOfClass:[MBStationNavigationViewController class]]) {
            [(MBStationNavigationViewController *)self.navigationController hideNavbar:NO];
            [(MBStationNavigationViewController *)self.navigationController showBackgroundImage:NO];
            [(MBStationNavigationViewController *)self.navigationController setShowRedBar:YES];
        }
    }

}

- (void) updateDistanceLabel:(CLLocation*)location
{
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma Create Views

- (void) configureServiceView:(MBService*)service
{
    MBStaticServiceView *staticServiceView = [[MBStaticServiceView alloc] initWithService:service fullscreenLayout:YES andFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    staticServiceView.delegate = self;
    
    [self.view addSubview:staticServiceView];
}





#pragma -


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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
