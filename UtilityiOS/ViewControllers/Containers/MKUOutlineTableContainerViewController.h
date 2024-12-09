//
//  MKUOutlineTableViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKUTableViewController.h"
#import "MKUOutlineViewProtocol.h"
//TODO: could replace MKUHeaderFooterContainerViewController
@interface MKUOutlineTableContainerViewController : UIViewController <MKUOutlineContainerViewProtocol>

@property (nonatomic, strong, readonly)  UIView * _Nonnull outlineView;
@property (nonatomic, strong, readonly)  UIView * _Nonnull contentView;
@property (nonatomic, strong) __kindof  UIView * _Nonnull headerView;
@property (nonatomic, strong) __kindof  UIView * _Nonnull footerView;

/** @brief A single view at the bottom expanding the entire width, used for background color in case of custom footer */
@property (nonatomic, strong) __kindof  UIView * _Nonnull backFooterView;

/** @brief Set to null for no outline footer */
@property (nonatomic, strong) __kindof  UIView * _Nullable outlineFooterView;
@property (nonatomic, strong, readonly) __kindof MKUTableViewController * _Nonnull outlineVC;
@property (nonatomic, strong, readonly) __kindof UIViewController * _Nonnull contentVC;

- (void)setContentVC:(__kindof UIViewController * _Nonnull)contentVC;
- (void)setOutlineVC:(__kindof MKUTableViewController * _Nonnull)outlineVC;

- (void)setExpanded:(BOOL)expanded completion:(void (^)(void))completion;

/** @brief Default is 0.4 */
+ (NSTimeInterval)animationDuration;

@end
