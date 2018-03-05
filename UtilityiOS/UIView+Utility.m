//
//  UIView+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Constraints)

- (void)removeConstraintsMask {
    for (UIView *view in self.subviews) {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
}

- (void)addConstraintsWithFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary<NSString *,id> *)metrics views:(NSDictionary<NSString *,id> *)views {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:metrics views:views]];
}

- (void)addConstraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:c]];
}

- (void)constraintSidesForView:(__kindof UIView *)view {
    [self constraint:NSLayoutAttributeTop view:view];
    [self constraint:NSLayoutAttributeBottom view:view];
    [self constraint:NSLayoutAttributeLeft view:view];
    [self constraint:NSLayoutAttributeRight view:view];
}

- (void)constraintSidesForView:(__kindof UIView *)view insets:(UIEdgeInsets)insets {
    [self constraint:NSLayoutAttributeTop view:view margin:insets.top];
    [self constraint:NSLayoutAttributeBottom view:view margin:-insets.bottom];
    [self constraint:NSLayoutAttributeLeft view:view margin:insets.left];
    [self constraint:NSLayoutAttributeRight view:view margin:-insets.right];
}

- (void)constraintSizeForView:(__kindof UIView *)view {
    [self addConstraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:view.frame.size.width];
    [self addConstraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:view.frame.size.height];
}

- (void)constraintWidthForView:(__kindof UIView *)view {
    [self addConstraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:view.frame.size.width];
}

- (void)constraintHeightForView:(__kindof UIView *)view {
    [self addConstraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:view.frame.size.height];
}

- (void)constraintWidth:(CGFloat)width forView:(__kindof UIView *)view {
    [self addConstraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:width];
}

- (void)constraintHeight:(CGFloat)height forView:(__kindof UIView *)view {
    [self addConstraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:height];
}

- (void)constraintSameWidthHeightForView:(__kindof UIView *)view {
    [self addConstraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
}

- (void)constraint:(NSLayoutAttribute)attr view:(__kindof UIView *)view {
    [self addConstraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:self attribute:attr multiplier:1.0 constant:0.0];
}

- (void)constraint:(NSLayoutAttribute)attr view:(__kindof UIView *)view margin:(CGFloat)margin {
    [self addConstraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:self attribute:attr multiplier:1.0 constant:margin];
}

- (void)constraintSame:(NSLayoutAttribute)attr view1:(__kindof UIView *)view1 view2:(__kindof UIView *)view2 {
    [self addConstraintWithItem:view1 attribute:attr relatedBy:NSLayoutRelationEqual toItem:view2 attribute:attr multiplier:1.0 constant:0.0];
}

@end

