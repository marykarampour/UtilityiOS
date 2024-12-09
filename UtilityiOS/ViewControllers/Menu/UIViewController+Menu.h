//
//  UIViewController+Menu.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-25.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUMenuObjects.h"
#import "UIViewController+UpdateBadge.h"
#import "MKUViewContentStyleProtocols.h"
#import "MKUViewControllerTransitionProtocol.h"

@interface UIViewController (Menu) <MKUMenuViewControllerProtocol, MKUViewControllerTransitionDelegate, MKURefreshViewControllerDelegate>

- (MKUMenuItemObject *)menuObjectAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)titleForItem:(NSIndexPath *)indexPath;
- (NSString *)subtitleForItem:(NSIndexPath *)indexPath;
- (NSString *)anyTitleForSection:(NSInteger)section;
- (void)updateMenuBadge:(MKUBadgeItem *)badge;

/** @brief By default all items have self as their transitionDelegate as long as they conforms to MKUViewControllerTransitionProtocol.
 It pops the navigation controller to self.
 It is called in viewController:didReturnWithResultType:andObject: */
- (void)handleViewController:(UIViewController *)viewController didReturnWithObject:(id)object;

@end
