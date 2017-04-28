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

static DictStringString *JSONMapperDict;

@implementation MKModel

+ (void)initialize {
    if (!JSONMapperDict) {
        JSONMapperDict = [self keyMapperDictionaryWithAncestors];
    }
}

#pragma mark - JSONModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

#pragma mark - key mapper

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self keyMapperDictionaryWithAncestors]];
}

+ (NSDictionary *)keyMapperDictionaryWithAncestors {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    Class class = [self class];
    while (class != [MKModel class]) {
        [dict addEntriesFromDictionary:[self keyMapperDictionaryForClass:class]];
        class = [class superclass];
    }
    return dict;
}

+ (NSDictionary *)keyMapperDictionaryForClass:(Class)class {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(class, &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *under_score_name = [name format:StringFormatUnderScoreIgnoreDigits];
        [dict setValue:under_score_name forKey:name];
    }
    free(properties);
    return dict;
}

- (NSString *)convertToJson:(NSString *)property {
    return [JSONMapperDict objectForKey:property];
}

- (NSString *)convertToProperty:(NSString *)json {
    NSArray *keys = [JSONMapperDict allKeysForObject:json];
    if (keys && keys.count) {
        return keys[0];
    }
    return nil;
}

#pragma mark - override NSObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        
        for (unsigned int i=0; i<count; i++) {
            NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
            id value = [aDecoder decodeObjectForKey:name];
            if (value) {
                [self setValue:value forKey:name];
            }
        }
        free(properties);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
    }
    free(properties);
}

- (id)copyWithZone:(NSZone *)zone {
    return [self MKCopyWithZone:zone];
}

- (BOOL)isEqual:(id)object {
    return [self MKIsEqual:object];
}

- (NSUInteger)hash {
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



@end
