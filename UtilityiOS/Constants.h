//
//  AppCommon.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <LocalAuthentication/LocalAuthentication.h>

#pragma mark - macros

#ifdef DEBUG
#define DEBUGLOG(s, ...) NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DEBUGLOG(s, ...)
#endif

#define RaiseExceptionMissingMethodInClass      [NSException raise:NSInternalInconsistencyException format:@"You have not implemented %@ in %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])];

#define RaiseExceptionIncorrectMethodUse(...)   [NSException raise:NSInternalInconsistencyException format:@"You are calling %@, use %@ instead", NSStringFromSelector(_cmd), ##__VA_ARGS__];





#pragma mark - typedefs

typedef NSInteger ServerEnvironment;
typedef NSInteger TargetType;

enum {
    ServerEnvironment_NONE = -1,
    ServerEnvironment_DEV_IN,
    ServerEnvironment_DEV_OUT,
    ServerEnvironment_TESTING_IN,
    ServerEnvironment_TESTING_OUT,
    ServerEnvironment_LOCAL,
    ServerEnvironment_PROD,
    ServerEnvironment_BASE
};

enum {
    TargetType_NONE = -1,
    TargetType_BASE
};

typedef NSArray<NSString *>                                     StringArr;
typedef NSMutableArray<NSString *>                              MStringArr;
typedef NSDictionary<NSString *, NSString *>                    DictStringString;
typedef NSMutableDictionary<NSString *, NSString *>             MDictStringString;

typedef NSArray<DictStringString *>                             ArrDictStringString;
typedef NSDictionary<NSString *, ArrDictStringString *>         DictStringDictStringString;
typedef NSMutableDictionary<NSString *, NSString *>             MDictStringString;
typedef NSMutableDictionary<NSString *, ArrDictStringString *>  MDictStringDictStringString;

typedef NSDictionary<NSString *, StringArr *>                   DictStringStringArr;
typedef NSMutableDictionary<NSString *, MStringArr *>           MDictStringStringArr;
typedef NSDictionary<NSString *, DictStringStringArr *>         DictStringDictStringStringArr;
typedef NSMutableDictionary<NSString *, MDictStringStringArr *> MDictStringDictStringStringArr;

typedef NSArray<NSNumber *>                                     NumArr;
typedef NSMutableArray<NSNumber *>                              MNumArr;

typedef NSDictionary<id, NSNumber *>                            DictIDNum;
typedef NSMutableDictionary<id, NSNumber *>                     MDictIDNum;

typedef NSMutableDictionary<NSString *, NSNumber *>             MDictStringNum;
typedef NSDictionary<NSString *, NSNumber *>                    DictStringNum;

typedef NSDictionary<NSNumber *, NSNumber *>                    DictNumNum;
typedef NSMutableDictionary<NSNumber *, NSNumber *>             MDictNumNum;

typedef NSDictionary<NSString *, StringArr *>                   DictStringStringArr;
typedef NSMutableDictionary<NSString *, MStringArr *>           MDictStringStringArr;

typedef NSArray<NSValue *>                                      ValueArr;
typedef NSMutableArray<NSValue *>                               MValueArr;


#pragma mark - format

extern NSString * const DateFormatServerStyle;
extern NSString * const DateFormatShortStyle;
extern NSString * const DateFormatFullStyle;
extern NSString * const DateFormatMonthDayYearStyle;
extern NSString * const DateFormatMonthYear;
extern NSString * const DateFormatDayMonthYear;
extern NSString * const DateFormatDayMonthYearNumeric;


#pragma mark - classes
/** @brief This class contains the constants used throughout the app
 @note Projects must define a subclass of this class called AppCommon containing app specific constants. Different implementations are done via swizzling in A category of Constants. All methods are class methods, no instance of this class is created.
 */
@interface Constants : NSObject

#pragma mark - networking

+ (ServerEnvironment)ServerEnvironmentVariable;
+ (BOOL)USING_HTTPS;
+ (NSString *)BaseLocalHostURL;
+ (NSString *)BaseTestingInURL;
+ (NSString *)BaseTestingOutURL;
+ (NSString *)BaseDevInURL;
+ (NSString *)BaseDevOutURL;
+ (NSString *)BaseProductionURL;
+ (NSString *)BaseURLString;
+ (NSString *)BasePort;

#pragma mark - constants

+ (float)TransitionAnimationDuration;
+ (float)PrimaryColumnWidth;
+ (float)PrimaryColumnShrunkenWidth;
+ (float)DefaultRowHeight;
+ (float)ButtonCornerRadious;
+ (float)GeoFenceRadiousMeter;
+ (float)GeoFenceRadiousKiloMeter;

#pragma mark - defaults

+ (NSString *)DefaultsVersion;

#pragma mark - flags

+ (BOOL)IS_TESTING;

#pragma mark - strings

+ (NSString *)ExitTitle_STR;
+ (NSString *)FaceID_STR;
+ (NSString *)TouchID_STR;
+ (NSString *)OK_STR;
+ (NSString *)Cancel_STR;
+ (NSString *)Skip_STR;
+ (NSString *)PIN_STR;
+ (NSString *)Username_STR;
+ (NSString *)Password_STR;
+ (NSString *)Enter_BLANK_STR;
+ (NSString *)Incorrect_BLANK_STR;
+ (NSString *)LocationRestrictedTitle_STR;
+ (NSString *)LocationRestrictedMessage_STR;

#pragma mark - app

+ (BOOL)isIPhone;
+ (BOOL)isIPad;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (NSString *)versionString;
+ (NSString *)bundleID;
+ (NSString *)targetName;

#pragma mark - Push Notification

+ (void)setPushNotificationDeviceToken:(NSData *)deviceToken;
+ (NSString *)pushNotificationDeviceToken;
+ (NSString *)pushNotificationPlatform;

#pragma mark - abstracts

+ (NSURL *)BaseURL;
+ (TargetType)appTargetType;
+ (NSString *)authorizationUsername;
+ (NSString *)authorizationPassword;

@end


