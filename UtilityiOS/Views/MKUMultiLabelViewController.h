//
//  MKUMultiLabelViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-04.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUContainerView.h"
#import "MKULabel.h"

typedef NS_OPTIONS(NSUInteger, MKU_MULTI_LABEL_VIEW_TYPE) {
    MKU_MULTI_LABEL_VIEW_TYPE_NONE  = 0,
    MKU_MULTI_LABEL_VIEW_TYPE_LABEL = 1 << 0,
    MKU_MULTI_LABEL_VIEW_TYPE_LEFT  = 1 << 1,
    MKU_MULTI_LABEL_VIEW_TYPE_RIGHT = 1 << 2
};

#define MULTILABEL_CENTER_X         -1000
#define MULTILABEL_CENTER_Y         -2000
#define MULTILABEL_TOP_FIRST_LABEL  -3000

@interface MKUMultiLabelViewController <__covariant LeftObjectType : __kindof UIView *, __covariant RightObjectType : __kindof UIView *> : NSObject

@property (nonatomic, strong, readonly) __kindof UIView *contentView;
@property (nonatomic, strong, readonly) MKUContainerView<LeftObjectType> *leftView;
@property (nonatomic, strong, readonly) MKUContainerView<RightObjectType> *rightView;
@property (nonatomic, strong, readonly) NSMutableArray<__kindof MKULabel *> *labels;

/** @brief An optional view at the back of all views, if added will cover the entire contentView. */
@property (nonatomic, strong, readonly) __kindof UIView *backView;

- (void)addBackView:(__kindof UIView *)backView;

/** @brief Default initializer
 @param contentView Pass nil if you want a default UIView be set as contentView */
- (instancetype)initWithContentView:(__kindof UIView *)contentView;

/** @brief Creats a view based on type
 @param type supported types are:
    none uses leftview or if nil rightview
    labels only,
    left and right views only (both should be non null, frame.size of whichever is nonzero is used, e.g.    left.frame.size.height = 22.0 is used if right.frame.size.height = 0.0. Default, left.frame is used for  size if both are provided). Set MULTILABEL_CENTER_X for constraint centerX for originX, and     MULTILABEL_CENTER_Y for centerY for originY.
    labels and left views
    labels and right views
    labels and left and right views
    single view, pass MKU_MULTI_LABEL_VIEW_TYPE_NONE and a left or right view
 @param leftView only used if labels or right view is non null, frame.size should be provided
 @param rightView only used if labels or left view is non null, frame.size should be provided
 @param labelsCount number of labels, used if type includes option labels
 */
- (void)constructWithType:(MKU_MULTI_LABEL_VIEW_TYPE)type leftView:(LeftObjectType)leftView rightView:(RightObjectType)rightView labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets;

- (void)setText:(NSString *)text forLabelAtIndex:(NSUInteger)index;
- (void)setAttributedText:(NSAttributedString *)text forLabelAtIndex:(NSUInteger)index;

/** @brief subclass can override to create custom labels */
- (__kindof MKULabel *)createLabelAtIndex:(NSUInteger)index;
- (__kindof MKULabel *)labelAtIndex:(NSUInteger)index;

/** @brief Call only after construct, the method does not add aditional views, only replaces the view */
- (void)addLeftView:(LeftObjectType)leftView;

/** @brief Call only after construct, the method does not add aditional views, only replaces the view */
- (void)addRightView:(RightObjectType)rightView;

/** @brief Sum of all constant widths of the view including insets */
- (CGFloat)constantWidthSum;
- (CGFloat)heightForWidth:(CGFloat)width;

@end
