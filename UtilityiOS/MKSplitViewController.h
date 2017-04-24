//
//  MKSplitViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "TabBarSplitViewController.h"

@interface MKSplitViewController : TabBarSplitViewController

- (void)animateLogin;
- (void)animateLogout;

- (void)setSelectedTab:(TabBarIndex)index isShrunkednMenu:(BOOL)shrunken;

@end
