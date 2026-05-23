//
//  MKUStackedViews.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-28.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUViewProtocol.h"

@protocol MKUStackedViewProtocol <MKUCompoundViewProtocol>

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

/** @brief Initializes the views and adds them as subview but doesn't constraint them.
 @param handler Returns a UIView that will be added and constrainted to self. */
- (void)initViewsWithCount:(NSUInteger)count viewCreationHandler:(SINGLE_INDEX_VIEW_CREATION_HANDLER)handler;

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
- (NSUInteger)indexOfView:(ViewType)view;

@end


@interface MKUHorizontalViews <__covariant ViewType> : MKUStackedViews

- (ViewType)viewAtIndex:(NSUInteger)index;

@end


@interface MKUVerticalViews <__covariant ViewType> : MKUStackedViews

- (ViewType)viewAtIndex:(NSUInteger)index;

@end


@interface MKUVerticallyStackedHorizontalViews <__covariant ViewType> : MKUVerticalViews <MKUHorizontalViews <ViewType> *>

/** @param handler Returns a UIVIew that will be added and constrainted to self.
 width is set on individual views in each row. Height is set on each row. */
- (instancetype)initWithCount:(NSUInteger)count horizontalCount:(NSUInteger)horizontalCount padding:(CGFloat)padding  verticalSizes:(NSDictionary<NSNumber *, NSNumber *> *)verticalSizes horizontalSizes:(NSDictionary<NSNumber *, NSNumber *> *)horizontalSizes viewCreationHandler:(DOUBLE_INDEX_COUNT_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIVIew that will be added and constrainted to self. */
- (instancetype)initWithCount:(NSUInteger)count horizontalCount:(NSUInteger)horizontalCount padding:(CGFloat)padding viewCreationHandler:(DOUBLE_INDEX_COUNT_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIVIew that will be added and constrainted to self. */
- (instancetype)initWithCount:(NSUInteger)count horizontalCount:(NSUInteger)horizontalCount viewCreationHandler:(DOUBLE_INDEX_COUNT_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIVIew that will be added and constrainted to self. */
- (instancetype)initWithCount:(NSUInteger)count horizontalCount:(NSUInteger)horizontalCount interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin viewCreationHandler:(DOUBLE_INDEX_COUNT_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIVIew that will be added and constrainted to self.
 width is set on individual views in each row. Height is set on each row. */
- (instancetype)initWithVerticalCount:(NSUInteger)verticalCount horizontalCount:(NSUInteger)horizontalCount padding:(CGFloat)padding  verticalSizes:(NSDictionary<NSNumber *, NSNumber *> *)verticalSizes horizontalSizes:(NSDictionary<NSNumber *, NSNumber *> *)horizontalSizes viewCreationHandler:(DOUBLE_INDEX_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIVIew that will be added and constrainted to self. */
- (instancetype)initWithVerticalCount:(NSUInteger)verticalCount horizontalCount:(NSUInteger)horizontalCount padding:(CGFloat)padding viewCreationHandler:(DOUBLE_INDEX_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIVIew that will be added and constrainted to self. */
- (instancetype)initWithVerticalCount:(NSUInteger)verticalCount horizontalCount:(NSUInteger)horizontalCount viewCreationHandler:(DOUBLE_INDEX_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIVIew that will be added and constrainted to self. */
- (instancetype)initWithVerticalCount:(NSUInteger)verticalCount horizontalCount:(NSUInteger)horizontalCount interItemSpacing:(CGFloat)interItemSpacing horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin viewCreationHandler:(DOUBLE_INDEX_VIEW_CREATION_HANDLER)handler;

/** @param handler Returns a UIVIew that will be added and constrainted to self. */
- (instancetype)initWithViewCreationHandlers:(NSArray <NSArray <SINGLE_INDEX_VIEW_CREATION_HANDLER> *> *)handlers;

- (ViewType)viewForRow:(NSUInteger)row column:(NSUInteger)column;
/** @param The index represents the spot in the views in total, first rows are calcualted, then columns, e.g., view is 2x3, and index = 5, means row = 2 and column = 1 */
- (ViewType)viewForIndex:(NSUInteger)index;

- (NSUInteger)rowCount;
/** @brief These are individual views within rows and columns. */
- (NSArray<ViewType> *)cellViews;
- (NSUInteger)indexOfCellView:(ViewType)view;

@end



