//
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBPTSAvailabilityTimes : NSObject

-(instancetype)initWithArray:(NSArray*)availability;//new PTS

@property(nonatomic,strong) NSMutableArray<NSString*>* availabilityStrings;
-(NSString*)availabilityString;

@end
