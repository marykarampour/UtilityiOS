//
//  MKPair.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKModel.h"

//MKPair
@protocol MKPair;

@interface MKPair <__covariant ObjectTypeFirst, __covariant ObjectTypeSecond> : MKModel

@property (nonatomic, strong) __kindof NSObject *first;
@property (nonatomic, strong) __kindof NSObject *second;

+ (__kindof MKPair *)first:(__kindof NSObject *)first second:(__kindof NSObject *)second;

@end

//MKKeyValue
@protocol MKKeyValue;

@interface MKKeyValue : MKPair <NSString *, NSString *>

@property (nonatomic, strong) __kindof NSString *first;
@property (nonatomic, strong) __kindof NSString *second;

+ (__kindof NSObject *)objectForKey:(__kindof NSObject *)key inArray:(NSArray<MKKeyValue *> *)array;
+ (__kindof NSArray *)keysForObject:(__kindof NSObject *)object inArray:(NSArray<MKKeyValue *> *)array;

@end

//MKPairArray
@protocol MKPairArray;

@interface MKPairArray<__covariant ObjectTypeFirst, __covariant ObjectTypeSecond> : MKModel
/** @brief array of key values
 @note add <MKPair> to subclass for serialization */
@property (nonatomic, strong) NSArray<__kindof MKPair <ObjectTypeFirst, ObjectTypeSecond> *> *array;

- (instancetype)initWithArray:(NSArray<__kindof MKPair <ObjectTypeFirst, ObjectTypeSecond> *> *)array;

- (NSArray<__kindof NSObject *> *)allKeys;
- (NSArray<__kindof NSObject *> *)allValues;
- (__kindof ObjectTypeSecond)objectForKey:(__kindof NSObject *)key;
- (__kindof MKPair <ObjectTypeFirst, ObjectTypeSecond> *)pairForKey:(__kindof NSObject *)key;
- (NSUInteger)indexOfPairForKey:(__kindof NSObject *)key;
- (void)addPair:(__kindof MKPair <ObjectTypeFirst, ObjectTypeSecond> *)pair;
- (void)insertPair:(__kindof MKPair *)pair atIndex:(NSUInteger)index;
/** @brief Inserts the pair if index is equal to count of array, otherwise replaces it */
- (void)setPair:(__kindof MKPair *)pair atIndex:(NSUInteger)index;

+ (NSObject *)objectForKey:(__kindof NSObject *)key inArray:(NSArray <__kindof MKPair <ObjectTypeFirst, ObjectTypeSecond> *> *)arr;
+ (NSObject *)keyForObject:(__kindof NSObject *)object inArray:(NSArray <__kindof MKPair <ObjectTypeFirst, ObjectTypeSecond> *> *)arr;
+ (NSArray<__kindof NSObject *> *)allKeysInArray:(NSArray<__kindof MKPair <ObjectTypeFirst, ObjectTypeSecond> *> *)arr;
+ (NSArray<__kindof NSObject *> *)allValuesInArray:(NSArray<__kindof MKPair <ObjectTypeFirst, ObjectTypeSecond> *> *)arr;

@end

//MKKeyValueArray
@protocol MKKeyValueArray;

@interface MKKeyValueArray : MKPairArray
/** @brief array of key values
 @note add <MKKeyValue, MKPair> to subclass for serialization */
@property (nonatomic, strong) __kindof NSArray<MKKeyValue *> *array;

@end

typedef NSArray<MKKeyValueArray *>        ArrMKKeyValueArray;
typedef NSMutableArray<MKKeyValueArray *> MArrMKKeyValueArray;
typedef MKPair<NSString *, StringArr *>   StringStringArrPair;
