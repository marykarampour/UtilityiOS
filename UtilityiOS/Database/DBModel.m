//
//  DBModel.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "DBModel.h"
#import <objc/runtime.h>
#import "NSObject+Utility.h"

static DictNumString *syncStatusDict;

@implementation DBModel

//+ (StringFormat)customFormat {
//    return StringFormatCamelCase;
//}

+ (StringFormat)classMapperFormat {
    return StringFormatUnderScoreIgnoreDigits;
}

+ (BOOL)usingAncestors {
    return YES;
}

- (NSString *)SQLKeysEqualValues {
    
    NSArray<MKKeyValue *> *pairs = [self SQLKeyValuePairs];
    NSString *str = @"";
    
    for (MKKeyValue *pr in pairs) {
        NSString *format = ([pairs lastObject] == pr ? @"%@%@=%@" : @"%@%@=%@, ");
        str = [NSString stringWithFormat:format, str, pr.first, pr.second];
    }
    return str;
}

- (MKKeyValue *)SQLKeysWithValues {
    
    NSArray<MKKeyValue *> *pairs = [self SQLKeyValuePairs];
    NSString *keyStr = @"";
    NSString *valueStr = @"";
    
    for (MKKeyValue *pr in pairs) {
        NSString *format = ([pairs lastObject] == pr ? @"%@%@" : @"%@%@, ");
        keyStr = [NSString stringWithFormat:format, keyStr, pr.first];
        valueStr = [NSString stringWithFormat:format, valueStr, pr.second];
    }
    
    MKKeyValue *pair = [[MKKeyValue alloc] init];
    pair.first = keyStr;
    pair.second = valueStr;
    
    return pair;
}
//mapper not used
- (NSArray<MKKeyValue *> *)SQLKeyValuePairs {
    NSMutableArray<MKKeyValue *> *pairs = [[NSMutableArray alloc] init];
    DictStringString *attrPropertyDict = self.class.propertyClassNames;
    
    [attrPropertyDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *keyStr = @"";
        NSString *valueStr = @"";
        NSString *value;
        
        id object = [self valueForKey:key];
        if (object && [object respondsToSelector:@selector(description)]) {
            value = [object description];
            
            Class propertyClass = NSClassFromString(obj);
            if ([propertyClass isSubclassOfClass:[NSDate class]] && [value isKindOfClass:[NSString class]]) {
                value = [NSString stringWithFormat:@"%ld", (long)[[self valueForKey:key] timeIntervalSince1970]];
            }
            
            if (value.length) {
                value = [value quotations];
            }
            else {
                value = [NSString stringWithFormat:@"NULL"];
            }
            
            NSString *propertyName = [self.class convertToJson:key];
            keyStr = [NSString stringWithFormat:@"%@", propertyName];
            valueStr = [NSString stringWithFormat:@"%@", value];
            
            MKKeyValue *pair = [[MKKeyValue alloc] init];
            pair.first = keyStr;
            pair.second = valueStr;
            
            [pairs addObject:pair];
        }
    }];
    return pairs;
}

+ (NSString *)classIDName {
    return [[self.class dbPropertyName] stringByAppendingString:@"Id"];;
}

+ (StringFormat)dbColumnNameFormat {
    return StringFormatUnderScore;
}

+ (StringFormat)dbPropertyNameFormat {
    return StringFormatCamelCase;
}

+ (NSString *)dbClassNameForTable:(NSString *)table {
    return [table format:StringFormatCapitalizedCamelCase];
}

+ (NSString *)dbTableName {
    return [NSStringFromClass(self) format:StringFormatUnderScoreIgnoreDigits];
}

+ (NSString *)dbPropertyName {
    return [NSStringFromClass(self) format:StringFormatCamelCase];
}

@end

@implementation DBStaticModel


@end

@implementation DBDynamicModel

+ (void)initialize {
    if (!syncStatusDict) {
        syncStatusDict = @{
            @(SYNC_STATUS_TYPE_I):@"I",
            @(SYNC_STATUS_TYPE_N):@"N",
            @(SYNC_STATUS_TYPE_P):@"P"};
    }
}

+ (SYNC_STATUS_NAME)nameForSyncStatus:(SYNC_STATUS_TYPE)type {
    return syncStatusDict[@(type)];
}

+ (SYNC_STATUS_TYPE)typeForSyncName:(SYNC_STATUS_NAME)name {
    return [[syncStatusDict allKeysForObject:name].firstObject integerValue];
}

@end

@implementation DBStaticPrimaryModel

@dynamic Id;

- (NSString *)IDString {
    return self.Id.description;
}

@end

@implementation DBDynamicPrimaryModel

@dynamic Id;

- (instancetype)init {
    if (self = [super init]) {
        if (!self.Id) [self setID];
    }
    return self;
}

- (void)setID {
    self.Id = [NSObject GUID];
}

- (NSString *)IDString {
    return [self.Id quotations];
}

@end

@implementation DBDynamicCompositePrimaryModel

- (NSString *)IDString {
    return self.Id.description;
}

@end

@implementation DBColumn

- (id)copyWithZone:(NSZone *)zone {
    return [self MKCopyWithZone:zone];
}

+ (DBColumn *)columnWithName:(NSString *)name values:(NSArray *)values {
    DBColumn *col = [[DBColumn alloc] init];
    col.name = name;
    col.values = values;
    return col;
}

+ (NSArray <DBColumn *> *)columnsWithNames:(StringArr *)names values:(StringArr *)values {
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    
    [values enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < names.count) {
            [columns addObject:[DBColumn columnWithName:names[idx] values:@[obj]]];
        }
    }];
    return columns;
}

@end

@implementation DBIntervalColumn

- (id)copyWithZone:(NSZone *)zone {
    return [self MKCopyWithZone:zone];
}

@end
