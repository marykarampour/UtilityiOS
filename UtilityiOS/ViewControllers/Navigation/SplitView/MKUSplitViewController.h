//
//  MKUSplitViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKUSplitViewController : UISplitViewController

- (void)updateMode;
/** @brief Pops detail ViewController to root and returns the corresponding NavigationController. */
- (UINavigationController *)popDetailViewController:(BOOL)animated;

@end
