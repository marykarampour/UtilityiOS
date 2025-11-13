//
//  MKUModel.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUModel.h"
#import "NSNumber+Utility.h"
#import "NSObject+Utility.h"
#import "NSString+Utility.h"
#import "NSArray+Utility.h"
#import "NSString+Server.h"
#import "NSDate+Utility.h"
#import <objc/runtime.h>

const void * DATE_PROPERTIES_KEY;
const void * PROPERTIES_KEY;
const void * ATTRIBUTES_KEY;
const void * ATTRIBUTES_CLASS_KEY;
const void * MAPPER_FORMAT_KEY;

@interface MKUModel ()

- (NSDictionary *)XMLSerialize;
/** @brief Each element of the resulting array will be a one item dictionary with class name as a tag. */
+ (NSArray *)XMLSerializeArray:(NSArray<MKUModel *> *)items;
/** @param tags If YES it adds self class name as a tag, each element of the resulting array will be a one item dictionary. */
+ (NSArray *)XMLSerializeArray:(NSArray<NSDictionary *> *)items withTags:(BOOL)tags;
+ (NSArray<__kindof MKUModel *> *)XMLDeserializeArray:(NSArray<NSDictionary *> *)items;

@end

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

+ (MKU_STRING_FORMAT)mapperFormat {
    NSNumber *mapper = objc_getAssociatedObject(self, &MAPPER_FORMAT_KEY);
    if (!mapper) {
        mapper = @([self classMapperFormat]);
        objc_setAssociatedObject(self, &MAPPER_FORMAT_KEY, mapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return mapper.integerValue;
}

+ (MKU_STRING_FORMAT)classMapperFormat {
    return MKU_STRING_FORMAT_NONE;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    return [self initWithDictionary:dict error:nil];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict useXML:(BOOL)XML {
    return [self initWithDictionary:dict error:nil useXML:XML];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    return [self initWithDictionary:dict error:err useXML:NO];
}

//overriding this only to support date formates not supporeted by JSONModel
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err useXML:(BOOL)XML {
    if (XML) {
        self = [super init];
        [self XMLDeserialize:dict];
        return self;
    }
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
    NSMutableDictionary *dict = [[super toDictionary] mutableCopy];
    [dict removeObjectsForKeys:[keys allObjects]];
    return dict;
}

- (NSDictionary *)toDictionary {
    return [self toDictionaryWithXML:NO];
}

- (NSDictionary *)toDictionaryWithXML:(BOOL)XML {
    NSSet *set = [[self class] excludedKeys];
    if (XML)
        return [self XMLSerializeIgnoringKeys:set];
    return [self toDictionaryWithExcludedKeys:set];
}

+ (NSArray *)toDictionaryWithArray:(NSArray<MKUModel *> *)items useXML:(BOOL)XML {
    return [self toDictionaryWithArray:items withTags:YES useXML:XML];
}

+ (NSArray *)toDictionaryWithArray:(NSArray<MKUModel *> *)items withTags:(BOOL)tags useXML:(BOOL)XML {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (MKUModel *object in items) {
        if ([object isKindOfClass:[MKUModel class]]) {
            NSDictionary *dict = XML ? [object XMLSerialize] : [object toDictionary];
            if (tags)
                [arr addObject:@{[[object class] tagName] : dict}];
            else
                [arr addObject:object];
        }
        else {
            [arr addObject:object];
        }
    }
    return arr;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self JSONMapperDict]];
}

+ (DictStringString *)JSONMapperDict {
    return [self keyMapperWithFormat:self.mapperFormat];
}

+ (DictStringString *)DBMapperDict {
    return [self keyMapperWithFormat:MKU_STRING_FORMAT_UNDERSCORE | MKU_STRING_FORMAT_IGNORE_DIGITS];
}

+ (DictStringString *)keyMapperWithFormat:(MKU_STRING_FORMAT)format {
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

+ (NSDictionary *)keyMapperDictionaryWithAncestorsWithFormat:(MKU_STRING_FORMAT)format {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    Class class = self;
    while (class != [MKUModel class]) {
        [dict addEntriesFromDictionary:[self keyMapperDictionaryForClass:class format:format]];
        class = [class superclass];
    }
    return dict;
}

+ (NSDictionary *)keyMapperDictionaryForClass:(Class)class format:(MKU_STRING_FORMAT)format {
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

- (Class)classForProperty:(NSString *)property {
    return nil;
}

+ (BOOL)usingAncestors {
    return NO;
}

+ (NSSet<NSString *> *)excludedKeys {
    return nil;
}

+ (NSSet<NSString *> *)customKeys {
    return nil;
}

+ (MKU_STRING_FORMAT)customFormat {
    return MKU_STRING_FORMAT_NONE;
}

+ (DictStringString *)customKeyValueDict {
    MDictStringString *dict = [[MDictStringString alloc] init];
    MKU_STRING_FORMAT format = [self customFormat];
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

- (DATE_FORMAT_STYLE)dateFormatForProperty:(NSString *)propertyName {
    return DATE_FORMAT_FULL_STYLE;
}

#pragma mark - search predicate

+ (NSArray<Class> *)searchPredicateClasses {
    if (![self respondsToSelector:@selector(searchPredicatePropertyNames)]) return nil;
    Class searchClass = [self class];
    
    NSSet<NSString *> *properties = [searchClass searchPredicatePropertyNames];
    
    if (properties.count == 0) return @[self];

    NSMutableArray *set = [[NSMutableArray alloc] init];
    for (NSString *name in properties) {
        
        Class cls = name == NSStringFromClass(self) ? self : NSClassFromString(self.propertyClassNames[name]);
        if (cls) [set addObject:cls];
    }
    return set;
}

+ (DictStringString *)searchPredicateKeyValues {
    if (![self respondsToSelector:@selector(searchPredicateKeys)]) return nil;
    if (![self respondsToSelector:@selector(searchPredicatePropertyNames)]) return nil;

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

+ (NSString *)stringValueForBOOL:(BOOL)value {
    return value ? @"true" : @"false";
}

+ (BOOL)boolValueForObject:(NSObject *)value {
    return [[value description] isEqualToString:@"true"] ? YES : NO;
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
    NSData *data = [self dataValue];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData *)dataValue {
    return [self dataValueUseXML:NO];
}

- (NSData *)dataValueUseXML:(BOOL)XML {
    NSDictionary *dict = XML ? [self XMLSerialize] : [self toDictionary];
    return [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
}

+ (instancetype)objectWithJSON:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        return [[self alloc] initWithDictionary:dict];
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

#pragma mark Serializer

- (NSDictionary *)XMLSerialize {
    return [self XMLSerializeIgnoringKeys:[self.class excludedKeysWithAncestors]];
}

- (id)XMLSerialize:(NSString *)key withAttribute:(NSString *)attribute {
    id serialized = nil;
    id value = [self valueForKey:key];
    
    if ([value isKindOfClass:[MKUModel class]]) {
        id superDictionary = [value XMLSerialize];
        if (superDictionary) {
            serialized = superDictionary;
        }
    }
    else if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:[value count]];
        for (id object in value) {
            if ([object isKindOfClass:[MKUModel class]]) {
                MKUModel *ser = (MKUModel *)object;
                NSDictionary *dict = [object XMLSerialize];
                if (dict) [arr addObject:@{[[ser class] tagName] : dict}];
            }
            else {
                [arr addObject:object];
            }
        }
        serialized = [arr count] > 0 ? arr : nil;
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *key in value) {
            id object = value[key];
            
            if ([object isKindOfClass:[MKUModel class]]) {
                dict[key] = [object XMLSerialize];
            }
            else {
                dict[key] = object;
            }
        }
        serialized = [dict count] > 0 ? dict : nil;
    }
    else if ([value isKindOfClass:[NSDate class]]) {
        BOOL isUTC = [self datePropertyIsUTC:key];
        serialized = [((NSDate *)value) dateStringWithFormat:[self dateFormatForProperty:key] isUTC:isUTC];
    }
    else if (value && ([attribute characterAtIndex:1] == 'B' || [attribute characterAtIndex:1] == 'c') && ([value isEqualToNumber:@0] || [value isEqualToNumber:@1])) {
        serialized = [self.class stringValueForBOOL:[value boolValue]];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        serialized = [value stringValue];
    }
    else if (value) {
        serialized = value;
    }
    
    return serialized;
}

- (NSDictionary *)XMLSerializeIgnoringKeys:(NSSet *)excludedKeys {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *data = [[[self class] propertyAttributes] mutableCopy];
    [data removeObjectsForKeys:[excludedKeys allObjects]];
    
    for (NSString *key in [data allKeys]) {
        if ([self propertyExists:key]) {
            id value = [self XMLSerialize:key withAttribute:data[key]];
            if (value) {
                [dict setObject:value forKey:[self nameForProperty:key]];
            }
        }
    }
    
    return [dict count] > 0 ? dict : nil;
}

#pragma mark Deserializer

- (void)XMLDeserialize:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) return;
    
    NSDictionary *data = [[self class] propertyAttributes];

    for (NSString *key in [data allKeys]) {
        [self XMLDeserialize:key withAttribute:data[key] withValue:dictionary[[self nameForProperty:key]]];
    }
}

- (void)XMLDeserialize:(NSString *)key withAttribute:(NSString *)attribute withValue:(id)value {
    NSParameterAssert(key != nil);
    
    id old_value = [self valueForKey:key];
    if (old_value == value) {
        return;
    }
    
    [self willChangeValueForKey:key];
    
    if ([attribute characterAtIndex:1] == '@') {
        NSArray *components = [attribute componentsSeparatedByString:@"\""];
        if ([components count] > 1) {
            
            id deserialized = nil;
            NSString *className = [components[1] componentsSeparatedByString:@"<"].firstObject;//To remove protocols
            Class propertyClass = NSClassFromString(className);
            Class cls = [self classForProperty:key];

            if ([value isKindOfClass:[NSArray class]]) {
                deserialized = value;
                if ([cls isSubclassOfClass:[MKUModel class]]) {
                    NSMutableArray *map = [NSMutableArray arrayWithArray:value];
                    
                    for (NSUInteger i = 0; i < [map count]; ++i) {
                        map[i] = [(MKUModel *)[cls alloc] initWithDictionary:map[i] useXML:YES];
                    }
                    deserialized = map;
                }
                else if ([cls isSubclassOfClass:[NSString class]]) {
                    deserialized = [NSObject deserializeStringResult:value];
                }
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                if ([value count] > 0) {
                    if ([propertyClass isSubclassOfClass:[MKUModel class]]) {
                        deserialized = [(MKUModel *) [propertyClass alloc] initWithDictionary:value useXML:YES];
                    }
                    else {
                        deserialized = value;
                        NSMutableDictionary *classMap = [NSMutableDictionary dictionaryWithDictionary:value];
                        NSArray *keys = [classMap allKeys];
                        id object;
                        
                        for (NSString *key in keys) {
                            if ([classMap[key] isKindOfClass:[NSArray class]]) {
                                NSMutableArray *map = [NSMutableArray arrayWithArray:classMap[key]];
                                
                                if ([cls isSubclassOfClass:[MKUModel class]]) {
                                    for (NSUInteger i = 0; i < [map count]; ++i) {
                                        if ([cls isSubclassOfClass:[MKUModel class]]) {
                                            map[i] = [(MKUModel *)[cls alloc] initWithDictionary:map[i] useXML:YES];
                                        }
                                    }
                                    object = (id)map;
                                }
                                else if (classMap.count == 1) {
                                    object = [NSObject deserializeObjectResult:value objectClass:cls key:keys.firstObject];
                                }
                            }
                            else {
                                if ([cls isSubclassOfClass:[MKUModel class]]) {
                                    object = (id)@[[(MKUModel *) [cls alloc] initWithDictionary:classMap[key] useXML:YES]];
                                }
                                else if (classMap.count == 1) {
                                    object = (id)@[classMap.allValues.firstObject];
                                }
                                else {
                                    object = (id)@[classMap];
                                }
                                
                                BOOL isMutable = [propertyClass isSubclassOfClass:[NSMutableArray class]];
                                if (isMutable)
                                    object = [object mutableCopy];
                            }
                        }
                        deserialized = object;
                    }
                }
            }
            else if ([propertyClass isSubclassOfClass:[NSDate class]] && [value isKindOfClass:[NSNumber class]]) {
                deserialized = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
            }
            else if ([propertyClass isSubclassOfClass:[NSDate class]] && [value isKindOfClass:[NSString class]]) {
                BOOL isUTC = [self datePropertyIsUTC:key];
                deserialized = [value dateWithAnyFormatIsUTC:isUTC];
            }
            else if ([propertyClass isSubclassOfClass:[NSNumber class]]) {
                if ([value isEqualToString:@"true"] || [value isEqualToString:@"false"]) {
                    [self setValue:@([MKUModel boolValueForObject:value]) forKey:key];
                }
                else if ([value isKindOfClass:[NSString class]]) {
                    deserialized = [value stringToNumber];
                }
            }
            else if ([propertyClass isSubclassOfClass:[NSData class]] && [value isKindOfClass:[NSString class]]) {
                deserialized = [value dataUsingEncoding:NSUTF8StringEncoding];
            }
            else if (0 < [value description].length && [propertyClass isSubclassOfClass:[NSArray class]] && ![value isKindOfClass:[NSArray class]]) {
                
                BOOL isMutable = [propertyClass isSubclassOfClass:[NSMutableArray class]];
                if ([cls isSubclassOfClass:[MKUModel class]]) {
                    NSObject *obj = [(MKUModel *)[cls alloc] initWithDictionary:value useXML:YES];
                    deserialized = isMutable ? [@[obj] mutableCopy] : @[obj];
                }
                else {
                    deserialized = isMutable ? [@[value] mutableCopy] : @[value];
                }
            }
            else {
                deserialized = value;
            }
            
            if ([deserialized isKindOfClass:propertyClass]) {
                [self setValue:deserialized forKey:key];
            }
            else if (deserialized && ![deserialized isKindOfClass:[NSNull class]]) {
                DEBUGLOG(@"Cannot Set Property of Type: %@ With A Value of Type: %@", className, NSStringFromClass([value class]));
            }
        }
    }
    else if ([attribute characterAtIndex:1] != '{') {
        if ([value isKindOfClass:[NSNumber class]]) {
            [self setValue:value forKey:key];
        }
        else {
            if (([attribute characterAtIndex:1] == 'B' || [attribute characterAtIndex:1] == 'c') && ([value isEqualToString:@"true"] || [value isEqualToString:@"false"])) {
                [self setValue:@([MKUModel boolValueForObject:value]) forKey:key];
            }
            else if ([value integerValue]) {
                [self setValue:@([value integerValue]) forKey:key];
            }
        }
    }
    
    [self didChangeValueForKey:key];
}

+ (NSArray<MKUModel *> *)XMLDeserializeArray:(NSArray<NSDictionary *> *)items {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in items) {
        MKUModel *object = [[self alloc] initWithDictionary:dict useXML:YES];
        [arr addObject:object];
    }
    return arr;
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
    return [[self alloc] initWithTitle:title name:name value:value];
}

