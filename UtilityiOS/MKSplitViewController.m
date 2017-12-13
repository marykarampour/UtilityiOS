//
//  MKSplitViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKSplitViewController.h"
#import "TabBarSplitViewController_Extension.h"
#import "UINavigationController+Transition.h"

#import "ShrunkenMenuViewController.h"
#import "BaseDetailViewController.h"
#import "LoginViewController.h"

@implementation MKSplitViewController

- (instancetype)initWithMasterDetailPairs:(NSArray<__kindof MasterDetailNavControllerPair *> *)pairs secondaryDetailViewController:(UIViewController *)detailViewController {
    if (self = [super initWithMasterDetailPairs:pairs secondaryDetailViewController:detailViewController]) {
        self.splitViewController.view.backgroundColor = [AppTheme VCBackgroundColor];
    }
    return self;
}

#pragma mark - login/out

- (void)animateLogin {
    [[self splitViewDetailMainNavController] popToRootFromBottomViewControllerWithDuration:[Constants TransitionAnimationDuration]];
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
    [(MKTableViewController *)[self selectedTabViewController] reloadDataAnimated:NO];
}

- (void)animateLogout {
    for (NSUInteger i=TabBarIndexFirst; i<TabBarIndexCount; i++) {
        [self popToRootWithFade:NO forTabItem:i];
    }
    [self setSelectedTab:TabBarIndexFirst];
    [self hideDetailBackground];
    [self updatePrimaryViewWithState:PrimaryViewStateHidden];
    [self performSelector:@selector(hideNavigationBar) withObject:nil afterDelay:[Constants TransitionAnimationDuration]];
    [self performSelector:@selector(popToLoginScreen) withObject:nil afterDelay:(2 * [Constants TransitionAnimationDuration])];
}

- (void)hideNavigationBar {
    [[self splitViewDetailMainNavController] setNavigationBarHidden:YES animated:YES];
}

- (void)popToLoginScreen {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [[self splitViewDetailMainNavController] pushToBottomViewController:loginViewController withDuration:[Constants TransitionAnimationDuration]];
}

#pragma mark - updating views
//examples:
//- (void)reloadWithShrunkednMenuForReport:(id)data {
//    MasterDetailViewControllerPair *pair = [NSObject masterDetailViewPairFor:[PQRShrunkenMenuViewController class] detailClass:[PQRSpecialReportViewController class] tabItem:PQRTabBarIndexWizard];
//    pair.master.hidesBottomBarWhenPushed = YES;
//    ((PQRSpecialReportViewController *)pair.detail).charts = data;
//    [self pushWithFade:YES pair:pair forTabItem:PQRTabBarIndexWizard];
//    [self updatePrimaryViewWithState:PrimaryViewStateShrunken];
//}
//
//- (void)editSession {
//    MasterDetailViewControllerPair *pair = [NSObject masterDetailViewPairFor:[PQRUnitsListViewController class] detailClass:[PQRUnitViewController class] tabItem:PQRTabBarIndexSessions];
//    [self pushWithFade:YES pair:pair forTabItem:PQRTabBarIndexSessions];
//}
//
- (void)didAfterSelectingTabItem:(TabBarIndex)index {
    MasterViewController *master = (MasterViewController *)self.pairs[index].master.visibleViewController;
    PrimaryViewState state = ([master isKindOfClass:[ShrunkenMenuViewController class]] ? PrimaryViewStateShrunken : PrimaryViewStateVisible);
    [self updatePrimaryViewWithState:state];
}

@end
