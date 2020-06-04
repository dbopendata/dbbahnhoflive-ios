//
//  MBExternalLinkButton.m
//  MeinBahnhof
//
//  Created by Heiko on 22.11.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import "MBExternalLinkButton.h"

@implementation MBExternalLinkButton

+(MBExternalLinkButton *)createButton{
    MBExternalLinkButton* btn = [[MBExternalLinkButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    btn.accessibilityLabel = @"Externer link";
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    btn.layer.shadowColor = [[UIColor db_dadada] CGColor];
    btn.layer.shadowRadius = 5;
    btn.layer.shadowOpacity = 1.0;
    btn.layer.cornerRadius = btn.frame.size.height/2;
    [btn setImage:[UIImage db_imageNamed:@"app_extern_link"] forState:UIControlStateNormal];
    return btn;
}

@end
