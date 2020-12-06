//
//  NSArray+Utility.m
//  KaChing
//
//  Created by Maryam Karampour on 2020-12-05.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "NSArray+Utility.h"

@implementation NSArray (Utility)

+ (BOOL)isArray:(NSObject *)arr ofType:(Class)cls {
    if (![arr isKindOfClass:[NSArray class]]) return NO;
    NSArray *obj = (NSArray *)arr;
    if (obj.count == 0) return YES;
    if ([obj.firstObject isKindOfClass:cls]) return YES;
    return NO;
}

- (id)nullableObjectAtIndex:(NSUInteger)index {
    return ((index < self.count && ![self[index] isKindOfClass:[NSNull class]]) ? self[index] : nil);
}

@end
