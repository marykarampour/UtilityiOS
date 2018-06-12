//
//  NSObject+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSObject+Utility.h"
#import <objc/runtime.h>

@implementation NSObject (Utility)

- (BOOL)MKIsEqual:(id)object {
    if (object == self) {
        return YES;
    }
    if (!object || ([object class] != [self class])) {
        return NO;
    }
    
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        id valueObject = [object valueForKey:name];
        id valueSelf = [self valueForKey:name];
        if (valueObject || valueSelf) {
            if ([valueSelf isKindOfClass:[NSObject class]] && [valueObject isKindOfClass:[NSObject class]]) {
                if (valueObject && valueSelf) {
                    if (![valueObject isEqual:valueSelf]) {
                        free(properties);
                        return NO;
                    }
                }
                else {
                    free(properties);
                    return NO;
                }
            }
            else {
                if (valueObject != valueSelf) {
                    free(properties);
                    return NO;
                }
            }
        }
    }
    free(properties);
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
                NSArray *array = [[NSArray alloc] initWithArray:value copyItems:YES];
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
    [self MKInitWithCoder:aDecoder ofKind:[self superclass]];
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
    unsigned int varCount = 0;
    objc_property_t *vars = class_copyPropertyList(objectClass, &varCount);
    MStringArr *arr = [[NSMutableArray alloc] init];
    
    for (unsigned int i=0; i<varCount; i++) {
        objc_property_t var = vars[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(var)];
        [arr addObject:name];
    }
    free(vars);
    return arr;
}

+ (void)swizzleSelectorOriginal:(SEL)originalSelector swizzled:(SEL)swizzledSelector {
    Class class = object_getClass(self);
    Method originalMethod =class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL addMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (addMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleSelector:(SEL)selector {
    NSString *swizzledSelectorName = [NSString stringWithFormat:@"swizzled_%@", NSStringFromSelector(selector)];
    SEL swizzledSelector = NSSelectorFromString(swizzledSelectorName);
    [self swizzleSelectorOriginal:selector swizzled:swizzledSelector];
}


- (NSString *)timestampGUID {
    return [NSString stringWithFormat:@"%d-%@", (int)[[NSDate date] timeIntervalSince1970], [NSUUID UUID].UUIDString];
}

@end
