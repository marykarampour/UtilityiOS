//
//  MKUOutlineTableViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKUOutlineTableContainerViewController.h"
#import "UIViewController+Utility.h"
#import "UIView+Utility.h"

@interface MKUOutlineTableContainerViewController ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong, readwrite) UIView *outlineView;
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong, readwrite) __kindof MKUTableViewController *outlineVC;
@property (nonatomic, strong, readwrite) __kindof UIViewController *contentVC;

@property (nonatomic, strong) NSLayoutConstraint *outLineWidthConstraint;

@end

@implementation MKUOutlineTableContainerViewController

- (instancetype)init {
    if (self = [super init]) {
        [self createChildContentVC];
        [self createChildOutlineVC];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self removeBackBarButtonText];
    [self addTapToDismissKeyboard];
    
    [self createHeaderView];
    [self createFooterView];
    [self createOutlineFooterView];
    self.backView = [[UIView alloc] init];
    self.backFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.contentView];
    [self.backView addSubview:self.headerView];
    [self.backView addSubview:self.backFooterView];
    [self.backView addSubview:self.footerView];
    [self.backView addSubview:self.outlineView];
    [self.backView addSubview:self.outlineFooterView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self constraintViews];
}

- (void)setContentVC:(__kindof UIViewController *)contentVC {
    _contentVC = contentVC;
    [self setContentView];
}

- (void)setOutlineVC:(__kindof MKUTableViewController *)outlineVC {
    _outlineVC = outlineVC;
    [self setOutlineView];
}

#pragma mark - container protocol

- (void)createHeaderView {
    self.headerView = [[UIView alloc] init];
}

- (void)createFooterView {
    self.footerView = [[UIView alloc] init];
}

- (void)createChildContentVC {
}

- (void)createChildOutlineVC {
}

- (void)createOutlineFooterView {
    self.outlineFooterView = [[UIView alloc] init];
}

- (void)setContentView {
    if (self.contentVC) {
        [self addChildViewController:self.contentVC];
        [self.contentVC willMoveToParentViewController:self];
        [self.contentVC beginAppearanceTransition:YES animated:YES];
        self.contentView = self.contentVC.view;
        [self.contentVC endAppearanceTransition];
        [self.contentVC didMoveToParentViewController:self];
    }
    else {
        self.contentView = [[UIView alloc] init];
    }
}

- (void)setOutlineView {
    if (self.outlineVC) {
        [self addChildViewController:self.outlineVC];
        [self.outlineVC willMoveToParentViewController:self];
        [self.outlineVC beginAppearanceTransition:YES animated:YES];
        self.outlineView = self.outlineVC.view;
        [self.outlineVC endAppearanceTransition];
        [self.outlineVC didMoveToParentViewController:self];
    }
    else {
        self.outlineView = [[UIView alloc] init];
    }
}

- (CGFloat)headerHeight {
    return 0.0;
}

- (CGFloat)headerWidth {
    return [Constants screenWidth];
}

- (CGFloat)headerVerticalMargin {
    return 0.0;
}

- (CGFloat)footerHeight {
    return 0.0;
}

- (CGFloat)footerWidth {
    return [Constants screenWidth]-[self minOutlineWidth];
}

- (CGFloat)footerVerticalMargin {
    return [Constants safeAreaInsets].bottom;
}

- (CGFloat)minOutlineWidth {
    return 0.0;
}

- (CGFloat)maxOutlineWidth {
    return [Constants screenWidth];
}

- (void)constraintViews {
    [self.view removeConstraintsMask];
    [self.backView removeConstraintsMask];
    
    [self.view constraintSidesForView:self.backView];
    
    [self.backView constraint:NSLayoutAttributeRight view:self.contentView];
    [self.backView constraint:NSLayoutAttributeLeft view:self.contentView margin:[self minOutlineWidth]];
    
    [self.backView constraintWidth:[self headerWidth] forView:self.headerView];
    [self.backView constraintHeight:[self headerHeight] forView:self.headerView];
    [self.backView constraint:NSLayoutAttributeCenterX view:self.headerView];
    [self.backView constraint:NSLayoutAttributeTop view:self.headerView margin:[self headerVerticalMargin]];

    [self.backView constraintWidth:[self footerWidth] forView:self.footerView];
    [self.backView constraintHeight:[self footerHeight] forView:self.footerView];
    [self.backView constraint:NSLayoutAttributeRight view:self.footerView];
    [self.backView constraint:NSLayoutAttributeLeft view:self.footerView margin:[self minOutlineWidth]];
    [self.backView constraint:NSLayoutAttributeBottom view:self.footerView margin:-[self footerVerticalMargin]];
    
    if (self.outlineFooterView) {
        
        [self.backView constraintHeight:[self footerHeight] forView:self.outlineFooterView];
        
        [self.backView constraintSame:NSLayoutAttributeRight view1:self.outlineView view2:self.outlineFooterView];
        [self.backView constraintSame:NSLayoutAttributeLeft view1:self.outlineView view2:self.outlineFooterView];
        [self.backView constraintSame:NSLayoutAttributeBottom view1:self.footerView view2:self.outlineFooterView];

        [self.backView addConstraintWithItem:self.outlineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.outlineFooterView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    }
    else {
        [self.backView constraint:NSLayoutAttributeBottom view:self.outlineView];
    }
    [self.backView constraint:NSLayoutAttributeLeft view:self.outlineView];
    [self.backView constraintSame:NSLayoutAttributeTop view1:self.outlineView view2:self.contentView];
    
    [self.backView constraintSame:NSLayoutAttributeRight view1:self.backFooterView view2:self.footerView];
    [self.backView constraintSame:NSLayoutAttributeLeft view1:self.backFooterView view2:self.outlineView];
    [self.backView constraint:NSLayoutAttributeBottom view:self.backFooterView];
    [self.backView constraintHeight:[self footerHeight]+[self footerVerticalMargin] forView:self.backFooterView];

    [self.backView addConstraintWithItem:self.headerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [self.backView addConstraintWithItem:self.footerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
   
    self.outLineWidthConstraint = [NSLayoutConstraint constraintWithItem:self.outlineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:[self minOutlineWidth]];
    [self.backView addConstraint:self.outLineWidthConstraint];
}

- (void)setExpanded:(BOOL)expanded completion:(void (^)(void))completion {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:[self.class animationDuration] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.outLineWidthConstraint.constant = expanded ? [self maxOutlineWidth] : [self minOutlineWidth];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

+ (NSTimeInterval)animationDuration {
    return 0.4;
}

- (void)dealloc {
    [self.contentVC.view removeFromSuperview];
    [self.contentVC removeFromParentViewController];
    
    [self.outlineVC.view removeFromSuperview];
    [self.outlineVC removeFromParentViewController];
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
