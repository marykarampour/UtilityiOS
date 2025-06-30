//
//  MKUPair.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUModel.h"

//MKUPair
@protocol MKUPair;

@interface MKUPair <__covariant FirstObjectType : __kindof NSObject *, __covariant SecondObjectType : __kindof NSObject *> : MKUModel

@property (nonatomic, strong) FirstObjectType first;
@property (nonatomic, strong) SecondObjectType second;

+ (instancetype)pairWithFirst:(FirstObjectType)first second:(SecondObjectType)second;

+ (NSArray<FirstObjectType> *)firstObjects:(NSArray <MKUPair <FirstObjectType, NSObject *> *> *)pairs;
+ (NSArray<SecondObjectType> *)secondObjects:(NSArray <MKUPair <NSObject *, SecondObjectType> *> *)pairs;

@end

//MKUKeyValue
@protocol MKUKeyValue;

@interface MKUKeyValue : MKUPair <NSString *, NSString *>

@property (nonatomic, strong) __kindof NSString *first;
@property (nonatomic, strong) __kindof NSString *second;

+ (__kindof NSObject *)objectForKey:(__kindof NSObject *)key inArray:(NSArray<MKUKeyValue *> *)array;
+ (__kindof NSArray *)keysForObject:(__kindof NSObject *)object inArray:(NSArray<MKUKeyValue *> *)array;

@end

//MKUPairArray
@protocol MKUPairArray;

@interface MKUPairArray<__covariant ObjectTypeFirst : __kindof NSObject *, __covariant ObjectTypeSecond : __kindof NSObject *> : MKUModel
/** @brief array of key values
 @note add <MKUPair> to subclass for serialization */
@property (nonatomic, strong) NSArray<__kindof MKUPair <ObjectTypeFirst, ObjectTypeSecond> *> *array;

- (instancetype)initWithArray:(NSArray<__kindof MKUPair <ObjectTypeFirst, ObjectTypeSecond> *> *)array;

- (NSArray<__kindof NSObject *> *)allKeys;
- (NSArray<__kindof NSObject *> *)allValues;
- (__kindof ObjectTypeSecond)objectForKey:(__kindof NSObject *)key;
- (__kindof MKUPair <ObjectTypeFirst, ObjectTypeSecond> *)pairForKey:(__kindof NSObject *)key;
- (NSUInteger)indexOfPairForKey:(__kindof NSObject *)key;
- (void)addPair:(__kindof MKUPair <ObjectTypeFirst, ObjectTypeSecond> *)pair;
- (void)insertPair:(__kindof MKUPair *)pair atIndex:(NSUInteger)index;
/** @brief Inserts the pair if index is equal to count of array, otherwise replaces it */
- (void)setPair:(__kindof MKUPair *)pair atIndex:(NSUInteger)index;

+ (NSObject *)objectForKey:(__kindof NSObject *)key inArray:(NSArray <__kindof MKUPair <ObjectTypeFirst, ObjectTypeSecond> *> *)arr;
+ (NSObject *)keyForObject:(__kindof NSObject *)object inArray:(NSArray <__kindof MKUPair <ObjectTypeFirst, ObjectTypeSecond> *> *)arr;
+ (NSArray<__kindof NSObject *> *)allKeysInArray:(NSArray<__kindof MKUPair <ObjectTypeFirst, ObjectTypeSecond> *> *)arr;
+ (NSArray<__kindof NSObject *> *)allValuesInArray:(NSArray<__kindof MKUPair <ObjectTypeFirst, ObjectTypeSecond> *> *)arr;

@end

//MKUKeyValueArray
@protocol MKUKeyValueArray;

@interface MKUKeyValueArray : MKUPairArray
/** @brief array of key values
 @note add <MKUKeyValue, MKUPair> to subclass for serialization */
@property (nonatomic, strong) __kindof NSArray<MKUKeyValue *> *array;

@end

typedef NSArray<MKUKeyValueArray *>        ArrMKKeyValueArray;
typedef NSMutableArray<MKUKeyValueArray *> MArrMKKeyValueArray;
typedef MKUPair<NSString *, StringArr *>   StringStringArrPair;
