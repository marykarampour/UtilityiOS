//
//  SplitViewManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "SplitViewManager.h"
#import "BaseDetailViewController.h"
#import "LoginViewController.h"
#import "NSObject+Utility.h"

@interface SplitViewManager () <UIAlertViewDelegate>

@end

@implementation SplitViewManager

+ (instancetype)instance {
    static SplitViewManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SplitViewManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        NSArray<__kindof MasterDetailNavControllerPair *> * navPairs =
        @[[NSObject masterDetailNavPairFor:[MasterViewController class] detailClass:[LoginViewController class] title:@"Title" icon:@"icon"]];
        
        self.splitViewController = [[MKSplitViewController alloc] initWithMasterDetailPairs:navPairs secondaryDetailViewController:[[BaseDetailViewController alloc] init]];
    }
    return self;
}

- (UIViewController *)windowRootViewController {
    return self.splitViewController.splitViewController;
}

- (UIBarButtonItem *)logoutButton {
    return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString([Constants ExitTitle_STR], nil) style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
}

- (void)logout {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString([Constants ExitTitle_STR], nil) message:NSLocalizedString(@"Are you sure you want to exit?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"YES", nil) otherButtonTitles:NSLocalizedString(@"Cancel", nil), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:NSLocalizedString([Constants ExitTitle_STR], nil)] && buttonIndex == 0) {
        [[SplitViewManager instance].splitViewController animateLogout];
    }
}

@end
