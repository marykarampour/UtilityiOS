//
//  NSObject+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSObject+Utility.h"
#import "NSString+Utility.h"
#import "NSString+Number.h"
#import "NSSet+Utility.h"
#import <objc/runtime.h>

@implementation NSObject (Utility)

#pragma mark - init and set

- (instancetype)initWithObject:(NSObject *)object ancestors:(BOOL)ancestors baseClass:(Class)baseClass {
    self = [self init];
    [self setValuesOfObject:object ancestors:ancestors baseClass:baseClass];
    return self;
}

- (instancetype)initWithObject:(NSObject *)object properties:(NSSet<NSString *> *)properties {
    self = [self init];
    [self setValuesOfObject:object properties:properties];
    return self;
}

+ (instancetype)objectWithObject:(NSObject *)object ancestors:(BOOL)ancestors baseClass:(Class)baseClass {
    return [[self alloc] initWithObject:object ancestors:ancestors baseClass:baseClass];
}

- (void)resetIsDefaults:(BOOL)isDefaults {
    [self resetIsDefaults:isDefaults excludeProperties:nil];
}

- (void)resetIsDefaults:(BOOL)isDefaults excludeProperties:(NSSet<NSString *> *)excluding {
    unsigned int varCount = 0;
    Ivar *vars = class_copyIvarList([self class], &varCount);
    
    for (unsigned int i=0; i<varCount; i++) {
        
        Ivar var = vars[i];
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        NSString *name = [[NSString stringWithUTF8String:ivar_getName(var)] trimCharSet:@"_"];
        if ([excluding containsObject:name]) continue;
        
        [self setDefaultValues:type name:name isDefaults:isDefaults];
    }
    
    free(vars);
}

- (void)setDefaultValues:(NSString *)type name:(NSString *)name isDefaults:(BOOL)isDefaults {
    
    id value;
    
    if ([type isEqualToString:@"@\"NSString\""]) {
        value = isDefaults ? @"" : nil;
    }
    else if ([type isEqualToString:@"@\"NSNumber\""]) {
        value = isDefaults ? @0 : nil;
    }
    else if ([type isEqualToString:@"@\"NSData\""]) {
        value = isDefaults ? [[NSData alloc] init] : nil;
    }
    else if ([type isEqualToString:@"@\"NSDate\""]) {
        value = isDefaults ? [[NSDate alloc] init] : nil;
    }
    else if ([type isEqualToString:@"@\"NSArray\""]) {
        value = isDefaults ? @[] : nil;
    }
    else {
        //Treating all primitives which have 1 char type the same way.
        //Used to be: else if ([type isEqualToString:@"@\"c\""] || [type isEqualToString:@"B"]) {
        //Otherwise, for NSOption it would bypass all conditions and nil would not be accepted in setValue:forKey:
        value = @(NO);
    }
    
    [self setValue:value forKey:name];
}

- (void)setValuesOfObject:(NSObject *)object ancestors:(BOOL)ancestors baseClass:(Class)baseClass {
    NSMutableSet<NSString *> *arr = [[NSMutableSet alloc] init];
    NSObject *currentObject = object;
    Class currentClass = [currentObject class];
    if (ancestors) {
        while (currentClass != baseClass && currentClass != [NSObject class]) {
            [arr addObjectsFromArray:[[NSObject ivarNamesOfClass:currentClass] allObjects]];
            currentClass = [currentClass superclass];
        }
    }
    else {
        [arr addObjectsFromArray:[[NSObject ivarNamesOfClass:currentClass] allObjects]];
    }
    [self setValuesOfObject:object properties:arr];
}

- (void)setValuesOfObject:(NSObject *)object properties:(NSSet<NSString *> *)properties {
    for (NSString *name in properties) {
        if ([object respondsToSelector:NSSelectorFromString(name)] &&
            [self respondsToSelector:NSSelectorFromString(name)] &&
            ![self isReadOnlyProperty:name]) {
            [self setValue:[object valueForKey:name] forKey:name];
        }
    }
}

- (BOOL)MKUIsEqual:(id)object {
    return [self MKUIsEqual:object properties:[self.class propertyNamesOfClass:self.class]];
}

