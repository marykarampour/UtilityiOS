//
//  MKUMultiLabelTableViewCell.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUBaseTableViewCell.h"
#import "MKUMultiLabelViewController.h"

@interface MKUMultiLabelTableViewCell <__covariant LeftObjectType : __kindof UIView *, __covariant RightObjectType : __kindof UIView *> : MKUBaseTableViewCell

@property (nonatomic, strong, readonly) MKUMultiLabelViewController <LeftObjectType, RightObjectType> *viewController;

/** @brief By default calls constructViewController and the cell's contentView is set as the contentView of viewController. */
- (instancetype)initWithType:(MKU_MULTI_LABEL_VIEW_TYPE)type leftView:(LeftObjectType)leftView rightView:(RightObjectType)rightView labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets;

/** @brief By default the cell's contentView is set as the contentView of viewController. Called in
 initWithType: leftView: rightView: labelsCount: insets:
 Override to use another view so the cell's contentView can be customized. */
- (void)constructControllerWithType:(MKU_MULTI_LABEL_VIEW_TYPE)type leftView:(LeftObjectType)leftView rightView:(RightObjectType)rightView labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets;

@end
