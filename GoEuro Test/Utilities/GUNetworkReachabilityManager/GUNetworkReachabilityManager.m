//
//  GUNetworkReachabilityManager.m
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import "GUNetworkReachabilityManager.h"
#import "Reachability.h"

@implementation GUNetworkReachabilityManager
+(instancetype)sharedManager{
    static GUNetworkReachabilityManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
-(BOOL)isInternetReachable{
    return [[self reachability] currentReachabilityStatus] != NotReachable;
}
-(Reachability*)reachability{
    return [Reachability reachabilityForInternetConnection];
}
@end
