//
//  AppCommon.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "Constants.h"
#import "AppDelegate.h"
#import "NSString+Utility.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MKUMessageComposerController.h"
#import "NSObject+Utility.h"
#import "NSError+Utility.h"
#import "NSObject+Alert.h"
#import "NSData+Utility.h"
#import "MKUModel.h"

#pragma mark - defaults

NSString * const DefaultLoggedInUsersKey                = @"DefaultLoggedInUsersKey";
NSString * const DefaultVersionKey                      = @"DefaultVersionKey";
NSString * const DefaultSavedUsersKey                   = @"DefaultSavedUsersKey";
NSString * const DefaultPushNotificationDeviceTokenKey  = @"DefaultPushNotificationDeviceTokenKey";

#pragma mark - format

NSString * const DateFormatServerStyle              = @"YYYY-MM-dd HH:mm:ss";
NSString * const DateFormatShortStyle               = @"yyyy-MM-dd";
NSString * const DateFormatWeekdayShortStyle        = @"EEEE MMM dd";
NSString * const DateFormatMonthDayYearStyle        = @"MMMM dd, yyyy";
NSString * const DateFormatMonthYearStyle           = @"MMMM yyyy";
NSString * const DateFormatDayMonthYearStyle        = @"dd MMMM yyyy";
NSString * const DateFormatDayMonthYearNumericStyle = @"dd MM yyyy";
NSString * const DateFormatWeekdayDayStyle          = @"EEEE dd";
NSString * const DateFormatFullTimeStyle            = @"HH:mm:ss EEEE, MMMM dd, yyyy";
NSString * const DateFormatShortAPMStyle            = @"yyyy/MM/dd hh:mm a";
NSString * const DateFormatFullStyle                = @"yyyy-MM-dd'T'HH:mm:ss.SS";
NSString * const DateFormatTimeStyle                = @"HH:mm:ss";
NSString * const DateFormatWeekdayMonthLongStyle    = @"EEEE, MMMM dd, yyyy";
NSString * const DateFormatTimeAPMStyle             = @"HH:mm:ss a";
NSString * const DateFormatFullTimeZoneStyle        = @"yyyy-MM-dd'T'HH:mm:ss.SS zzz";
NSString * const DateFormatLongStyle                = @"yyyy-MM-dd'T'HH:mm:ss";
NSString * const DateFormatShortSlashStyle          = @"MM/dd/yy";
NSString * const DateFormatTimeLongStyle            = @"MM-dd HH:mm";
NSString * const DateFormatTimeShortStyle           = @"HH:mm";
NSString * const DateFormatDayTimeStyle             = @"EEEE, MMM. d, yyyy h:mm a";
NSString * const DateFormatDayTimeStyleLineBreak    = @"EEEE, MMM. d, yyyy\nh:mm a";
NSString * const DateFormatDayStyle                 = @"EEEE, MMM. d, yyyy";
NSString * const DateFormatDateTimeStyle            = @"yyyy-MM-dd HH:mm:ss";
NSString * const DateFormatDateTimeCompactStyle     = @"MM-dd-yy HH:mm";
NSString * const DateFormatMonthTimeCompactStyle    = @"MMM dd HH:mm";

#pragma mark - classes

static NSString * const DEFAULTS_SAVED_USERS_KEY = @"DEFAULTS_SAVED_USERS_KEY";

@interface AppBuildInfo : MKUModel

@property (nonatomic, strong) NSNumber *Major;
@property (nonatomic, strong) NSNumber *Minor;
@property (nonatomic, strong) NSNumber *Revison;

@end

@implementation AppBuildInfo

+ (instancetype)infoWithVersionString:(NSString *)version {
    NSString *majorStr;
    NSString *minorStr;
    NSString *revisionStr;
    
    NSArray<NSString *> *components = [version componentsSeparatedByString:@"."];
    
    switch (components.count) {
        case 1: {
            majorStr = components[0];
        }
            break;
        case 2: {
            majorStr = components[0];
            minorStr = components[1];
        }
            break;
        case 3: {
            majorStr = components[0];
            minorStr = components[1];
            revisionStr = components[2];
        }
            break;
        default:
            break;
    }
    
    AppBuildInfo *info = [[AppBuildInfo alloc] init];
    info.Major = [majorStr stringToNumber];
    info.Minor = [minorStr stringToNumber];
    info.Revison = [revisionStr stringToNumber];
    
    return info;
}