+ (instancetype)optionWithTitle:(NSString *)title value:(NSInteger)value {
    return [[self alloc] initWithTitle:title name:title value:value];
}

+ (NSArray *)namesForOptions:(NSArray<MKUOption *> *)options {
    return [NSArray arrayFromArray:options forKey:NSStringFromSelector(@selector(name))];
}

+ (NSArray *)titlesForOptions:(NSArray<MKUOption *> *)options {
    return [NSArray arrayFromArray:options forKey:NSStringFromSelector(@selector(title))];
}

+ (NSArray *)namesForOptions:(NSArray<MKUOption *> *)options range:(NSRange)range {
    return [self namesForOptions:[self optionsForOptions:options range:range]];
}

+ (NSArray *)titlesForOptions:(NSArray<MKUOption *> *)options range:(NSRange)range {
    return [self titlesForOptions:[self optionsForOptions:options range:range]];
}

+ (NSArray<MKUOption *> *)optionsForOptions:(NSArray<MKUOption *> *)options range:(NSRange)range {
    return [options filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(MKUOption * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return NSLocationInRange(evaluatedObject.value, range);
    }]];
}

+ (NSArray<MKUOption *> *)optionsForOptions:(NSArray<MKUOption *> *)options values:(NSArray<NSNumber *> *)values {
    return [options filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(MKUOption * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [values indexOfObjectPassingTest:^BOOL(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return evaluatedObject.value & obj.integerValue;
        }] != NSNotFound;
    }]];
}

