//
//  Copyright © 2018 ScholzVolkmer. All rights reserved.
//

#import "MBPTSRequestManager.h"
#import "MBCacheManager.h"
#import "Constants.h"
@interface MBPTSRequestManager()

@end

@implementation MBPTSRequestManager

+ (MBPTSRequestManager*)sharedInstance
{
    static MBPTSRequestManager *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:[Constants kBusinessHubProdBaseUrl]];
        sharedClient = [[self alloc] initWithBaseURL:baseUrl];
        
    });
    return sharedClient;
}

-(NSURLSessionTask *)requestStationData:(NSNumber *)stationId forcedByUser:(BOOL)forcedByUser success:(void (^)(MBPTSStationResponse *response))success failureBlock:(void (^)(NSError *))failure{
    
    MBCacheResponseType type = MBCacheResponsePTS;
    MBCacheState cacheState = [[MBCacheManager sharedManager] cacheStateForStationId:stationId type:type];
    if(forcedByUser && cacheState == MBCacheStateValid){
        cacheState = MBCacheStateOutdated;
    }
    if(cacheState == MBCacheStateValid){
        NSDictionary* cachedResponse = [[MBCacheManager sharedManager] cachedResponseForStationId:stationId type:type];
        if(cachedResponse){
            NSLog(@"using PTS data from cache!");
            MBPTSStationResponse* response = [[MBPTSStationResponse alloc] initWithResponse:cachedResponse];
            success(response);
            return nil;
        }
    }
    
    NSString* endPoint = [NSString stringWithFormat:@"%@/%@/stop-places/%@",[Constants kBusinessHubProdBaseUrl],[Constants kPTSPath], stationId];
    NSLog(@"endPoint %@",endPoint);
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:[Constants kBusinesshubKey] forHTTPHeaderField:@"key"];
    
    return [self GET:endPoint parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionTask *operation, id responseObject) {
        
        MBPTSStationResponse* response = [[MBPTSStationResponse alloc] initWithResponse:responseObject];
        if(response.isValid){
            [[MBCacheManager sharedManager] storeResponse:responseObject forStationId:stationId type:type];
            success(response);
        } else {
            failure(nil);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        //NSData* data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        //NSLog(@"data: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if(cacheState == MBCacheStateOutdated){
            NSDictionary* cachedResponse = [[MBCacheManager sharedManager] cachedResponseForStationId:stationId type:type];
            if(cachedResponse){
                NSLog(@"using outdated PTS data from cache!");
                MBPTSStationResponse* response = [[MBPTSStationResponse alloc] initWithResponse:cachedResponse];
                success(response);
                return;
            }
        }
        
        failure(error);
    }];
}


-(NSURLSessionTask *)searchStationByName:(NSString *)text success:(void (^)(NSArray<MBPTSStationFromSearch*>* stationList))success failureBlock:(void (^)(NSError *))failure{
    NSString* searchTerm = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
    NSInteger size = 250;
    NSString* requestUrlWithParams = [NSString stringWithFormat:@"%@/%@/stop-places?size=%ld&name=%@",[Constants kBusinessHubProdBaseUrl], [Constants kPTSPath],(long)size,searchTerm];

    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:[Constants kBusinesshubKey] forHTTPHeaderField:@"key"];
    
    return [self GET:requestUrlWithParams parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionTask *operation, id responseObject) {
        if([responseObject isKindOfClass:NSDictionary.class]){
            success([self parseResponse:responseObject]);
        } else {
            failure(nil);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"search failed: %@",error.localizedDescription);
        failure(error);
    }];
}

-(NSURLSessionTask *)searchStationByGeo:(CLLocationCoordinate2D)geo success:(void (^)(NSArray<MBPTSStationFromSearch*>* stationList))success failureBlock:(void (^)(NSError *))failure{
    NSInteger size = 58;
    NSString* requestUrlWithParams = [NSString stringWithFormat:@"%@/%@/stop-places?latitude=%.3f&longitude=%.3f&radius=2000&size=%ld",
                            [Constants kBusinessHubProdBaseUrl],
                            [Constants kPTSPath],
                            geo.latitude,
                            geo.longitude,
                            (long)size];

    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:[Constants kBusinesshubKey] forHTTPHeaderField:@"key"];
    
    return [self GET:requestUrlWithParams parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionTask *operation, id responseObject) {
        if([responseObject isKindOfClass:NSDictionary.class]){
            success([self parseResponse:responseObject]);
        } else {
            failure(nil);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}

-(NSArray<MBPTSStationFromSearch*>*)parseResponse:(NSDictionary*)response{
    NSArray* results = nil;
    if([response isKindOfClass:NSDictionary.class]){
        NSDictionary* emb = response[@"_embedded"];
        if(emb){
            results = emb[@"stopPlaceList"];
        }
    }
    if(results){
        NSMutableArray<MBPTSStationFromSearch*>* resultsTransformed = [NSMutableArray arrayWithCapacity:results.count];
        for(NSDictionary* res in results){
            NSNumber* stationNumber = nil;
            NSString* evaId = nil;
            NSArray* identifiers = res[@"identifiers"];
            for(NSDictionary* identifier in identifiers){
                if([identifier[@"type"] isEqualToString:@"STADA"]){
                    NSString* stadaString = identifier[@"value"];
                    stationNumber = [NSNumber numberWithLongLong:stadaString.longLongValue];
                } else if([identifier[@"type"] isEqualToString:@"EVA"]){
                    evaId = identifier[@"value"];
                }
            }
            NSString* title = res[@"name"];
            NSNumber* longitude = nil;
            NSNumber* latitude = nil;
            NSDictionary* location = res[@"location"];
            longitude = location[@"longitude"];
            latitude = location[@"latitude"];
            
            if(stationNumber && title && evaId && longitude && latitude){
                MBPTSStationFromSearch* res = [MBPTSStationFromSearch new];
                res.stationId = stationNumber;
                res.title = title;
                res.eva_ids = @[evaId];
                res.coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
                res.distanceInKm = @0;
                [resultsTransformed addObject:res];
            } else {
                //NSLog(@"missing data, ignored: %@",title);
            }
        }
        return resultsTransformed;
    }
    return nil;
}


@end