@end

@implementation Constants

#pragma mark - networking

+ (ServerEnvironment)ServerEnvironmentVariable {
    return ServerEnvironment_DEV_IN;
}

+ (BOOL)USING_HTTPS {
    return NO;
}

+ (BOOL)USING_SOAP {
    return NO;
}

+ (NSString *)BaseLocalHostURL {
    return @"://localhost";
}

+ (NSString *)BaseTestingInURL {
    return @"";
}

+ (NSString *)BaseTestingOutURL {
    return @"";
}

+ (NSString *)BaseDevInURL {
    return @"";
}

+ (NSString *)BaseDevOutURL {
    return @"";
}

+ (NSString *)BaseQAURL {
    return @"";
}

+ (NSString *)BaseProductionURL {
    return @"";
}

+ (NSString *)TestUsername {
    return @"";
}

+ (NSString *)TestPassword {
    return @"";
}

+ (StringArr *)ServerDateFormats {
    return @[DateFormatFullTimeZoneStyle];
}

#pragma mark - constants

+ (CGFloat)TransitionAnimationDuration {
    return 0.4;
}

+ (CGFloat)PrimaryColumnWidth {
    return 256.0;
}

+ (CGFloat)MaxPrimaryColumnWidth {
    return 256.0;
}

+ (CGFloat)MinPrimaryColumnWidth {
    return 0.0;
}

+ (CGFloat)PrimaryColumnShrunkenWidth {
    return 44.0;
}

+ (CGFloat)BarButtonItemSpaceWidth {
    return 32.0;
}

+ (CGFloat)TextFieldHeight {
    return 36.0;
}

+ (CGFloat)TextViewTitleHeight {
    return 32.0;
}

+ (CGFloat)TextViewMediumHeight {
    return 128.0;
}

+ (CGFloat)NumericInputTextFieldWidth {
    return 100.0;
}

+ (CGFloat)InputTextFieldWidth {
    return 184.0;
}

+ (CGFloat)DefaultRowHeight {
    return 44.0;
}

+ (CGFloat)ExtendedRowHeight {
    return 52.0;
}

+ (CGFloat)TableSectionHeaderHeight {
    return 32.0;
}

+ (CGFloat)TableSectionHeaderMediumHeight {
    return 44.0;
}

+ (CGFloat)TableSectionHeaderShortHeight {
    return 22.0;
}

+ (CGFloat)TableSectionFooterHeight {
    return 0.0;
}

+ (CGFloat)TableFooterHeight {
    return 44.0;
}

+ (CGFloat)TableCellAccessorySize {
    return 36.0;
}

+ (CGFloat)TableIconImageSmallSize {
    return 32.0;
}

+ (CGFloat)TableIconImageLargeSize {
    return 64.0;
}

+ (CGFloat)TableCellLineHeight {
    return 14.0;
}

+ (CGFloat)TableCellContentHorizontalMargin {
    return 16.0;
}

+ (CGFloat)TableCellContentVerticalMargin {
    return 16.0;
}

+ (CGFloat)ButtonCornerRadious {
    return 6.0;
}

+ (CGFloat)BorderWidth {
    return 1.0;
}

+ (CGFloat)TextPadding {
    return 4.0;
}

+ (CGFloat)HorizontalSpacing {
    return 8.0;
}

+ (CGFloat)VerticalSpacing {
    return 8.0;
}

+ (CGFloat)DatePickerPopOverHeight {
    return 300.0;
}

+ (CGFloat)ButtonChevronSize {
    return 20.0;
}

+ (CGFloat)DatePickerCalendarHeight {
    return 400.0;
}

+ (CGSize)SpinnerSize {
    return CGSizeMake(120.0, 120.0);
}

+ (CGSize)ImageShrinkMaxSize {
    return CGSizeMake(1080.0, 1920.0);
}

+ (CGSize)DateViewControllerPopoverSize {
    return CGSizeMake(300.0, [self DatePickerPopOverHeight]);
}

+ (CGSize)DateViewControllerCalPopoverSize {
    return CGSizeMake(300.0, [self DatePickerCalendarHeight]);
}

+ (NSUInteger)MaxValue1CellCharacterCount {
    return 16;
}


+ (NSUInteger)MaxTextViewCharacters {
    return 400;
}

+ (NSUInteger)MaxTextViewCharactersLong {
    return 1024;
}

