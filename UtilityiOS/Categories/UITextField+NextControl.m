//
//  UITextField+NextControl.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-29.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "UITextField+NextControl.h"
#import <objc/runtime.h>

const void *NEXT_CONTROL_KEY;

@implementation UITextField (NextControl)

- (UITextField *)nextControl {
    return (UITextField *)objc_getAssociatedObject(self, &NEXT_CONTROL_KEY);
}

- (void)setNextControl:(UITextField *)nextControl {
    objc_setAssociatedObject(self, &NEXT_CONTROL_KEY, nextControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)transferFirstResponderToNextControl {
    if (self.nextControl) {
        [self.nextControl becomeFirstResponder];
        return YES;
    }
    [self resignFirstResponder];
    return NO;
}

@end
