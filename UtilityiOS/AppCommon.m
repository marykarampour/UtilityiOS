//
//  AppCommon.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "AppCommon.h"

#pragma mark - constants

const ServerEnvironment ServerEnvironmentVariable = ServerEnvironment_DEV_IN;
const BOOL USING_HTTPS                            = 0;

NSString * const BaseLocalHostURL                 = @"://localhost";
NSString * const BaseTestingInURL                 = @"://10.1.0.129";
NSString * const BaseTestingOutURL                = @"://testing.baldhead.com";
NSString * const BaseDevInURL                     = @"://10.1.0.119";
NSString * const BaseDevOutURL                    = @"://kaching.baldhead.com";
NSString * const BaseProductionURL                = @"://";

float const TransitionAnimationDuration           = 0.4;
float const PrimaryColumnWidth                    = 256.0;
float const PrimaryColumnShrunkenWidth            = 44.0;

float const DefaultRowHeight                      = 44.0;
float const ButtonCornerRadious                   = 6.0;

#pragma mark - strings

NSString * const ExitTitle_STR                    = @"Exit";

#pragma mark - classes

@implementation AppCommon

+ (NSString *)BaseURLString {
    NSString *https = USING_HTTPS ? @"https" : @"http";
    switch (ServerEnvironmentVariable) {
        case ServerEnvironment_PROD:
            return [NSString stringWithFormat:@"%@%@:3000", https, BaseProductionURL];
        case ServerEnvironment_TESTING_IN:
            return [NSString stringWithFormat:@"%@%@:3000", https, BaseTestingInURL];
        case ServerEnvironment_TESTING_OUT:
            return [NSString stringWithFormat:@"%@%@:3001", https, BaseTestingOutURL];
        case ServerEnvironment_LOCAL:
            return [NSString stringWithFormat:@"%@%@:3000", https, BaseLocalHostURL];
        case ServerEnvironment_DEV_IN:
            return [NSString stringWithFormat:@"%@%@:3000", https, BaseDevInURL];
        case ServerEnvironment_DEV_OUT:
        default:
            return [NSString stringWithFormat:@"%@%@:3000", https, BaseDevOutURL];
            break;
    }
}

+ (NSURL *)BaseURL {
    return [NSURL URLWithString:[self BaseURLString]];
}

+ (BOOL)isIPhone {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isIPad {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (CGFloat)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (NSString *)versionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)bundleID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)targetName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

@end
