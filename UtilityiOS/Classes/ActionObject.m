//
//  ActionObject.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-12-31.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "ActionObject.h"

@implementation ActionObject

+ (instancetype)actionWithAction:(SEL)action {
    return [self actionWithTitle:nil target:nil action:action];
}

+ (instancetype)actionWithTarget:(id)target action:(SEL)action {
    return [self actionWithTitle:nil target:target action:action];
}

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    if (self = [super init]) {
        self.title = title;
        self.target = target;
        self.action = action;
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}

+ (instancetype)blankAction {
    return [[ActionObject alloc] init];
}

+ (instancetype)actionWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [[ActionObject alloc] initWithTitle:title target:target action:action];
}

+ (NSArray<ActionObject *> *)actionsWithTitles:(StringArr *)titles target:(id)target action:(SEL)action {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ActionObject *act = [ActionObject actionWithTitle:obj target:target action:action object:@(idx)];
        [actions addObject:act];
    }];
    return actions;
}

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action object:(NSObject *)object {
    self = [self initWithTitle:title target:target action:action];
    self.object = object;
    return self;
}

+ (instancetype)actionWithTitle:(NSString *)title target:(id)target action:(SEL)action object:(NSObject *)object {
    return [[ActionObject alloc] initWithTitle:title target:target action:action object:object];
}

+ (NSArray<ActionObject *> *)actionsWithTitleObjects:(MKUPairArray<NSString *, NSObject *> *)titles target:(id)target action:(SEL)action {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    [titles.array enumerateObjectsUsingBlock:^(__kindof MKUPair<NSString *, NSObject *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ActionObject *act = [ActionObject actionWithTitle:obj.first target:target action:action object:obj.second];
        [actions addObject:act];
    }];
    return actions;
}

@end


@implementation OptionObject

- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName iconColor:(UIColor *)iconColor {
    if (self = [super init]) {
        self.title = title;
        self.iconName = iconName;
        self.iconColor = iconColor;
    }
    return self;
}

+ (instancetype)optionWithTitle:(NSString *)title iconName:(NSString *)iconName iconColor:(UIColor *)iconColor {
    return [[OptionObject alloc] initWithTitle:title iconName:iconName iconColor:iconColor];
}

@end