- (BOOL)MKUIsEqual:(id)object properties:(NSSet<NSString *> *)properties {
    if (object == self) {
        return YES;
    }
    if (!object || ([object class] != [self class])) {
        return NO;
    }
    for (NSString *name in properties) {
        id valueObject = [object valueForKey:name];
        id valueSelf = [self valueForKey:name];
        if (valueObject || valueSelf) {
            if ([valueSelf isKindOfClass:[NSObject class]] && [valueObject isKindOfClass:[NSObject class]]) {
                if (valueObject && valueSelf) {
                    if (![valueObject isEqual:valueSelf]) {
                        return NO;
                    }
                }
                else {
                    return NO;
                }
            }
            else {
                if (valueObject != valueSelf) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark - copying

- (id)MKUCopyWithZone:(NSZone *)zone {
    return [self MKUCopyWithZone:zone excludeProperties:nil];
}

- (id)MKUCopyWithZone:(NSZone *)zone excludeProperties:(NSSet<NSString *> *)excluding {
    return [self MKUCopyWithZone:zone baseClass:[self superclass] option:MKU_COPY_OPTION_PROPERTIES | MKU_COPY_OPTION_IVARS excludeProperties:excluding];
}

- (id)MKUCopyWithZone:(NSZone *)zone baseClass:(Class)baseClass option:(MKU_COPY_OPTION)option {
    return [self MKUCopyWithZone:zone baseClass:baseClass option:option excludeProperties:nil];
}

- (id)MKUCopyWithZone:(NSZone *)zone baseClass:(Class)baseClass option:(MKU_COPY_OPTION)option excludeProperties:(NSSet<NSString *> *)excluding {
    Class currentClass = [self class];
    id object = [[currentClass allocWithZone:zone] init];
    
    while (currentClass != baseClass && currentClass != [NSObject class]) {
        [self copyWithZone:zone toObject:object ofKind:currentClass option:option excludeProperties:excluding];
        currentClass = [currentClass superclass];
    }
    return object;
}

- (id)MKUCopyWithZone:(NSZone *)zone properties:(NSSet<NSString *> *)properties {
    id object = [[self.class allocWithZone:zone] init];
    [self copyWithZone:zone toObject:object properties:properties];
    return object;
}

- (void)copyWithZone:(NSZone *)zone toObject:(id)object ofKind:(Class)objectClass option:(MKU_COPY_OPTION)option excludeProperties:(NSSet<NSString *> *)excluding {
    if (![object isKindOfClass:objectClass]) {
        return;
    }
    
    if (option & MKU_COPY_OPTION_IVARS) {
        NSSet<NSString *> *ivars = [NSObject ivarNamesOfClass:objectClass];
        ivars = [ivars setByRemovingObjects:excluding];
        [self copyWithZone:zone toObject:object ivars:ivars];
    }
    
    if (option & MKU_COPY_OPTION_PROPERTIES) {
        NSSet<NSString *> *properties = [NSObject propertyNamesOfClass:objectClass];
        properties = [properties setByRemovingObjects:excluding];
        [self copyWithZone:zone toObject:object properties:properties];
    }
}

- (void)copyWithZone:(NSZone *)zone toObject:(id)object name:(NSString *)name isReadOnly:(BOOL)isReadOnly {
    if ([object respondsToSelector:NSSelectorFromString(name)] && !isReadOnly) {
        
        id value = [self valueForKey:name];
        if (!value) return;
        
        if ([value isKindOfClass:[NSArray class]]) {
            
            NSArray *array;
            if ([value isKindOfClass:[NSMutableArray class]]) {
                array = [[NSMutableArray alloc] initWithArray:value copyItems:YES];
            }
            else {
                array = [[NSArray alloc] initWithArray:value copyItems:YES];
            }
            [object setValue:array forKey:name];
        }
        else {
            [object setValue:[value copyWithZone:zone] forKey:name];
        }
    }
}

- (void)copyWithZone:(NSZone *)zone toObject:(id)object properties:(NSSet<NSString *> *)properties {
    for (NSString *name in properties) {
        BOOL isReadOnly = [self isReadOnlyProperty:name];
        [self copyWithZone:zone toObject:object name:name isReadOnly:isReadOnly];
    }
}

- (void)copyWithZone:(NSZone *)zone toObject:(id)object ivars:(NSSet<NSString *> *)ivars {
    for (NSString *name in ivars) {
        [self copyWithZone:zone toObject:object name:name isReadOnly:NO];
    }
}

- (BOOL)isReadOnlyProperty:(NSString *)name {
    
    Class objectClass = self.class;
    
    while (objectClass != [NSObject class]) {
        objc_property_t property = class_getProperty(objectClass, [name UTF8String]);
        
        if (property) {
            NSString *attributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            NSArray *attrComps = [attributes componentsSeparatedByString:@","];
            
            for (NSString *attr in attrComps) {
                if ([attr characterAtIndex:0] == 'R') {
                    return YES;
                }
            }
        }
        
        objectClass = [objectClass superclass];
    }
    
    return NO;
}

+ (NSDictionary *)attributePropertyNamesOfClass:(Class)objectClass {
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(objectClass, &count);
    
    for (unsigned int i=0; i<count; i++) {
        objc_property_t var = properties[i];
        NSString *name = [[NSString stringWithUTF8String:property_getName(var)] trimCharSet:@"_"];
        objc_property_t property = class_getProperty(objectClass, [name UTF8String]);
        if (property) {
            NSString *attribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            if (name && attribute) {
                [fields setObject:attribute forKey:name];
            }
        }
    }
    free(properties);
    return fields;
}

#pragma mark - coding

- (void)MKUInitWithCoder:(NSCoder *)aDecoder ofKind:(Class)objectClass {
    NSSet<NSString *> *properties = [NSObject propertyNamesOfClass:objectClass];
    [self MKUInitWithCoder:aDecoder properties:properties];
}

- (void)MKUInitWithCoder:(NSCoder *)aDecoder baseClass:(Class)baseClass {
    Class currentClass = [self class];
    
    while (currentClass != baseClass && currentClass != [NSObject class]) {
        [self MKUInitWithCoder:aDecoder ofKind:currentClass];
        currentClass = [currentClass superclass];
    }
}

- (void)MKUInitWithCoder:(NSCoder *)aDecoder properties:(StringArr *)properties {
    if (properties.count == 0) {
        return;
    }
    
    for (NSString *name in properties) {
        if ([self isReadOnlyProperty:name])
            continue;
        
        id value = [aDecoder decodeObjectForKey:name];
        if (value && [self respondsToSelector:NSSelectorFromString(name)]) {
            [self setValue:value forKey:name];
        }
    }
}

- (void)MKUInitWithCoder:(NSCoder *)aDecoder {
    [self MKUInitWithCoder:aDecoder ofKind:[self class]];
}

- (void)MKUEncodeWithCoder:(NSCoder *)aCoder ofKind:(Class)objectClass {
    
    NSSet<NSString *> *properties = [NSObject propertyNamesOfClass:objectClass];
    
    for (NSString *name in properties) {
        if ([self respondsToSelector:NSSelectorFromString(name)]) {
            id value = [self valueForKey:name];
            [aCoder encodeObject:value forKey:name];
        }
    }
}

- (void)MKUEncodeWithCoder:(NSCoder *)aCoder baseClass:(Class)baseClass {
    Class currentClass = [self class];
    
    while (currentClass != baseClass && currentClass != [NSObject class]) {
        [self MKUEncodeWithCoder:aCoder ofKind:currentClass];
        currentClass = [currentClass superclass];
    }
}

- (void)MKUEncodeWithCoder:(NSCoder *)aCoder {
    [self MKUEncodeWithCoder:aCoder baseClass:[self superclass]];
}

- (void)MKUEncodeWithCoder:(NSCoder *)aCoder properties:(NSSet<NSString *> *)properties {
    if (properties.count == 0) {
        return;
    }
    
    for (NSString *name in properties) {
        if ([self respondsToSelector:NSSelectorFromString(name)]) {
            id value = [self valueForKey:name];
            [aCoder encodeObject:value forKey:name];
        }
    }
}

- (NSUInteger)MKUHashWithProperties:(NSSet<NSString *> *)properties {
    NSUInteger hashPrime = 179;
    NSUInteger hashEven = 178;
    NSUInteger hashResult = 1;
    NSUInteger hashObjects = 1;
    
    for (NSString *name in properties) {
        if ([self respondsToSelector:NSSelectorFromString(name)]) {
            id value = [self valueForKey:name];
            if (!value) continue;
            
            if ([value isKindOfClass:[NSObject class]]) {
                hashObjects = hashObjects ^ [value hash];
            }
            else {
                hashResult = hashResult*hashPrime + (value ? hashPrime : hashEven);
            }
        }
    }
    return hashResult + hashObjects;
}

#pragma mark - properties and ivars

+ (NSSet<NSString *> *)propertyNamesOfClass:(Class)objectClass {
    NSMutableSet<NSString *> *fields = [[NSMutableSet alloc] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(objectClass, &count);
    
    for (unsigned int i=0; i<count; i++) {
        objc_property_t var = properties[i];
        NSString *name = [[NSString stringWithUTF8String:property_getName(var)] trimCharSet:@"_"];
        if (name) {
            [fields addObject:name];
        }
    }
    free(properties);
    return fields;
}

+ (NSDictionary *)propertyAttributesOfClass:(Class)objectClass {
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(objectClass, &count);
    
    for (unsigned int i=0; i<count; i++) {
        objc_property_t var = properties[i];
        NSString *name = [[NSString stringWithUTF8String:property_getName(var)] trimCharSet:@"_"];
        objc_property_t property = class_getProperty(objectClass, [name UTF8String]);
        if (property) {
            NSString *attribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            if (name && attribute) {
                [fields setObject:attribute forKey:name];
            }
        }
    }
    free(properties);
    return fields;
}

+ (NSSet<NSString *> *)ivarNamesOfClass:(Class)objectClass {
    NSMutableSet<NSString *> *fields = [[NSMutableSet alloc] init];
    unsigned int count = 0;
    Ivar *properties = class_copyIvarList(objectClass, &count);
    
    for (unsigned int i=0; i<count; i++) {
        Ivar var = properties[i];
        NSString *name = [[NSString stringWithUTF8String:ivar_getName(var)] trimCharSet:@"_"];
        if (name) {
            [fields addObject:name];
        }
    }
    free(properties);
    return fields;
}

+ (NSDictionary *)ivarAttributesOfClass:(Class)objectClass {
    
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    unsigned int count = 0;
    Ivar *properties = class_copyIvarList(objectClass, &count);
    
    for (unsigned int i=0; i<count; i++) {
        Ivar var = properties[i];
        NSString *name = [[NSString stringWithUTF8String:ivar_getName(var)] trimCharSet:@"_"];
        objc_property_t property = class_getProperty(objectClass, [name UTF8String]);
        if (property) {
            NSString *attribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            if (name && attribute) {
                [fields setObject:attribute forKey:name];
            }
        }
    }
    free(properties);
    return fields;
}

+ (Class)classOfProperty:(NSString *)name forObjectClass:(Class)objectClass {
    
    Class class = nil;
    objc_property_t property = class_getProperty(objectClass, [name UTF8String]);
    if (!property) return nil;
    
    NSString *attrs = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *components = [attrs componentsSeparatedByString:@","];
    //no primitives are allowed
    if (components.count > 0) {
        
        if ([components[0] characterAtIndex:1] == 'B') {
            return [NSNumber class];
        }
        else if ([components[0] characterAtIndex:1] == 'c') {
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

#pragma mark - swizzling

+ (void)swizzleSelectorOriginal:(SEL)originalSelector swizzled:(SEL)swizzledSelector isClassMethod:(BOOL)isClassMethod {
    Class class = isClassMethod ? object_getClass(self) : self.class;
    Method originalMethod = isClassMethod ? class_getClassMethod(class, originalSelector) : class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = isClassMethod ? class_getClassMethod(class, swizzledSelector) : class_getInstanceMethod(class, swizzledSelector);
    
    BOOL addMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (addMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleSelector:(SEL)selector isClassMethod:(BOOL)isClassMethod {
    NSString *swizzledSelectorName = [NSString stringWithFormat:@"swizzled_%@", NSStringFromSelector(selector)];
    SEL swizzledSelector = NSSelectorFromString(swizzledSelectorName);
    [self swizzleSelectorOriginal:selector swizzled:swizzledSelector isClassMethod:isClassMethod];
}

+ (NSString *)GUID {
    return [NSUUID UUID].UUIDString;
}

+ (NSString *)timestampGUID {
    return [NSString stringWithFormat:@"%d-%@", (int)[[NSDate date] timeIntervalSince1970], [self GUID]];
}

#pragma mark - processing values

- (void)processText:(NSString *)text condition:(BOOL)condition object:(NSString *)object action:(SEL)action {
    if (condition) {
        if (!object || ![text isEqualToString:object]) {
            if ([self respondsToSelector:action]) {
                [self performSelectorOnMainThread:action withObject:text waitUntilDone:YES];
            }
        }
    }
}

- (void)processNumberInTextField:(__kindof UITextField *)textField action:(SEL)action object:(__kindof NSObject *)object, ... {
    NSNumber *numb = [textField.text stringToNumber];
    textField.text = [numb stringValue];
    if (numb && (!object || ![numb isEqualToNumber:object])) {
        if ([self respondsToSelector:action]) {
            NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:action];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            NSInteger numOfArgs = signature.numberOfArguments;
            [invocation setTarget:self];
            [invocation setSelector:action];
            va_list args;
            va_start(args, object);
            unsigned int index = 1;
            id arg = numb;
            while (arg != nil) {
                index ++;
                [invocation setArgument:&arg atIndex:index];
                if (index < numOfArgs-1) {
                    arg = va_arg(args, id);
                }
                else {
                    break;
                }
            }
            va_end(args);
            [invocation invoke];
        }
    }
}

- (NSNumber *)processNumberInTextField:(__kindof UITextField *)textField number:(__kindof NSNumber *)number {
    NSNumber *numb = [textField.text stringToNumber];
    textField.text = [numb stringValue];
    if (numb && (!number || ![numb isEqualToNumber:number])) {
        return numb;
    }
    return number;
}

+ (NSArray <NSString *> *)deserializeStringResult:(id)result {
    return [self deserializeObjectResult:result objectClass:[NSString class] key:@"string"];
}

+ (NSArray<NSString *> *)deserializeNumberResult:(id)result {
    return [self deserializeSingleKeyResult:result objectClass:[NSNumber class]];
}

+ (NSArray<NSString *> *)deserializeSingleKeyResult:(id)result objectClass:(Class)objectClass {
    return [self deserializeObjectResult:result objectClass:objectClass key:nil];
}

+ (NSArray <NSString *> *)deserializeObjectResult:(id)result objectClass:(Class)objectClass key:(NSString *)key {
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        if (key.length == 0) key = ((NSDictionary *)result).allKeys.firstObject;
        id obj = [result objectForKey:key];
        
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *arr = [result objectForKey:key];
            if ([arr.firstObject isKindOfClass:objectClass]) {
                return arr;
            }
            else if ([obj isKindOfClass:objectClass]) {
                return @[obj];
            }
            else if ([arr.firstObject isKindOfClass:[NSString class]] && objectClass == [NSNumber class]) {
                NSMutableArray *nums = [[NSMutableArray alloc] init];
                for (NSString *str in arr) {
                    [nums addObject:[str stringToNumber]];
                }
                return nums;
            }
        }
        else if ([obj isKindOfClass:objectClass]) {
            return @[obj];
        }
        else if ([obj isKindOfClass:[NSString class]] && objectClass == [NSNumber class]) {
            return @[[obj stringToNumber]];
        }
    }
    else if ([result isKindOfClass:[NSString class]]) {
        return @[result];
    }
    return nil;
}

- (MKU_TENARY_TYPE)stateForSelector:(SEL)action {
    if (![self respondsToSelector:action])
        return MKU_TENARY_TYPE_NONE;
    return [self performSelector:action] ? MKU_TENARY_TYPE_YES : MKU_TENARY_TYPE_NO;
}

- (MKU_TENARY_TYPE)stateForSelector:(SEL)action object:(id)object {
    if (![self respondsToSelector:action])
        return MKU_TENARY_TYPE_NONE;
    return [self performSelector:action withObject:object] ? MKU_TENARY_TYPE_YES : MKU_TENARY_TYPE_NO;
}

#pragma mark - Predicate

- (NSPredicate *)predicateWithKey:(NSString *)key value:(NSObject *)value {
    return [NSPredicate predicateWithFormat:@"SELF.%K == %@", key, value];
}

- (NSPredicate *)predicateWithKey:(NSString *)key searchText:(NSString *)searchText condition:(BOOL)condition {
    if (key.length == 0)
        return [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText];
    
    NSArray *arr = [NSArray arrayWithObjects:[NSPredicate predicateWithFormat:@"SELF.%K CONTAINS[cd] %@", key, searchText], [NSPredicate predicateWithValue:condition], nil];
    return [NSCompoundPredicate andPredicateWithSubpredicates:arr];
}

#pragma mark - Math

+ (UIEdgeInsets)insets:(CGFloat)value {
    return UIEdgeInsetsMake(value, value, value, value);
}

+ (CGRect)boundingRectWithTopLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight {
    
    CGRect rect;
    CGFloat topWidth = topRight.x - topLeft.x;
    CGFloat bottomWidth = bottomRight.x - bottomLeft.x;
    CGFloat leftHeight = topLeft.y - bottomLeft.y;
    CGFloat rightHeight = topRight.x - bottomRight.y;
    
    rect.origin.x = MIN(topLeft.x, bottomLeft.x);
    rect.origin.y = 1.0 - MAX(topLeft.y, topRight.y);
    rect.size.width = MAX(topWidth, bottomWidth);
    rect.size.height = MAX(leftHeight, rightHeight);
    
    return rect;
}

+ (CGRect)rectForNormalizedRect:(CGRect)normalizedRect withWidth:(CGFloat)width height:(CGFloat)height {
    
    CGRect rect;
    rect.origin.x = normalizedRect.origin.x * width;
    rect.origin.y = normalizedRect.origin.y * height;
    rect.size.width = normalizedRect.size.width * width;
    rect.size.height = normalizedRect.size.height * height;
    
    return rect;
}

+ (NSInteger)indexOfBitmask:(NSUInteger)bits {
    NSInteger index = -1;
    NSUInteger num = bits;
    while (num != 0) {
        num >>= 1;
        index ++;
    }
    return index;
}

- (NSUInteger)MKUHash {
    NSUInteger hashPrime = 179;
    NSUInteger hashEven = 178;
    NSUInteger hashResult = 1;
    NSUInteger hashObjects = 1;
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:name];
        if ([value isKindOfClass:[NSObject class]]) {
            hashObjects = hashObjects ^ [value hash];
        }
        else {
            hashResult = hashResult*hashPrime + (value ? hashPrime : hashEven);
        }
    }
    free(properties);
    
    return hashResult + hashObjects;
}

#pragma mark - null

- (BOOL)allIsNull {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([self valueForKey:name]) {
            return NO;
        }
    }
    free(properties);
    
    return YES;
}

+ (BOOL)haveSameNullity:(NSObject *)obj1 asObject:(NSObject *)obj2 {
    if (obj1 && !obj2) return NO;
    if (!obj1 && obj2) return NO;
    return YES;
}

- (BOOL)allIsNullWithProperties:(NSSet<NSString *> *)properties {
    for (NSString *name in properties) {
        if ([self respondsToSelector:NSSelectorFromString(name)]) {
            id value = [self valueForKey:name];
            if ([value isKindOfClass:[NSNumber class]]) {
                return ![value boolValue];
            }
            else if (value) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)allIsNullWithBaseClass:(Class)baseClass {
    Class currentClass = [self class];
    BOOL allIsNull = YES;
    
    while (currentClass != baseClass && allIsNull) {
        
        NSSet<NSString *> *properties = [NSObject propertyNamesOfClass:currentClass];
        allIsNull = [self allIsNullWithProperties:properties];
        currentClass = [currentClass superclass];
    }
    return allIsNull;
}

#pragma mark - overrides

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

@end


@implementation NSIndexPath (Utility)

+ (instancetype)indexPathWithSameIndex:(NSUInteger)index {
    return [NSIndexPath indexPathForRow:index inSection:index];
}

@end

