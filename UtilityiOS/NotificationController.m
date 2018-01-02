//
//  NotificationController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-02.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "NotificationController.h"

static NSString * const NotificationIdentifierUserInfoKey = @"NotificationIdentifier";

@implementation LocalNotification

- (instancetype)initWithType:(LocalNotificationType)type {
    return self;
}

@end


@implementation NotificationController

@end

@interface LocalNotificationController ()

@property (nonatomic, strong, readwrite) NSArray<LocalNotification *> *Notifications;

@end


@implementation LocalNotificationController

- (instancetype)initWithNotifications:(NSArray<LocalNotification *> *)Notifications {
    if (self = [super init]) {
        self.Notifications = Notifications;
    }
    return self;
}

- (void)registerForNotifications {
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for (LocalNotification *note in self.Notifications) {
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = note.categoryID;
        [category setActions:note.actions forContext:UIUserNotificationActionContextMinimal];
        [category setActions:note.actions forContext:UIUserNotificationActionContextDefault];
        [categories addObject:category];
    }
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:[NSSet setWithArray:categories]]];
}

- (void)scheduleNotificationWithIdentifier:(NotificationIdentifier)identifier body:(NSString *)body fireTime:(NSTimeInterval)fireTime {
    for (LocalNotification *note in self.Notifications) {
        if ([note.actions[0].identifier isEqualToString:identifier]) {
            UILocalNotification *notify = [[UILocalNotification alloc] init];
            notify.fireDate = [NSDate dateWithTimeIntervalSinceNow:fireTime];
            [notify.userInfo setValue:identifier forKey:NotificationIdentifierUserInfoKey];
            notify.alertBody = body;
            notify.category = note.categoryID;
            notify.soundName = UILocalNotificationDefaultSoundName;
            notify.timeZone = [NSTimeZone defaultTimeZone];
            notify.applicationIconBadgeNumber = 1;
            [[UIApplication sharedApplication] scheduleLocalNotification:notify];
        }
    }
}

- (void)cancelNotificationWithIdentifier:(NotificationIdentifier)identifier {
    for (UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([[notify.userInfo objectForKey:NotificationIdentifierUserInfoKey] isEqualToString:identifier]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
        }
    }
}

+ (void)cancelAllNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end




