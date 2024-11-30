//
//  MKUSearch.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUModel.h"

@interface MKUSearch : MKUModel

@end

@interface MKUSearchPredicate : MKUModel

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL condition;

- (instancetype)initWithText:(NSString *)text condition:(BOOL)condition;
+ (instancetype)objectWithText:(NSString *)text condition:(BOOL)condition;

@end

