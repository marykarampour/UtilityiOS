//
//  DBModel.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "DBModel.h"
#import <objc/runtime.h>

@implementation DBVarChar

@end

@implementation DBChar

@end

@implementation DBNumber

@end

@implementation DBText

@end

@implementation DBEnumValue

@end

@implementation DBEnum

@end

@implementation DBForeignKey

@end

@implementation DBModel

- (NSString *)SQLKeysEqualValues {
    
    MKPairArr *pairs = [self SQLKeyValuePairs];
    NSString *str = @"";
    
    for (MKPair *pr in pairs) {
        NSString *format = ([pairs lastObject] == pr ? @"%@%@=%@" : @"%@%@=%@, ");
        str = [NSString stringWithFormat:format, str, pr.key, pr.value];
    }
    return str;
}

- (MKPair *)SQLKeysWithValues {
    
    MKPairArr *pairs = [self SQLKeyValuePairs];
    NSString *keyStr = @"";
    NSString *valueStr = @"";
    
    for (MKPair *pr in pairs) {
        NSString *format = ([pairs lastObject] == pr ? @"%@%@" : @"%@%@, ");
        keyStr = [NSString stringWithFormat:format, keyStr, pr.key];
        valueStr = [NSString stringWithFormat:format, valueStr, pr.value];
    }
    
    MKPair *pair = [[MKPair alloc] init];
    pair.key = keyStr;
    pair.value = valueStr;
    
    return pair;
}
//mapper not used
- (MKPairArr *)SQLKeyValuePairs {
    MMKPairArr *pairs = [[NSMutableArray alloc] init];
    
    unsigned int varCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &varCount);
    
    for (unsigned int i=0; i<varCount; i++) {
        NSString *keyStr = @"";
        NSString *valueStr = @"";
        NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(properties[i])];
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        if (![self valueForKey:name]) {
            continue;
        }
        NSString *value = [[self valueForKey:name] description];
        
        if ([attribute characterAtIndex:1] == '@') {
            NSArray *components = [attribute componentsSeparatedByString:@"\""];
            if ([components count] > 1) {
                
                NSString *className = components[1];
                Class propertyClass = NSClassFromString(className);
                if ([propertyClass isSubclassOfClass:[NSDate class]] && [value isKindOfClass:[NSString class]]) {
                    value = [NSString stringWithFormat:@"%ld", (long)[[self valueForKey:name] timeIntervalSince1970]];
                }
            }
        }
        
        if (!value.length) {
            NSString *propertyName = [self convertToProperty:name];
//            NSString *propertyName = [mapper convertValue:[name stringByReplacingOccurrencesOfString:@"_" withString:@""] isImportingToModel:YES];
            value = [NSString stringWithFormat:@"\"%@\"", value];
            keyStr = [NSString stringWithFormat:@"%@", propertyName];
            valueStr = [NSString stringWithFormat:@"%@", value];
        }
        
        MKPair *pair = [[MKPair alloc] init];
        pair.key = keyStr;
        pair.value = valueStr;
        
        [pairs addObject:pair];
    }
    free(properties);
    
    return pairs;
}



//+ (NSString *)createTableQuery {
//    NSString *query;
//    unsigned int count = 0;
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    for (unsigned int i=0; i<count; i++) {
//        
//    }
//    
//    free(properties);
//    
//    return query;
//}

@end
