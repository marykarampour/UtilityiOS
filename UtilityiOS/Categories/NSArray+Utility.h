//
//  NSArray+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-12-05.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray <ObjectType> (Utility)

+ (BOOL)isArray:(NSObject *)arr ofType:(Class)cls;

/** @brief This method is safe, any index can be passed. */
- (ObjectType)nullableObjectAtIndex:(NSInteger)index;

- (NSString *)findStringBeginWith:(NSString *)string;
+ (NSString *)findStringBeginWith:(NSString *)string inArray:(StringArr *)array;

/** @brief It returns an ordered array of values based on a given range from a dictionary where the keys are the expected indices of those values.
 @param range Range of the indices to be returned in the ordered array of values. */
+ (NSArray *)orderedArrayOfValuesFromDict:(NSDictionary<NSNumber *, ObjectType> *)dict range:(NSRange)range;

/** @brief For each element of the array, each predicate is checked in order and put inside a subarray corresponding to the predicate.
 @param exclusive If Yes the first predicate that matches is used. This makes the resulting array not share any eleents. The last element will be what is left out. */
- (NSArray<NSArray<ObjectType> *> *)filteredArraysUsingPredicates:(NSArray<NSPredicate *> *)predicates exclusive:(BOOL)exclusive;

+ (instancetype)arrayWithNullableObject:(ObjectType)obj;
- (ObjectType)objectPassingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray<ObjectType> *)objectsPassingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (ObjectType)objectIdenticalTo:(ObjectType)anObject;

/** Returns indexOfObject: if found, otherwise returns the lower bound, i.e., -1. */
- (NSInteger)lowerBoundIndexOfObject:(ObjectType)obj;

/** @brief It returns an array of values based on a given key that the objects in the original array responds to. */
+ (instancetype)arrayFromArray:(NSArray<ObjectType> *)array forKey:(NSString *)key;
+ (instancetype)arrayWithArray:(NSArray<ObjectType> *)array byAddingObject:(ObjectType)anObject;
/** @brief It returns arrays grouped based on a given key that the objects in the original array responds to. */
- (NSDictionary<NSString *, NSMutableArray<ObjectType> *> *)groupedArrayForKey:(NSString *)key;
/** @brief It returns arrays grouped based on a given key that the objects in the original array responds to. */
+ (NSDictionary<NSString *, NSMutableArray<ObjectType> *> *)groupedArrayFromArray:(NSArray<ObjectType> *)array forKey:(NSString *)key;
- (instancetype)arrayByAddingObject:(ObjectType)anObject;
- (NSString *)uniqueComponentsJoinedByString:(NSString *)separator usingSelector:(SEL)selector;

- (NSSet<ObjectType> *)set;
- (NSArray<ObjectType> *)unique;

@end


@interface NSMutableArray <ObjectType> (Utility)

/** @brief If object is nil, nothing will happen. */
- (void)addNullableObject:(ObjectType)anObject;

/** @brief If index is out of bounds, nothing will happen.
    @return NO if index is out of bounds. */
- (BOOL)boundsCheckRemoveObjectAtIndex:(NSUInteger)index;

/** @brief If object is already in the array, nothing will happen.
 @return A BOOL indicating if the object was added to the array. */
- (BOOL)addUniqueObject:(ObjectType)anObject;

/** @brief If object is already in the array, nothing will happen.
 @return Objects that failed to be added to the array. */
- (NSArray *)addUniqueObjectsFromArray:(NSArray<ObjectType> *)otherArray;

/** @brief If object is already in the array, it will be replaced by the one from otherArray.
 @return Objects that were replaced. */
- (NSArray *)addOrReplaceUniqueObjectsFromArray:(NSArray<ObjectType> *)otherArray;

/** @brief If insert fails due to index being out of bounds the item will be added. */
- (void)insertOrAddObject:(ObjectType)anObject atIndex:(NSUInteger)index;

/** @brief Thread-safe add operation. */
- (void)addSynchronizedObject:(ObjectType)anObject;

/** @brief Thread-safe remove operation. */
- (void)removeSynchronizedObject:(ObjectType)anObject;

/** @brief If object is nil, nothing will happen. Sets the first value if the array has at least one element, if empty, will add the object. */
- (void)setFirstWithNullableObject:(ObjectType)anObject;

+ (NSMutableArray *)mutableArrayWithNullableArray:(NSArray *)arr;

@end
