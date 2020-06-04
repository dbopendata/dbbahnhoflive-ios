//
//  FahrzeugAusstattung.h
//  MeinBahnhof
//
//  Created by Heiko on 31.08.17.
//  Copyright © 2017 ScholzVolkmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FahrzeugAusstattung : NSObject

//new api
@property(nonatomic,strong) NSString* anzahl;
@property(nonatomic,strong) NSString* ausstattungsart;
@property(nonatomic,strong) NSString* bezeichnung;
@property(nonatomic,strong) NSString* status;


//old api
@property(nonatomic,strong) NSString* symbol;

-(NSString*)displayText;
-(NSArray*)iconNames;
-(BOOL)displayEntry;
-(BOOL)isOldAPI;

@end
