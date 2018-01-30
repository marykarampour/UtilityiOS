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

@property (nonatomic, strong, readwrite) UITabBarController *primaryTabBarController;

@property (nonatomic, strong, readwrite) NSArray<__kindof MasterDetailNavControllerPair *> *pairs;
@property (nonatomic, strong) NSArray<__kindof UINavigationController *> *detailNavigationControllers;

@property (nonatomic, assign) Class initialViewControllerClass;

@end

@implementation TabBarSplitViewController

- (instancetype)init {
    return [self initWithBaseMasterDetailPair:nil];
}

- (instancetype)initWithBaseMasterDetailPair:(MasterDetailNavControllerPair *)pair {
    if (self = [super init]) {
        self.primaryTabBarController = [[UITabBarController alloc] init];
        self.primaryTabBarController.delegate = self;
        self.primaryTabBarController.tabBar.hidden = YES;
        
        self.splitViewController = [[UISplitViewController alloc] init];
        if (pair) {
            [self setMasterDetailPair:pair];
        }
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        self.splitViewController.maximumPrimaryColumnWidth = [Constants MaxPrimaryColumnWidth];
        self.splitViewController.minimumPrimaryColumnWidth = [Constants MinPrimaryColumnWidth];
        self.splitViewController.preferredPrimaryColumnWidthFraction = 0.0;
    }
    return self;
}

- (void)setMasterDetailPair:(MasterDetailNavControllerPair *)pair {
    self.pairs = @[pair];
    self.initialViewControllerClass = [pair.detail.viewControllers[0] class];
    self.detailNavigationControllers = @[pair.detail];
    self.primaryTabBarController.viewControllers = @[pair.master];
    self.detailNavigationControllers[0].delegate = self;
    self.splitViewController.viewControllers = @[self.primaryTabBarController, self.detailNavigationControllers[0]];
}

- (void)pushToBase:(MasterDetailNavControllerPair *)pair addMasterDetailPairs:(NSArray<__kindof MasterDetailNavControllerPair *> *)pairs {
    if (pair) {//TODO: put a dummy in between 0 and 1 for pop to login screen, select tab 0, pop to dummy, pop to root animated
        MasterDetailViewControllerPair *pairVC = [[MasterDetailViewControllerPair alloc] initWithNavPair:pair];
        [self pushWithType:PopToRootType_Bottom pair:pairVC forTabItem:0];
    }
    if (pairs.count) {
        NSMutableArray *newPairs = [[NSMutableArray alloc] initWithArray:self.pairs];
        [newPairs addObjectsFromArray:pairs];
        self.pairs = newPairs;
        
        NSMutableArray *detailNavigationControllers = [[NSMutableArray alloc] init];
        for (MasterDetailNavControllerPair *nav in self.pairs) {
            [detailNavigationControllers addObject:nav.detail];
        }
        self.detailNavigationControllers = detailNavigationControllers;
        
        NSMutableArray *masterNavigationControllers = [[NSMutableArray alloc] init];
        for (MasterDetailNavControllerPair *nav in self.pairs) {
            [masterNavigationControllers addObject:nav.master];
        }
        
        self.primaryTabBarController.viewControllers = masterNavigationControllers;
    }
}

- (NSUInteger)tabCount {
    return self.primaryTabBarController.viewControllers.count;
}

#pragma mark - transition & navigation

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//
//    if (navigationController == [self splitViewDetailMainNavController]) {
//        if ([viewController isKindOfClass:self.initialViewControllerClass]) {
//            if ([navigationController.viewControllers indexOfObject:viewController] == 0) {
//                [self setRootDetailNavWithView:self.detailViewController];
//            }
//        }
//    }
//}

- (void)setRootDetailNavWithView:(UIViewController *)viewController {
    UINavigationController *detailNav = [self splitViewDetailMainNavController];
    NSMutableArray<__kindof UIViewController *> *viewControllers = [detailNav.viewControllers mutableCopy];
    [viewControllers insertObject:viewController atIndex:0];
    detailNav.viewControllers = viewControllers;
}

