//
//  UIButton+Utility.m
//  CFI HAWB Reader
//
//  Created by Maryam Karampour on 2026-08-06.
//  Copyright © 2026 Commodity Forwarders Inc. All rights reserved.
//

#import "UIButton+Utility.h"

@implementation UIButton (Utility)

- (void)addTarget:(id)target action:(SEL)action {
    if (target)
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    else
        [self removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.userInteractionEnabled = target;
}

@end
