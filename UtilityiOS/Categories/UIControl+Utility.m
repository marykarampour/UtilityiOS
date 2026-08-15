//
//  UIControl+Utility.m
//  CFI HAWB Reader
//
//  Created by Maryam Karampour on 2026-08-14.
//  Copyright © 2026 Commodity Forwarders Inc. All rights reserved.
//

#import "UIControl+Utility.h"
#import <objc/runtime.h>

static char HANDLER_KEY;

@interface UIControl ()

@property (copy) VoidSenderActionHandler actionHandler;

@end

@implementation UIControl (Utility)

- (void)addActionHandelr:(VoidSenderActionHandler)action forControlEvents:(UIControlEvents)controlEvents {
    self.actionHandler = action;
    [self addTarget:self action:@selector(action:) forControlEvents:controlEvents];
}

- (void)setActionHandler:(VoidSenderActionHandler)actionHandler {
    objc_setAssociatedObject(self, &HANDLER_KEY, actionHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (VoidSenderActionHandler)actionHandler {
    return objc_getAssociatedObject(self, &HANDLER_KEY);
}

- (void)action:(UIControl *)sender {
    self.actionHandler(sender);
}

@end
