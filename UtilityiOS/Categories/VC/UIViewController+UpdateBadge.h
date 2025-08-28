//
//  UIViewController+UpdateBadge.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUBadgeItem.h"

@interface UIViewController (UpdateBadge)

@property (nonatomic, weak) id<MKUBadgeItemUpdateDelegate> badgeDelegate;

- (void)registerForBadgeUpdates;
- (void)updateBadgesWithNotification:(NSNotification *)notification;
- (void)updateBadges:(NSArray<MKUBadgeItem *> *)badges;

@end
