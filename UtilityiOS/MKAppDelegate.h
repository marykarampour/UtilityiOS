//
//  AppDelegate.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-20.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (UIViewController *)visibleViewController;

//Abstract
- (UIViewController *)windowRootViewController;
- (UINavigationController *)detailSplitViewController;
/** @brief initializes instances and globals, called early when app launches. Call theme, notification, server controller etc. initializations here
 @code
 - (void)initializeInstances {
    [AppTheme applyTheme];
 }
 @endcode
 */
- (void)initializeInstances;

/** @brief call super on this whensubclass implements */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end

