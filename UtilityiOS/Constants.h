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

#define RaiseExceptionVariableInconsistency(...) [NSException raise:NSInternalInconsistencyException format:@"In method %@, variable %@ is of type %@, you must use type %@ instead", NSStringFromSelector(_cmd), ##__VA_ARGS__];

#define LOCALIZED(s)     NSLocalizedString(s, nil)


#pragma mark - timers

#define TIMER_DURATION_1_MIN                     60
#define TIMER_DURATION_5_MIN                     5*TIMER_DURATION_1_MIN
#define TIMER_DURATION_10_MIN                    10*TIMER_DURATION_1_MIN
#define TIMER_DURATION_1_HOUR                    60*TIMER_DURATION_1_MIN
#define TIMER_DURATION_12_HOUR                   12*TIMER_DURATION_1_HOUR

#define BADGE_POOLING_TIMER                      TIMER_DURATION_10_MIN


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

typedef NS_ENUM(NSUInteger, TextType) {
    TextType_String,
    TextType_Int,
    TextType_IntPositive,
    TextType_Float,
    TextType_FloatPositive,
    TextType_Alphabet,
    TextType_AlphaNumeric,
    TextType_AlphaSpaceDot,
    TextType_Name,
    TextType_Email,
    TextType_Phone,
    TextType_Address,
    TextType_Date,
    TextType_Gender,
    TextType_Count
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

typedef NSDictionary<NSNumber *, NSString *>                    DictNumString;
typedef NSMutableDictionary<NSNumber *, NSString *>             MDictNumString;

typedef NSDictionary<NSString *, StringArr *>                   DictStringStringArr;
typedef NSMutableDictionary<NSString *, MStringArr *>           MDictStringStringArr;

typedef NSArray<NSValue *>                                      ValueArr;
typedef NSMutableArray<NSValue *>                               MValueArr;

typedef NSArray<__kindof NSObject *>                            ObjectArr;
typedef NSMutableArray<__kindof NSObject *>                     MObjectArr;

typedef NSArray<NSIndexPath *>                                  IndexPathArr;
typedef NSMutableArray<NSIndexPath *>                           MIndexPathArr;

#pragma mark - format

extern NSString * const DateFormatServerStyle;
extern NSString * const DateFormatShortStyle;
extern NSString * const DateFormatWeekdayShortStyle;
extern NSString * const DateFormatFullStyle;
extern NSString * const DateFormatMonthDayYearStyle;
extern NSString * const DateFormatMonthYearStyle;
extern NSString * const DateFormatDayMonthYearStyle;
extern NSString * const DateFormatDayMonthYearNumericStyle;
extern NSString * const DateFormatWeekdayDayStyle;


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
+ (NSString *)TestUsername;
+ (NSString *)TestPassword;

#pragma mark - constants

+ (float)TransitionAnimationDuration;
+ (float)PrimaryColumnWidth;
+ (float)MaxPrimaryColumnWidth;
+ (float)MinPrimaryColumnWidth;
+ (float)PrimaryColumnShrunkenWidth;
+ (float)DefaultRowHeight;
+ (float)TableSectionHeaderHeight;
+ (float)TableSectionFooterHeight;
+ (float)TableFooterHeight;
+ (float)TableIconImageSmallSize;
+ (float)TableIconImageLargeSize;
+ (float)BorderWidth;
+ (float)ButtonCornerRadious;
+ (float)GeoFenceRadiousMeter;
+ (float)GeoFenceRadiousKiloMeter;
+ (float)TextPadding;
+ (float)HorizontalSpacing;
+ (float)VerticalSpacing;
+ (CGSize)SpinnerSize;
+ (UIEdgeInsets)TabBarItemImageInsets;
+ (float)LoginViewInset;
+ (float)LoginViewWidth;
+ (float)BadgeHeight;
+ (CGSize)TableCellDisclosureIndicatorSize;

#pragma mark - defaults

+ (NSString *)DefaultsVersion;

#pragma mark - flags

+ (BOOL)IS_TESTING;

#pragma mark - strings

+ (NSString *)ExitTitle_STR;
+ (NSString *)ExitMessage_STR;
+ (NSString *)LoginFailedTitle_STR;
+ (NSString *)LoginFailedMessage_STR;
+ (NSString *)FaceID_STR;
+ (NSString *)TouchID_STR;
+ (NSString *)Done_STR;
+ (NSString *)Save_STR;
+ (NSString *)Replace_STR;
+ (NSString *)OK_STR;
+ (NSString *)Cancel_STR;
+ (NSString *)Clear_STR;
+ (NSString *)Skip_STR;
+ (NSString *)Sign_STR;
+ (NSString *)Register_STR;
+ (NSString *)Update_STR;
+ (NSString *)PIN_STR;
+ (NSString *)Username_STR;
+ (NSString *)Password_STR;
+ (NSString *)Login_STR;
+ (NSString *)Enter_BLANK_STR;
+ (NSString *)Incorrect_BLANK_STR;
+ (NSString *)LocationRestrictedTitle_STR;
+ (NSString *)LocationRestrictedMessage_STR;
+ (NSString *)Camera_STR;
+ (NSString *)Photo_Library_STR;
+ (NSString *)CameraDisabledTitle_STR;
+ (NSString *)CameraAccessMessage_BLANK_STR;
+ (NSString *)TakingPicture_STR;
+ (NSString *)ScanningBarcode_STR;
+ (NSString *)NoCamera_STR;
+ (NSString *)Invalid_STR;
+ (NSString *)Error_STR;

+ (NSString *)Placeholder_Date_STR;
+ (NSString *)Placeholder_Phone_STR;

#pragma mark - app

+ (BOOL)isIPhone;
+ (BOOL)isIPad;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (NSString *)versionString;
+ (NSURL *)appDocumentsDirectory;
+ (NSString *)bundleID;
+ (NSString *)targetName;
+ (CGFloat)statusBarHeight;
+ (CGFloat)safeAreaInsets;

#pragma mark - Push Notification

+ (void)setPushNotificationDeviceToken:(NSData *)deviceToken;
+ (NSString *)pushNotificationDeviceToken;
+ (NSString *)pushNotificationPlatform;

#pragma mark - Notification Center

+ (NSNotificationName)NotificationName_App_Terminated;


#pragma mark - abstracts

+ (NSURL *)BaseURL;
+ (TargetType)appTargetType;
+ (NSString *)authorizationUsername;
+ (NSString *)authorizationPassword;

#pragma mark - regex and predicate

+ (NSString *)Predicate_MatchesSelf;

+ (NSString *)Regex_CharRange;
+ (NSString *)Regex_CharRange_IntPositive;
+ (NSString *)Regex_CharRange_Int;
+ (NSString *)Regex_CharRange_FloatPositive;
+ (NSString *)Regex_CharRange_Float;
+ (NSString *)Regex_CharRange_Alphabet;
+ (NSString *)Regex_CharRange_Alphanumeric;
+ (NSString *)Regex_CharRange_AlphaSpaceDot;
+ (NSString *)Regex_CharRange_Dash_Numeric;
+ (NSString *)Regex_Email;
+ (NSString *)Regex_Email_NoCheck;
+ (NSString *)Regex_Email_Has_AT;
+ (NSString *)Regex_Email_Has_AT_Dot;
+ (NSString *)Regex_Phone;
+ (NSString *)Regex_Address;
+ (NSString *)Regex_Date;
+ (NSString *)Regex_Gender;

#pragma mark - core date

+ (NSString *)CoreData_StorePath;
+ (NSString *)CoreData_ModelPath;

@end


