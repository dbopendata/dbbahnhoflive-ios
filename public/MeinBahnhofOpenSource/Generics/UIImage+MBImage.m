//
//  UIImage+MBImage.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 15.10.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

#import "UIImage+MBImage.h"

@implementation UIImage (MBImage)


+(UIImage *)db_imageNamed:(NSString *)name{
    UIImage* res = [UIImage imageNamed:name];
    if(!res){
        //missing asset, fallback
        NSLog(@"missing image: %@",name);
        return [UIImage imageNamed:@"notavailable"];
    }
    return res;
}


@end