+ (UIEdgeInsets)TabBarItemImageInsets {
    return UIEdgeInsetsMake(8.0, 0.0, -8.0, 0.0);
}

+ (CGFloat)TabBarHeight {
    return 52.0;
}

+ (CGFloat)NavbarItemSpaceWidth {
    return 32.0;
}

+ (CGFloat)SplitViewPrimaryWidth {
    return 256.0;
}

+ (CGFloat)LoginViewInset {
    return 100.0;
}

+ (CGFloat)LoginViewWidth {
    return 400.0;
}

+ (CGFloat)BadgeHeight {
    return 20.0;
}

+ (CGFloat)SpinnerBadgeSpacing {
    return 4.0;
}

+ (CGSize)TableCellDisclosureIndicatorSize {
    return CGSizeMake(20.0, 20.0);
}

+ (CGFloat)Toast_Length_Seconds {
    return 1.0;
}

+ (CGFloat)Subsection_Left_Spacing {
    return 22.0;
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

+ (NSString *)Exit_Title_STR {
    return LOCALIZED(@"Exit");
}

+ (NSString *)Exit_Message_STR {
    return LOCALIZED(@"Are you sure you want to exit?");
}

+ (NSString *)Login_Failed_Title_STR {
    return LOCALIZED(@"Login Failed!");
}

+ (NSString *)Login_Failed_Message_STR {
    return LOCALIZED(@"Please check your credentials and try again.");
}

+ (NSString *)Update_Failed_Title_STR {
    return LOCALIZED(@"Update Failed!");
}

+ (NSString *)Save_Successful_STR {
    return LOCALIZED(@"Save Successful!");
}

+ (NSString *)FaceID_STR {
    return LOCALIZED(@"Face ID");
}

+ (NSString *)TouchID_STR {
    return LOCALIZED(@"Touch ID");
}

+ (NSString *)Done_STR {
    return LOCALIZED(@"Done");
}

+ (NSString *)Save_STR {
    return LOCALIZED(@"Save");
}

+ (NSString *)Reset_STR {
    return LOCALIZED(@"Reset");
}

+ (NSString *)Replace_STR {
    return LOCALIZED(@"Replace");
}

+ (NSString *)Remove_STR {
    return LOCALIZED(@"Remove");
}

+ (NSString *)Delete_STR {
    return LOCALIZED(@"Delete");
}

+ (NSString *)Delete_Prompt_Message_STR {
    return LOCALIZED(@"Delete this item?");
}

+ (NSString *)OK_STR {
    return LOCALIZED(@"OK");
}

+ (NSString *)Cancel_STR {
    return LOCALIZED(@"Cancel");
}

+ (NSString *)Clear_STR {
    return LOCALIZED(@"Clear");
}

+ (NSString *)Close_STR {
    return LOCALIZED(@"Close");
}

+ (NSString *)Skip_STR {
    return LOCALIZED(@"Skip");
}

+ (NSString *)Yes_STR {
    return LOCALIZED(@"Yes");
}

+ (NSString *)No_STR {
    return LOCALIZED(@"No");
}

+ (NSString *)Retry_STR {
    return LOCALIZED(@"Retry");
}

+ (NSString *)Choose_STR {
    return LOCALIZED(@"Choose");
}

+ (NSString *)Select_STR {
    return LOCALIZED(@"Select");
}

+ (NSString *)Comments_STR {
    return LOCALIZED(@"Comments");
}

+ (NSString *)Notes_STR {
    return LOCALIZED(@"Notes");
}

+ (NSString *)Other_STR {
    return LOCALIZED(@"Other");
}

+ (NSString *)Details_STR {
    return LOCALIZED(@"Details");
}

+ (NSString *)Sign_STR {
    return LOCALIZED(@"Sign");
}

+ (NSString *)PIN_STR {
    return LOCALIZED(@"PIN");
}

+ (NSString *)Username_STR {
    return LOCALIZED(@"Username");
}

+ (NSString *)Password_STR {
    return LOCALIZED(@"Password");
}

+ (NSString *)Enter_Password_STR {
    return LOCALIZED(@"Please Enter Your Password");
}

+ (NSString *)First_Name_STR {
    return LOCALIZED(@"First Name");
}

+ (NSString *)Last_Name_STR {
    return LOCALIZED(@"Last Name");
}

+ (NSString *)Login_STR {
    return LOCALIZED(@"Login");
}

+ (NSString *)Register_STR {
    return LOCALIZED(@"Register");
}

+ (NSString *)Update_STR {
    return LOCALIZED(@"Update");
}

+ (NSString *)Enter_BLANK_STR {
    return LOCALIZED(@"Please Enter Your %@");
}

+ (NSString *)Incorrect_BLANK_STR {
    return LOCALIZED(@"Incorrect %@");
}

+ (NSString *)LocationRestrictedTitle_STR {
    return LOCALIZED(@"Location access is restricted!");
}

+ (NSString *)LocationRestrictedMessage_STR {
    return @"";
}

+ (NSString *)Camera_STR {
    return LOCALIZED(@"Camera");
}

+ (NSString *)Photo_Library_STR {
    return LOCALIZED(@"Photo Library");
}

+ (NSString *)Document_Picker_STR {
    return LOCALIZED(@"Document Picker");
}

+ (NSString *)Document_Browser_STR {
    return LOCALIZED(@"Document Browser");
}

+ (NSString *)Document_Detection_STR {
    return LOCALIZED(@"Document Detection");
}

+ (NSString *)CameraDisabledTitle_STR {
    return LOCALIZED(@"Camera is disabled!");
}

+ (NSString *)CameraAccessMessage_BLANK_STR {
    return LOCALIZED(@"Camera access is required for taking pictures. Go to settings to enable camera.");
}

+ (NSString *)TakingPicture_STR {
    return LOCALIZED(@"taking pictures");
}

+ (NSString *)ScanningBarcode_STR {
    return LOCALIZED(@"scanning barcodes");
}

+ (NSString *)NoCamera_STR {
    return LOCALIZED(@"Device has no camera");
}

+ (NSString *)Invalid_STR {
    return LOCALIZED(@"Invalid %@");
}

+ (NSString *)Error_STR {
    return LOCALIZED(@"Error");
}

+ (NSString *)Untitled_STR {
    return LOCALIZED(@"Untitled");
}

+ (NSString *)No_Items_Available_STR {
    return LOCALIZED(@"No Items available");
}

+ (NSString *)Placeholder_Date_STR {
    return LOCALIZED(@"1980-02-28");
}

+ (NSString *)Placeholder_Phone_STR {
    return LOCALIZED(@"12223334444");
}

+ (NSString *)NO_Connection_Title_STR {
    return LOCALIZED(@"No Network Connection is available");
}

+ (NSString *)Add_New_Item_STR {
    return LOCALIZED(@"Add a new item");
}

+ (NSString *)Generic_Error_Message_STR {
    return LOCALIZED(@"Something went wrong, please try again");
}

+ (NSString *)No_Camera_Error_Message_STR {
    return LOCALIZED(@"Device has no camera");
}

+ (NSString *)Camera_Disabled_Error_Title_STR {
    return LOCALIZED(@"Camera is disabled!");
}

+ (NSString *)Camera_Disabled_Error_Message_STR {
    return LOCALIZED(@"Camera access is required for taking pictures. Go to settings to enable camera.");
}

+ (NSString *)Missing_Value_Error_Message_STR {
    return LOCALIZED(@"Please enter a value for %@");
}

+ (NSString *)Touch_ID_STR {
    return LOCALIZED(@"Touch ID");
}

+ (NSString *)Face_ID_STR {
    return LOCALIZED(@"Face ID");
}
 
+ (NSString *)Login_Biometrics_Message_STR {
    return LOCALIZED(@"Logging in with %@");
}
 
+ (NSString *)Biometrics_Authentication_Failed_Message_STR {
    return LOCALIZED(@"%@ Authentication Failed!");
}

+ (NSString *)Biometrics_Cannot_Perform_Message_STR {
    return LOCALIZED(@"Device cannot perform %@ Authentication");
}

+ (NSString *)Biometrics_User_Mismatch_Message_STR {
    return LOCALIZED(@"You must Sign In with password first to use %@ Authentication in future");
}

+ (NSString *)Colon_Empty_STR {
    return LOCALIZED(@": ");
}

+ (NSString *)Missing_Object_Error_Message_STR {
    return LOCALIZED(@"Please select a %@");
}

+ (NSString *)Search_Not_Found_STR {
    return LOCALIZED(@"No items with this search criteria were found!");
}

+ (CGFloat)GeoFenceRadiousKiloMeter {
    return 1.0;
}

+ (CGFloat)GeoFenceRadiousMeter {
    return [self GeoFenceRadiousKiloMeter]*1000.0;
}

+ (NSString *)BaseURLString {
    NSString *https = [self USING_HTTPS] ? @"https" : @"http";
    NSString *url = [self CommonURLString];
    return [self URLStringWithHttps:https url:url port: [self BasePort]];
}

+ (NSString *)URLStringWithHttps:(NSString *)https url:(NSString *)url port:(NSString *)port {
    return [NSString stringWithFormat:@"%@%@%@", https, url, port];
}

+ (NSString *)CommonURLString {
   
    switch ([self ServerEnvironmentVariable]) {
        case ServerEnvironment_PROD:        return [self BaseProductionURL];
        case ServerEnvironment_QA:          return [self BaseQAURL];
        case ServerEnvironment_TESTING_IN:  return [self BaseTestingInURL];
        case ServerEnvironment_TESTING_OUT: return [self BaseTestingOutURL];
        case ServerEnvironment_LOCAL:       return [self BaseLocalHostURL];
        case ServerEnvironment_DEV_IN:      return [self BaseDevInURL];
        case ServerEnvironment_DEV_OUT:
        default: return [self BaseDevOutURL];
    }
}


+ (NSURL *)BaseURL {
    return [NSURL URLWithString:[self BaseURLString]];
}

+ (NSString *)BasePort {
    return @"";
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
    NSDictionary *versionDict = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [versionDict objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *version = [versionDict objectForKey:@"CFBundleShortVersionString"];
    version = [NSString stringWithFormat:@"%@ (%@)", version, build];
    return version;
}

+ (NSURL *)appDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSString *)bundleID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)targetName {
    return [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleNameKey];
}

