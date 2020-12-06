//
//  NSArray+Utility.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-12-05.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utility)

+ (BOOL)isArray:(NSObject *)arr ofType:(Class)cls;
- (id)nullableObjectAtIndex:(NSUInteger)index;

@end
