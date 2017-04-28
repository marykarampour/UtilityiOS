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
    Class type = [self class];
    id object = [[type allocWithZone:zone] init];
    
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(type, &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        [object setValue:[[self valueForKey:name] copyWithZone:zone] forKey:name];
    }
    free(properties);
    
    return object;
}



@end
