//
//  GUItineraryLoader.m
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import "GUItineraryLoader.h"
#import "GUNetworkReachabilityManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation GUItineraryLoader
+(void)loadItinerariesWithType:(GUItineraryType)type completionBlock:(GUItineraryLoaderCompletionBlock)completion{
    if([GUNetworkReachabilityManager sharedManager].isInternetReachable){
        [self fetchFromRemoteWithType:type completionBlock:completion];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *cachedData = [NSData dataWithContentsOfFile:[self cachFilePathForType:type].path];
            if(cachedData){
                NSError *parseError;
                NSArray *result = [self parseJsonData:cachedData withType:type error:&parseError];
                if(!parseError){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(result,nil);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil,parseError);
                    });
                }
            }
        });
        
    }
}

+(void)fetchFromRemoteWithType:(GUItineraryType)type completionBlock:(GUItineraryLoaderCompletionBlock)completion{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[self urlForType:type] completionHandler:^(NSData *_Nullable data,NSURLResponse * _Nullable response,NSError * _Nullable error){
        if(!error){
            NSError *parseError;
            NSArray *array = [self parseJsonData:data withType:type error:&parseError];
            
            if(!parseError){
                [self cachResponseData:data withType:type];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(array,nil);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil,parseError);
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil,error);
            });
        }
    }];
    [task resume];
}

+(NSArray<GUItinerary*>*)parseJsonData:(NSData*)data withType:(GUItineraryType)type error:(NSError**)error{
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:json.count];
    for(NSDictionary *dict in json){
        GUItinerary *itinerary = [[GUItinerary alloc] initWithJsonDictionary:dict type:type];
        if(itinerary){
            [array addObject:itinerary];
        }
    }
    return array;
}

+(void)cachResponseData:(NSData*)jsonData withType:(GUItineraryType)type{
    [jsonData writeToURL:[self cachFilePathForType:type] atomically:YES];
}

+(NSURL*)cachFilePathForType:(GUItineraryType)type{
    NSString *documentsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    switch (type) {
        case GUItineraryTypeBus:
            return [NSURL fileURLWithPath:[documentsDir stringByAppendingPathComponent:@"bus_cach"]];
        case GUItineraryTypeTrain:
            return [NSURL fileURLWithPath:[documentsDir stringByAppendingPathComponent:@"train_cach"]];
        case GUItineraryTypeFlight:
            return [NSURL fileURLWithPath:[documentsDir stringByAppendingPathComponent:@"flight_cach"]];
        default:
            return nil;
    }
}

+(NSURL*)urlForType:(GUItineraryType)type{
    switch (type) {
        case GUItineraryTypeBus:
            return [NSURL URLWithString:@"https://api.myjson.com/bins/37yzm"];
        case GUItineraryTypeTrain:
            return [NSURL URLWithString:@"https://api.myjson.com/bins/3zmcy"];
        case GUItineraryTypeFlight:
            return [NSURL URLWithString:@"https://api.myjson.com/bins/w60i"];
        default:
            return nil;
    }
}
@end

NS_ASSUME_NONNULL_END