+ (CGFloat)statusBarHeight {
#ifdef AF_APP_EXTENSIONS
    return 0.0;
#else
    return [UIApplication sharedApplication].statusBarFrame.size.height;
#endif
}

+ (UIEdgeInsets)safeAreaInsets {
#ifdef AF_APP_EXTENSIONS
    return UIEdgeInsetsZero;
#endif
    
    UIWindow *window = [AppDelegate application].window;
    UIEdgeInsets insets = window.safeAreaInsets;
    if ([window respondsToSelector:@selector(safeAreaInsets)]) {
        if (@available(iOS 11.0, *)) {
            CGFloat topInset = insets.top;
            topInset = (topInset > 0.0 ? topInset : [self statusBarHeight]);
            return UIEdgeInsetsMake(topInset, insets.left, insets.bottom, insets.right);
        }
    }
    return UIEdgeInsetsMake([self statusBarHeight], insets.left, insets.bottom, insets.right);
}

+ (CGFloat)safeAreaHeight {
#ifdef AF_APP_EXTENSIONS
    return 0.0;
#else
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    if ([window respondsToSelector:@selector(safeAreaInsets)]) {
        if (@available(iOS 11.0, *)) {
            CGFloat inset = 0.0;
            switch ([UIDevice currentDevice].orientation) {
                case UIDeviceOrientationPortrait:           inset = window.safeAreaInsets.top; break;
                case UIDeviceOrientationPortraitUpsideDown: inset = window.safeAreaInsets.bottom; break;
                case UIDeviceOrientationLandscapeLeft:      inset = window.safeAreaInsets.right; break;
                case UIDeviceOrientationLandscapeRight:     inset = window.safeAreaInsets.left; break;
                default:
                    break;
            }
            
            return inset > 0.0 ? inset : [self statusBarHeight];
        }
    }
    return [self statusBarHeight];
#endif
}

