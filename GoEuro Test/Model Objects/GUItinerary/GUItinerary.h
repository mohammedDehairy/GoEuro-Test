//
//  GUItinerary.h
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,GUItineraryType) {
    GUItineraryTypeTrain,
    GUItineraryTypeBus,
    GUItineraryTypeFlight
};

@interface GUItinerary : NSObject
-(instancetype)initWithJsonDictionary:(NSDictionary*)dict type:(GUItineraryType)type NS_DESIGNATED_INITIALIZER;
-(instancetype)init NS_UNAVAILABLE;
@property(nonatomic,strong,readonly)NSURL *logoUrl;
@property(nonatomic,assign,readonly)CGFloat priceEuro;
@property(nonatomic,assign,readonly)NSUInteger depHour;
@property(nonatomic,assign,readonly)NSUInteger depMinute;
@property(nonatomic,assign,readonly)NSUInteger arrivalHour;
@property(nonatomic,assign,readonly)NSUInteger arrivalMinute;
@property(nonatomic,assign,readonly)NSUInteger noOfStops;
@property(nonatomic,assign,readonly)GUItineraryType type;
@end

NS_ASSUME_NONNULL_END