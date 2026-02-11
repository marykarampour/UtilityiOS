//
//  NSDictionary+Utility.m
//  CFI HAWB Reader
//
//  Created by Maryam Karampour on 2025-12-23.
//  Copyright © 2025 Commodity Forwarders Inc. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)

- (NSDictionary *)removeNull {
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithDictionary:self];
    [map removeObjectsForKeys:[self NullKeysArray]];
    return map;
}

- (StringSet *)NullKeys {
    return [NSSet setWithArray:[self NullKeysArray]];
}

- (StringArr *)NullKeysArray {
    MStringArr *arr = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.description containsString:@"<null>"]) {
            [arr addObject:key];
        }
    }];
    return arr;
}

@end
