//
//  Constants.m
//  Open Source Version!
//
#import "Constants.h"
#import "UIColor+DBColor.h"

@implementation Constants

+(void)setup{
    
}

+(NSString*)kBusinesshubKey{
    return @"TOL1jxXeqIW72s7vKPCcUuPNqFJTvPQx";
}
+(NSString*)kNewsApiKey{
    return @"";
}
+(NSString*)kBusinessHubProdBaseUrl{
    return @"https://gateway.businesshub.deutschebahn.com";
}
+(NSString*)kPTSPath{
    return @"public-transport-stations/v1";
}

+(NSString*)kHafasKey{
    return @"";
}
+(NSString*)kMapsKey{
    return @"";
}

+(UIColor*)dbMainColor{
    return [UIColor dbColorWithRGB:0xED7200];
}

@end
