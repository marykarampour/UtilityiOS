//
//  SplitViewManager.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUTabBarSplitViewController.h"

@interface SplitViewManager : NSObject

@property (nonatomic, strong) __kindof MKUTabBarSplitViewController *splitViewController;

+ (instancetype)instance;
- (UIViewController *)windowRootViewController;
- (UIBarButtonItem *)logoutButton;

@end
