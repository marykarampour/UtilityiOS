//
//  DBTests.m
//  DBTests
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SampleTable.h"

@interface DBTests : XCTestCase

@end

@implementation DBTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateTable {
    NSString *query = [SampleTable createTableQuery];
    NSString *querySTR = @"";
    XCTAssert([query isEqualToString:querySTR]);
}

- (void)testConvertModelJSON {
    SampleTable *table = [[SampleTable alloc] init];
    NSString * json = [[SampleTable keyMapper] convertValue:@"operationType"];
    NSString * model = [[SampleTable keyMapper] convertValue:@"operation_type"];
    [table ]
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
