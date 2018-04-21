//
//  ActionObject.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2017-12-31.
//  Copyright © 2017 BHS Consultants. All rights reserved.
//

#import "ActionObject.h"

@implementation ActionObject

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    if (self = [super init]) {
        self.title = title;
        self.target = target;
        self.action = action;
    }
    return self;
}

+ (instancetype)actionWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [[ActionObject alloc] initWithTitle:title target:target action:action];
}

+ (NSArray<ActionObject *> *)actionsWithTitles:(StringArr *)titles target:(id)target action:(SEL)action {
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    for (NSString *title in titles) {
        ActionObject *act = [ActionObject actionWithTitle:title target:target action:action];
        [actions addObject:act];
    }
    return actions;
}

@end


@implementation OptionObject

- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName {
    if (self = [super init]) {
        self.title = title;
        self.iconName = iconName;
    }
    return self;
}

+ (instancetype)optionWithTitle:(NSString *)title iconName:(NSString *)iconName {
    return [[OptionObject alloc] initWithTitle:title iconName:iconName];
}

@end
