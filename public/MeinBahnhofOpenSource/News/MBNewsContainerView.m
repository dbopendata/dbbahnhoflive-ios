//
//  MBNewsContainerView.m
//  MeinBahnhof
//
//  Created by Heiko on 20.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBNewsContainerView.h"
#import "MBExternalLinkButton.h"

#import "MBRootContainerViewController.h"
#import "MBNewsOverlayViewController.h"
#import "MBContentSearchResult.h"
#import "MBNewsContainerViewController.h"

@interface MBNewsContainerView()

@property(nonatomic,strong) UIButton* touchAreaButton;
@property(nonatomic,strong) UIView* headerLabelContainer;
@property(nonatomic,strong) UILabel* staticHeaderlabel;
@property(nonatomic,strong) UIView* line;
@property(nonatomic,strong) UIImageView* icon;
@property(nonatomic,strong) UILabel* titleLabel;
@property(nonatomic,strong) UILabel* contentLabel;
@end

@implementation MBNewsContainerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [[UIColor db_dadada] CGColor];
        self.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOpacity = 1.0;
        
        self.headerLabelContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        self.headerLabelContainer.clipsToBounds = YES;
        [self addSubview:self.headerLabelContainer];
        self.staticHeaderlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
        self.staticHeaderlabel.textAlignment = NSTextAlignmentLeft;
        self.staticHeaderlabel.text = @"+++ Aktuelle Informationen ";
        self.staticHeaderlabel.font = [UIFont db_BoldSixteen];
        self.staticHeaderlabel.textColor = [UIColor db_333333];
        [self.headerLabelContainer addSubview:self.staticHeaderlabel];
        [self.staticHeaderlabel sizeToFit];
        
        NSInteger sizeOfBlock = self.staticHeaderlabel.sizeWidth;
        NSString* txt = [self.staticHeaderlabel.text copy];
        BOOL endlessAnimation = NO;
        if(endlessAnimation){
            for(NSInteger i=0; i<3; i++){
                self.staticHeaderlabel.text = [self.staticHeaderlabel.text stringByAppendingString:txt];
            }
        } else {
            self.staticHeaderlabel.text = [self.staticHeaderlabel.text stringByAppendingString:@"+++"];
            [self.staticHeaderlabel setGravityLeft:34];
        }
        [self.staticHeaderlabel sizeToFit];
        [self.staticHeaderlabel setHeight:44];

        //the +++ are displayed in red color
        NSMutableAttributedString* attrText = [[NSMutableAttributedString alloc] initWithString:self.staticHeaderlabel.text attributes:@{NSForegroundColorAttributeName:[UIColor db_333333]}];
        NSDictionary* hightlightAttr = @{NSForegroundColorAttributeName:[UIColor db_mainColor]};
        NSRange searchrange = NSMakeRange(0, self.staticHeaderlabel.text.length-1);
        while(true){
            NSRange plusRange = [self.staticHeaderlabel.text rangeOfString:@"+++" options:0 range:searchrange];
            if(plusRange.location != NSNotFound){
                [attrText setAttributes:hightlightAttr range:plusRange];
                searchrange = NSMakeRange(plusRange.location+3, self.staticHeaderlabel.text.length-(plusRange.location+3));
                if(searchrange.location >= self.staticHeaderlabel.text.length){
                    break;
                }
            } else {
                break;
            }
        }
        self.staticHeaderlabel.attributedText = attrText;
        
        if(endlessAnimation){
            [UIView animateWithDuration:6 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear animations:^{
                [self.staticHeaderlabel setGravityLeft:-sizeOfBlock];
            } completion:nil];
        }

        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.frame.size.width, 1)];
        self.line.backgroundColor = [UIColor db_light_lineColor];
        [self addSubview:self.line];
        
        self.icon = [[UIImageView alloc] initWithImage:[UIImage db_imageNamed:@"news_coupon"]];
        [self addSubview:self.icon];
        
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:title];
        title.numberOfLines = 2;
        title.font = [UIFont db_BoldFourteen];
        title.textColor = [UIColor db_333333];
        self.titleLabel = title;
        
        
        UILabel* content = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:content];
        content.numberOfLines = 3;
        content.font = [UIFont db_RegularFourteen];
        content.textColor = [UIColor db_333333];
        self.contentLabel = content;


        self.contentLabel.isAccessibilityElement = NO;
        self.staticHeaderlabel.isAccessibilityElement = NO;
        self.titleLabel.isAccessibilityElement = NO;

        self.touchAreaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.sizeWidth, self.sizeHeight)];
        [self.touchAreaButton addTarget:self action:@selector(touchAreaButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.touchAreaButton];
        
    }
    return self;
}