+ (NSArray<MKUOption *> *)optionsForOptions:(NSArray<MKUOption *> *)options value:(NSInteger)value {
    return [options filteredArrayUsingPredicate:[self predicateWithValue:@(value) field:NSStringFromSelector(@selector(value))]];
}

+ (NSArray<MKUOption *> *)optionsForOptions:(NSArray<MKUOption *> *)options name:(NSString *)name {
    return [options filteredArrayUsingPredicate:[self predicateWithValue:name field:NSStringFromSelector(@selector(name))]];
}

+ (NSArray<MKUOption *> *)optionsForOptions:(NSArray<MKUOption *> *)options title:(NSString *)title {
    return [options filteredArrayUsingPredicate:[self predicateWithValue:title field:NSStringFromSelector(@selector(title))]];
}

+ (NSPredicate *)predicateWithValue:(NSObject *)value field:(NSString *)field {
    return [NSPredicate predicateWithBlock:^BOOL(MKUOption * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [[evaluatedObject valueForKey:field] isEqual:value];
    }];
}

+ (instancetype)optionForNameOrTitle:(NSString *)text options:(NSArray<MKUOption *> *)options {
    return [options objectPassingTest:^BOOL(MKUOption *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.name isEqualToString:text] || [obj.title isEqualToString:text])
            return obj;
        return nil;
    }];
}

