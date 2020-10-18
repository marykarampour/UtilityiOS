//
//  MKHeaderFooterContainerViewController.m
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-18.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKHeaderFooterContainerViewController.h"
#import "UIViewController+Utility.h"
#import "UIView+Utility.h"

@interface MKHeaderFooterContainerViewController ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign, readwrite) HEADER_CONTAINER_TYPE type;

@property (nonatomic, strong) NSLayoutConstraint *footerHeightConstraint;

@end

@implementation MKHeaderFooterContainerViewController

- (instancetype)init {
    return [self initWithHeaderType:HEADER_CONTAINER_TYPE_DEFAULT];
}

- (instancetype)initWithChildObject:(NSObject *)object {
    return [self initWithHeaderType:HEADER_CONTAINER_TYPE_DEFAULT childObject:object];
}

- (instancetype)initWithHeaderType:(HEADER_CONTAINER_TYPE)type {
    return [self initWithHeaderType:type childObject:nil];
}

- (instancetype)initWithHeaderType:(HEADER_CONTAINER_TYPE)type childObject:(NSObject *)object {
    if (self = [super init]) {
        self.type = type;
        [self createChildVCWithChildObject:object];
        self.headerChildDelegate = self.childViewController;
        self.childViewController.headerDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self removeBackBarButtonText];
    [self addTapToDismissKeyboard];
    
    [self constructNextButton];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    [self.nextButton setEnabled:NO];
    
    [self createHeaderView];
    [self createFooterView];
    [self setContentView];
    self.backView = [[UIView alloc] init];
    
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.contentView];
    [self.backView addSubview:self.headerView];
    [self.backView addSubview:self.footerView];
    
    [self constraintViews];
}

- (void)constructNextButton {
    [self createNextButtonWithType:NAV_BAR_ITEM_TYPE_TITLE systemItem:0 image:nil];
}

- (void)createNextButtonWithType:(NAV_BAR_ITEM_TYPE)type systemItem:(UIBarButtonSystemItem)item image:(UIImage *)image {
    self.nextButton = [self navBarButtonWithAction:@selector(nextPressed:) type:type title:[Constants Next_STR] systemItem:item image:image];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self constraintViews];
}

- (void)createHeaderView {
    self.headerView = [[UIView alloc] init];
}

- (void)createFooterView {
    self.footerView = [[UIView alloc] init];
}

- (CGFloat)maxFooterHeight {
    return 256.0;
}

- (void)createChildVC {
}

- (void)createChildVCWithChildObject:(NSObject *)object {
    [self createChildVC];
}

- (void)setContentView {
    if (self.childViewController) {
        [self addChildViewController:self.childViewController];
        [self.childViewController willMoveToParentViewController:self];
        [self.childViewController beginAppearanceTransition:YES animated:YES];
        self.contentView = self.childViewController.view;
        [self.childViewController endAppearanceTransition];
        [self.childViewController didMoveToParentViewController:self];
    }
    else {
        self.contentView = [[UIView alloc] init];
    }
}

- (void)setObject:(id)object {
    _object = object;
    self.childViewController.object = self.object;
}

- (void)nextPressed:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    if ([self.headerChildDelegate respondsToSelector:@selector(nextPressed:)]) {
        [self.headerChildDelegate nextPressed:self.nextButton];
    }
}

- (void)headerNextSetEnabled:(BOOL)enabled {
    self.nextButton.enabled = enabled;
}

- (void)headerNextSetHidden:(BOOL)hidden {
    self.navigationItem.rightBarButtonItem = (hidden ? nil : self.nextButton);
}

- (void)headerNextSetTitle:(NSString *)title {
    self.nextButton.title = title;
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
    return [Constants screenWidth];
}

- (CGFloat)footerVerticalMargin {
    return 0.0;
}

- (void)constraintViews {
    
    if (self.footerHeightConstraint) return;
    
    [self.view removeConstraintsMask];
    [self.backView removeConstraintsMask];
    
    [self.view constraintSidesForView:self.backView];
    [self.backView constraint:NSLayoutAttributeLeft view:self.contentView];
    [self.backView constraint:NSLayoutAttributeRight view:self.contentView];
    
    [self.backView constraintWidth:[self headerWidth] forView:self.headerView];
    [self.backView constraintHeight:[self headerHeight] forView:self.headerView];
    [self.backView constraint:NSLayoutAttributeTop view:self.headerView margin:[self headerVerticalMargin]];
    
    [self.backView constraintWidth:[self footerWidth] forView:self.footerView];
    [self.backView constraint:NSLayoutAttributeBottom view:self.footerView];
    
    [self.backView constraintSame:NSLayoutAttributeCenterX view1:self.headerView view2:self.contentView];
    [self.backView constraintSame:NSLayoutAttributeCenterX view1:self.footerView view2:self.contentView];
    
    [self.backView addConstraintWithItem:self.headerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [self.backView addConstraintWithItem:self.footerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:[self footerVerticalMargin]];
    
    self.footerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.footerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:[self footerHeight]];
    [self.backView addConstraint:self.footerHeightConstraint];
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
