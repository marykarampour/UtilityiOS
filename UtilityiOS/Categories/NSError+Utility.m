//
//  NSError+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-11-30.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "NSError+Utility.h"

static NSErrorDomain const GENERIC_ERROR_DOMAIN = @"GENERIC_ERROR_DOMAIN";
static NSErrorUserInfoKey const GENERIC_ERROR_KEY = @"GENERIC_ERROR_KEY";

@implementation NSError (AFNetworking)

- (NSInteger)statusCode {
    NSHTTPURLResponse *resp = self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    return resp.statusCode;
}

@end

@implementation NSError (Utility)

- (BOOL)isInternetConnectionOffline {
    return [self.localizedDescription isEqualToString:@"The Internet connection appears to be offline."];
}

+ (NSError *)errorWithMessage:(NSString *)message {
    if (message.length == 0) return nil;
    return [NSError errorWithDomain:NSLocalizedDescriptionKey code:0 userInfo:@{NSLocalizedDescriptionKey : message}];
}

@end