+ (CGFloat)bottomSafeAreaHeight {
#ifdef AF_APP_EXTENSIONS
    return 0.0;
#else
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    if ([window respondsToSelector:@selector(safeAreaInsets)]) {
        if (@available(iOS 11.0, *)) {
            CGFloat inset = 0.0;
            switch ([UIDevice currentDevice].orientation) {
                case UIDeviceOrientationPortrait:           inset = window.safeAreaInsets.bottom; break;
                case UIDeviceOrientationPortraitUpsideDown: inset = window.safeAreaInsets.top; break;
                case UIDeviceOrientationLandscapeLeft:      inset = window.safeAreaInsets.left; break;
                case UIDeviceOrientationLandscapeRight:     inset = window.safeAreaInsets.right; break;
                default:
                    break;
            }
            
            return inset > 0.0 ? inset : 0.0;
        }
    }
    return [self statusBarHeight];
#endif
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
    if ([self touchIDIsAvaialable]) {
        return [self TouchID_STR];
    }
    else if ([self faceIDIsAvaialable]) {
        return [self FaceID_STR];
    }
    return nil;
}

+ (NSString *)bioMetricNameForContext:(LAContext *)context {
    if (context.biometryType == LABiometryTypeTouchID) {
        return [self Touch_ID_STR];
    }
    else if (context.biometryType == LABiometryTypeFaceID) {
        return [self Face_ID_STR];
    }
    return nil;
}

