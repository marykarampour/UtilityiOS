//
//  NotificationController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-02.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKNotificationController.h"

static NSString * const NotificationIdentifierUserInfoKey = @"NotificationIdentifier";

@implementation LocalNotification

- (instancetype)initWithType:(LocalNotificationType)type {
    return self;
}

@end

@implementation NotificationCategory


@end


@interface MKNotificationController ()

@end

@implementation MKNotificationController

+ (instancetype)instance {
    static MKNotificationController *note = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        note = [[MKNotificationController alloc] init];
    });
    return note;
}

- (void)setCategories:(NotificationCategoryArr *)categories {
    for (LocalNotification *note in self.categories) {
        [self cancelLocalNotificationWithIdentifier:note.identifier];
    }
    _categories = categories;
    [self registerForNotifications];
}

- (void)registerForNotifications {
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for (NotificationCategory *cat in self.categories) {
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = cat.categoryID;
        [category setActions:cat.actions forContext:UIUserNotificationActionContextMinimal];
        [category setActions:cat.actions forContext:UIUserNotificationActionContextDefault];
        [categories addObject:category];
    }
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:[NSSet setWithArray:categories]]];
}

- (void)scheduleLocalNotificationWithIdentifier:(NotificationIdentifier)identifier categoryID:(NotificationCategoryIdentifier)categoryID body:(NSString *)body fireTime:(NSTimeInterval)fireTime {
    UILocalNotification *notify = [[UILocalNotification alloc] init];
    notify.fireDate = [NSDate dateWithTimeIntervalSinceNow:fireTime];
    [notify.userInfo setValue:identifier forKey:NotificationIdentifierUserInfoKey];
    notify.alertBody = body;
    notify.category = categoryID;
    notify.soundName = UILocalNotificationDefaultSoundName;
    notify.timeZone = [NSTimeZone defaultTimeZone];
    notify.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
}

- (void)scheduleLocalNotification:(LocalNotification *)note body:(NSString *)body fireTime:(NSTimeInterval)fireTime {
    UILocalNotification *notify = [[UILocalNotification alloc] init];
    notify.fireDate = [NSDate dateWithTimeIntervalSinceNow:fireTime];
    [notify.userInfo setValue:note.identifier forKey:NotificationIdentifierUserInfoKey];
    notify.alertBody = body;
    notify.category = note.category.categoryID;
    notify.soundName = UILocalNotificationDefaultSoundName;
    notify.timeZone = [NSTimeZone defaultTimeZone];
    notify.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notify];
}

- (void)cancelLocalNotificationWithIdentifier:(NotificationIdentifier)identifier {
    for (UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([[notify.userInfo objectForKey:NotificationIdentifierUserInfoKey] isEqualToString:identifier]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
        }
    }
}

- (void)cancelLocalNotification:(LocalNotification *)note {
    [self cancelLocalNotificationWithIdentifier:note.identifier];
}

+ (void)cancelAllLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)handleDidReceiveLocalNotification:(UILocalNotification *)note receiveType:(NotificationReceiveType)receiveType {
}

- (void)handleDidReceivePushNotificationWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo receiveType:(NotificationReceiveType)receiveType {
}

@end




