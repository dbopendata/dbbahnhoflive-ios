//
//  TransportCategory.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 29.05.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransportCategory : NSObject

@property (nonatomic, strong) NSString* transportCategoryType;
@property (nonatomic, strong) NSString* transportCategoryNumber;
@property (nonatomic, strong) NSString* transportCategoryGenericNumber;

@end
