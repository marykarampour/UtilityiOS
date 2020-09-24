//
//  NSObject+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSObject+Utility.h"
#import "NSString+Utility.h"
#import <objc/runtime.h>

@implementation NSObject (Utility)

- (BOOL)MKIsEqual:(id)object {
    return [self MKIsEqual:object properties:[self.class propertyNamesOfClass:self.class]];
}

- (BOOL)MKIsEqual:(id)object properties:(StringArr *)properties {
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

- (id)MKCopyWithZone:(NSZone *)zone {
    return [self MKCopyWithZone:zone baseClass:[self superclass]];
}

- (id)MKCopyWithZone:(NSZone *)zone baseClass:(Class)baseClass {
    Class currentClass = [self class];
    id object = [[currentClass allocWithZone:zone] init];
    
    while (currentClass != baseClass) {
        [self copyWithZone:zone toObject:object ofKind:currentClass];
        currentClass = [currentClass superclass];
    }
    return object;
}

- (void)copyWithZone:(NSZone *)zone toObject:(id)object ofKind:(Class)objectClass {
    if (![object isKindOfClass:objectClass]) {
        return;
    }
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(objectClass, &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([self respondsToSelector:NSSelectorFromString(name)]) {
            
            id value = [self valueForKey:name];
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
    free(properties);
}

- (void)MKInitWithCoder:(NSCoder *)aDecoder ofKind:(Class)objectClass {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(objectClass, &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [aDecoder decodeObjectForKey:name];
        if (value && [self respondsToSelector:NSSelectorFromString(name)]) {
            [self setValue:value forKey:name];
        }
    }
    free(properties);
}

- (void)MKInitWithCoder:(NSCoder *)aDecoder baseClass:(Class)baseClass {
    Class currentClass = [self class];
    
    while (currentClass != baseClass) {
        [self MKInitWithCoder:aDecoder ofKind:currentClass];
        currentClass = [currentClass superclass];
    }
}

- (void)MKInitWithCoder:(NSCoder *)aDecoder {
    [self MKInitWithCoder:aDecoder ofKind:[self class]];
}

- (void)MKEncodeWithCoder:(NSCoder *)aCoder ofKind:(Class)objectClass {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(objectClass, &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([self respondsToSelector:NSSelectorFromString(name)]) {
            id value = [self valueForKey:name];
            [aCoder encodeObject:value forKey:name];
        }
    }
    free(properties);
}

- (void)MKEncodeWithCoder:(NSCoder *)aCoder baseClass:(Class)baseClass {
    Class currentClass = [self class];
    
    while (currentClass != baseClass) {
        [self MKEncodeWithCoder:aCoder ofKind:currentClass];
        currentClass = [currentClass superclass];
    }
}

- (void)MKEncodeWithCoder:(NSCoder *)aCoder {
    [self MKEncodeWithCoder:aCoder baseClass:[self superclass]];
}

- (NSUInteger)MKHash {
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

+ (StringArr *)propertyNamesOfClass:(Class)objectClass {
    MStringArr *fields = [[MStringArr alloc] init];
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

+ (NSDictionary *)attributePropertyNamesOfClass:(Class)objectClass {
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

- (BOOL)allIsNull {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:name];
        if (value) {
            return NO;
        }
    }
    free(properties);
    
    return YES;
}

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

@end
