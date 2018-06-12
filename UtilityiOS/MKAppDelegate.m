//
//  AppDelegate.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKAppDelegate.h"
#import "MKNotificationController.h"
#import "MKSpinner.h"

@interface MKAppDelegate ()

@end

@implementation MKAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeInstances];
    [self setNotificationCateories];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self windowRootViewController];
    [self.window makeKeyAndVisible];
    
    [self.window addSubview:[MKSpinner spinner]];
    [[MKSpinner spinner] setWidth:[Constants SpinnerSize].width height:[Constants SpinnerSize].height];
    [self.window bringSubviewToFront:[MKSpinner spinner]];
    
    return YES;
}

- (void)initializeInstances {
    [AppTheme applyTheme];
}

- (void)setNotificationCateories {
}

- (UIViewController *)windowRootViewController {
    RaiseExceptionMissingMethodInClass
    return nil;
}

- (UINavigationController *)detailSplitViewController  {
    return nil;
}

#pragma mark - application

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:[Constants NotificationName_App_Terminated] object:self];
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


#pragma mark - notifications

// Add "remote-notification" to the list of your supported UIBackgroundModes in your Info.plist.

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [Constants setPushNotificationDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DEBUGLOG(@"%@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //Forground, notification tap
    [[MKNotificationController instance] handleDidReceiveLocalNotification:notification receiveType:NotificationReceiveType_Forground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[MKNotificationController instance] handleDidReceivePushNotificationWithIdentifier:nil forRemoteNotification:userInfo receiveType:NotificationReceiveType_Forground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[MKNotificationController instance] handleDidReceivePushNotificationWithIdentifier:nil forRemoteNotification:userInfo receiveType:NotificationReceiveType_Action_Background];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    [[MKNotificationController instance] handleDidReceiveLocalNotification:notification receiveType:NotificationReceiveType_Action_Background];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    //Button tap from notification center
    [[MKNotificationController instance] handleDidReceiveLocalNotification:notification receiveType:NotificationReceiveType_Action_Background];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    [[MKNotificationController instance] handleDidReceivePushNotificationWithIdentifier:identifier forRemoteNotification:userInfo receiveType:NotificationReceiveType_Action_Background];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    [[MKNotificationController instance] handleDidReceivePushNotificationWithIdentifier:identifier forRemoteNotification:userInfo receiveType:NotificationReceiveType_Action_Background];
}

@end
