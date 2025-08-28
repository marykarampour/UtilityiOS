//
//  NSSet+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet <ObjectType> (Utility)

- (instancetype)setByRemovingObjects:(NSSet *)set;

@end

@interface NSMutableSet <ObjectType> (Utility)

/** @brief If object is nil, nothing will happen. */
- (void)addNullableObject:(ObjectType)anObject;

@end

