//
//  UIView+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "UIView+Utility.h"
#import <CoreText/CoreText.h>

@implementation UIView (Constraints)

- (void)removeConstraintsMask {
    for (UIView *view in self.subviews) {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
}

- (void)addConstraintsWithFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary<NSString *,id> *)metrics views:(NSDictionary<NSString *,id> *)views {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:metrics views:views]];
}

- (NSLayoutConstraint *)addConstraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:c];
    [self addConstraint:constraint];
    return constraint;
}

- (NSLayoutConstraint *)addConstraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c priority:(UILayoutPriority)priority {
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1 attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:c];
    constraint.priority = priority;
    [self addConstraint:constraint];
    return constraint;
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
    [self constraintSize:view.frame.size forView:view];
}

- (void)constraintSize:(CGSize)size forView:(__kindof UIView *)view {
    [self addConstraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:size.width];
    [self addConstraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:size.height];
}

- (NSLayoutConstraint *)constraintWidthForView:(__kindof UIView *)view {
    return [self addConstraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:view.frame.size.width];
}

- (NSLayoutConstraint *)constraintHeightForView:(__kindof UIView *)view {
    return [self addConstraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:view.frame.size.height];
}

- (NSLayoutConstraint *)constraintWidth:(CGFloat)width forView:(__kindof UIView *)view {
    return [self addConstraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:width];
}

- (NSLayoutConstraint *)constraintHeight:(CGFloat)height forView:(__kindof UIView *)view {
    return [self addConstraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:height];
}

- (void)constraintWidth:(CGFloat)width forView:(__kindof UIView *)view priority:(UILayoutPriority)priority {
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:width];
    constraint.priority = priority;
    [self addConstraint:constraint];
}

- (void)constraintHeight:(CGFloat)height forView:(__kindof UIView *)view priority:(UILayoutPriority)priority {
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:height];
    constraint.priority = priority;
    [self addConstraint:constraint];
}

- (void)constraintSameWidthHeightForView:(__kindof UIView *)view {
    [self addConstraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
}

- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)attr view:(__kindof UIView *)view {
    return [self addConstraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:self attribute:attr multiplier:1.0 constant:0.0];
}

- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)attr view:(__kindof UIView *)view margin:(CGFloat)margin {
    return [self addConstraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:self attribute:attr multiplier:1.0 constant:margin];
}

- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)attr view:(__kindof UIView *)view margin:(CGFloat)margin priority:(UILayoutPriority)priority {
    return [self addConstraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:self attribute:attr multiplier:1.0 constant:margin priority:priority];
}

- (void)constraintSame:(NSLayoutAttribute)attr view1:(__kindof UIView *)view1 view2:(__kindof UIView *)view2 {
    [self addConstraintWithItem:view1 attribute:attr relatedBy:NSLayoutRelationEqual toItem:view2 attribute:attr multiplier:1.0 constant:0.0];
}

- (void)constraintSame:(NSLayoutAttribute)attr view1:(__kindof UIView *)view1 view2:(__kindof UIView *)view2 margin:(CGFloat)margin {
    [self addConstraintWithItem:view1 attribute:attr relatedBy:NSLayoutRelationEqual toItem:view2 attribute:attr multiplier:1.0 constant:margin];
}

- (void)constraintSameView1:(__kindof UIView *)view1 view2:(__kindof UIView *)view2 {
    return [self constraintSameView1:view1 view2:view2 insets:UIEdgeInsetsZero];
}

- (void)constraintSameView1:(__kindof UIView *)view1 view2:(__kindof UIView *)view2 insets:(UIEdgeInsets)insets {
    [self addConstraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:insets.top];
    [self addConstraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:insets.left];
    [self addConstraintWithItem:view1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:insets.bottom];
    [self addConstraintWithItem:view1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:insets.right];
}

- (void)constraintVertically:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin {
    [self constraintVertically:views interItemMargin:interItemMargin horizontalMargin:horizontalMargin verticalMargin:verticalMargin equalHeights:NO];
}

