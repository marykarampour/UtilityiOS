//
//  MultiLabelView.h
//  Serafa
//
//  Created by Maryam Karampour on 2018-03-27.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKLabel.h"

typedef NS_OPTIONS(NSUInteger, MultiLabelViewType) {
    MultiLabelViewType_NONE = 0,
    MultiLabelViewType_Labels = 1 << 0,
    MultiLabelViewType_LeftView = 1 << 1,
    MultiLabelViewType_rightView = 1 << 2
};

#define MULTILABEL_CENTER_X         -1000
#define MULTILABEL_CENTER_Y         -1000
#define MULTILABEL_TOP_FIRST_LABEL  -2000

@interface MultiLabelView : NSObject

@property (nonatomic, strong, readonly) __kindof UIView *contentView;
@property (nonatomic, strong, readonly) __kindof UIView *leftView;
@property (nonatomic, strong, readonly) __kindof UIView *rightView;
@property (nonatomic, strong, readonly) NSMutableArray<__kindof MKLabel *> *labels;

/** @brief An optional view at the back of all views, if added will cover the entire contentView */
@property (nonatomic, strong, readonly) __kindof UIView *backView;

- (void)addBackView:(__kindof UIView *)backView;

/** @brief Default initializer
 @param contentView Pass nil if you want a default UIView be set as contentView */
- (instancetype)initWithContentView:(__kindof UIView *)contentView;

/** @brief Creats a cell based on type
 @param type supported types are:
 none uses leftview or if nil rightview
 labels only,
 left and right views only (both should be non null, frame.size of whichever is nonzero is used, e.g. left.frame.size.height = 22.0 is used if right.frame.size.height = 0.0. Default, left.frame is used for size if both are provided). Set MULTILABEL_CENTER_X for constraint centerX for originX, and MULTILABEL_CENTER_Y for centerY for originY.
 labels and left views
 labels and right views
 labels and left and right views
 single view, pass MultiLabelViewType_NONE and a left or right view
 @param leftView only used if labels or right view is non null, frame.size should be provided
 @param rightView only used if labels or left view is non null, frame.size should be provided
 @param labelsCount number of labels, used if type includes option labels
 */

- (void)constructWithType:(MultiLabelViewType)type leftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets;

- (void)setText:(NSString *)text forLabelAtIndex:(NSUInteger)index;
- (void)setAttributedText:(NSAttributedString *)text forLabelAtIndex:(NSUInteger)index;

/** @brief subclass can override to create custom labels */
- (__kindof MKLabel *)createLabelAtIndex:(NSUInteger)index;

/** @brief Call only after construct, the method does not add aditional views, only replaces the view */
- (void)addLeftView:(__kindof UIView *)leftView;

/** @brief Call only after construct, the method does not add aditional views, only replaces the view */
- (void)addRightView:(__kindof UIView *)rightView;

/** @brief Sum of all constant widths of the view including insets */
- (CGFloat)constantWidthSum;

- (CGFloat)heightForWidth:(CGFloat)width;

@end
