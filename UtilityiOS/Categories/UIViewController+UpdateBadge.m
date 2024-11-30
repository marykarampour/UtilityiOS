//
//  UIViewController+UpdateBadge.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIViewController+UpdateBadge.h"
#import "MKUNotificationCenter.h"
#import <objc/runtime.h>

static char BADGE_DELEGATE_KEY;

@implementation UIViewController (UpdateBadge)

@dynamic badgeDelegate;

- (id<MKUBadgeItemUpdateDelegate>)badgeDelegate {
    return objc_getAssociatedObject(self, &BADGE_DELEGATE_KEY);
}

- (void)setBadgeDelegate:(id<MKUBadgeItemUpdateDelegate>)badgeDelegate {
    objc_setAssociatedObject(self, &BADGE_DELEGATE_KEY, badgeDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)registerForBadgeUpdates {
    [MKUNotificationCenter registerBadgeNotificationWithTarget:self action:@selector(updateBadgesWithNotification:)];
}

- (void)updateBadges:(NSArray<MKUBadgeItem *> *)badges {
    if (![self.badgeDelegate respondsToSelector:@selector(updateBadge:)]) return;
    
    for (MKUBadgeItem *badge in badges) {
        [self.badgeDelegate updateBadge:badge];
    }
    
    if ([self.badgeDelegate respondsToSelector:@selector(combinedBadgeNames)]) {
        for (NSString *name in [self.badgeDelegate combinedBadgeNames]) {
            [self updateCombinedBadge:name withBadges:badges];
        }
    }
}

- (void)updateCombinedBadge:(NSString *)name withBadges:(NSArray<MKUBadgeItem *> *)badges {
    
    NSInteger combinedType = -1;
    NSUInteger count = 0;
    MKUBadgeItem *badge = [MKUBadgeItem badgeWithName:name];
    
    for (MKUBadgeItem *obj in badges) {
        if (obj.type & badge.type) {
            combinedType = combinedType | obj.type;
            count += obj.count.integerValue;
        }
    }
    
    if (combinedType != badge.type) return;
    
    badge.count = @(count);
    
    [self.badgeDelegate updateBadge:badge];
}

- (void)updateBadgesWithNotification:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[NSArray<MKUBadgeItem *> class]]) {
        NSArray<MKUBadgeItem *> *badges = notification.object;
        [self updateBadges:badges];
    }
}

@end

