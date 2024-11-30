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

typedef NS_ENUM(NSUInteger, NotificationReceiveType) {
    NotificationReceiveType_Forground,
    NotificationReceiveType_Action_Background
};

typedef NSUInteger LocalNotificationType;
typedef NSUInteger PushNotificationType;

typedef NSString * NotificationIdentifier;
typedef NSString * NotificationActionIdentifier;
typedef NSString * NotificationCategoryIdentifier;

@interface NotificationCategory : NSObject

@property (nonatomic, strong) NSArray<UIUserNotificationAction *> *actions;
@property (nonatomic, strong) NotificationCategoryIdentifier categoryID;

@end

@interface LocalNotification : NSObject

@property (nonatomic, strong) NotificationCategory *category;
@property (nonatomic, strong) NotificationIdentifier identifier;

- (instancetype)initWithType:(LocalNotificationType)type;

@end

typedef NSArray<LocalNotification *>        LocalNotificationArr;
typedef NSMutableArray<LocalNotification *> MLocalNotificationArr;

typedef NSArray<NotificationCategory *>        NotificationCategoryArr;
typedef NSMutableArray<NotificationCategory *> MNotificationCategoryArr;

@interface MKUNotificationController : NSObject

/** @brief when this property is set, actions for each category can also be set
 @code
 UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
 action.identifier = @"ActionID";
 action.destructive = NO;
 action.title = @"Action";
 action.activationMode = UIUserNotificationActivationModeForeground;
 action.authenticationRequired = NO;
 cat.actions = @[action];
 @endcode
 */
@property (nonatomic, strong) NotificationCategoryArr *categories;

+ (instancetype)instance;

- (void)setCategories:(NotificationCategoryArr *)categories;

- (void)registerForNotifications;
- (void)scheduleLocalNotificationWithIdentifier:(NotificationIdentifier)identifier categoryID:(NotificationCategoryIdentifier)categoryID body:(NSString *)body fireTime:(NSTimeInterval)fireTime;
- (void)scheduleLocalNotification:(LocalNotification *)note body:(NSString *)body fireTime:(NSTimeInterval)fireTime;
- (void)cancelLocalNotificationWithIdentifier:(NotificationIdentifier)identifier;
- (void)cancelLocalNotification:(LocalNotification *)note;
+ (void)cancelAllLocalNotifications;

/** @brief These are abstracts, create category to override */
- (void)handleDidReceiveLocalNotification:(UILocalNotification *)note receiveType:(NotificationReceiveType)receiveType;
- (void)handleDidReceivePushNotificationWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo receiveType:(NotificationReceiveType)receiveType;

@end
