//
//  MKHamburgerContainerViewController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-04-21.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKHamburgerContainerViewController.h"
#import "MKHamburgerViewController.h"
#import "UIViewController+Utility.h"
#import "UIView+Utility.h"

@interface MKHamburgerContainerViewController () {
    UIView *menuView;
}

@property (nonatomic, strong, readwrite) MKHamburgerViewController *menuVC;
@property (nonatomic, strong) NSLayoutConstraint *rightMarginConstraint;

@end

@implementation MKHamburgerContainerViewController

- (instancetype)init {
    return [self initWithMenuVC:[[MKHamburgerViewController alloc] init]];
}

- (instancetype)initWithMenuVC:(__kindof MKHamburgerViewController *)menuVC {
    if (self = [super init]) {
        self.menuVC = menuVC;
    }
    return self;
}

- (void)addChildViews {
    menuView = [[UIView alloc] init];
    [self setChildView:self.menuVC forSubView:&menuView];
    [self.view addSubview:menuView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViews];
    
    [self.view removeConstraintsMask];
    [self.view constraint:NSLayoutAttributeBottom view:menuView];
    [self.view constraint:NSLayoutAttributeTop view:menuView];
    [self.view constraintWidth:self.menuWidth forView:menuView];
    self.rightMarginConstraint = [NSLayoutConstraint constraintWithItem:menuView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    [self.view addConstraint:self.rightMarginConstraint];
    [self addTapWithAction:@selector(hideMenu)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)hideMenu {
    [self.menuVC hideMenuWithCompletion:nil];
}

- (void)updateMenuIsHidden:(BOOL)isHidden comletion:(void (^)(void))completion {
    [self.view layoutIfNeeded];
    self.rightMarginConstraint.constant = isHidden ? 0.0 : self.menuWidth;
    [UIView animateWithDuration:[Constants TransitionAnimationDuration] animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

@end