+ (void)autentiacteWithBiometrics:(void (^)(BOOL, NSError * _Nullable))completion {
    
    LAContext *context = [[LAContext alloc] init];
    BOOL hasBiometry = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    NSString *bioTypeStr = [self bioMetricNameForContext:context];
    __block NSString *message;
    
    if (hasBiometry) {
        NSString *reason = [NSString stringWithFormat:[self Login_Biometrics_Message_STR], bioTypeStr];
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success && !error) {
                    completion(success, nil);
                    return;
                }
                else {
                    switch (error.code) {
                            
                        case LAErrorAuthenticationFailed:
                            message = [self Biometrics_Authentication_Failed_Message_STR];
                            break;
                            
                        case LAErrorUserCancel:
                        case LAErrorUserFallback:
                        case LAErrorAppCancel:
                            message = [self Biometrics_Authentication_Failed_Message_STR];
                            break;
                            
                        case LAErrorPasscodeNotSet:
                        case LAErrorSystemCancel:
                        case LAErrorInvalidContext:
                        case LAErrorBiometryNotAvailable:
                        case LAErrorBiometryNotEnrolled:
                        case LAErrorBiometryLockout:
                        case LAErrorNotInteractive:
                        default:
                            message = [self Biometrics_Cannot_Perform_Message_STR];
                            break;
                    }
                }
                [self handleAutentiacteWithBiometricsMessage:message type:bioTypeStr completion:completion];
            });
        }];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            message = [self Biometrics_Cannot_Perform_Message_STR];
            [self handleAutentiacteWithBiometricsMessage:message type:bioTypeStr completion:completion];
        });
    }
}

+ (void)handleAutentiacteWithBiometricsMessage:(NSString *)message type:(NSString *)type completion:(void (^)(BOOL, NSError * _Nullable))completion {
    if (0 < message.length)
        message = [NSString stringWithFormat:message, type];
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(NO, [NSError errorWithMessage:message]);
    });
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
    return [version isEqualToString:[self DefaultsVersion]];
}

+ (void)setDefaultsVersion {
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:[self DefaultsVersion] forKey:DefaultVersionKey];
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

#pragma mark - Push Notification

+ (void)setPushNotificationDeviceToken:(NSData *)deviceToken {
    NSString *token = [self tokenStringFromTokenDate:deviceToken];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:DefaultPushNotificationDeviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)tokenStringFromTokenDate:(NSData *)deviceToken {
    NSUInteger length = deviceToken.length;
    if (length == 0) {
        return nil;
    }
    const unsigned char *buffer = deviceToken.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; ++i) {
        [hexString appendFormat:@"%02x", buffer[i]];
    }
    return [hexString copy];
}

+ (NSString *)pushNotificationDeviceToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultPushNotificationDeviceTokenKey];
    return token ? token : @"PUSH_NOTIFICATION_TOKEN_NONE";
}

+ (NSString *)pushNotificationPlatform {
#if DEBUG
    return @"APNS_SANDBOX";
#endif
    return @"APNS";
}

#pragma mark - Notification Center

