//
//  NSSet+Utility.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "NSSet+Utility.h"

@implementation NSSet (Utility)

- (instancetype)setByRemovingObjects:(NSSet *)set {
    NSMutableSet *mutable = [NSMutableSet setWithSet:self];
    for (NSObject *obj in set) {
        [mutable removeObject:obj];
    }
    return mutable;
}

@end

@implementation NSMutableSet (Utility)

@end