-(void)linkButtonPressed:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.news.link]];
}
-(void)touchAreaButtonPressed:(id)sender{
    if(self.news.newsType == MBNewsTypeOffer && self.containerVC.station.hasShops){
        [MBTrackingManager trackActionsWithStationInfo:@[@"h1",@"tap",@"coupon"]];
        MBContentSearchResult* res = [MBContentSearchResult searchResultWithCoupon:self.news];
        MBRootContainerViewController* root = [MBRootContainerViewController currentlyVisibleInstance];
        [root handleSearchResult:res];
    } else {
        [MBTrackingManager trackActionsWithStationInfo:@[@"h1",@"tap",@"newsbox"]];
        [MBTrackingManager trackActionsWithStationInfo:@[@"h1",@"tap",@"newstype",[NSString stringWithFormat:@"%lu",(unsigned long)self.news.newsType]]];
        
        MBNewsOverlayViewController* vc = [[MBNewsOverlayViewController alloc] init];
        vc.news = self.news;
        [MBRootContainerViewController presentViewControllerAsOverlay:vc];
    }
}

-(void)setNews:(MBNews *)news{
    _news = news;
    self.titleLabel.text = news.title;
    if(news.subtitle.length > 0){
        self.contentLabel.text = news.subtitle;
    } else {
        self.contentLabel.text = news.content;
    }
    NSString* iconName = nil;
    switch (news.newsType) {
        case MBNewsTypePoll:
            iconName = @"news_survey";
            break;
        case MBNewsTypeOffer:
            iconName = @"news_coupon";
            break;
        case MBNewsTypeDisruption:
            iconName = @"news_malfunction";
            break;
        case MBNewsTypeProductsServices:
            iconName = @"news_neuambahnhof";
            break;
        case MBNewsTypeUndefined:
            break;
    }
    if(iconName){
        self.icon.image = [UIImage db_imageNamed:iconName];
        CGRect f = self.icon.frame;
        f.size = self.icon.image.size;
        self.icon.frame = f;
    } else {
        self.icon.image = nil;
    }
    //update layout: resize and position text labels
    
    [self.icon setGravityLeft:15];
    [self.icon setGravityTop:CGRectGetMaxY(self.line.frame)+(self.size.height-20-CGRectGetMaxY(self.line.frame))/2-self.icon.frame.size.height/2];

    NSInteger x = CGRectGetMaxX(self.icon.frame)+15;
    NSInteger contentWidth = self.frame.size.width-20-x;
    self.titleLabel.frame = CGRectMake(x, CGRectGetMaxY(self.line.frame)+10, contentWidth, self.sizeHeight);
    NSInteger maxHeight = self.sizeHeight-60-20;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.sizeWidth, maxHeight)];
    [self.titleLabel setSize:CGSizeMake(ceilf(size.width), ceilf(size.height))];
    
    NSInteger y = CGRectGetMaxY(self.titleLabel.frame)+5;
    maxHeight = self.sizeHeight-y-20;
    self.contentLabel.frame = CGRectMake(x, y, contentWidth, self.sizeHeight);
    size = [self.contentLabel sizeThatFits:CGSizeMake(self.contentLabel.sizeWidth, maxHeight)];
    [self.contentLabel setSize:CGSizeMake(ceilf(size.width), MIN(maxHeight,ceilf(size.height)))];

    self.touchAreaButton.accessibilityLabel = [NSString stringWithFormat:@"Aktuelle Informationen. %@. Zur Anzeige von Details doppeltippen",self.news.title];

}

@end
