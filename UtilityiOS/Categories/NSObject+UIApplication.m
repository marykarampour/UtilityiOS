//
//  NSObject+UIApplication.m
//  KaChing
//
//  Created by Maryam Karampour on 2021-01-18.
//  Copyright © 2021 Prometheus Software. All rights reserved.
//

#import "NSObject+UIApplication.h"

@implementation NSObject (UIApplication)

+ (void)goToApplicationSettings {
    if (IS_OS_8_OR_LATER) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
