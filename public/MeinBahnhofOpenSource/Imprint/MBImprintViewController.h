//
//  MBImprintViewController.h
//  MeinBahnhof
//
//  Created by Thomas Kuster on 17.07.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "MBUIViewController.h"
#import "MBTextView.h"

@interface MBImprintViewController : MBUIViewController

@property (nonatomic, assign) BOOL openAsModal;
@property (nonatomic, strong) NSString *url;

@end
