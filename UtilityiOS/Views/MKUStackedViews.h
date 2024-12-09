//
//  MKUStackedViews.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-28.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKUStackedViewProtocol <NSObject>

@required
/** @param sizes The key is the index of the view and the value is the width or height whichever applies. Only used if the corresponding value isn't zero. */
- (void)constreintViewsWithSizes:(NSDictionary<NSNumber *, NSNumber *> *)sizes interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin;
/** @brief Views are sized equally here. */
- (void)constreintViewsWithInterItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin;
- (void)constreintViewsWithPadding:(CGFloat)padding interItemMargin:(CGFloat)interItemMargin;
- (void)constreintViewsWithPadding:(CGFloat)padding;
- (void)constreintViews;

@end

@interface MKUStackedViews <__covariant ViewType : UIView *> : UIView <MKUStackedViewProtocol>

@property (nonatomic, assign) CGFloat defaultPadding;

- (NSArray <__kindof UIView *> *)contentViews;

/** @param handler Returns a UIView that will be added and constrainted to self. */
- (instancetype)initWithCount:(NSUInteger)count viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIView that will be added and constrainted to self.
 @param padding Is used for horizontalMargin. */
- (instancetype)initWithCount:(NSUInteger)count padding:(CGFloat)padding viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIView that will be added and constrainted to self.
 @param sizes Key is the index of a subview, value is the size for that view. */
- (instancetype)initWithCount:(NSUInteger)count interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin sizes:(NSDictionary<NSNumber *, NSNumber *> *)sizes viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIView that will be added and constrainted to self. */
- (instancetype)initWithCount:(NSUInteger)count interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIView that will be added and constrainted to self.
 @param interItemMargin By default it is padding if not passed as in initWithCount:countpadding:viewCreationHandler:.
 @param padding Is used for horizontalMargin. */
- (instancetype)initWithCount:(NSUInteger)count padding:(CGFloat)padding interItemMargin:(CGFloat)interItemMargin viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler;

/** @param handlers Returns an array of blocks to create a UIView that will be added and constrainted to self. */
- (instancetype)initWithViewCreationHandlers:(NSArray <SINGLE_INDEX_VIEW_CREATION_HANDLER> *)handlers;

- (ViewType)viewAtIndex:(NSUInteger)index;
- (NSUInteger)count;
- (NSMutableArray<ViewType> *)views;

@end


@interface MKUHorizontalViews <__covariant ViewType> : MKUStackedViews

- (ViewType)viewAtIndex:(NSUInteger)index;

@end


@interface MKUVerticalViews <__covariant ViewType> : MKUStackedViews

- (ViewType)viewAtIndex:(NSUInteger)index;

@end