+ (NSNotificationName)NotificationName_App_Terminated {
    return @"NotificationName_App_Terminated";
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

#pragma mark - regex and predicate

+ (NSString *)Predicate_MatchesSelf {
    return @"SELF MATCHES %@";
}

+ (NSString *)Regex_CharRange {
    return @"^([\\s\\.a-zA-Z0-9@-]{%d,%d})$";
}

+ (NSString *)Regex_CharRange_IntPositive {
    return @"^([0-9]{%d,%d})$";
}

+ (NSString *)Regex_CharRange_Int {
    return @"^([-]?[0-9]{%d,%d})$";
}

+ (NSString *)Regex_CharRange_FloatPositive {
    return @"^([0-9]{%d,%d}(\\.[0-9]{%d,%d})?)$";
}

+ (NSString *)Regex_CharRange_Float {
    return @"^([-]?[0-9]{%d,%d}(\\.[0-9]{%d,%d})?)$";
}

+ (NSString *)Regex_CharRange_Alphabet {
    return @"^([a-zA-Z]{%d,%d})$";
}

+ (NSString *)Regex_CharRange_Alphanumeric {
    return @"^([a-zA-Z0-9]{%d,%d})$";
}

+ (NSString *)Regex_CharRange_AlphaSpaceDot {
    return @"^([\\s\\.a-zA-Z]{%d,%d})$";
}

+ (NSString *)Regex_CharRange_Dash_Numeric {
    return @"^([0-9-]{%d,%d})$";
}

+ (NSString *)Regex_Email {
    return @"^([A-Z0-9a-z\\._%+-]){1,64}+@([A-Za-z0-9-]{2,64})+\\.+([A-Za-z\\.]{2,32})$";
}

+ (NSString *)Regex_Email_NoCheck {
    return @"^([A-Z0-9a-z\\._%+-@]){0,256}$";
}

+ (NSString *)Regex_Email_Has_AT {
    return @"^([A-Z0-9a-z\\._%+-]){1,64}+@([A-Za-z0-9-]{0,64})$";
}

+ (NSString *)Regex_Email_Has_AT_Dot {
    return @"^([A-Z0-9a-z\\._%+-]){1,64}+@([A-Za-z0-9-]{2,64})+\\.+([A-Za-z\\.]{0,32})$";
}

+ (NSString *)Regex_Phone {
    return @"^([0-9]{10})$";
}

+ (NSString *)Regex_Password {
    return @"^(?=.*?([A-Z]|[\\W]))(?=.*?[a-z])(?=.*?[0-9]).{8,48}$";
}

+ (NSString *)Regex_Password_Strong {
    return @"^(?=.{10,48}$)(?=.*[a-z])(?=.*[A-Z])(?=.*[\\d])(?=.*[@$!%*#?&])(([\\w\\s-\\/!-.:-@\\[-\\`{-~])\\2?(?!\\2))+$";
}

+ (NSString *)Regex_Address {
    return @"^([\\s\\.\\,a-zA-Z0-9-]{0,100})$";
}

+ (NSString *)Regex_Date {
    return @"^(((1[0-9][0-9][0-9])|(20[0-9][0-9]))-(0[0-9]|1[0-2])-((0[0-9])|([1-2][0-9])|(3[0-1])))$";
}

+ (NSString *)Regex_Gender {
    return @"^([fFmM]{1})$";
}

#pragma mark - core date
+ (NSString *)Search_Predicate_Format_Begins {
    return @"SELF.%K BEGINSWITH[cd] %@";
}

+ (NSString *)Search_Predicate_Format_Contains {
    return @"SELF.%K CONTAINS[cd] %@";
}

+ (NSString *)Search_Predicate_Format_Int_Equals {
    return @"SELF.%K == %d";
}

#pragma mark - core date and archive

+ (NSString *)CoreData_StorePath {
    return @"db.sqlite";
}

+ (NSString *)CoreData_ModelPath {
    return @"Model";
}

+ (NSString *)Archive_Data_Path {
    return @"DATA_PATH.plist";
}

+ (NSString *)Archive_Data_Key {
    return @"DATA_KEY";
}

+ (NSString *)Archive_File_ID_Key {
    return @"FILE_IDS_KEY";
}

#pragma mark - util update

+ (CGFloat)CheckBoxSize {
    return 44.0;
}

+ (UIEdgeInsets)CheckBoxInsets {
    return UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0);
}

+ (UIEdgeInsets)CheckBoxSubsectionInsets {
    return UIEdgeInsetsMake(8.0, 32.0, 8.0, 16.0);
}

+ (CGFloat)LoginLogoHeight {
    return 100.0;
}

+ (CGFloat)TableHeaderPadding {
    return 8.0;
}

+ (CGFloat)textFieldContentHorizontalPadding {
    return 16.0;
}

+ (CGFloat)textFieldContentVerticalPadding {
    return 4.0;
}

+ (CGSize)textFieldOverlayViewSize {
    return CGSizeMake(24.0, 24.0);
}

+ (NSUInteger)Image_Shrink_Max_Size_Bytes {
    return 200000;
}

+ (NSUInteger)Image_Shrink_Compression_Ratio {
    return 0.5;
}

+ (NSUInteger)Image_Shrink_Resize_Factor {
    return 2.0;
}

