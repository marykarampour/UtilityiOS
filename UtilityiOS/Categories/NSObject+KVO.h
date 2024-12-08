//
//  NSObject+KVO.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKUKVOProtocol <NSObject>

@optional
+ (NSSet<NSString *> *)KVOKeys;
/** The object which adds self as observer. */
- (NSObject *)KVOObject;

@end

@interface NSObject (KVO) <MKUKVOProtocol>

/** @brief Call in when the corresponding objects are created. */
- (void)registerKVO;
/** @brief Call in when the corresponding objects are created. */
- (void)registerKVOKeys:(NSSet<NSString *> *)keys;
/** @brief Call in dealoc. */
- (void)unregisterKVO;
/** @brief Call in dealoc. */
- (void)unregisterKVOKeys:(NSSet<NSString *> *)keys;

@end
