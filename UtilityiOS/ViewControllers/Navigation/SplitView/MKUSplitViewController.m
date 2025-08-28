//
//  MKUSplitViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUSplitViewController.h"

@interface MKUSplitViewController ()

@end

@implementation MKUSplitViewController

- (void)updateMode {
    UISplitViewControllerDisplayMode mode = UISplitViewControllerDisplayModeAutomatic;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown: {
            mode = UISplitViewControllerDisplayModePrimaryHidden;
        }
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.4 animations:^{
        [self setPreferredDisplayMode:mode];
    }];
}

- (UINavigationController *)popDetailViewController:(BOOL)animated {
    UIViewController *detailViewController = [[self.viewControllers lastObject] topViewController];
    UINavigationController *nav = detailViewController.navigationController;
    [nav popToRootViewControllerAnimated:animated];
    [self updateMode];
    return nav;
}

@end
