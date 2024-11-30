//
//  MKUHeaderContainerProtocol.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKUViewControllerTransitionProtocol.h"

@class MKUHeaderFooterContainerViewController;

@class MKUTableViewController;

@protocol HeaderVCChildViewDelegate <NSObject>

@required
@property (nonatomic, weak) __kindof MKUHeaderFooterContainerViewController *headerDelegate;

@optional
- (void)nextPressed:(UIBarButtonItem *)sender;
- (void)containerViewDidLoad;

@end

@protocol MKUHeaderFooterContainerProtocol <MKUViewControllerTransitionProtocol>

@required
- (void)setContentView;

/** @brief Default is a blank UIView, it is called in viewDidLoad, if you want to set this prior to that,
 override this method with blank implementation. This is called prior to createChildVC. */
- (void)createHeaderView;

/** @brief Used to add a height constraint to the headerView. Default is kDefaultTableCellHeight.
 @note Return CONSTRAINT_NO_PADDING to not add a height constraint to the headerView. */
- (CGFloat)headerHeight;
- (CGFloat)maxHeaderHeight;
- (CGFloat)headerWidth;
- (CGFloat)headerVerticalMargin;
/** @brief Default is [self headerVerticalMargin] + [self headerHeight] */
- (CGFloat)contentViewTopMargin;

/** @brief Default is a blank UIView, it is called in viewDidLoad, if you want to set this prior to that,
 override this method with blank implementation. This is called prior to createChildVC. */
- (void)createFooterView;
- (CGFloat)maxFooterHeight;

/** @brief Used to add a height constraint to the footerView. Default is kDefaultTableCellHeight.
 @note Return CONSTRAINT_NO_PADDING to not add a height constraint to the footerView. */
- (CGFloat)footerHeight;
- (CGFloat)footerWidth;
- (CGFloat)footerVerticalMargin;
/** @brief Default is [self footerVerticalMargin] + [self footerHeight] */
- (CGFloat)contentViewBottomMargin;

/** @brief It is called after createHeaderView. */
- (void)createChildVC;

@optional
@property (nonatomic, strong) NSString *headerViewTitle;
@property (nonatomic, strong) NSAttributedString *headerViewAttributedTitle;

- (void)setChildViewController:(__kindof UIViewController<HeaderVCChildViewDelegate> *)childViewController;
- (void)nextPressed:(UIBarButtonItem *)sender;

@end