- (void)constraintHorizontally:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin {
    [self constraintHorizontally:views interItemMargin:interItemMargin horizontalMargin:horizontalMargin verticalMargin:verticalMargin equalWidths:NO];
}

- (void)constraintVertically:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin equalHeights:(BOOL)equalHeights {
    [self constraintVertically:views interItemMargin:interItemMargin horizontalMargin:horizontalMargin verticalMargin:verticalMargin equalHeights:equalHeights parentConstraints:NSLayoutAttributeTop | NSLayoutAttributeBottom];
}

- (void)constraintHorizontally:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin equalWidths:(BOOL)equalWidths {
    [self constraintHorizontally:views interItemMargin:interItemMargin horizontalMargin:horizontalMargin verticalMargin:verticalMargin equalWidths:equalWidths parentConstraints:NSLayoutAttributeLeft | NSLayoutAttributeRight];
}

- (void)constraintVertically:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin equalHeights:(BOOL)equalHeights parentConstraints:(NSLayoutAttribute)parentConstraints {
    
    NSMutableArray<UIView *> *totalViews = [[NSMutableArray alloc] init];

    for (UIView *view in views) {
        if ([self.subviews containsObject:view]) {
            [totalViews addObject:view];
        }
    }

    long total = totalViews.count;
    if (total == 0) return;

    UIView *last = totalViews.firstObject;
    
    if (parentConstraints & NSLayoutAttributeTop) {
        [self constraint:NSLayoutAttributeTop view:last margin:verticalMargin];
    }

    for (UIView *view in totalViews) {

        long index = [totalViews indexOfObject:view];

        if (horizontalMargin != CONSTRAINT_NO_PADDING) {
            [self constraint:NSLayoutAttributeLeft view:view margin:horizontalMargin];
            [self constraint:NSLayoutAttributeRight view:view margin:horizontalMargin];
        }

        if ((parentConstraints & NSLayoutAttributeBottom) && index == totalViews.count - 1) {
            [self constraint:NSLayoutAttributeBottom view:view margin:verticalMargin];
        }
        if (0 < index) {
            [self addConstraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:last attribute:NSLayoutAttributeBottom multiplier:1.0 constant:interItemMargin];
            if (equalHeights) [self constraintSame:NSLayoutAttributeHeight view1:view view2:last];
        }
        last = view;
    }
}

- (void)constraintHorizontally:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin equalWidths:(BOOL)equalWidths parentConstraints:(NSLayoutAttribute)parentConstraints {
    
    NSMutableArray<UIView *> *totalViews = [[NSMutableArray alloc] init];

    for (UIView *view in views) {
        if ([self.subviews containsObject:view]) {
            [totalViews addObject:view];
        }
    }

    long total = totalViews.count;
    if (total == 0) return;

    UIView *last = totalViews.firstObject;
    
    if (parentConstraints & NSLayoutAttributeLeft) {
        [self constraint:NSLayoutAttributeLeft view:last margin:horizontalMargin];
    }

    for (UIView *view in totalViews) {

        long index = [totalViews indexOfObject:view];

        if (verticalMargin != CONSTRAINT_NO_PADDING) {
            [self constraint:NSLayoutAttributeTop view:view margin:verticalMargin];
            [self constraint:NSLayoutAttributeBottom view:view margin:verticalMargin];
        }

        if ((parentConstraints & NSLayoutAttributeRight) && index == totalViews.count - 1) {
            [self constraint:NSLayoutAttributeRight view:view margin:horizontalMargin];
        }
        if (0 < index) {
            [self addConstraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:last attribute:NSLayoutAttributeRight multiplier:1.0 constant:interItemMargin];
            if (equalWidths) [self constraintSame:NSLayoutAttributeWidth view1:view view2:last];
        }
        last = view;
    }
}

