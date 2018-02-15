//
//  MKModel.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKModel.h"
#import "NSObject+Utility.h"
#import <objc/runtime.h>

static StringFormat MapperFormat;

@implementation MKModel

//+ (void)initialize {
//    if (!JSONMapperDict) {
//        JSONMapperDict = [self keyMapperDictionaryForClass:[self class]];//[self keyMapperDictionaryWithAncestors];
//    }
//}
//TODO: make type: JSON vs DB
//- (instancetype)initWithDB {
//    if (self = [super init]) {
//
//    }
//}

+ (void)initialize {
    MapperFormat = StringFormatUnderScoreIgnoreDigits;
}

+ (void)setMapperFormat:(StringFormat)format {
    MapperFormat = format;
}

- (instancetype)initWithStringsDictionary:(NSDictionary *)values {
    return [self initWithStringsDictionary:values mapper:[[self class] keyMapper]];
}
//overriding this only to support date formates not supporeted by JSONModel
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {
        NSArray *names = [[self class] propertyNames];
        for (NSString *name in names) {
            NSString *propertyName = [self convertToJson:name];
            
            Class class = [self classOfProperty:name forObjectClass:[self class]];
            if (class == [NSDate class]) {
                id value = dict[propertyName];
                if (value && ![value isKindOfClass:[NSNull class]]) {
                    NSDate * date = [[self dateFormatter] dateFromString:value];
                    if ([date isKindOfClass:[NSDate class]]) {
                        [self setValue:date forKey:name];
                    }
                }
            }
        }
    }
    return self;
}

- (instancetype)initWithStringsDictionary:(NSDictionary *)values mapper:(JSONKeyMapper *)mapper {
    if (self = [super init]) {
        NSArray *names = [[self class] propertyNames];
        for (NSString *name in names) {
            NSString *propertyName = [self convertToJson:name];
            
            Class class = [self classOfProperty:name forObjectClass:[self class]];
            id value = values[propertyName];
            
            if (value && ![value isKindOfClass:[NSNull class]]) {
                if (class == [NSString class]) {
                    if ([value isKindOfClass:[NSString class]] && ![(NSString *)value isEqualToString:@"<null>"]) {
                        [self setValue:value forKey:name];
                    }
                }
                else if (class == [NSNumber class]) {
                    if ([value isKindOfClass:[NSString class]]) {
                        [self setValue:[value stringToNumber] forKey:name];
                    }
                    else if ([value isKindOfClass:[NSNumber class]]) {
                        [self setValue:value forKey:name];
                    }
                }
                else {
                    [self setValue:@([value boolValue]) forKey:name];
                }
            }
        }
    }
    return self;
}

+ (NSArray *)propertyNames {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(self, &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        [names addObject:name];
    }
    free(properties);
    return names;
}

- (Class)classOfProperty:(NSString *)name forObjectClass:(Class)objectClass {
    
    Class class = nil;
    objc_property_t property = class_getProperty(objectClass, [name UTF8String]);
    NSString *attrs = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *components = [attrs componentsSeparatedByString:@","];
    //no primitives are allowed
    if (components.count > 0) {
        if ([components[0] characterAtIndex:1] == 'c' || [components[0] characterAtIndex:1] == 'B') {
            return nil;
        }
        components = [components[0] componentsSeparatedByString:@"\""];
        if (components.count < 2) {
            return nil;
        }
        class = NSClassFromString(components[1]);
    }
    return class;
}

#pragma mark - JSONModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

#pragma mark - key mapper

- (NSDictionary *)toDictionaryWithExcludedKeys {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *excluded = [[self class] excludedKeys];
    [[self toDictionary] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![excluded containsObject:key]) {
            [dict setObject:obj forKey:key];
        }
    }];
    return dict;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self JSONMapperDict]];
}

+ (DictStringString *)JSONMapperDict {
    return [self keyMapperWithFormat:MapperFormat];
}

+ (DictStringString *)DBMapperDict {
    return [self keyMapperWithFormat:StringFormatUnderScoreIgnoreDigits];
}

+ (DictStringString *)keyMapperWithFormat:(StringFormat)format {
    if ([self usingAncestors]) {
        return [self keyMapperDictionaryWithAncestorsWithFormat:format];
    }
    else {
        return [self keyMapperDictionaryForClass:self format:format];
    }
}

+ (JSONKeyMapper *)DBKeyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self DBMapperDict]];
}

+ (NSDictionary *)keyMapperDictionaryWithAncestorsWithFormat:(StringFormat)format {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    Class class = self;
    while (class != [MKModel class]) {
        [dict addEntriesFromDictionary:[self keyMapperDictionaryForClass:class format:format]];
        class = [class superclass];
    }
    return dict;
}

+ (NSDictionary *)keyMapperDictionaryForClass:(Class)class format:(StringFormat)format {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    NSDictionary *customNames = [self customKeyValueDict];
    NSArray *excluded = [[self class] excludedKeys];
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        if (![excluded containsObject:name]) {
            NSString *json_name;
            if ([customNames.allKeys containsObject:name]) {
                json_name = customNames[name];
            }
            else {
                json_name = [name format:format];
            }
            
            [dict setValue:json_name forKey:name];
        }
    }
    free(properties);
    return dict;
}

- (NSString *)convertToJson:(NSString *)property {
    return [[[self class] JSONMapperDict] objectForKey:property];
}

- (NSString *)convertToProperty:(NSString *)json {
    NSArray *keys = [[[self class] JSONMapperDict] allKeysForObject:json];
    if (keys && keys.count) {
        return keys[0];
    }
    return nil;
}

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    return formatter;
}

#pragma mark - override NSObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self MKInitWithCoder:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self MKEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self MKCopyWithZone:zone];
}

- (BOOL)isEqual:(id)object {
    return [self MKIsEqual:object];
}

- (NSUInteger)hash {
    return [self MKHash];
}

- (NSString *)titleText {
    return @"";
}

- (void)copyValues:(__kindof MKModel *)object {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([self respondsToSelector:NSSelectorFromString(name)] && [object valueForKey:name]) {
            [self setValue:[object valueForKey:name] forKey:name];
        }
    }
    free(properties);
}

- (void)setValuesOfObject:(__kindof MKModel *)object ancestors:(BOOL)ancestors {
    MStringArr *arr = [[NSMutableArray alloc] init];
    MKModel *currentObject = object;
    Class currentClass = [currentObject class];
    if (ancestors) {
        while (currentClass != [MKModel class]) {
            [arr addObjectsFromArray:[NSObject propertyNamesOfClass:currentClass]];
            currentClass = [currentClass superclass];
        }
    }
    else {
        [arr addObjectsFromArray:[NSObject propertyNamesOfClass:currentClass]];
    }
    for (NSString *name in arr) {
        id value = [object valueForKey:name];
        if ([self respondsToSelector:NSSelectorFromString(name)]) {
            [self setValue:value forKey:name];
        }
    }
}

#pragma mark - MKModelCustomKeysProtocol

+ (BOOL)usingAncestors {
    return NO;
}

+ (StringArr *)excludedKeys {
    return nil;
}

+ (StringArr *)customKeys {
    return nil;
}

+ (StringFormat)customFormat {
    return StringFormatNone;
}

+ (DictStringString *)customKeyValueDict {
    MDictStringString *dict = [[MDictStringString alloc] init];
    StringFormat format = [self customFormat];
    StringArr *keys = [self customKeys];
    for (NSString *name in keys) {
        [dict setObject:[name format:format] forKey:name];
    }
    return dict;
}

@end