+ (instancetype)optionForName:(NSString *)name options:(NSArray<MKUOption *> *)options {
    return [options objectPassingTest:^BOOL(MKUOption *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.name isEqualToString:name])
            return obj;
        return nil;
    }];
}

+ (instancetype)optionForTitle:(NSString *)title options:(NSArray<MKUOption *> *)options {
    return [options objectPassingTest:^BOOL(MKUOption *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.title isEqualToString:title])
            return obj;
        return nil;
    }];
}

+ (instancetype)optionForType:(NSInteger)type options:(NSArray<MKUOption *> *)options {
    return [options objectPassingTest:^BOOL(MKUOption *obj, NSUInteger idx, BOOL *stop) {
        if (obj.value == type)
            return obj;
        return nil;
    }];
}

- (NSComparisonResult)compare:(MKUOption *)option {
    return [@(self.value) compare:@(option.value)];
}

@end

@implementation MKUBool

- (NSString *)description {
    if (self.falseState && self.trueState) return nil;
    if (!self.falseState && !self.trueState) return nil;
    if (self.trueState) return @"true";
    return @"false";
}

- (void)setFalse {
    self.falseState = YES;
    self.trueState = NO;
}

- (void)setTrue {
    self.falseState = NO;
    self.trueState = YES;
}

- (void)setState:(BOOL)state {
    if (state)
        [self setTrue];
    else
        [self setFalse];
}

@end


@implementation JSONValueTransformer (MKUModel)

- (id)NSDataFromNSString:(NSString*)string {
    return [[NSData alloc] initWithBase64EncodedString:string options:0];
}

- (NSString *)JSONObjectFromNSData:(NSData *)data {
    return [data base64EncodedStringWithOptions:0];
}

@end
