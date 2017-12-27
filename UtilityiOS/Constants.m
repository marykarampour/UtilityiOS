//
//  AppCommon.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "Constants.h"
#import "AppDelegate.h"


#pragma mark - defaults

static NSString * const DefaultLoggedInUsersKey = @"DefaultLoggedInUsersKey";
static NSString * const DefaultVersionKey       = @"DefaultVersionKey";
static NSString * const DefaultSavedUsersKey    = @"DefaultSavedUsersKey";

#pragma mark - format

NSString * const DateFormatServerStyle            = @"YYYY-MM-dd HH:mm:ss";
NSString * const DateFormatShortStyle             = @"yyyy-MM-dd";
NSString * const DateFormatFullStyle              = @"EEEE, MMMM dd, yyyy";
NSString * const DateFormatMonthDayYearStyle      = @"MMMM dd, yyyy";
NSString * const DateFormatMonthYear              = @"MMMM yyyy";
NSString * const DateFormatDayMonthYear           = @"dd MMMM yyyy";
NSString * const DateFormatDayMonthYearNumeric    = @"dd MM yyyy";


#pragma mark - classes

@implementation Constants


#pragma mark - networking

+ (ServerEnvironment)ServerEnvironmentVariable {
    return ServerEnvironment_DEV_IN;
}

+ (BOOL)USING_HTTPS {
    return 0;
}

+ (NSString *)BaseLocalHostURL {
    return @"://localhost";
}

+ (NSString *)BaseTestingInURL {
    return @"://10.1.0.129";
}

+ (NSString *)BaseTestingOutURL {
    return @"://testing.baldhead.com";
}

+ (NSString *)BaseDevInURL {
    return @"://10.1.0.119";
}

+ (NSString *)BaseDevOutURL {
    return @"://kaching.baldhead.com";
}

+ (NSString *)BaseProductionURL {
    return @"://";
}


#pragma mark - constants

+ (float)TransitionAnimationDuration {
    return 0.4;
}

+ (float)PrimaryColumnWidth {
    return 256.0;
}

+ (float)PrimaryColumnShrunkenWidth {
    return 44.0;
}

+ (float)DefaultRowHeight {
    return 44.0;
}

+ (float)ButtonCornerRadious {
    return 6.0;
}


#pragma mark - defaults

+ (NSString *)DefaultsVersion {
    return @"1.0.0";
}

#pragma mark - flags

+ (BOOL)IS_TESTING {
    return YES;
}

#pragma mark - strings

+ (NSString *)ExitTitle_STR {
    return @"Exit";
}

+ (NSString *)FaceID_STR {
    return @"Face ID";
}

+ (NSString *)TouchID_STR {
    return @"Touch ID";
}

+ (NSString *)BaseURLString {
    NSString *https = [Constants USING_HTTPS] ? @"https" : @"http";
    NSString *port = @"3000";
    NSString *url = @"";
    switch ([Constants ServerEnvironmentVariable]) {
        case ServerEnvironment_PROD:
            url = [Constants BaseProductionURL];
            break;
            
        case ServerEnvironment_TESTING_IN:
            url = [Constants BaseTestingInURL];
            break;
            
        case ServerEnvironment_TESTING_OUT: {
            port = @"3001";
            url = [Constants BaseTestingOutURL];
        }
            break;
            
        case ServerEnvironment_LOCAL:
            url = [Constants BaseLocalHostURL];
            break;
            
        case ServerEnvironment_DEV_IN:
            url = [Constants BaseDevInURL];
            break;
            
        case ServerEnvironment_DEV_OUT:
        default:
            url = [Constants BaseDevOutURL];
            break;
    }
    return [NSString stringWithFormat:@"%@%@:%@", https, url, port];
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
    return [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleNameKey];
}

