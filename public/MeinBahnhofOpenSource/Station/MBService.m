//
//  MBService.m
//  MeinBahnhof
//
//  Created by Thomas Kuster on 03.07.15.
//  Copyright (c) 2015 ScholzVolkmer. All rights reserved.
//

#import "MBService.h"


// Pattern to detect phone numbers in a text which also may be surrounded by anchor-tags or white spaces
#define kPhoneRegexPattern @"(>|\\s)[\\d]{3,}\\/?([^\\D]|\\s)+[\\d]"
#define kHTMLPTagParser @"<p>.*</p>"

#define kTagCloseBraceChar @">"
#define kTagSlashChar @"/"

@implementation MBService

- (UIImage*) iconForType
{
    
    UIImage *icon = [UIImage db_imageNamed:[self iconImageNameForType]];
    if (!icon) {
        icon = [UIImage db_imageNamed:@""];
    }
    return icon;
}

- (NSString *)iconImageNameForType {
    NSDictionary *mappingTypes = @{
                                   @"mobilitaetsservice": @"app_mobilitaetservice",
                                   @"stufenfreier_zugang": @"IconBarrierFree",
                                   @"3-s-zentrale": @"app_3s",
                                   @"bahnhofsmission": @"rimap_bahnhofsmission_grau",
                                   @"fundservice": @"app_fundservice",
                                   @"db_information": @"app_information",
                                   @"wlan": @"rimap_wlan_grau",
                                   @"local_travelcenter": @"rimap_reisezentrum_grau",
                                   @"local_db_lounge": @"app_db_lounge",
                                   @"local_lostfound": @"app_fundservice",
                                   @"chatbot": @"chatbot_icon",
                                   @"pickpack": @"pickpack",
                                   @"mobiler_service": @"app_mobiler_service",
                                   @"parkplaetze": @"rimap_parkplatz_grau",
                                   
                                   };
    
    NSString *name = [mappingTypes objectForKey:self.type];
    name = nil == name ? @"" : name;
    return name;
}

- (NSArray*) parseDreiSComponents:(NSString*)string
{
    NSError *error;
    // Special case for 3S content detail:
    // Parse the text enclosed by <p></p> everything after that will be interpreted as phone number
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kHTMLPTagParser options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    NSString *descriptionText = [string substringWithRange:[match rangeAtIndex:0]];
    NSString *phoneNumber = [string stringByReplacingOccurrencesOfString:descriptionText withString:@""];
    
    return @[descriptionText, @{kPhoneKey: phoneNumber}];
}

- (NSArray*) descriptionTextComponents
{
    NSString *string = self.descriptionText;
    
    // strip additional new lines to improve linebreaks and word wrapping
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (string.length == 0) {
        return @[];
    }
    
    // check if we need special content handling
    if ([self.type isEqualToString:@"3-s-zentrale"]) {
        return [self parseDreiSComponents:string];
    } else if ([self.type isEqualToString:@"chatbot"]) {
        return [self parseChatbotComponents:string];
    } else if ([self.type isEqualToString:@"pickpack"]) {
        return [self parsePickpackComponents:string];
    } else {
        return [self parseRegularComponents:string];
    }
}

- (NSArray*)parsePickpackComponents:(NSString*)string{
    //we expect a text and add one or two buttons
    NSMutableArray* res = [NSMutableArray arrayWithCapacity:3];
    [res addObject:string];
    [res addObject:@{kActionButtonKey:@"Webseite", kActionButtonAction:kActionPickpackWebsite}];
    [res addObject:@{kActionButtonKey:@"pickpack App", kActionButtonAction:kActionPickpackApp}];
    return res;
}

- (NSArray*)parseChatbotComponents:(NSString*)string{
    //we expect a text, a button and another text
    //the button is only visible at the opening times of the chatbot service
    NSRange btnStart = [string rangeOfString:@"<dbactionbutton>"];
    NSRange btnEnd = [string rangeOfString:@"</dbactionbutton>"];
    if(btnStart.location != NSNotFound){
        NSString* firstText = [string substringToIndex:btnStart.location];
        NSString* btntext = [string substringWithRange:NSMakeRange(btnStart.location+btnStart.length, btnEnd.location-(btnStart.location+btnStart.length))];
        NSString* lastText = [string substringFromIndex:btnEnd.location+btnEnd.length];
        NSMutableArray* res = [NSMutableArray arrayWithCapacity:3];
        [res addObject:@{kImageKey:@"chatbot_d1"}];
        [res addObject:firstText];
        if([self isChatBotTime]){
            [res addObject:@{kActionButtonKey:btntext, kActionButtonAction:kActionChatbot}];
        }
        [res addObject:lastText];
        return res;
    }
    //failure, return complete string
    return @[string];
}

-(BOOL)isChatBotTime{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setLocale:[NSLocale localeWithLocaleIdentifier:@"de_DE"]];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];
    
    NSDateComponents *comps = [gregorian components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
    NSInteger currentHour = [comps hour];
    return currentHour >= 7 && currentHour <= 19;
}

- (NSArray*)parseRegularComponents:(NSString*)string
{
    // parse the phone number and create an array which keeps the components
    NSString *phoneNumber = [self parsePhoneNumber];
    NSArray *components = @[string];
    
    // the resulting array, in case a phone number was found
    if (phoneNumber && phoneNumber.length > 0) {
        NSMutableArray *arrComponents = [[string componentsSeparatedByString:phoneNumber] mutableCopy];
        [arrComponents insertObject:@{kPhoneKey: phoneNumber} atIndex:1];
        components = arrComponents;
    }
    
    return components;
}

- (NSString*) parsePhoneNumber
{
    NSString *string = self.descriptionText;
    
    NSError *error = nil;
    // search the descriptionText for a phone number
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kPhoneRegexPattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    NSString *phoneNumber = [string substringWithRange:[match rangeAtIndex:0]];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:kTagCloseBraceChar withString:@""];
    
    return phoneNumber;
}

-(void)fillTableWithOpenTimes:(NSString *)openTimes{
    
    openTimes = [openTimes stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    
    self.table = @{ @"headlines":@[@"Öffnungszeiten"],
                       @"rows":@[ @{@"rowItems": @[ @{
                                                        @"key": @"Öffnungszeiten",
                                                        @"headline": @"Öffnungszeiten",
                                                        @"content": openTimes
                                                        }] }  ],
                       };
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title": @"title",
             @"descriptionText": @"descriptionText",
             @"additionalText": @"additionalText",
             @"type": @"type",
             @"position": @"position",
             @"table": @"table" 
             };
}

@end
