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
#import "ServerController.h"
#import "NSObject+Utility.h"
#import "NSObject+Alert.h"
#import "MKUSpinner.h"

@interface SplitViewManager ()

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
    }
    return self;
}

- (UIViewController *)windowRootViewController {
    return self.splitViewController.splitViewController;
}

- (UIBarButtonItem *)logoutButton {
    return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString([Constants Exit_Title_STR], nil) style:UIBarButtonItemStylePlain target:self action:@selector(logoutAlert)];
}

- (void)logoutAlert {
    [self actionAlertWithTitle:[Constants Exit_Title_STR] message:[Constants Exit_Message_STR] alertAction:@selector(logout)];
}

- (void)logout {
    [MKUSpinner show];
    [ServerController logoutUserWithCompletion:^(id result, NSError *error) {
        [MKUSpinner hide];
        [self.splitViewController didLogout];
        [[SplitViewManager instance].splitViewController animateLogout];
    }];
}

@end
