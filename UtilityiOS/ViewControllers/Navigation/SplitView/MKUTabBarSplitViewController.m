//
//  TabBarSplitViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUTabBarSplitViewController.h"
#import "TabBarSplitViewController_Extension.h"
#import "UINavigationController+Transition.h"
#import "ShrunkenMenuViewController.h"
#import "BaseDetailViewController.h"
#import "LoginViewController.h"
#import "MKUPair.h"

@interface MKUTabBarSplitViewController () <UISplitViewControllerDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong, readwrite) UITabBarController *primaryTabBarController;

@property (nonatomic, strong, readwrite) NSArray<__kindof MasterDetailNavControllerPair *> *pairs;
@property (nonatomic, strong) NSArray<__kindof UINavigationController *> *detailNavigationControllers;

@property (nonatomic, assign) Class initialViewControllerClass;

@end

@implementation MKUTabBarSplitViewController

- (instancetype)init {
    return [self initWithBaseMasterDetailPair:nil];
}

- (instancetype)initWithBaseMasterDetailPair:(MasterDetailNavControllerPair *)pair {
    if (self = [super init]) {
        self.primaryTabBarController = [[UITabBarController alloc] init];
        self.primaryTabBarController.delegate = self;
        self.primaryTabBarController.tabBar.hidden = YES;
        
        self.splitViewController = [[MKUSplitViewController alloc] init];
        self.splitViewController.view.backgroundColor = [AppTheme VCBackgroundColor];
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        self.splitViewController.maximumPrimaryColumnWidth = [Constants MaxPrimaryColumnWidth];
        self.splitViewController.minimumPrimaryColumnWidth = [Constants MinPrimaryColumnWidth];
        self.splitViewController.preferredPrimaryColumnWidthFraction = 0.0;
        
        if (pair) [self setMasterDetailPair:pair];
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
        [self pushWithType:MKU_TABBAR_SPLIT_POPTOROOT_TYPE_BOTTOM pair:pairVC forTabItem:0];
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

- (void)pushWithType:(MKU_TABBAR_SPLIT_POPTOROOT_TYPE)type pair:(MasterDetailViewControllerPair * _Nonnull)pair forTabItem:(TabBarIndex)index {
    switch (type) {
        case MKU_TABBAR_SPLIT_POPTOROOT_TYPE_FADE: {
            [(UINavigationController *)self.pairs[index].master pushWithFadeViewController:pair.master withDuration:[Constants TransitionAnimationDuration]];
            [(UINavigationController *)self.pairs[index].detail pushWithFadeViewController:pair.detail withDuration:2*[Constants TransitionAnimationDuration]];
        }
            break;
        case MKU_TABBAR_SPLIT_POPTOROOT_TYPE_BOTTOM: {
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

- (void)popToRootWithType:(MKU_TABBAR_SPLIT_POPTOROOT_TYPE)type forTabItem:(TabBarIndex)index {
    switch (type) {
        case MKU_TABBAR_SPLIT_POPTOROOT_TYPE_FADE: {
            [(UINavigationController *)self.primaryTabBarController.viewControllers[index] popWithFadeViewControllerWithDuration:[Constants TransitionAnimationDuration]];
            [(UINavigationController *)self.detailNavigationControllers[index] popWithFadeViewControllerWithDuration:2*[Constants TransitionAnimationDuration]];
        }
            break;
        case MKU_TABBAR_SPLIT_POPTOROOT_TYPE_BOTTOM: {
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
        [self popToRootWithType:MKU_TABBAR_SPLIT_POPTOROOT_TYPE_DEFAULT forTabItem:0];
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
    
    [UIView animateWithDuration:[Constants TransitionAnimationDuration] animations:^{
        self.splitViewController.preferredPrimaryColumnWidthFraction = width/[Constants screenWidth];
        self.primaryTabBarController.tabBar.hidden = (self.primaryTabBarController.viewControllers.count <= 1) || (state == PrimaryViewStateVisible ? NO : YES);
    }];
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

#pragma mark - login/out

- (void)animateLogin {
    //    [[self splitViewDetailMainNavController] popToRootFromBottomViewControllerWithDuration:[Constants TransitionAnimationDuration]];
    [self performSelector:@selector(showNavigationBar) withObject:nil afterDelay:[Constants TransitionAnimationDuration]];
    [self performSelector:@selector(showPrimaryView) withObject:nil afterDelay:(2*[Constants TransitionAnimationDuration])];
    [self performSelector:@selector(showPrimaryListNavigationController) withObject:nil afterDelay:(3*[Constants TransitionAnimationDuration])];
    [self performSelector:@selector(showDetailBackground) withObject:nil afterDelay:(4*[Constants TransitionAnimationDuration])];
}

- (void)showDetailBackground {
    [(BaseDetailViewController *)self.detailViewController setBackgroundHidden:NO];
}

- (void)hideDetailBackground {
    [(BaseDetailViewController *)self.detailViewController setBackgroundHidden:YES];
}

- (void)showNavigationBar {
    [[self splitViewDetailMainNavController] setNavigationBarHidden:NO animated:YES];
}

- (void)showPrimaryView {
    [self updatePrimaryViewWithState:PrimaryViewStateVisible];
}

- (void)showPrimaryListNavigationController {
    [(MKUTableViewController *)[self selectedTabViewController] reloadDataAnimated:NO];
}

- (void)animateLogout {
    [self setSelectedTab:0];
    [self performSelector:@selector(hideDetailBackground) withObject:nil afterDelay:[Constants TransitionAnimationDuration]];
    [self performSelector:@selector(hideNavigationBar) withObject:nil afterDelay:[Constants TransitionAnimationDuration]];
    [self performSelector:@selector(presentLoginView) withObject:nil afterDelay:(2*[Constants TransitionAnimationDuration])];
}

- (void)presentLoginView {
    [self popToLoginScreen];
    [self clearNavPairs];
    [self updatePrimaryViewWithState:PrimaryViewStateHidden];
}

- (void)didLogout {
}


- (void)hideNavigationBar {
    [[self splitViewDetailMainNavController] setNavigationBarHidden:YES animated:YES];
}

- (void)popToLoginScreen {
    [self popToRootWithType:MKU_TABBAR_SPLIT_POPTOROOT_TYPE_BOTTOM forTabItem:0];
}

#pragma mark - updating views

- (void)didAfterSelectingTabItem:(TabBarIndex)index {
    MasterViewController *master = (MasterViewController *)self.pairs[index].master.visibleViewController;
    PrimaryViewState state = ([master isKindOfClass:[ShrunkenMenuViewController class]] ? PrimaryViewStateShrunken : PrimaryViewStateVisible);
    [self updatePrimaryViewWithState:state];
}

#pragma mark - abstracts

- (MasterDetailNavControllerPair *)basePair {
    return nil;
}

- (StringArr *)tabbarImages {
    return nil;
}

- (void)pushViewControllerPairs {
}

@end
