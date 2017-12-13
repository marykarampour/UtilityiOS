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

- (instancetype)initWithStringsDictionary:(NSDictionary *)values {
    return [self initWithStringsDictionary:values mapper:[[self class] keyMapper]];
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
    
    if (components.count > 0) {
        if ([components[0] characterAtIndex:1] == 'c' || [components[0] characterAtIndex:1] == 'B') {
            return nil;
        }
        class = NSClassFromString([components[0] componentsSeparatedByString:@"\""][1]);
    }
    return class;
}

#pragma mark - JSONModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

#pragma mark - key mapper

+ (DictStringString *)JSONMapperDict {
    return [self keyMapperDictionaryForClass:[self class] format:StringFormatUnderScoreIgnoreDigits];//[self keyMapperDictionaryWithAncestors];
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self JSONMapperDict]];
}

+ (DictStringString *)DBMapperDict {
    return [self keyMapperDictionaryForClass:[self class] format:StringFormatUnderScoreIgnoreDigits];//[self keyMapperDictionaryWithAncestors];
}

+ (JSONKeyMapper *)DBKeyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self DBMapperDict]];
}

+ (NSDictionary *)keyMapperDictionaryWithAncestorsWithFormat:(StringFormat)format {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    Class class = [self class];
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
    
    for (unsigned int i=0; i<count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *under_score_name = [name format:format];
        [dict setValue:under_score_name forKey:name];
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


@end
