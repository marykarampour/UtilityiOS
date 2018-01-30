//
//  MKPair.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKPair.h"

@implementation MKPair

+ (__kindof MKPair *)first:(__kindof NSObject *)first second:(__kindof NSObject *)second {
    MKPair *obj = [[[self class] alloc] init];
    obj.first = first;
    obj.second = second;
    return obj;
}

@end

@implementation MKKeyValue

@dynamic first;
@dynamic second;

@end

@implementation MKPairArray

- (ObjectArr *)allKeys {
    MObjectArr *keys = [[NSMutableArray  alloc] init];
    for (MKKeyValue *obj in self.array) {
        [keys addObject:obj.first];
    }
    return keys;
}

- (ObjectArr *)allValues {
    MObjectArr *values = [[NSMutableArray  alloc] init];
    for (MKKeyValue *obj in self.array) {
        [values addObject:obj.second];
    }
    return values;
}

- (NSObject *)objectForKey:(__kindof NSObject *)key {
    for (MKPair *obj in self.array) {
        if ([obj.first isEqual:key]) {
            return obj.second;
        }
    }
    return nil;
}

@end

@implementation MKKeyValueArray

@dynamic array;

@end


//@implementation MKColorPair
//
//@dynamic first;
//@dynamic second;
//
//@end
