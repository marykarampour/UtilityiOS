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

@end
