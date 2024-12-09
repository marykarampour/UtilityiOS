//
//  MKUHeaderFooterContainerViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKUHeaderFooterContainerViewController.h"
#import "UIViewController+Navigation.h"
#import "UIViewController+Utility.h"
#import "NSArray+Utility.h"
#import "UIView+Utility.h"

@interface MKUHeaderFooterContainerViewController () {
    UIView *contentView;
}

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSLayoutConstraint *headerHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *footerHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *contentTopMarginConstraint;
@property (nonatomic, strong) NSLayoutConstraint *contentBottomMarginConstraint;

@end

@implementation MKUHeaderFooterContainerViewController

@synthesize headerViewTitle = _headerViewTitle;

- (instancetype)init {
    return [self initWithObject:nil];
}

- (instancetype)initWithObject:(id)object {
    if (self = [super init]) {
        [self initBaseWithObject:object];
    }
    return self;
}

- (instancetype)initWithChildViewController:(__kindof UIViewController<HeaderVCChildViewDelegate> *)childViewController {
    if (self = [super init]) {
        self.childViewController = childViewController;
        [self initBaseWithObject:nil];
    }
    return self;
}

- (void)initBaseWithObject:(id)object {
    [self createChildVC];
    [self createHeaderView];
    [self createFooterView];
}

- (void)setChildViewController:(__kindof UIViewController<HeaderVCChildViewDelegate> *)childViewController {
    _childViewController = childViewController;
    
    self.headerChildDelegate = self.childViewController;
    
    if ([self.childViewController respondsToSelector:@selector(setHeaderDelegate:)])
        self.childViewController.headerDelegate = self;
}

- (void)setChildViewControllerAsNavBarTarget {
    [self addNavBarTarget:self.childViewController];
    [self setNavBarItemsOfTarget:self.childViewController];
}

- (void)setNavBarItems {
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
}

- (SEL)actionForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return [self isDoneButtonOfType:type] ? @selector(nextPressed:) : nil;
}

- (BOOL)isEnabledButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return NO;
}

- (NSString *)titleForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return [self isDoneButtonOfType:type] ? [Constants Next_STR] : nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTapToDismissKeyboard];
    [self setContentView];
    
    self.backView = [[UIView alloc] init];
    [self.view addSubview:self.backView];
    
    [self.backView addSubview:contentView];
    [self.backView addSubview:self.headerView];
    [self.backView addSubview:self.footerView];
    
    [self constraintViews];
    [self dispathHeaderChildDelegateForViewDidLoad];
}

- (void)createHeaderView {
    self.headerView = [[UIView alloc] init];
}

- (void)createFooterView {
    self.footerView = [[UIView alloc] init];
}

- (void)createChildVC {
}

- (UIView *)contentView {
    return contentView;
}

- (void)setContentView {
    if (self.childViewController) {
        [self setChildView:self.childViewController forSubView:&contentView];
    }
    else {
        contentView = [[UIView alloc] init];
    }
}

- (void)nextPressed:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    if ([self.headerChildDelegate respondsToSelector:@selector(nextPressed:)]) {
        [self.headerChildDelegate nextPressed:sender];
    }
}

- (void)dispathHeaderChildDelegateForViewDidLoad {
    if ([self.headerChildDelegate respondsToSelector:@selector(containerViewDidLoad)]) {
        [self.headerChildDelegate containerViewDidLoad];
    }
}

- (CGFloat)headerHeight {
    return [Constants DefaultRowHeight];
}

- (CGFloat)maxHeaderHeight {
    return [self headerHeight];
}

- (CGFloat)headerWidth {
    return 0.0;
}

- (CGFloat)headerVerticalMargin {
    return 0.0;
}

- (CGFloat)contentViewTopMargin {
    if ([self headerHeight] == CONSTRAINT_NO_PADDING)
        return [self headerVerticalMargin];
    return [self headerVerticalMargin] + [self headerHeight];
}

- (CGFloat)footerHeight {
    return 0.0;
}

- (CGFloat)maxFooterHeight {
    return 200.0;
}

- (CGFloat)footerWidth {
    return 0.0;
}

- (CGFloat)footerVerticalMargin {
    return 0.0;
}

