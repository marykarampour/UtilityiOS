//
//  MKUPair.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUPair.h"
#import "NSArray+Utility.h"

@implementation MKUPair

+ (instancetype)pairWithFirst:(__kindof NSObject *)first second:(__kindof NSObject *)second {
    MKUPair *obj = [[self alloc] init];
    obj.first = first;
    obj.second = second;
    return obj;
}

+ (NSArray *)firstObjects:(NSArray *)pairs {
    return [NSArray arrayFromArray:pairs forKey:NSStringFromSelector(@selector(first))];
}

+ (NSArray *)secondObjects:(NSArray *)pairs {
    return [NSArray arrayFromArray:pairs forKey:NSStringFromSelector(@selector(second))];
}

@end

@implementation MKUKeyValue

@dynamic first;
@dynamic second;

+ (BOOL)usingAncestors {
    return YES;
}

+ (NSObject *)objectForKey:(__kindof NSObject *)key inArray:(NSArray<MKUKeyValue *> *)array {
    for (MKUPair *obj in array) {
        if ([obj.first isEqual:key]) {
            return obj.second;
        }
    }
    return nil;
}

+ (NSArray *)keysForObject:(__kindof NSObject *)object inArray:(NSArray<MKUKeyValue *> *)array {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (MKUPair *obj in array) {
        if ([obj.second isEqual:object]) {
            if (obj.first) [arr addObject:obj.first];
        }
    }
    return arr;
}

@end


@implementation MKUPairArray

- (instancetype)init {
    return [self initWithArray:@[]];
}

- (instancetype)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        self.array = array;
    }
    return self;
}

- (ObjectArr *)allKeys {
    MObjectArr *keys = [[NSMutableArray  alloc] init];
    for (MKUKeyValue *obj in self.array) {
        if (obj.first) [keys addObject:obj.first];
    }
    return keys;
}

- (ObjectArr *)allValues {
    MObjectArr *values = [[NSMutableArray  alloc] init];
    for (MKUPair *obj in self.array) {
        if (obj.second) [values addObject:obj.second];
    }
    return values;
}

- (NSObject *)objectForKey:(__kindof NSObject *)key {
    for (MKUPair *obj in self.array) {
        if ([obj.first isEqual:key]) {
            return obj.second;
        }
    }
    return nil;
}

+ (NSObject *)objectForKey:(__kindof NSObject *)key inArray:(NSArray *)arr {
    for (MKUPair *obj in arr) {
        if ([obj.first isEqual:key]) {
            return obj.second;
        }
    }
    return nil;
}

+ (NSObject *)keyForObject:(__kindof NSObject *)object inArray:(NSArray *)arr {
    for (MKUPair *obj in arr) {
        if ([obj.second isEqual:object]) {
            return obj.first;
        }
    }
    return nil;
}

- (MKUPair *)pairForKey:(__kindof NSObject *)key {
    for (MKUPair *obj in self.array) {
        if ([obj.first isEqual:key]) {
            return obj;
        }
    }
    return nil;
}

- (NSUInteger)indexOfPairForKey:(__kindof NSObject *)key {
    MKUPair *pair = [self pairForKey:key];
    return [self.array indexOfObject:pair];
}

- (void)addPair:(__kindof MKUPair *)pair {
    NSMutableArray<MKUPair *> *arr = [self.array mutableCopy];
    if (![self.array containsObject:pair]) {
        [arr addObject:pair];
        self.array = arr;
    }
}

- (void)insertPair:(__kindof MKUPair *)pair atIndex:(NSUInteger)index {
    NSMutableArray<MKUPair *> *arr = [self.array mutableCopy];
    if (![self.array containsObject:pair] && index <= self.array.count) {
        [arr insertObject:pair atIndex:index];
        self.array = arr;
    }
}

- (void)setPair:(__kindof MKUPair *)pair atIndex:(NSUInteger)index {
    NSMutableArray<MKUPair *> *arr = [self.array mutableCopy];
    if (![self.array containsObject:pair] && index < self.array.count) {
        [arr setObject:pair atIndexedSubscript:index];
        self.array = arr;
    }
    else if (index == self.array.count) {
        [arr insertObject:pair atIndex:index];
        self.array = arr;
    }
}

+ (NSArray<NSObject *> *)allKeysInArray:(NSArray *)arr {
    MObjectArr *values = [[NSMutableArray  alloc] init];
    for (MKUPair *obj in arr) {
        if (obj.first) [values addObject:obj.first];
    }
    return values;
}

+ (NSArray<NSObject *> *)allValuesInArray:(NSArray *)arr {
    MObjectArr *values = [[NSMutableArray  alloc] init];
    for (MKUPair *obj in arr) {
        if (obj.second) [values addObject:obj.second];
    }
    return values;
}

@end


@implementation MKUKeyValueArray

@dynamic array;

@end

