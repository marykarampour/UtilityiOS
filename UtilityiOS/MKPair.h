//
//  MKPair.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKModel.h"

@interface MKPair<__covariant ObjectTypeFirst, __covariant ObjectTypeSecond> : MKModel

@property (nonatomic, strong) __kindof NSObject *first;
@property (nonatomic, strong) __kindof NSObject *second;

+ (__kindof MKPair *)first:(__kindof NSObject *)first second:(__kindof NSObject *)second;

@end

typedef MKPair<UIColor *, UIColor *> MKColorPair;
//typedef MKPair<NSString *, NSString *> MKKeyValue;

//@interface MKColorPair : MKPair<UIColor *, UIColor *>
//
//@property (nonatomic, strong) __kindof UIColor *first;
//@property (nonatomic, strong) __kindof UIColor *second;
//
//@end

@interface MKKeyValue : MKPair<NSString *, NSString *>

@property (nonatomic, strong) __kindof NSString *first;
@property (nonatomic, strong) __kindof NSString *second;

@end

typedef NSArray<MKPair *> MKPairArr;
typedef NSMutableArray<MKPair *> MMKPairArr;

typedef NSArray<MKKeyValue *> MKKeyValueArr;
typedef NSMutableArray<MKKeyValue *> MMKKeyValueArr;

@interface MKPairArray<__covariant ObjectType> : NSObject

@property (nonatomic, strong) __kindof MKPairArr *array;

- (ObjectArr *)allKeys;
- (ObjectArr *)allValues;
- (__kindof NSObject *)objectForKey:(__kindof NSObject *)key;

@end

@interface MKKeyValueArray : MKPairArray

@property (nonatomic, strong) __kindof MKKeyValueArr *array;

@end

typedef NSArray<MKKeyValueArray *> ArrMKKeyValueArray;
typedef NSMutableArray<MKKeyValueArray *> MArrMKKeyValueArray;


typedef MKPair<NSString *, StringArr *>         StringStringArrPair;
typedef MKPairArray<StringStringArrPair *>      SectionIndexPathTitle;