+ (NSUInteger)Image_Picker_Max_Selection {
    return 1;
}

+ (NSString *)Remember_Me_STR {
    return LOCALIZED(@"Remember Me");
}

+ (NSString *)OR_STR {
    return LOCALIZED(@"OR");
}

+ (NSString *)Next_STR {
    return LOCALIZED(@"Next");
}

+ (NSString *)Month_s_STR {
    return LOCALIZED(@"Month(s)");
}

+ (NSString *)Day_s_STR {
    return LOCALIZED(@"Day(s)");
}

+ (NSString *)Hour_s_STR {
    return LOCALIZED(@"Hour(s)");
}

+ (NSString *)Minute_s_STR {
    return LOCALIZED(@"Minute(s)");
}

+ (NSString *)documentsDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}


#pragma mark - methods and actions

+ (void)callPhoneNumber:(NSString *)num {
#ifdef AF_APP_EXTENSIONS
    return;
#else

    if (num.length == 0) return;
    
    num = [num numbersOnly];
    NSURL *urlPrompt = [NSURL URLWithString:[NSString telPromptFromString:num]];
    NSURL *url = [NSURL URLWithString:[NSString telFromString:num]];
    
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        [NSObject OKAlertWithTitle:@"Device can not make phone calls" message:nil];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:urlPrompt]) {
        [[UIApplication sharedApplication] openURL:urlPrompt options:@{} completionHandler:nil];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    else {
        [NSObject textFieldAlertWithTitle:@"Device can not dial this number" message:@"Please make sure the number is valid and try again" defaultText:num target:nil alertActionHandler:^(NSString *string) {
            [self callPhoneNumber:string];
        }];
    }
#endif
}

+ (NSDictionary *)appVersionDict {
    return [[self appBuildInfo] toDictionary];
}

+ (AppBuildInfo *)appBuildInfo {
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [AppBuildInfo infoWithVersionString:versionStr];
}

+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appVersionBuild {
    NSDictionary *versionDict = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [versionDict objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *version = [versionDict objectForKey:@"CFBundleShortVersionString"];
    version = [NSString stringWithFormat:@"%@ (%@)", version, build];
    return version;
}

+ (CGFloat)detailMinScreenWidth {
    float splitWidth = IS_IPAD ? [self SplitViewPrimaryWidth] : 0.0;
    return [self screenWidth] - splitWidth;
}

+ (MKU_UI_TYPE)UIType {
    return IS_IPAD ? MKU_UI_TYPE_IPAD : MKU_UI_TYPE_IPHONE;
}

+ (void)copyToClipboard:(NSString *)text {
    if (text.length == 0) return;

    UIPasteboard *obj = [UIPasteboard generalPasteboard];
    obj.string = text;
    [NSObject displayToastWithTitle:text message:@"Copied to Clipboard" duration:2];
}

+ (void)emailToAddress:(NSString *)text {
#ifdef AF_APP_EXTENSIONS
    return;
#else
    if (text.length == 0) return;

    [MKUMessageComposerController initComposerWithRecipient:text completion:^(MKU_MESSAGE_COMPOSER_RESULT result) {
        if (result == MKU_MESSAGE_COMPOSER_RESULT_FAILED) {
            [NSObject OKAlertWithTitle:@"Device can not send email" message:nil];
        }
    }];
#endif
}

+ (void)clearTempDirectory {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *temp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
        
        for (NSString *file in temp) {
            NSString *path = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file];
            [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
        }
    });
}

+ (NSURL *)writeToTempDirectoryWithFileName:(NSString *)fileName directory:(NSString *)directory data:(NSData *)data {
    if (data.length == 0 || fileName.length == 0) return nil;
    
    NSString *name = [[fileName filename] GUID];
    NSString *path = [name fileNameWithExtension:[data extension]];
    NSString *dir = [self tempDirectoryWithDirectory:directory];
    
    NSURL *URL = [[NSURL fileURLWithPath:dir isDirectory:YES] URLByAppendingPathComponent:path];
    if (URL) {
        DEBUGLOG(@"Saving file to tmp path: %@", URL);
        [data writeToURL:URL atomically:YES];
    }
    return URL;
}

+ (NSString *)tempDirectoryWithDirectory:(NSString *)directory {
    NSString *tmp = NSTemporaryDirectory();
    if (directory.length == 0) return tmp;
    ;
    NSString *path = [tmp stringByAppendingPathComponent:directory];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return path;
}

@end

