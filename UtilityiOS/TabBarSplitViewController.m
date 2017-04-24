//
//  TabBarSplitViewController.m
//  PQR
//
//  Created by Maryam Karampour on 2017-01-01.
//  Copyright © 2017 Team Solutions. All rights reserved.
//

#import "TabBarSplitViewController.h"
#import "TabBarSplitViewController_Extension.h"
#import "UINavigationController+Transition.h"


@interface TabBarSplitViewController () <UISplitViewControllerDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITabBarController *primaryTabBarController;

@property (nonatomic, strong, readwrite) NSArray<__kindof MasterDetailNavControllerPair *> *pairs;
@property (nonatomic, strong) NSArray<__kindof UINavigationController *> *detailNavigationControllers;

@property (nonatomic, assign) Class initialViewControllerClass;

@end

@implementation TabBarSplitViewController

- (instancetype)init {
    return [self initWithMasterDetailPairs:@[] secondaryDetailViewController:[[UIViewController alloc] init]];
}

- (instancetype)initWithMasterDetailPairs:(NSArray<__kindof MasterDetailNavControllerPair *> *)pairs secondaryDetailViewController:(UIViewController *)detailViewController {
    if (self = [super init]) {
        
        self.detailViewController = detailViewController;
        
        self.pairs = pairs;
        if (pairs.count > 0) {
            self.initialViewControllerClass = [self.pairs[0].detail.viewControllers[0] class];
        }
        
        NSMutableArray *detailNavigationControllers = [[NSMutableArray alloc] init];
        for (MasterDetailNavControllerPair *nav in self.pairs) {
            [detailNavigationControllers addObject:nav.detail];
        }
        self.detailNavigationControllers = detailNavigationControllers;
        
        NSMutableArray *masterNavigationControllers = [[NSMutableArray alloc] init];
        for (MasterDetailNavControllerPair *nav in self.pairs) {
            [masterNavigationControllers addObject:nav.master];
        }
        
        self.primaryTabBarController = [[UITabBarController alloc] init];
        self.primaryTabBarController.delegate = self;
        self.primaryTabBarController.viewControllers = masterNavigationControllers;
        self.primaryTabBarController.tabBar.hidden = YES;
        
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.maximumPrimaryColumnWidth = 1024;
        self.splitViewController.minimumPrimaryColumnWidth = 0;
        self.splitViewController.preferredPrimaryColumnWidthFraction = 0.0;
        
        self.splitViewController.viewControllers = @[self.primaryTabBarController, self.detailNavigationControllers[0]];
        
        self.detailNavigationControllers[0].delegate = self;

    }
    return self;
}

#pragma mark - transition & navigation

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (navigationController == [self splitViewDetailMainNavController]) {
        if ([viewController isKindOfClass:self.initialViewControllerClass]) {
            if ([navigationController.viewControllers indexOfObject:viewController] == 0) {
                [self setRootDetailNavWithView:self.detailViewController];
            }
        }
    }
}

- (void)setRootDetailNavWithView:(UIViewController *)viewController {
    UINavigationController *detailNav = [self splitViewDetailMainNavController];
    NSMutableArray<__kindof UIViewController *> *viewControllers = [detailNav.viewControllers mutableCopy];
    [viewControllers insertObject:viewController atIndex:0];
    detailNav.viewControllers = viewControllers;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger index = self.primaryTabBarController.selectedIndex;
    [self.splitViewController showDetailViewController:self.detailNavigationControllers[index] sender:nil];
    [self didAfterSelectingTabItem:index];
}

- (void)pushWithFade:(BOOL)fade pair:(MasterDetailViewControllerPair * _Nonnull)pair forTabItem:(TabBarIndex)index {
    if (fade) {
        [(UINavigationController *)self.pairs[index].master pushWithFadeViewController:pair.master withDuration:TransitionAnimationDuration];
        [(UINavigationController *)self.pairs[index].detail pushWithFadeViewController:pair.detail withDuration:2*TransitionAnimationDuration];
    }
    else {
        [(UINavigationController *)self.pairs[index].master pushViewController:pair.master animated:NO];
        [(UINavigationController *)self.pairs[index].detail pushViewController:pair.detail animated:NO];
    }
}

- (void)popToRootWithFade:(BOOL)fade forTabItem:(TabBarIndex)index {
    if (fade) {
        [(UINavigationController *)self.primaryTabBarController.viewControllers[index] popWithFadeViewControllerWithDuration:TransitionAnimationDuration];
        [(UINavigationController *)self.detailNavigationControllers[index] popWithFadeViewControllerWithDuration:2*TransitionAnimationDuration];
    }
    else {
        [(UINavigationController *)self.primaryTabBarController.viewControllers[index] popToRootViewControllerAnimated:NO];
        [(UINavigationController *)self.detailNavigationControllers[index] popToRootViewControllerAnimated:NO];
    }
    [self updatePrimaryViewWithState:PrimaryViewStateVisible];
}

#pragma mark - animation

- (void)updatePrimaryViewWithState:(PrimaryViewState)state {
    CGFloat width = 0.0;
    switch (state) {
        case PrimaryViewStateVisible:
            width = PrimaryColumnWidth;
            break;
        case PrimaryViewStateShrunken:
            width = PrimaryColumnShrunkenWidth;
            break;
        default:
            break;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:TransitionAnimationDuration];
    
    self.splitViewController.preferredPrimaryColumnWidthFraction = width/[AppCommon screenWidth];
    self.primaryTabBarController.tabBar.hidden = (state == PrimaryViewStateVisible ? NO : YES);
    [UIView commitAnimations];
}

#pragma mark - helper methods

- (UINavigationController *)splitViewDetailMainNavController {
    return self.splitViewController.viewControllers[1];
}

- (UIViewController *)splitViewMasterController {
    return self.splitViewController.viewControllers[0];
}

- (UIViewController *)selectedTabViewController {
    UINavigationController *selectedNav = self.primaryTabBarController.selectedViewController;
    return (UIViewController *)selectedNav.visibleViewController;
}

- (void)setSelectedTab:(TabBarIndex)index {
    self.primaryTabBarController.selectedIndex = index;
    UIViewController *master = self.pairs[index].master.visibleViewController;
    [self tabBarController:self.primaryTabBarController didSelectViewController:master];
}


#pragma mark - abstracts

- (void)didAfterSelectingTabItem:(TabBarIndex)index {
}

@end
