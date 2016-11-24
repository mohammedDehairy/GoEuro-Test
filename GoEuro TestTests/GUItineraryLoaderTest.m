//
//  GUItineraryLoaderTest.m
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GUItineraryLoader.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface GUItineraryLoaderTest : XCTestCase

@end

@implementation GUItineraryLoaderTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadingFromRemoteServer {

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * request){
        return [request.URL.host isEqualToString:@"https://api.myjson.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test Train data" ofType:@"json"];
        return [OHHTTPStubsResponse responseWithFileAtPath:path statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    XCTestExpectation *loadingExpectation = [self expectationWithDescription:@"loading"];
    
    [GUItineraryLoader loadItinerariesWithType:GUItineraryTypeTrain completionBlock:^(NSArray<GUItinerary*>* result,NSError *error){
        if(error){
            XCTFail(@"%@",@"unexpected error when loading data");
        }else{
            XCTAssertEqual(result.count, 20);
            for(GUItinerary *itinerary in result){
                XCTAssertNotEqual(itinerary.priceEuro, 0);
                XCTAssertNotEqual(itinerary.arrivalMinute, 0);
                XCTAssertNotEqual(itinerary.arrivalHour, 0);
                XCTAssertNotEqual(itinerary.depHour, 0);
                XCTAssertNotEqual(itinerary.depMinute, 0);
                XCTAssertNotEqual(itinerary.logoUrl, nil);
            }
        }
        [loadingExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error){
    }];
    
}

- (void)testLoadingOffline{
    
    // Load online first to cache the response*********************************************************
    
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * request){
        return [request.URL.host isEqualToString:@"https://api.myjson.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test Train data" ofType:@"json"];
        return [OHHTTPStubsResponse responseWithFileAtPath:path statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
    XCTestExpectation *loadingExpectation = [self expectationWithDescription:@"loading"];
    
    [GUItineraryLoader loadItinerariesWithType:GUItineraryTypeTrain completionBlock:^(NSArray<GUItinerary*>* result,NSError *error){
        if(error){
            XCTFail(@"%@",@"unexpected error when loading data");
        }
        [loadingExpectation fulfill];
    }];
    
    
    // Load cach when offline*********************************************************
    
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * request){
        return [request.URL.host isEqualToString:@"https://api.myjson.com"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request){
        NSError *noConnectionError = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
        return [OHHTTPStubsResponse responseWithError:noConnectionError];
    }];
    XCTestExpectation *loadingOfflineExpectation = [self expectationWithDescription:@"loadingOffline"];
    
    [GUItineraryLoader loadItinerariesWithType:GUItineraryTypeTrain completionBlock:^(NSArray<GUItinerary*>* result,NSError *error){
        if(error){
            XCTFail(@"%@",@"unexpected error when loading data");
        }else{
            XCTAssertEqual(result.count, 20);
            for(GUItinerary *itinerary in result){
                XCTAssertNotEqual(itinerary.priceEuro, 0);
                XCTAssertNotEqual(itinerary.arrivalMinute, 0);
                XCTAssertNotEqual(itinerary.arrivalHour, 0);
                XCTAssertNotEqual(itinerary.depHour, 0);
                XCTAssertNotEqual(itinerary.depMinute, 0);
                XCTAssertNotEqual(itinerary.logoUrl, nil);
            }
        }
        [loadingOfflineExpectation fulfill];
    }];

    
    [self waitForExpectationsWithTimeout:20 handler:^(NSError *error){
    }];
}

@end
