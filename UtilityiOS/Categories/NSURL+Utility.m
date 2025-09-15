//
//  NSURL+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2025-09-01.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSURL+Utility.h"

@implementation NSURL (Utility)

@end

@implementation NSURLComponents (Utility)

- (NSDictionary *)queryKeyValues {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSURLQueryItem *item in self.queryItems) {
        [dict setObject:item.value forKey:item.name];
    }
    return dict;
}

@end

