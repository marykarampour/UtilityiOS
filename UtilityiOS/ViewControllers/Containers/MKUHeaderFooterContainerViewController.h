//
//  MKUHeaderFooterContainerViewController.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Utility.h"
#import "MKUHeaderContainerProtocol.h"
#import "NSObject+NavBarButtonTarget.h"
#import "MKUViewControllerTransitionProtocol.h"

/** @brief class is the generic VC which includes a header view on top, and a main content view.
 @note Uses MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE */
@interface MKUHeaderFooterContainerViewController <__covariant ObjectType : __kindof UIViewController<HeaderVCChildViewDelegate> *> : UIViewController <MKUHeaderFooterContainerProtocol>

@property (nonatomic, strong) __kindof UIView *headerView;
@property (nonatomic, strong) __kindof UIView *footerView;

/** @brief If nil both content view and header view are added to single subview of self.view as ordinary subviews.
 All subviews should be added to content view in this case.
 Otherwise content view is the view of a UIViewController as a child view controller. */
@property (nonatomic, strong) ObjectType childViewController;
@property (nonatomic, weak) id<HeaderVCChildViewDelegate> headerChildDelegate;

/** @brief Call this if you intend not to call super in your init, for example in case of a class cluster.
 @param objects A dictionary of objects passed to a custom init method. */
- (void)initBaseWithObject:(id)object;
- (void)refreshHeaderHeightAnimated:(BOOL)animated;
- (void)refreshHeaderHeight;
- (void)refreshFooterHeightAnimated:(BOOL)animated;
- (void)refreshFooterHeight;

- (void)setChildViewControllerAsNavBarTarget;

/** @brief Default: both content view and heaedr view are added to self.view as ordinary subviews. All subviews should be added to content view. */
- (UIView *)contentView;
- (UIView *)backView;
- (void)constraintViews;

+ (NSTimeInterval)animationDuration;

/** @brief Expands or collapses the footer */
- (void)setFooterExpanded:(BOOL)expanded animated:(BOOL)animated completion:(void (^)(void))completion;

/** @brief Expands or collapses the header to min height */
- (void)setHeaderExpanded:(BOOL)expanded animated:(BOOL)animated completion:(void (^)(void))completion;

@end

