//
//  GraphORM.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-30.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GraphLib.h"

@interface GraphORMTests : XCTestCase

@end

@implementation GraphORMTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGraph {
    DictStringDictStringStringArr *paramsDict = @{
                                                  @"plant" : @{
                                                          @"id" : @[
                                                                  @"10"
                                                                  ]
                                                          },
                                                  
                                                  @"defect" : @{
                                                          @"location" : @[
                                                                  @"\"EXTERIOR\""
                                                                  ],
                                                          @"severity" : @[
                                                                  @"1"
                                                                  ]
                                                          },
                                                  
                                                  @"surface" : @{
                                                          @"id" : @[
                                                                  @"47",
                                                                  @"48",
                                                                  ],
                                                          @"panel" : @[
                                                                  @"\"RIGHT_SIDE\""
                                                                  ]
                                                          },
                                                  
                                                  @"session" : @{
                                                          @"start_time" : @[
                                                                  @"1483982590",
                                                                  @"1489080190"
                                                                  ],
                                                          @"is_special" : @[
                                                                  @"0"
                                                                  ],
                                                          @"shift" : @[
                                                                  @"1",
                                                                  ]
                                                          },
                                                  
                                                  @"station" : @{
                                                          @"id" : @[
                                                                  @"4",
                                                                  ]
                                                          },
                                                  
                                                  @"unit" : @{
                                                          @"booth_num" : @[
                                                                  @"1",
                                                                  @"2",
                                                                  @"3",
                                                                  ]
                                                          },
                                                  
                                                  @"model" : @{
                                                          @"id" : @[
                                                                  @"25",
                                                                  @"26"
                                                                  ]
                                                          },
                                                  
                                                  @"defect_type" : @{
                                                            @"id" : @[
                                                                    @"790",
                                                                    @"791",
                                                                    @"792",
                                                                    ],
                                                            @"parent_id" : @[@"1", @"2"]
                                                          },
                                                  
                                                  @"colour" : @{
                                                          @"id" : @[
                                                                  @"83",
                                                                  @"84",
                                                                  @"129",
                                                                  @"130",
                                                                  @"131",
                                                                  @"132",
                                                                  @"133",
                                                                  @"134",
                                                                  @"135",
                                                                  @"136",
                                                                  @"137",
                                                                  @"141",
                                                                  @"142",
                                                                  @"143",
                                                                  @"145",
                                                                  @"144",
                                                                  @"138",
                                                                  @"139",
                                                                  @"140"
                                                                  ]
                                                          }
                                                  };
    
    GraphLib * lib = [[GraphLib alloc] init];
    NSString *query = [lib queryForParameters:paramsDict tableName:@"defect"];
//
//    QueryParamMapPTR paramsMap = [lib queryParametersMap:paramsDict];
    //works

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