- (CGFloat)contentViewBottomMargin {
    if ([self footerHeight] == CONSTRAINT_NO_PADDING)
        return [self footerVerticalMargin];
    return [self footerVerticalMargin] + [self footerHeight];
}

- (void)constraintViews {
    
    if (self.footerHeightConstraint || self.headerHeightConstraint) return;

    [self.view removeConstraintsMask];
    [self.view constraintSidesForView:self.backView];
    
    [self.backView removeConstraintsMask];
    
    [self.backView constraint:NSLayoutAttributeTop view:self.headerView margin:[self headerVerticalMargin]];
    [self.backView constraint:NSLayoutAttributeBottom view:self.footerView margin:-[self footerVerticalMargin]];
    
    [self.backView constraint:NSLayoutAttributeLeft view:contentView];
    [self.backView constraint:NSLayoutAttributeRight view:contentView];
    
    self.contentTopMarginConstraint = [self.backView constraint:NSLayoutAttributeTop view:contentView margin:[self contentViewTopMargin]];
    self.contentBottomMarginConstraint = [self.backView constraint:NSLayoutAttributeBottom view:contentView margin:-[self contentViewBottomMargin]];
    
    if (0 < [self headerWidth]) {
        [self.backView constraintWidth:[self headerWidth] forView:self.headerView];
        [self.backView constraint:NSLayoutAttributeCenterX view:self.headerView];
    }
    else {
        [self.backView constraint:NSLayoutAttributeLeft view:self.headerView];
        [self.backView constraint:NSLayoutAttributeRight view:self.headerView];
    }
    
    if (0 < [self footerWidth]) {
        [self.backView constraintWidth:[self footerWidth] forView:self.footerView];
        [self.backView constraint:NSLayoutAttributeCenterX view:self.footerView];
    }
    else {
        [self.backView constraint:NSLayoutAttributeLeft view:self.footerView];
        [self.backView constraint:NSLayoutAttributeRight view:self.footerView];
    }
    
    if ([self headerHeight] != CONSTRAINT_NO_PADDING)
        self.headerHeightConstraint = [self.backView constraintHeight:[self headerHeight] forView:self.headerView];
    
    if ([self footerHeight] != CONSTRAINT_NO_PADDING)
        self.footerHeightConstraint = [self.backView constraintHeight:[self footerHeight] forView:self.footerView];
}

- (void)refreshHeaderHeightAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            [self refreshHeaderHeight];
        }];
    }
    else {
        [self refreshHeaderHeight];
    }
}

- (void)refreshHeaderHeight {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headerHeightConstraint.constant = [self headerHeight];
        self.contentTopMarginConstraint.constant = [self contentViewTopMargin];
        [self.view layoutIfNeeded];
    });
}

- (void)refreshFooterHeightAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            [self refreshFooterHeight];
        }];
    }
    else {
        [self refreshFooterHeight];
    }
}

- (void)refreshFooterHeight {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.footerHeightConstraint.constant = [self footerHeight];
        self.contentBottomMarginConstraint.constant = [self contentViewBottomMargin];
        [self.view layoutIfNeeded];
    });
}

- (void)setHeaderExpanded:(BOOL)expanded animated:(BOOL)animated completion:(void (^)(void))completion {
        
    if (animated) {
        [UIView animateWithDuration:[self.class animationDuration] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.headerHeightConstraint.constant = expanded ? [self maxHeaderHeight] : [self headerHeight];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }
    else {
        self.headerHeightConstraint.constant = expanded ? [self maxHeaderHeight] : [self headerHeight];
        [self.view layoutIfNeeded];
    }
}

- (void)setFooterExpanded:(BOOL)expanded animated:(BOOL)animated completion:(void (^)(void))completion {
    
    self.footerView.hidden = !expanded;
    
    if (animated) {
        [UIView animateWithDuration:[self.class animationDuration] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.footerHeightConstraint.constant = expanded ? [self maxFooterHeight] : [self footerHeight];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }
    else {
        self.footerHeightConstraint.constant = expanded ? [self maxFooterHeight] : [self footerHeight];
        [self.view layoutIfNeeded];
    }
}

+ (NSTimeInterval)animationDuration {
    return 0.4;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
