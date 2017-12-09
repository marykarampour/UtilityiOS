//
//  AppCommon.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - macros

#ifdef DEBUG
#define DEBUGLOG(s, ...) NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DEBUGLOG(s, ...)
#endif

#define RaiseExceptionMissingMethodInClass      [NSException raise:NSInternalInconsistencyException format:@"You have not implemented %@ in %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])];

#define RaiseExceptionIncorrectMethodUse(...)   [NSException raise:NSInternalInconsistencyException format:@"You are calling %@, use %@ instead", NSStringFromSelector(_cmd), ##__VA_ARGS__];


#pragma mark - typedefs

typedef NS_ENUM(NSUInteger, ServerEnvironment) {
    ServerEnvironment_DEV_IN,
    ServerEnvironment_DEV_OUT,
    ServerEnvironment_TESTING_IN,
    ServerEnvironment_TESTING_OUT,
    ServerEnvironment_LOCAL,
    ServerEnvironment_PROD
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

#pragma mark - constants

extern float const TransitionAnimationDuration;
extern float const PrimaryColumnWidth;
extern float const PrimaryColumnShrunkenWidth;

extern float const DefaultRowHeight;
extern float const ButtonCornerRadious;

#pragma mark - format

extern NSString * const DateFormatServerStyle;
extern NSString * const DateFormatShortStyle;
extern NSString * const DateFormatFullStyle;
extern NSString * const DateFormatMonthDayYearStyle;
extern NSString * const DateFormatMonthYear;
extern NSString * const DateFormatDayMonthYear;
extern NSString * const DateFormatDayMonthYearNumeric;

#pragma mark - strings

extern NSString * const ExitTitle_STR;

#pragma mark - classes

@interface AppCommon : NSObject

+ (NSString *)BaseURLString;
+ (NSURL *)BaseURL;
+ (BOOL)isIPhone;
+ (BOOL)isIPad;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (NSString *)versionString;
+ (NSString *)bundleID;
+ (NSString *)targetName;

@end
