//
//  GUNetworkReachabilityManager.h
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GUNetworkReachabilityManager : NSObject
+(instancetype)sharedManager;
@property(nonatomic,assign,readonly)BOOL isInternetReachable;
@end
