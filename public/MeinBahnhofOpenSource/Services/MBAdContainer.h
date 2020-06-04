//
//  MBAdContainer.h
//  MeinBahnhof
//
//  Created by Heiko on 17.09.19.
//  Copyright © 2019 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBAdContainerType) {
    MBAdContainerTypeEinkaufsbahnhof    = 0,
    MBAdContainerTypePickPack           = 1
};

@interface MBAdContainer : NSObject

@property(nonatomic,strong) NSString* voiceOverText;
@property(nonatomic) MBAdContainerType type;
@property(nonatomic,strong) NSString* imageName;
@property(nonatomic) BOOL isSquare;
@property(nonatomic,strong) NSURL* url;
@property(nonatomic,strong) NSArray<NSString*>* trackingAction;

@end

NS_ASSUME_NONNULL_END
