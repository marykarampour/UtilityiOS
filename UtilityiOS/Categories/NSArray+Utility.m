//
//  NSArray+Utility.m
//  KaChing
//
//  Created by Maryam Karampour on 2020-12-05.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "NSArray+Utility.h"

@implementation NSArray (Utility)

- (id)nullableObjectAtIndex:(NSInteger)index {
    if (index < 0) return nil;
    return ((self.count > index && ![self[index] isKindOfClass:[NSNull class]]) ? self[index] : nil);
}

+ (BOOL)isArray:(NSObject *)arr ofType:(Class)cls {
    if (![arr isKindOfClass:[NSArray class]]) return NO;
    NSArray *obj = (NSArray *)arr;
    if (obj.count == 0) return YES;
    if ([obj.firstObject isKindOfClass:cls]) return YES;
    return NO;
}

- (NSString *)findStringBeginWith:(NSString *)string {
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", string]].firstObject;
}

+ (NSString *)findStringBeginWith:(NSString *)string inArray:(StringArr *)array {
    return [array findStringBeginWith:string];
}

+ (NSArray *)orderedArrayOfValuesFromDict:(NSDictionary<NSNumber *, NSObject *> *)dict range:(NSRange)range {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSInteger i = range.location; i < range.length + range.location; i++) {
        NSObject *obj = [dict objectForKey:@(i)];
        if (obj) {
            [arr addObject:obj];
        }
    }
    return arr;
}

- (NSArray *)filteredArraysUsingPredicates:(NSArray<NSPredicate *> *)predicates exclusive:(BOOL)exclusive {
    
    NSMutableArray *arrays = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfFiltered = [[NSMutableArray alloc] initWithArray:self];
    
    for (NSPredicate *obj in predicates) {
        NSArray *arr = [arrayOfFiltered filteredArrayUsingPredicate:obj];
        if (arr) [arrays addObject:arr];
        if (exclusive) [arrayOfFiltered removeObjectsInArray:arr];
    }
    return arrays;
}

+ (NSArray *)arrayWithNullableObject:(__kindof NSObject *)obj {
    if (!obj)
        return @[];
    return @[obj];
}

- (id)objectPassingTest:(BOOL (^)(id, NSUInteger, BOOL *))predicate {
    NSInteger index = [self indexOfObjectPassingTest:predicate];
    return [self nullableObjectAtIndex:index];
}

- (NSArray *)objectsPassingTest:(BOOL (^)(id, NSUInteger, BOOL *))predicate {
    return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:predicate]];
}

- (id)objectIdenticalTo:(id)anObject {
    NSInteger index = [self indexOfObjectIdenticalTo:anObject];
    return [self nullableObjectAtIndex:index];
}

- (NSInteger)lowerBoundIndexOfObject:(id)obj {
    NSUInteger index = [self indexOfObject:obj];
    if (index == NSNotFound) return -1;
    return index;
}

+ (instancetype)arrayFromArray:(NSArray *)array forKey:(NSString *)key {
    if (array.count == 0) return nil;
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSObject *obj in array) {
        if (![obj respondsToSelector:NSSelectorFromString(key)]) continue;
        id value = [obj valueForKey:key];
        if (![arr containsObject:value]) [arr addObject:value];
    }
    return arr;
}

+ (instancetype)arrayWithArray:(NSArray *)array byAddingObject:(id)anObject {
    return [array arrayByAddingObject:anObject];
}

- (instancetype)arrayByAddingObject:(id)anObject {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self];
    [arr addObject:anObject];
    return arr;
}

- (NSString *)uniqueComponentsJoinedByString:(NSString *)separator usingSelector:(SEL)selector {
    NSMutableString *str = [[NSMutableString alloc] init];
    
    for (NSObject *obj in self) {
        if (![obj respondsToSelector:selector]) continue;
        
        NSString *desc = [[obj performSelector:selector] description];
        if ([str containsString:desc]) continue;
        
        [str appendString:desc];
    }
    return str;
}

- (NSSet *)set {
    return [NSSet setWithArray:self];
}

- (NSArray *)unique {
    return [[self set] allObjects];
}

@end


@implementation NSMutableArray (Utility)

- (void)addNullableObject:(id)anObject {
    if (!anObject) return;
    [self addObject:anObject];
}

- (void)addUniqueObject:(id)anObject {
    if ([self containsObject:anObject]) return;
    [self addObject:anObject];
}

- (void)addUniqueObjectsFromArray:(NSArray *)otherArray {
    for (id obj in otherArray) {
        [self addUniqueObject:obj];
    }
}

- (void)addSynchronizedObject:(id)anObject {
    if (!anObject) return;
    @synchronized (self) {
        [self addObject:anObject];
    }
}

- (void)removeSynchronizedObject:(id)anObject {
    if (![self containsObject:anObject]) return;
    @synchronized (self) {
        [self removeObject:anObject];
    }
}

- (void)setFirstWithNullableObject:(id)anObject {
    if (!anObject) return;
    if (0 < self.count)
        [self setObject:anObject atIndexedSubscript:0];
    else
        [self addObject:anObject];
}

+ (NSMutableArray *)mutableArrayWithNullableArray:(NSArray *)arr {
    if (!arr) return [[NSMutableArray alloc] init];
    return [arr mutableCopy];
}

@end
