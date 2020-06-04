//
//  MBStationTeaserWithImageCollectionViewCell.m
//  MeinBahnhof
//
//  Created by Heiko on 12.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBStationTeaserWithImageCollectionViewCell.h"

@interface MBStationTeaserWithImageCollectionViewCell()
@property(nonatomic,strong) UILabel* mainLabel;
@property(nonatomic,strong) UIImageView* mainImage;

@end

@implementation MBStationTeaserWithImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        
        self.mainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.mainLabel.numberOfLines = 0;
        self.mainLabel.textColor = [UIColor db_333333];
        self.mainLabel.font = [UIFont dbHeadBlackWithSize:17];
        [self.contentView addSubview:self.mainLabel];
                
        self.mainImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.mainImage];

    }
    return self;
}

-(void)setKachel:(MBStationKachel *)kachel{
    self.mainLabel.text = kachel.title;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.mainLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.mainLabel.text.length)];
    self.mainLabel.attributedText = attributedString;

    self.mainImage.image = [UIImage db_imageNamed:kachel.imageName];
    self.mainImage.frame = CGRectMake(0, 0, self.mainImage.size.width, self.mainImage.size.height);
    if(kachel.titleForVoiceOver){
        self.mainLabel.isAccessibilityElement = NO;
        self.isAccessibilityElement = YES;
        self.accessibilityLabel = kachel.titleForVoiceOver;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainImage.frame = CGRectMake(0, 0, 100,100);
    [self.mainImage centerViewHorizontalInSuperView];
    [self.mainImage setGravityBottom:10];

    NSInteger w = self.frame.size.width-2*5;
    CGSize size = [self.mainLabel sizeThatFits:CGSizeMake(w, 200)];
    self.mainLabel.frame = CGRectMake(0, 23, size.width,size.height);
    [self.mainLabel centerViewHorizontalInSuperView];
}
@end
