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

#pragma mark - defaults

NSString * const DefaultLoggedInUsersKey = @"DefaultLoggedInUsersKey";
NSString * const DefaultVersionKey       = @"DefaultVersionKey";
NSString * const DefaultSavedUsersKey    = @"DefaultSavedUsersKey";
NSString * const DefaultPushNotificationDeviceTokenKey    = @"DefaultPushNotificationDeviceTokenKey";

#pragma mark - format

NSString * const DateFormatServerStyle            = @"YYYY-MM-dd HH:mm:ss";
NSString * const DateFormatShortStyle             = @"yyyy-MM-dd";
NSString * const DateFormatWeekdayShortStyle      = @"EEEE MMM dd";
NSString * const DateFormatFullStyle              = @"EEEE, MMMM dd, yyyy";
NSString * const DateFormatMonthDayYearStyle      = @"MMMM dd, yyyy";
NSString * const DateFormatMonthYearStyle         = @"MMMM yyyy";
NSString * const DateFormatDayMonthYearStyle      = @"dd MMMM yyyy";
NSString * const DateFormatDayMonthYearNumericStyle = @"dd MM yyyy";
NSString * const DateFormatWeekdayDayStyle        = @"EEEE dd";

NSString * const DateFormatFullTimeStyle          = @"HH:mm:ss EEEE, MMMM dd, yyyy";
NSString * const DateFormatTimeStyle              = @"HH:mm:ss a";
NSString * const DateFormatShortAPMStyle          = @"yyyy/MM/dd hh:mm a";

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


#pragma mark - constants

+ (float)TransitionAnimationDuration {
    return 0.4;
}

+ (float)PrimaryColumnWidth {
    return 256.0;
}

+ (float)MaxPrimaryColumnWidth {
    return 256.0;
}

+ (float)MinPrimaryColumnWidth {
    return 0.0;
}

+ (float)PrimaryColumnShrunkenWidth {
    return 44.0;
}

+ (float)DefaultRowHeight {
    return 44.0;
}

+ (float)TableSectionHeaderHeight {
    return 32.0;
}

+ (float)TableSectionFooterHeight {
    return 0.0;
}

+ (float)TableFooterHeight {
    return 44.0;
}

+ (float)TableIconImageSmallSize {
    return 32.0;
}

+ (float)TableIconImageLargeSize {
    return 64.0;
}

+ (float)ButtonCornerRadious {
    return 6.0;
}

+ (float)BorderWidth {
    return 1.0;
}

+ (float)TextPadding {
    return 4.0;
}

+ (float)HorizontalSpacing {
    return 8.0;
}

+ (float)VerticalSpacing {
    return 8.0;
}

+ (CGSize)SpinnerSize {
    return CGSizeMake(120.0, 120.0);
}

+ (UIEdgeInsets)TabBarItemImageInsets {
    return UIEdgeInsetsMake(8.0, 0.0, -8.0, 0.0);
}

+ (float)LoginViewInset {
    return 100.0;
}

+ (float)LoginViewWidth {
    return 400.0;
}

+ (float)BadgeHeight {
    return 20.0;
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

+ (NSString *)ExitTitle_STR {
    return LOCALIZED(@"Exit");
}

+ (NSString *)ExitMessage_STR {
    return LOCALIZED(@"Are you sure you want to exit?");
}

+ (NSString *)LoginFailedTitle_STR {
    return LOCALIZED(@"Login Failed!");
}

+ (NSString *)LoginFailedMessage_STR {
    return LOCALIZED(@"Please check your credentials and try again.");
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

+ (NSString *)Replace_STR {
    return LOCALIZED(@"Replace");
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

+ (NSString *)Skip_STR {
    return LOCALIZED(@"Skip");
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

+ (NSString *)CameraDisabledTitle_STR {
    return LOCALIZED(@"Camera is disabled!");
}

+ (NSString *)CameraAccessMessage_BLANK_STR {
    return LOCALIZED(@"Camera access is required for %@. Go to settings to enable camera.");
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

+ (NSString *)Placeholder_Date_STR {
    return LOCALIZED(@"1980-02-28");
}

+ (NSString *)Placeholder_Phone_STR {
    return LOCALIZED(@"12223334444");
}

+ (NSString *)NO_Connection_Title_STR {
    return LOCALIZED(@"No Network Connection is available");
}


+ (float)GeoFenceRadiousKiloMeter {
    return 1.0;
}

+ (float)GeoFenceRadiousMeter {
    return [Constants GeoFenceRadiousKiloMeter]*1000.0;
}

+ (NSString *)BaseURLString {
    NSString *https = [Constants USING_HTTPS] ? @"https" : @"http";
    NSString *url = [self CommonURLString];
    return [self URLStringWithHttps:https url:url port: [Constants BasePort]];
}

+ (NSString *)URLStringWithHttps:(NSString *)https url:(NSString *)url port:(NSString *)port {
    return [NSString stringWithFormat:@"%@%@%@", https, url, port];
}

+ (NSString *)CommonURLString {
   
    switch ([Constants ServerEnvironmentVariable]) {
        case ServerEnvironment_PROD:        return [Constants BaseProductionURL];
        case ServerEnvironment_QA:          return [Constants BaseQAURL];
        case ServerEnvironment_TESTING_IN:  return [Constants BaseTestingInURL];
        case ServerEnvironment_TESTING_OUT: return [Constants BaseTestingOutURL];
        case ServerEnvironment_LOCAL:       return [Constants BaseLocalHostURL];
        case ServerEnvironment_DEV_IN:      return [Constants BaseDevInURL];
        case ServerEnvironment_DEV_OUT:
        default: return [Constants BaseDevOutURL];
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
#else
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    if ([window respondsToSelector:@selector(safeAreaInsets)]) {
        if (@available(iOS 11.0, *)) {
            return window.safeAreaInsets;
        }
    }
    return UIEdgeInsetsZero;
#endif
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
            
            return inset > 0.0 ? inset : [Constants statusBarHeight];
        }
    }
    return [Constants statusBarHeight];
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
    return [Constants statusBarHeight];
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
    NSString *phoneNum = [NSString telFromString:num];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
#endif
}

@end
