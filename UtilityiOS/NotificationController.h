//
//  NotificationController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-02.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NotificationType) {
    NotificationType_Local,
    NotificationType_Push
};

typedef NSUInteger LocalNotificationType;
typedef NSUInteger PushNotificationType;

typedef NSString * NotificationIdentifier;
typedef NSString * NotificationActionIdentifier;
typedef NSString * NotificationCategoryIdentifier;

@interface LocalNotification : NSObject

@property (nonatomic, strong) NSArray<UIUserNotificationAction *> *actions;
@property (nonatomic, strong, readonly) NotificationCategoryIdentifier categoryID;

- (instancetype)initWithType:(LocalNotificationType)type;
- (void)scheduleNotificationWithIdentifier:(NotificationIdentifier)identifier body:(NSString *)body fireTime:(NSTimeInterval)fireTime;
- (void)cancelNotificationWithIdentifier:(NotificationIdentifier)identifier;

@end


@interface NotificationController : NSObject

@end

@interface LocalNotificationController : NotificationController

@property (nonatomic, strong, readonly) NSArray<LocalNotification *> *Notifications;

- (instancetype)initWithNotifications:(NSArray<LocalNotification *> *)Notifications;
- (void)registerForNotifications;
+ (void)cancelAllNotifications;

@end

@interface PushNotificationController : NotificationController

@end
