//
//  NSError+AFNetworking.m
//  KaChing
//
//  Created by Maryam Karampour on 2020-11-30.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "NSError+AFNetworking.h"

@implementation NSError (AFNetworking)

- (NSInteger)statusCode {
    NSHTTPURLResponse *resp = self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    return resp.statusCode;
}

@end
