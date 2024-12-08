//
//  MKUSearch.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUSearch.h"

@implementation MKUSearch

@end

@implementation MKUSearchPredicate

- (instancetype)initWithText:(NSString *)text condition:(BOOL)condition {
    if (self = [super init]) {
        self.text = text;
        self.condition = condition;
    }
    return self;
}

+ (instancetype)objectWithText:(NSString *)text condition:(BOOL)condition {
    return [[self alloc] initWithText:text condition:condition];
}

@end
