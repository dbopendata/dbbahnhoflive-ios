//
//  MBEinkaufsbahnhofCategory.h
//  MeinBahnhof
//
//  Created by Heiko on 19.04.18.
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBEinkaufsbahnhofCategory : NSObject

@property(nonatomic,strong) NSNumber* number;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSArray* shops;

-(NSString*)iconFilename;
-(UIImage*)icon;
+(UIImage*)menuIconForCategoryTitle:(NSString*)title;
+(NSString*)categoryNameForCatTitle:(NSString*)title;
+(MBEinkaufsbahnhofCategory*)createCategoryWithName:(NSString*)name number:(NSNumber*)number;

@end
