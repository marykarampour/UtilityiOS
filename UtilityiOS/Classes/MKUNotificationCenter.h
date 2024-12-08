//
//  MKUNotificationCenter.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUBadgeItem.h"

#define MKU_UPDATE_BADGE_NOTIFICATION_KEY   @"MKU_UPDATE_BADGE_NOTIFICATION_KEY"
#define MKU_BADGE_NOTIFICATION_KEY          @"MKU_BADGE_NOTIFICATION_KEY"

@interface MKUNotificationCenter : NSObject

+ (void)postUpdateBadgeNotification;
+ (void)registerUpdateBadgeNotificationWithTarget:(id)object action:(SEL)action;

+ (void)postBadgeNotifications:(NSArray<MKUBadgeItem *> *)badges;
+ (void)registerBadgeNotificationWithTarget:(id)object action:(SEL)action;
+ (void)unregisterBadgeNotificationWithTarget:(id)object;

@end
