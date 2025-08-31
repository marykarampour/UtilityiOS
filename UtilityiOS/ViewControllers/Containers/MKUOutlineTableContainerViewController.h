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

@property (nonatomic, strong, readonly)  UIView *outlineView;
@property (nonatomic, strong, readonly)  UIView *contentView;
@property (nonatomic, strong) __kindof  UIView *headerView;
@property (nonatomic, strong) __kindof  UIView *footerView;

/** @brief A single view at the bottom expanding the entire width, used for background color in case of custom footer */
@property (nonatomic, strong) __kindof  UIView *backFooterView;

/** @brief Set to null for no outline footer */
@property (nonatomic, strong) __kindof  UIView *  outlineFooterView;
@property (nonatomic, strong, readonly) __kindof MKUTableViewController *outlineVC;
@property (nonatomic, strong, readonly) __kindof UIViewController *contentVC;

- (void)setContentVC:(__kindof UIViewController *)contentVC;
- (void)setOutlineVC:(__kindof MKUTableViewController *)outlineVC;

- (void)setExpanded:(BOOL)expanded completion:(void (^)(void))completion;

/** @brief Default is 0.4 */
+ (NSTimeInterval)animationDuration;

@end
