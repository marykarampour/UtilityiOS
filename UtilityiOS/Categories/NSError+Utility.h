//
//  NSError+Utility.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-11-30.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NSError (AFNetworking)

- (NSInteger)statusCode;

@end


@interface NSError (Utility)

- (BOOL)isInternetConnectionOffline;
+ (NSError *)errorWithMessage:(NSString *)message;

@end
