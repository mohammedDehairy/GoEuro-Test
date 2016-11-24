//
//  GUItineraryLoader.h
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GUItinerary.h"

typedef void (^GUItineraryLoaderCompletionBlock)(NSArray<GUItinerary*>* result,NSError *error);

@interface GUItineraryLoader : NSObject
+(void)loadItinerariesWithType:(GUItineraryType)type completionBlock:(GUItineraryLoaderCompletionBlock) completion;
@end
