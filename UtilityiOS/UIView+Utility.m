//
//  UIView+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)

- (void)removeConstraintsMask {
    for (UIView *view in self.subviews) {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
}

@end