+ (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

+ (CGFloat)safeAreaInsets {
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    if ([window respondsToSelector:@selector(safeAreaInsets)]) {
        if (@available(iOS 11.0, *)) {
            CGFloat topInset = window.safeAreaInsets.top;
            return topInset > 0.0 ? topInset : [Constants statusBarHeight];
        }
    }
    return [Constants statusBarHeight];
}

#pragma mark - biometrics

+ (BOOL)canAutentiacteWithBiometrics {
    LAContext *context = [[LAContext alloc] init];
    return ([LAContext class] && [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]);
}

+ (BOOL)touchIDIsAvaialable {
    LAContext *context = [[LAContext alloc] init];
    //This HAS to be called on context to return biometryType - looks like a glitch
    BOOL hasBiometry = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    if (@available(iOS 11.0, *)) {
        return hasBiometry && context.biometryType == LABiometryTypeTouchID;
    }
    else if (hasBiometry) {
        return YES;
    }
    return NO;
}

+ (BOOL)faceIDIsAvaialable {
    LAContext *context = [[LAContext alloc] init];
    //This HAS to be called on context to return biometryType - looks like a glitch
    BOOL hasBiometry = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    if (@available(iOS 11.0, *)) {
        return hasBiometry && context.biometryType == LABiometryTypeFaceID;
    }
    return NO;
}

+ (NSString *)bioMetricName {
    if ([Constants touchIDIsAvaialable]) {
        return [Constants TouchID_STR];
    }
    else if ([Constants faceIDIsAvaialable]) {
        return [Constants FaceID_STR];
    }
    return nil;
}


#pragma mark - saved user

+ (BOOL)isLoggedInUser:(NSString *)username {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *savedUsers = [defs objectForKey:DefaultLoggedInUsersKey];
    NSMutableArray *users;
    
    if (savedUsers && [savedUsers isKindOfClass:[NSArray class]]) {
        if ([savedUsers containsObject:username]) {
            return YES;
        }
        users = savedUsers.mutableCopy;
    }
    else {
        users = [[NSMutableArray alloc] init];
    }
    
    [users addObject:username];
    [defs setObject:users forKey:DefaultLoggedInUsersKey];
    [defs synchronize];
    return NO;
}

+ (BOOL)isSavedUser:(NSString *)username {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *savedUsers = [defs objectForKey:DefaultLoggedInUsersKey];
    
    if (savedUsers && [savedUsers isKindOfClass:[NSArray class]]) {
        if ([savedUsers containsObject:username]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isCurrentDefaultsVersion {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSString *version = [defs objectForKey:DefaultVersionKey];
    return [version isEqualToString:[Constants DefaultsVersion]];
}

+ (void)setDefaultsVersion {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:[Constants DefaultsVersion] forKey:DefaultVersionKey];
    [defs synchronize];
}

+ (NSArray *)savedUsers {
    return [[NSUserDefaults standardUserDefaults] objectForKey:DefaultSavedUsersKey];
}

+ (void)saveUser:(NSString *)username {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *savedUsers = [defs objectForKey:DefaultSavedUsersKey];
    NSMutableArray *users;
    
    if (savedUsers && [savedUsers isKindOfClass:[NSArray class]]) {
        if ([savedUsers containsObject:username]) {
            return;
        }
        users = savedUsers.mutableCopy;
    }
    else {
        users = [[NSMutableArray alloc] init];
    }
    [users addObject:username];
    [defs setObject:users forKey:DefaultSavedUsersKey];
    [defs synchronize];
}

+ (void)removeSavedUser:(NSString *)username {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *savedUsers = [defs objectForKey:DefaultSavedUsersKey];
    NSMutableArray *users;
    
    if (savedUsers && [savedUsers isKindOfClass:[NSArray class]]) {
        if ([savedUsers containsObject:username]) {
            users = savedUsers.mutableCopy;
            [users removeObject:username];
            [defs setObject:users forKey:DefaultSavedUsersKey];
            [defs synchronize];
        }
    }
}

+ (void)removeAllSavedUsers {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:nil forKey:DefaultSavedUsersKey];
    [defs synchronize];
}

#pragma mark - AppCommon abstracts

+ (TargetType)appTargetType {
    return 0;
}

+ (NSString *)authorizationUsername {
    return @"";
}

+ (NSString *)authorizationPassword {
    return @"";
}


@end
