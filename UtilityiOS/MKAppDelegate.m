//
//  AppDelegate.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKAppDelegate.h"
#import "MKSpinner.h"

@interface MKAppDelegate ()

@end

@implementation MKAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeInstances];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self windowRootViewController];
    [self.window makeKeyAndVisible];
    
    [self.window addSubview:[MKSpinner spinner]];
    [self.window bringSubviewToFront:[MKSpinner spinner]];
    
    return YES;
}

- (void)initializeInstances {
}

- (UIViewController *)windowRootViewController {
    RaiseExceptionMissingMethodInClass
    return nil;
}

- (UINavigationController *)detailSplitViewController  {
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (UIViewController *)visibleViewController {
    UIViewController *vc = self.window.rootViewController;
    return [self visibleViewControllerFor:vc];
}

- (UIViewController *)visibleViewControllerFor:(UIViewController *)vc {
    if ([vc isKindOfClass:[UISplitViewController class]]) {
        return [self visibleViewControllerFor:[self detailSplitViewController]];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self visibleViewControllerFor:((UINavigationController *)vc).visibleViewController];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self visibleViewControllerFor:((UITabBarController *)vc).selectedViewController];
    }
    else if (vc.presentedViewController) {
        return [self visibleViewControllerFor:vc.presentedViewController];
    }
    else {
        return vc;
    }
    return vc;
}



@end
