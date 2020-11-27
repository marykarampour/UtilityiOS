//
//  MKModel.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKModel.h"
#import "NSObject+Utility.h"
#import "NSString+Utility.h"
#import <objc/runtime.h>

const void * _Nonnull DATE_PROPERTIES_KEY;
const void * _Nonnull PROPERTIES_KEY;
const void * _Nonnull ATTRIBUTES_KEY;
const void * _Nonnull ATTRIBUTES_CLASS_KEY;
const void * _Nonnull MAPPER_FORMAT_KEY;

@implementation MKModel

+ (StringArr *)propertyNames {
    StringArr *properties = objc_getAssociatedObject(self, &PROPERTIES_KEY);
    if (!properties) {
        properties = [self initializePropertyNames];
        objc_setAssociatedObject(self, &PROPERTIES_KEY, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return properties;
}

+ (DictStringString *)propertyAttributeNames {
    DictStringString *propertyAttributeNames = objc_getAssociatedObject(self, &ATTRIBUTES_KEY);
    if (!propertyAttributeNames) {
        propertyAttributeNames = [self initializePropertyAttributeNames];
        objc_setAssociatedObject(self, &ATTRIBUTES_KEY, propertyAttributeNames, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return propertyAttributeNames;
}

+ (DictStringString *)propertyClassNames {
    DictStringString *propertyClassNames = objc_getAssociatedObject(self, &ATTRIBUTES_CLASS_KEY);
    if (!propertyClassNames) {
        propertyClassNames = [self initializePropertyClassNames];
        objc_setAssociatedObject(self, &ATTRIBUTES_CLASS_KEY, propertyClassNames, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return propertyClassNames;
}

+ (StringArr *)dateProperties {
    StringArr *properties = objc_getAssociatedObject(self, &DATE_PROPERTIES_KEY);
    if (!properties) {
        properties = [self initializeDatePropertyNames];
        objc_setAssociatedObject(self, &DATE_PROPERTIES_KEY, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return properties;
}

+ (StringFormat)mapperFormat {
    NSNumber *mapper = objc_getAssociatedObject(self, &MAPPER_FORMAT_KEY);
    if (!mapper) {
        mapper = @([self classMapperFormat]);
        objc_setAssociatedObject(self, &MAPPER_FORMAT_KEY, mapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mapper.integerValue;
}

+ (StringFormat)classMapperFormat {
    return StringFormatNone;
}

- (instancetype)initWithStringsDictionary:(NSDictionary *)values {
    return [self initWithStringsDictionary:values mapper:[[self class] keyMapper]];
}
//overriding this only to support date formates not supporeted by JSONModel
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {

        for (NSString *name in self.class.dateProperties) {
            NSString *propertyName = [self.class convertToJson:name];
            
            id value = dict[propertyName];
            if (value && ![value isKindOfClass:[NSNull class]]) {
                NSDate * date = [[self.class dateFormatter] dateFromString:value];
                if ([date isKindOfClass:[NSDate class]]) {
                    [self setValue:date forKey:name];
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
            NSString *propertyName = [self.class convertToJson:name];
            
            Class class = [NSObject classOfProperty:name forObjectClass:[self class]];
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

+ (DictStringString *)initializePropertyAttributeNames {
    if ([self usingAncestors]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        Class class = self;
        while (class != [MKModel class]) {
            [dict addEntriesFromDictionary:[self attributePropertyNamesOfClass:class]];
            class = [class superclass];
        }
        return dict;
    }
    else {
        return [self attributePropertyNamesOfClass:self];
    }
}

+ (DictStringString *)initializePropertyClassNames {
    DictStringString *attrPropertyDict = self.class.propertyAttributeNames;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [attrPropertyDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj characterAtIndex:1] == '@') {//objects
            NSArray *components = [obj componentsSeparatedByString:@"\""];
            if (components.count > 1) {
                [dict setObject:components[1] forKey:key];
            }
        }
        else {//primitives
            NSArray *components = [obj componentsSeparatedByString:@","];
            if (components.count > 0 && ((NSString *)components[0]).length > 1) {
                [dict setObject:[NSString stringWithFormat:@"%c", [components[0] characterAtIndex:1]] forKey:key];
            }
        }
    }];
    return dict;
}

+ (StringArr *)initializePropertyNames {
    if ([self usingAncestors]) {
        MStringArr *arr = [[MStringArr alloc] init];
        Class class = self;
        while (class != [MKModel class]) {
            [arr addObjectsFromArray:[self propertyNamesOfClass:class]];
            class = [class superclass];
        }
        return arr;
    }
    else {
        return [self propertyNamesOfClass:self];
    }
}

+ (StringArr *)initializeDatePropertyNames {
    if ([self usingAncestors]) {
        MStringArr *arr = [[MStringArr alloc] init];
        Class class = self;
        while (class != [MKModel class]) {
            [arr addObjectsFromArray:[self datePropertiesForClass:class]];
            class = [class superclass];
        }
        return arr;
    }
    else {
        return [self datePropertiesForClass:self];
    }
}

+ (StringArr *)datePropertiesForClass:(Class)className {
    NSArray *names = [className propertyNames];
    MStringArr *arr = [[MStringArr alloc] init];

    for (NSString *name in names) {
        
        Class class = [className classOfProperty:name forObjectClass:[self class]];
        if (class == [NSDate class]) {
            [arr addObject:name];
        }
    }
    return arr;
}

+ (Class)classForPropertyName:(NSString *)name {
    NSDictionary *names = [self.class propertyClassNames];
    NSString *className = [names objectForKey:name];
    return NSClassFromString(className);
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

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dict = [[super toDictionary] mutableCopy];
    [dict removeObjectsForKeys:[self.class excludedKeys]];
    return dict;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self JSONMapperDict]];
}

+ (DictStringString *)JSONMapperDict {
    return [self keyMapperWithFormat:self.mapperFormat];
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

+ (NSString *)convertToJson:(NSString *)property {
    return [[self JSONMapperDict] objectForKey:property];
}

+ (NSString *)convertToProperty:(NSString *)json {
    return [[self JSONMapperDict] allKeysForObject:json].firstObject;
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    return formatter;
}

#pragma mark - override NSObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self MKInitWithCoder:aDecoder baseClass:[MKModel class]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self MKEncodeWithCoder:aCoder baseClass:[MKModel class]];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self MKCopyWithZone:zone baseClass:[MKModel class]];
}

- (BOOL)isEqual:(id)object {
    return [self MKIsEqual:object properties:self.class.propertyNames];
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


#pragma mark - search predicate

+ (NSArray<Class> *)searchPredicateClasses {
    StringArr *properties = [self searchPredicatePropertyNames];
    
    if (properties.count == 0) return @[self];

    NSMutableArray *set = [[NSMutableArray alloc] init];
    for (NSString *name in properties) {
        
        Class cls = name == NSStringFromClass(self) ? self : NSClassFromString(self.propertyClassNames[name]);
        if (cls) [set addObject:cls];
    }
    return set;
}

+ (StringArr *)searchPredicatePropertyNames {
    return nil;
}

+ (DictStringString *)searchPredicateKeyValues {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray<Class> *searchClasses = [self searchPredicateClasses];
    
    for (Class cls in searchClasses) {

        NSArray *keys = [cls searchPredicateKeys];
        
        for (NSString *key in keys) {
            NSString *name = [key copy];
            NSString *className = cls.propertyClassNames[key];
            if (className.length == 0) continue;
            
            if (self != cls) {
                name = [NSString stringWithFormat:@"%@.%@", NSStringFromClass(cls), key];
            }
            
            [dict setObject:className forKey:name];
        }
    }

    return dict;
}

+ (StringArr *)searchPredicateKeys {
    return @[];
}

#pragma mark - utility

- (NSString *)stringJSON {
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:0 error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (void)setWithObject:(__kindof MKModel *)object {
    
    if (![self isKindOfClass:[object class]]) return;
    
    for (NSString *name in self.class.propertyNames) {
        if ([self respondsToSelector:NSSelectorFromString(name)] &&
            [object respondsToSelector:NSSelectorFromString(name)]) {
            [self setValue:[object valueForKey:name] forKey:name];
        }
    }
}

+ (BOOL)propertyIsBool:(NSString *)name {
    NSString *type = [[self.class propertyClassNames] objectForKey:name];
    return ([type characterAtIndex:0] == 'c' || [type characterAtIndex:0] == 'B');
}

@end