- (void)setRootPair:(MasterDetailViewControllerPair *)pair {
    UINavigationController *detailNav = [self splitViewDetailMainNavController];
    NSMutableArray<__kindof UIViewController *> *viewControllers = [detailNav.viewControllers mutableCopy];
    [viewControllers insertObject:pair.detail atIndex:0];
    detailNav.viewControllers = viewControllers;
    
    UINavigationController *masterNav = (UINavigationController *)[self splitViewMasterController].viewControllers[0];
    if ([masterNav isKindOfClass:[UINavigationController class]]) {
        
        NSMutableArray<__kindof UIViewController *> *viewControllers = [masterNav.viewControllers mutableCopy];
        [viewControllers insertObject:pair.master atIndex:0];
        masterNav.viewControllers = viewControllers;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger index = self.primaryTabBarController.selectedIndex;
    [self.splitViewController showDetailViewController:self.detailNavigationControllers[index] sender:nil];
    [self didAfterSelectingTabItem:index];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return (viewController != tabBarController.selectedViewController);
}

- (void)pushWithType:(PopToRootType)type pair:(MasterDetailViewControllerPair * _Nonnull)pair forTabItem:(TabBarIndex)index {
    switch (type) {
        case PopToRootType_Fade: {
            [(UINavigationController *)self.pairs[index].master pushWithFadeViewController:pair.master withDuration:[Constants TransitionAnimationDuration]];
            [(UINavigationController *)self.pairs[index].detail pushWithFadeViewController:pair.detail withDuration:2*[Constants TransitionAnimationDuration]];
        }
            break;
        case PopToRootType_Bottom: {
            [(UINavigationController *)self.primaryTabBarController.viewControllers[index] pushToBottomViewController:pair.master withDuration:[Constants TransitionAnimationDuration]];
            [(UINavigationController *)self.detailNavigationControllers[index] pushToBottomViewController:pair.detail withDuration:2*[Constants TransitionAnimationDuration]];
        }
            break;
        default: {
            [(UINavigationController *)self.pairs[index].master pushViewController:pair.master animated:NO];
            [(UINavigationController *)self.pairs[index].detail pushViewController:pair.detail animated:NO];
        }
            break;
    }
}

- (void)popToRootWithType:(PopToRootType)type forTabItem:(TabBarIndex)index {
    switch (type) {
        case PopToRootType_Fade: {
            [(UINavigationController *)self.primaryTabBarController.viewControllers[index] popWithFadeViewControllerWithDuration:[Constants TransitionAnimationDuration]];
            [(UINavigationController *)self.detailNavigationControllers[index] popWithFadeViewControllerWithDuration:2*[Constants TransitionAnimationDuration]];
        }
            break;
        case PopToRootType_Bottom: {
            [(UINavigationController *)self.primaryTabBarController.viewControllers[index] popToRootFromBottomViewControllerWithDuration:[Constants TransitionAnimationDuration]];
            [(UINavigationController *)self.detailNavigationControllers[index] popToRootFromBottomViewControllerWithDuration:2*[Constants TransitionAnimationDuration]];
        }
            break;
        default: {
            [(UINavigationController *)self.primaryTabBarController.viewControllers[index] popToRootViewControllerAnimated:NO];
            [(UINavigationController *)self.detailNavigationControllers[index] popToRootViewControllerAnimated:NO];
        }
            break;
    }
    [self updatePrimaryViewWithState:PrimaryViewStateVisible];
}

- (void)clearNavPairs {
    if (self.pairs.count) {
        [self popToRootWithType:PopToRootType_Default forTabItem:0];
        self.pairs = @[self.pairs[0]];
    }
    if (self.primaryTabBarController.viewControllers.count) {
        self.primaryTabBarController.viewControllers = @[self.primaryTabBarController.viewControllers[0]];
    }
}

#pragma mark - animation

- (void)updatePrimaryViewWithState:(PrimaryViewState)state {
    CGFloat width = 0.0;
    switch (state) {
        case PrimaryViewStateVisible:
            width = [Constants PrimaryColumnWidth];
            break;
        case PrimaryViewStateShrunken:
            width = [Constants PrimaryColumnShrunkenWidth];
            break;
        default:
            break;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[Constants TransitionAnimationDuration]];
    
    self.splitViewController.preferredPrimaryColumnWidthFraction = width/[Constants screenWidth];
    self.primaryTabBarController.tabBar.hidden = (self.primaryTabBarController.viewControllers.count <= 1) || (state == PrimaryViewStateVisible ? NO : YES);
    [UIView commitAnimations];
}

#pragma mark - helper methods

- (UINavigationController *)splitViewDetailMainNavController {
    return self.splitViewController.viewControllers[1];
}

- (UITabBarController *)splitViewMasterController {
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
