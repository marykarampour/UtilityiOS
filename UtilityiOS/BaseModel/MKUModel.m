//
//  MKUModel.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUModel.h"
#import "NSArray+Utility.h"
#import "NSObject+Utility.h"
#import "NSString+Utility.h"
#import <objc/runtime.h>

const void * _Nonnull DATE_PROPERTIES_KEY;
const void * _Nonnull PROPERTIES_KEY;
const void * _Nonnull ATTRIBUTES_KEY;
const void * _Nonnull ATTRIBUTES_CLASS_KEY;
const void * _Nonnull MAPPER_FORMAT_KEY;

@implementation MKUModel

+ (NSSet<NSString *> *)propertyNames {
    NSSet<NSString *> *properties = objc_getAssociatedObject(self, &PROPERTIES_KEY);
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

+ (NSSet<NSString *> *)dateProperties {
    NSSet<NSString *> *properties = objc_getAssociatedObject(self, &DATE_PROPERTIES_KEY);
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
        NSSet *names = [[self class] propertyNames];
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
        while (class != [MKUModel class]) {
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

+ (NSSet<NSString *> *)initializePropertyNames {
    MStringSet *arr = [[MStringSet alloc] init];
    Class class = self;
    Class finalClass = [self usingAncestors] ? [MKUModel class] : [self superclass];
    while (class != finalClass && class != [NSObject class]) {
        if ([self usingDynamicProperties]) {
            [arr addObjectsFromArray:[[self propertyNamesOfClass:class] allObjects]];
        }
        else {
            [arr addObjectsFromArray:[[self ivarNamesOfClass:class] allObjects]];
        }
        class = [class superclass];
    }
    return arr;
}

+ (NSSet<NSString *> *)initializeDatePropertyNames {
    if ([self usingAncestors]) {
        NSMutableSet<NSString *> *arr = [[NSMutableSet<NSString *> alloc] init];
        Class class = self;
        while (class != [MKUModel class]) {
            [arr addObjectsFromArray:[[self datePropertiesForClass:class] allObjects]];
            class = [class superclass];
        }
        return arr;
    }
    else {
        return [self datePropertiesForClass:self];
    }
}

+ (NSSet<NSString *> *)datePropertiesForClass:(Class)className {
    NSSet *names = [className propertyNames];
    NSMutableSet<NSString *> *arr = [[NSMutableSet<NSString *> alloc] init];

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

- (NSDictionary *)toDictionaryWithExcludedKeys:(StringSet *)keys {
    NSMutableDictionary *dict = [[self toDictionary] mutableCopy];
    [dict removeObjectsForKeys:[keys allObjects]];
    return dict;
}

- (NSDictionary *)toDictionary {
    return [self toDictionaryWithExcludedKeys:[[self class] excludedKeys]];
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
    while (class != [MKUModel class]) {
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
    NSSet *excluded = [[self class] excludedKeys];
    
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

#pragma mark - MKUModelCustomKeysProtocol

+ (BOOL)usingAncestors {
    return NO;
}

+ (NSSet<NSString *> *)excludedKeys {
    return nil;
}

+ (NSSet<NSString *> *)customKeys {
    return nil;
}

+ (StringFormat)customFormat {
    return StringFormatNone;
}

+ (DictStringString *)customKeyValueDict {
    MDictStringString *dict = [[MDictStringString alloc] init];
    StringFormat format = [self customFormat];
    NSSet<NSString *> *keys = [self customKeys];
    for (NSString *name in keys) {
        [dict setObject:[name format:format] forKey:name];
    }
    return dict;
}

+ (BOOL)usingDynamicProperties {
    return NO;
}

+ (StringSet *)excludedProperties {
    return nil;
}

+ (StringSet *)excludedKeysWithAncestors {
    MStringSet *arr = [[MStringSet alloc] init];
    Class class = self;
    Class finalClass = [self usingAncestors] ? [MKUModel class] : [self superclass];
    while (class != finalClass && class != [NSObject class]) {
        [arr addObjectsFromArray:[[class excludedKeys] allObjects]];
        class = [class superclass];
    }
    return arr;
}

+ (StringSet *)excludedPropertiesWithAncestors {
    MStringSet *arr = [[MStringSet alloc] init];
    Class class = self;
    Class finalClass = [self usingAncestors] ? [MKUModel class] : [self superclass];
    while (class != finalClass && class != [NSObject class]) {
        [arr addObjectsFromArray:[[class excludedProperties] allObjects]];
        class = [class superclass];
    }
    return arr;
}


#pragma mark - search predicate

+ (NSArray<Class> *)searchPredicateClasses {
    NSSet<NSString *> *properties = [self searchPredicatePropertyNames];
    
    if (properties.count == 0) return @[self];

    NSMutableArray *set = [[NSMutableArray alloc] init];
    for (NSString *name in properties) {
        
        Class cls = name == NSStringFromClass(self) ? self : NSClassFromString(self.propertyClassNames[name]);
        if (cls) [set addObject:cls];
    }
    return set;
}

+ (NSSet<NSString *> *)searchPredicatePropertyNames {
    return nil;
}

+ (DictStringString *)searchPredicateKeyValues {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray<Class> *searchClasses = [self searchPredicateClasses];
    
    for (Class cls in searchClasses) {
        NSSet *keys = [cls searchPredicateKeys];
        
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

+ (NSSet<NSString *> *)searchPredicateKeys {
    return [NSSet set];
}

#pragma mark - utility

- (NSString *)stringJSON {
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:0 error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (void)setWithObject:(__kindof MKUModel *)object {
    
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

+ (BOOL)propertyIsEnum:(NSString *)name {
    NSString *type = [[self.class propertyClassNames] objectForKey:name];
    return [type characterAtIndex:0] == 'Q';
}

- (NSString *)nameForProperty:(NSString *)property {
    return property;
}

+ (NSString *)tagName {
    return NSStringFromClass(self);
}

- (NSString *)stringValue {
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (instancetype)objectWithJSON:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *map = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        return [[self alloc] initWithStringsDictionary:map];
    }
    return nil;
}

#pragma mark - Helpers

+ (NSDictionary *)propertyAttributes {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    Class class = self;
    Class finalClass = [self usingAncestors] ? [MKUModel class] : [self superclass];
    while (class != finalClass && class != [NSObject class]) {
        if ([self usingDynamicProperties]) {
            [dict addEntriesFromDictionary:[self propertyAttributesOfClass:class]];
        }
        else {
            [dict addEntriesFromDictionary:[self ivarAttributesOfClass:class]];
        }
        class = [class superclass];
    }
    return dict;
}

- (BOOL)propertyExists:(NSString *)key {
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", [[key substringToIndex:1] capitalizedString], [key substringFromIndex:1]];
    
    if ([self respondsToSelector:NSSelectorFromString(setter)]) {
        return YES;
    }
    return NO;
}

- (BOOL)propertyIsBool:(NSString *)propertyName {
    id value = [self valueForKey:propertyName];
    NSString *attribute = [[self class] propertyAttributes][propertyName];
    
    return (value && ([attribute characterAtIndex:1] == 'B' || [attribute characterAtIndex:1] == 'c') && ([value isEqualToNumber:@0] || [value isEqualToNumber:@1]));
}

- (BOOL)datePropertyIsUTC:(NSString *)propertyName {
    return NO;
}

- (NSDictionary *)varNamesWithSingleLenght:(NSUInteger)lenght {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *str = [@" " multipliedStringOfLenght:lenght];
        str = [str stringByReplacingCharactersInRange:NSMakeRange(0, name.length) withString:name];
        [dict setValue:[self valueForKey:name] forKey:str];
    }
    return dict;
}

#pragma mark - utility

- (NSString *)titleText {
    return @"";
}

- (void)copyValues:(__kindof MKUModel *)object {
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

- (void)setValuesOfObject:(__kindof MKUModel *)object ancestors:(BOOL)ancestors {
    NSMutableSet<NSString *> *arr = [[NSMutableSet alloc] init];
    MKUModel *currentObject = object;
    Class currentClass = [currentObject class];
    if (ancestors) {
        while (currentClass != [MKUModel class]) {
            [arr addObjectsFromArray:[[NSObject propertyNamesOfClass:currentClass] allObjects]];
            currentClass = [currentClass superclass];
        }
    }
    else {
        [arr addObjectsFromArray:[[NSObject propertyNamesOfClass:currentClass] allObjects]];
    }
    for (NSString *name in arr) {
        id value = [object valueForKey:name];
        if ([self respondsToSelector:NSSelectorFromString(name)]) {
            [self setValue:value forKey:name];
        }
    }
}

#pragma mark - override NSObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if ([self.class usingAncestors])
            [self MKUInitWithCoder:aDecoder properties:[self.class propertyNames]];
        [self MKUInitWithCoder:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if ([self.class usingAncestors])
        [self MKUEncodeWithCoder:aCoder properties:[self.class propertyNames]];
    [self MKUEncodeWithCoder:aCoder];
}

- (id)copyWithZone:(NSZone *)zone {
    if ([self.class usingAncestors])
        return [self MKUCopyWithZone:zone properties:[self.class propertyNames]];
    return [self MKUCopyWithZone:zone];
}

- (BOOL)isEqual:(id)object {
    
    StringSet *propertyNames = [self.class propertyNames];
    MStringSet *arr = [NSMutableSet setWithSet:propertyNames];
    StringSet *excluded = [self.class excludedPropertiesWithAncestors];
    
    for (NSString *name in excluded) {
        [arr removeObject:name];
    }
    return [self MKUIsEqual:object properties:arr];
}

- (NSUInteger)hash {
    return [self MKUHashWithProperties:[self.class propertyNames]];
}

@end


@implementation MKUOption

- (instancetype)initWithTitle:(NSString *)title name:(NSString *)name value:(NSInteger)value {
    if (self = [super init]) {
        self.title = title;
        self.name = name;
        self.value = value;
    }
    return self;
}

+ (instancetype)optionWithTitle:(NSString *)title name:(NSString *)name value:(NSInteger)value {
    return [[MKUOption alloc] initWithTitle:title name:name value:value];
}

+ (instancetype)optionWithTitle:(NSString *)title value:(NSInteger)value {
    return [[MKUOption alloc] initWithTitle:title name:title value:value];
}

+ (NSArray *)namesForOptions:(NSArray<MKUOption *> *)options {
    return [NSArray arrayFromArray:options forKey:NSStringFromSelector(@selector(name))];
}

+ (NSArray *)titlesForOptions:(NSArray<MKUOption *> *)options {
    return [NSArray arrayFromArray:options forKey:NSStringFromSelector(@selector(title))];
}

+ (MKUOption *)optionForNameOrTitle:(NSString *)text options:(NSArray<MKUOption *> *)options {
    return [options objectPassingTest:^BOOL(MKUOption *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.name isEqualToString:text] || [obj.title isEqualToString:text])
            return obj;
        return nil;
    }];
}

+ (MKUOption *)optionForName:(NSString *)name options:(NSArray<MKUOption *> *)options {
    return [options objectPassingTest:^BOOL(MKUOption *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.name isEqualToString:name])
            return obj;
        return nil;
    }];
}

+ (MKUOption *)optionForTitle:(NSString *)title options:(NSArray<MKUOption *> *)options {
    return [options objectPassingTest:^BOOL(MKUOption *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.title isEqualToString:title])
            return obj;
        return nil;
    }];
}

+ (MKUOption *)optionForType:(NSInteger)type options:(NSArray<MKUOption *> *)options {
    return [options objectPassingTest:^BOOL(MKUOption *obj, NSUInteger idx, BOOL *stop) {
        if (obj.value == type)
            return obj;
        return nil;
    }];
}

@end