- (void)constraintLimitToParent:(NSLayoutAttribute)attr view:(__kindof UIView *)view size:(CGFloat)size {
    
    NSLayoutConstraint *elementHeight = [NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationEqual toItem:nil attribute:attr multiplier:1.0 constant:size];
    elementHeight.priority = 500;
    
    NSLayoutConstraint *elementMaxHeight = [NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:attr multiplier:1.0 constant:0.0];
    
    [self addConstraint:elementHeight];
    [self addConstraint:elementMaxHeight];
}

- (void)constraintLimitToParent:(NSLayoutAttribute)attr view:(__kindof UIView *)view {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:attr multiplier:1.0 constant:0.0]];
}


#pragma mark - constraints

- (NSLayoutConstraint *)layoutConstraint:(NSLayoutAttribute)constraint view:(__kindof UIView *)view margin:(CGFloat)margin {
    return [NSLayoutConstraint constraintWithItem:view attribute:constraint relatedBy:NSLayoutRelationEqual toItem:self attribute:constraint multiplier:1.0 constant:margin];
}

@end


@implementation UIView (Utility)

- (void)removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)addTopBar:(BOOL)top bottomBar:(BOOL)bottom color:(UIColor *)color height:(CGFloat)height {

    if (top) {
        UIView *topBar = [[UIView alloc] init];
        topBar.backgroundColor = color;
        [self addSubview:topBar];
        
        [self removeConstraintsMask];
        
        [self constraintHeight:height forView:topBar];
        [self constraint:NSLayoutAttributeRight view:topBar];
        [self constraint:NSLayoutAttributeTop view:topBar];
        [self constraint:NSLayoutAttributeLeft view:topBar];
    }
    if (bottom) {
        UIView *bottomBar = [[UIView alloc] init];
        bottomBar.backgroundColor = color;
        [self addSubview:bottomBar];

        [self removeConstraintsMask];

        [self constraintHeight:height forView:bottomBar];
        [self constraint:NSLayoutAttributeRight view:bottomBar];
        [self constraint:NSLayoutAttributeBottom view:bottomBar];
        [self constraint:NSLayoutAttributeLeft view:bottomBar];
    }
}

- (UIView *)addVerticalBar:(CGFloat)margin onLeft:(BOOL)onLeft color:(UIColor *)color width:(CGFloat)width {
    
    UIView *bar = [[UIView alloc] init];
    bar.backgroundColor = color;
    [self addSubview:bar];
    
    [self removeConstraintsMask];
    
    [self constraintWidth:width forView:bar];
    [self constraint:(onLeft ? NSLayoutAttributeLeft : NSLayoutAttributeRight) view:bar margin:(onLeft ? margin : -margin)];
    [self constraint:NSLayoutAttributeTop view:bar];
    [self constraint:NSLayoutAttributeBottom view:bar];
    return bar;
}

@end


@implementation UIView (CoreText)

- (void)rotateAttributedText:(NSAttributedString *)text angle:(CGFloat)angle rect:(CGRect)rect alignCenter:(BOOL)alignCenter {
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, rect);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), pathRef, NULL);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    CGFloat transformAdjustment = alignCenter ? 2.0 : 1.0;
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(center.x, center.y);
    transform = CGAffineTransformRotate(transform, angle);
    transform = CGAffineTransformTranslate(transform, -center.x/transformAdjustment, -center.x/transformAdjustment);
    CGContextConcatCTM(context, transform);
    
    CGContextSaveGState(context);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw(frameRef, context);
    
    CGContextRestoreGState(context);
    CGContextRestoreGState(context);
    
    CFRelease(pathRef);
    CFRelease(frameRef);
    CFRelease(frameSetter);
}

@end


@implementation UIView (Drawing)

- (void)shadowWithSize:(CGFloat)size color:(UIColor *)color offset:(CGSize)offset {
    
    CGRect rect = CGRectMake(self.bounds.origin.x - size / 2, self.bounds.origin.y - size / 2, self.bounds.size.width + size, self.bounds.size.height + size);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:rect];
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowPath = shadowPath.CGPath;
    self.layer.shadowRadius = self.layer.cornerRadius;
}

@end
