//
//  VenueExtraField.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 05.10.15.
//  Copyright © 2015 ScholzVolkmer. All rights reserved.
//

@interface VenueExtraField : NSObject

@property (nonatomic, copy) NSString *web;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;

- (NSString*)sanitizedPhoneNumber;

@end
