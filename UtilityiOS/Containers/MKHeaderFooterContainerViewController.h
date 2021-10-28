//
//  MKHeaderFooterContainerViewController.h
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Utility.h"
#import "MKHeaderContainerProtocol.h"
#import "MKViewControllerTransitionProtocol.h"

typedef NS_ENUM(NSUInteger, HEADER_CONTAINER_TYPE) {
    HEADER_CONTAINER_TYPE_DEFAULT,
    HEADER_CONTAINER_TYPE_TABLEVIEW
};

/** @brief class is the generic VC which includes a header view on top, and a main content view. */
@interface MKHeaderFooterContainerViewController : UIViewController <MKHeaderFooterContainerProtocol, HeaderVCParentViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) __kindof UIView *headerView;
@property (nonatomic, strong) __kindof UIView *footerView;
@property (nonatomic, strong) __kindof UIViewController<HeaderVCChildViewDelegate> *childViewController;
@property (nonatomic, strong) id object;

@property (nonatomic, weak) id<HeaderVCChildViewDelegate> headerChildDelegate;
@property (nonatomic, weak) id<MKViewControllerTransitionProtocol> transitionDelegate;

@property (nonatomic, assign, readonly) HEADER_CONTAINER_TYPE type;

@property (nonatomic, strong) UIBarButtonItem *nextButton;

/** @param type Default: both content view and heaedr view are added to self.view as ordinary subviews. All subviews should be added to content view. TableView: content view is the view (tableView) of a UITableViewController as a child view controller.*/
- (instancetype)initWithHeaderType:(HEADER_CONTAINER_TYPE)type;

/** @brief Use this to pass and object to be used while creating child VC */
- (instancetype)initWithChildObject:(NSObject *)object;

/** @brief Use this to pass and object to be used while creating child VC */
- (instancetype)initWithHeaderType:(HEADER_CONTAINER_TYPE)type childObject:(NSObject *)object;

/** @brief subclass must override to customize, default is HEADER_CONTAINER_NEXT_TYPE_TITLE */
- (void)constructNextButton;
- (void)createNextButtonWithType:(NAV_BAR_ITEM_TYPE)type systemItem:(UIBarButtonSystemItem)item image:(UIImage *)image;

+ (NSTimeInterval)animationDuration;

/** @brief Expands or collapses the footer */
- (void)setFooterExpanded:(BOOL)expanded animated:(BOOL)animated completion:(void (^)(void))completion;

/** @brief Expands or collapses the header to min height */
- (void)setHeaderExpanded:(BOOL)expanded animated:(BOOL)animated completion:(void (^)(void))completion;

@end
