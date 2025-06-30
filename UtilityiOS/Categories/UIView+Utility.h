//
//  UIView+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const CONSTRAINT_NO_PADDING = MAXFLOAT;

@interface UIView (Constraints)

- (void)removeConstraintsMask;
- (void)removeAllSubviewConstraints;

- (void)addConstraintsWithFormat:(NSString * _Nullable)format options:(NSLayoutFormatOptions)opts metrics:(nullable NSDictionary<NSString *,id> *)metrics views:(NSDictionary<NSString *, id> *_Nullable)views;

- (NSLayoutConstraint *)addConstraintWithItem:(id _Nullable)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;

- (NSLayoutConstraint *)addConstraintWithItem:(id _Nullable)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c priority:(UILayoutPriority)priority;

- (void)constraintSidesForView:(__kindof UIView *)view insets:(UIEdgeInsets)insets;
- (void)constraintSidesForView:(__kindof UIView *)view;

- (void)constraintSize:(CGSize)size forView:(__kindof UIView *)view;
/** brief constraint size based on frame size */
- (void)constraintSizeForView:(__kindof UIView *)view;
- (NSLayoutConstraint *)constraintWidthForView:(__kindof UIView *)view;
- (NSLayoutConstraint *)constraintHeightForView:(__kindof UIView *)view;
- (NSLayoutConstraint *)constraintWidth:(CGFloat)width forView:(__kindof UIView *)view;
- (NSLayoutConstraint *)constraintHeight:(CGFloat)height forView:(__kindof UIView *)view;
- (void)constraintSameWidthHeightForView:(__kindof UIView *)view;

- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)attr view:(__kindof UIView *)view;
- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)attr view:(__kindof UIView *)view margin:(CGFloat)margin;
- (NSLayoutConstraint *)constraint:(NSLayoutAttribute)attr view:(__kindof UIView *)view margin:(CGFloat)margin priority:(UILayoutPriority)priority;

- (void)constraintSidesExcluding:(NSLayoutAttribute)attr view:(__kindof UIView *)view;
- (void)constraintSidesExcluding:(NSLayoutAttribute)attr view:(__kindof UIView *)view insets:(UIEdgeInsets)insets;
- (void)constraintSidesExcluding:(NSLayoutAttribute)attr view:(__kindof UIView *)view margin:(CGFloat)margin;
- (void)constraintSidesExcluding:(NSLayoutAttribute)attr view:(__kindof UIView *)view margin:(CGFloat)margin priority:(UILayoutPriority)priority;

- (void)constraintSame:(NSLayoutAttribute)attr view1:(__kindof UIView *)view1 view2:(__kindof UIView *)view2;
- (void)constraintSame:(NSLayoutAttribute)attr view1:(__kindof UIView *)view1 view2:(__kindof UIView *)view2 margin:(CGFloat)margin;
- (void)constraintSameView1:(__kindof UIView *)view1 view2:(__kindof UIView *)view2;
- (void)constraintSameView1:(__kindof UIView *)view1 view2:(__kindof UIView *)view2 insets:(UIEdgeInsets)insets;
- (void)constraintVertically:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin;
- (void)constraintHorizontally:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin;
- (void)constraintVertically:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin equalHeights:(BOOL)equalHeights;
- (void)constraintHorizontally:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin equalWidths:(BOOL)equalWidths;

/** @param parentConstraints Specifies consraints on parent's edges, pass 0 for none,  NSLayoutAttributeTop or NSLayoutAttributeBottom or both, other values are ignored
    @param horizontalMargin Use CONSTRAINT_NO_PADDING to not constraint horizontally to the parent */
- (void)constraintVertically:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin equalHeights:(BOOL)equalHeights parentConstraints:(NSLayoutAttribute)parentConstraints;

/** @param parentConstraints Specifies consraints on parent's edges, pass 0 for none,  NSLayoutAttributeLeft or NSLayoutAttributeRight or both, other values are ignored
    @param verticalMargin Use CONSTRAINT_NO_PADDING to not constraint vertically to the parent */
- (void)constraintHorizontally:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin equalWidths:(BOOL)equalWidths parentConstraints:(NSLayoutAttribute)parentConstraints;

/** @param parentConstraints Specifies consraints on parent's edges, pass 0 for none,  NSLayoutAttributeTop or NSLayoutAttributeBottom or both, other values are ignored
    @param horizontalMargin Use CONSTRAINT_NO_PADDING to not constraint horizontally to the parent
    @param verticalConstraints Specifies consraints on parent's edges, pass 0 for none,  NSLayoutAttributeLeft or NSLayoutAttributeRight or both, other values are ignored */
- (void)constraintHorizontally:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin equalWidths:(BOOL)equalWidths parentConstraints:(NSLayoutAttribute)parentConstraints verticalConstraints:(NSLayoutAttribute)verticalConstraints;

/** @param parentConstraints Specifies consraints on parent's edges, pass 0 for none,  NSLayoutAttributeLeft or NSLayoutAttributeRight or both, other values are ignored
    @param verticalMargin Use CONSTRAINT_NO_PADDING to not constraint vertically to the parent
    @param horizontalConstraints  Specifies consraints on parent's edges, pass 0 for none,  NSLayoutAttributeTop or NSLayoutAttributeBottom or both, other values are ignored*/
