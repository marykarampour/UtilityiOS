//
//  MKUNotificationCenter.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUNotificationCenter.h"

@implementation MKUNotificationCenter

+ (void)postUpdateBadgeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKU_UPDATE_BADGE_NOTIFICATION_KEY object:nil];
}

+ (void)registerUpdateBadgeNotificationWithTarget:(id)object action:(SEL)action {
    [[NSNotificationCenter defaultCenter] addObserver:object selector:action name:MKU_UPDATE_BADGE_NOTIFICATION_KEY object:nil];
}

+ (void)postBadgeNotifications:(NSArray<MKUBadgeItem *> *)badges {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKU_BADGE_NOTIFICATION_KEY object:badges];
}

+ (void)registerBadgeNotificationWithTarget:(id)object action:(SEL)action {
    [[NSNotificationCenter defaultCenter] addObserver:object selector:action name:MKU_BADGE_NOTIFICATION_KEY object:nil];
}

+ (void)unregisterBadgeNotificationWithTarget:(id)object {
    [[NSNotificationCenter defaultCenter] removeObserver:object];
}

@end
