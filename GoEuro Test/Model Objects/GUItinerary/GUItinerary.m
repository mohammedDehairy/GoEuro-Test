//
//  GUItinerary.m
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import "GUItinerary.h"

@implementation GUItinerary
@synthesize durationFormattedString = _durationFormattedString;
@synthesize priceFormatedString = _priceFormatedString;
-(instancetype)initWithJsonDictionary:(NSDictionary *)dict type:(GUItineraryType)type{
    if((self = [super init])){
        if(![dict isKindOfClass:[NSDictionary class]]){
            return nil;
        }
        
        if([dict[@"price_in_euros"] isKindOfClass:[NSNumber class]]){
            _priceEuro = ((NSNumber*)dict[@"price_in_euros"]).floatValue;
        }
        
        
        if([dict[@"provider_logo"] isKindOfClass:[NSString class]]){
            NSMutableString *logoUrl = [NSMutableString stringWithString:dict[@"provider_logo"]];
            [logoUrl replaceOccurrencesOfString:@"{size}" withString:@"63" options:NSCaseInsensitiveSearch range:NSMakeRange(0, logoUrl.length) ];
            _logoUrl = [NSURL URLWithString:logoUrl];
        }
        
        
        if([dict[@"departure_time"] isKindOfClass:[NSString class]]){
            NSArray<NSString*> *departure = [((NSString*)dict[@"departure_time"]) componentsSeparatedByString:@":"];
            if(departure.count == 2){
                _depHour = departure.firstObject.integerValue;
                _depMinute = departure[1].integerValue;
            }
        }
        
        
        if([dict[@"arrival_time"] isKindOfClass:[NSString class]]){
            NSArray<NSString*> *arrival = [((NSString*)dict[@"arrival_time"]) componentsSeparatedByString:@":"];
            if(arrival.count == 2){
                _arrivalHour = arrival.firstObject.integerValue;
                _arrivalMinute = arrival[1].integerValue;
            }
        }
        
        if([dict[@"number_of_stops"] isKindOfClass:[NSString class]]){
            _noOfStops = ((NSString*)dict[@"number_of_stops"]).integerValue;
        }
        _type = type;
    }
    return self;
}

-(NSString*)durationFormattedString{
    if(!_durationFormattedString){
        NSUInteger depMinutes = _depHour*60+_depMinute;
        NSUInteger arrMinutes = _arrivalHour*60+_arrivalMinute;
        
        NSInteger diff = arrMinutes-depMinutes;
        
        if(diff < 0){
            diff = 24*60 - depMinutes + arrMinutes;
        }
        
        _durationFormattedString = [NSString stringWithFormat:@"%lu:%lu",diff/60,diff % 60];
    }
    
    return _durationFormattedString;
}

-(NSString*)priceFormatedString{
    if(!_priceFormatedString){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.locale = [NSLocale currentLocale];
        numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        numberFormatter.currencyCode = @"EUR";
        _priceFormatedString = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:_priceEuro]];
    }
    return _priceFormatedString;
}
@end