- (void)constraintVertically:(NSArray<__kindof UIView *> *)views interItemMargin:(CGFloat)interItemMargin horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin equalHeights:(BOOL)equalHeights parentConstraints:(NSLayoutAttribute)parentConstraints horizontalConstraints:(NSLayoutAttribute)horizontalConstraints;

/** @brief Limits the height or width of view to that of its parent */
- (void)constraintLimitToParent:(NSLayoutAttribute)attr view:(__kindof UIView *)view size:(CGFloat)size;

/** @brief Limits the height or width of view to that of its parent */
- (void)constraintLimitToParent:(NSLayoutAttribute)attr view:(__kindof UIView *)view;

- (void)constraintWidth:(CGFloat)width forView:(__kindof UIView *)view priority:(UILayoutPriority)priority;
- (void)constraintHeight:(CGFloat)height forView:(__kindof UIView *)view priority:(UILayoutPriority)priority;

#pragma mark - constraints

- (NSLayoutConstraint *)layoutConstraint:(NSLayoutAttribute)constraint view:(__kindof UIView *)view margin:(CGFloat)margin;

- (void)setPositionInSuperViewWhenHidden:(BOOL)hidden;
+ (void)setPositionOfView:(__kindof UIView *)view inSuperViewWhenHidden:(BOOL)hidden;

/** @brief Adds views to view and adds view to self and sends it to the back. */
- (void)encapsulateViews:(NSArray<__kindof UIView *> *)views inView:(__kindof UIView *)view;

/** @brief Adds views to view and adds view to self and sends it to the back. The encapsulating view is returned. */
- (__kindof UIView *)encapsulateViews:(NSArray<__kindof UIView *> *)views;

@end


@interface UIView (Utility)

- (void)removeAllSubviews;
- (void)addTopBar:(BOOL)top bottomBar:(BOOL)bottom color:(UIColor *)color height:(CGFloat)height;
- (UIView *)addVerticalBar:(CGFloat)leftDistance onLeft:(BOOL)onLeft color:(UIColor *)color width:(CGFloat)width;
+ (void)removeAllSubviewsOfSuperview:(__kindof UIView *)superview;

/** Adds the view to self, and constraints it to all sides.
 @param position If it is MKU_VIEW_HIERARCHY_POSITION_BACK it sends the view to background.
 If it is MKU_VIEW_HIERARCHY_POSITION_FRONT it keeps it in foreground. In this case it is equivalent to MKU_VIEW_HIERARCHY_POSITION_NEUTRAL. */
- (void)addCoverView:(__kindof UIView *)view position:(MKU_VIEW_HIERARCHY_POSITION)position;
/** Adds the view to self, and constraints it to all sides.
 @param position If it is MKU_VIEW_HIERARCHY_POSITION_BACK it sends the view to background.
 If it is MKU_VIEW_HIERARCHY_POSITION_FRONT it keeps it in foreground. In this case it is equivalent to MKU_VIEW_HIERARCHY_POSITION_NEUTRAL. */
- (void)addCoverView:(__kindof UIView *)view position:(MKU_VIEW_HIERARCHY_POSITION)position insets:(UIEdgeInsets)insets;
/** @brief Sets view as the wole subview of this view. */
- (void)setContentView:(__kindof UIView *)view;
/** @brief Sets view as the wole subview of this superview. */
+ (void)setContentView:(__kindof UIView *)view forSuperview:(__kindof UIView *)superview;
/** @brief Sets view as the wole subview of this superview. */
+ (void)setContentView:(__kindof UIView *)view forSuperview:(__kindof UIView *)superview insets:(UIEdgeInsets)insets;
/** @brief Sets view as the wole subview of this superview.
 @param setterHandler Use to set the view or do other construction. Called before adding the view as a subview and setting constraints. */
+ (void)setContentView:(__kindof UIView *)view forSuperview:(__kindof UIView *)superview insets:(UIEdgeInsets)insets setterHandler:(void (^)(void))setterHandler;

@end

@interface UIView (CoreText)

- (void)rotateAttributedText:(NSAttributedString *)text angle:(CGFloat)angle rect:(CGRect)rect alignCenter:(BOOL)alignCenter;

@end

@interface UIView (Drawing)

- (void)shadowWithSize:(CGFloat)size color:(UIColor *)color offset:(CGSize)offset;

@end

@interface UIView (DrawText)

/** @brief Call in drawRect:
 @note Will not draw if color is not given. */
- (void)drawText:(NSString *)text textColor:(UIColor *)textColor inRect:(CGRect)rect withAngle:(CGFloat)angle atPoint:(CGPoint)point;

/** @brief Call in drawRect:
 @note Will not draw if color is not given. */
- (void)drawAttributedString:(NSAttributedString *)attributedText inRect:(CGRect)rect withAngle:(CGFloat)angle atPoint:(CGPoint)point;

@end


