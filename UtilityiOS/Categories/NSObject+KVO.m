//
//  NSObject+KVO.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "NSObject+KVO.h"

@implementation NSObject (KVO)

- (void)registerKVO {
    if (![self.class respondsToSelector:@selector(KVOKeys)]) return;
    
    [self registerKVOKeys:[self.class KVOKeys]];
}

- (void)registerKVOKeys:(NSSet<NSString *> *)keys {
    if (![self respondsToSelector:@selector(KVOObject)]) return;
    
    for (NSString *key in keys) {
        [[self KVOObject] addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
    }
}

- (void)unregisterKVO {
    if (![self.class respondsToSelector:@selector(KVOKeys)]) return;
    
    [self unregisterKVOKeys:[self.class KVOKeys]];
}
//TODO: This has a bug / crash that the observed might be removd prior and it attempts to remove it again, keep track of all observed objects?
- (void)unregisterKVOKeys:(NSSet<NSString *> *)keys {
    if (![self respondsToSelector:@selector(KVOObject)]) return;
    
    for (NSString *key in keys) {
        [[self KVOObject] removeObserver:self forKeyPath:key];
    }
}

@end
