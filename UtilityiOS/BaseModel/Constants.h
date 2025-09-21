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

#define LOGGING YES

#if defined(DEBUG) && defined(LOGGING)
#define DEBUGLOG(s, ...) NSLog( @"<%@:%d> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DEBUGLOG(s, ...)
#endif

#define IS_IPHONE                               [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
#define IS_IPAD                                 [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad

#pragma mark - exceptions

#define MKUExceptionMissingMethodInClass                @"You have not implemented %@ in %@"
#define MKURaiseExceptionMissingMethodInClass           [NSException raise:NSInternalInconsistencyException format:MKUExceptionMissingMethodInClass, NSStringFromSelector(_cmd), NSStringFromClass([self class])];
#define MKURaiseExceptionIncorrectMethodUse(...)        [NSException raise:NSInternalInconsistencyException format:@"You are calling %@, use %@ instead", NSStringFromSelector(_cmd), ##__VA_ARGS__];
#define MKURaiseExceptionVariableInconsistency(...)     [NSException raise:NSInternalInconsistencyException format:@"In method %@, variable %@ is of type %@, you must use type %@ instead", NSStringFromSelector(_cmd), ##__VA_ARGS__];
#define MKURaiseExceptionPropertyIsNil(...)             [NSException raise:NSInternalInconsistencyException format:@"Proprty %@ cannot be nil when calling method %@ in class %@", ##__VA_ARGS__, NSStringFromSelector(_cmd), NSStringFromClass([self class])];

#pragma mark - timers

#define TIMER_DURATION_1_MIN                     60
#define TIMER_DURATION_5_MIN                     5*TIMER_DURATION_1_MIN
#define TIMER_DURATION_10_MIN                    10*TIMER_DURATION_1_MIN
#define TIMER_DURATION_1_HOUR                    60*TIMER_DURATION_1_MIN
#define TIMER_DURATION_12_HOUR                   12*TIMER_DURATION_1_HOUR

#define BADGE_POOLING_TIMER                      TIMER_DURATION_10_MIN

#pragma mark - regex

#define kRegexIntPositiveMaxChar                @"^([0-9]{0,%zd})$"
#define kRegexIntMaxChar                        @"^([-]?[0-9]{0,%zd})$"
#define kRegexFloatPositiveMaxChar              @"^([0-9]{0,%zd}(\\.[0-9]{0,%zd})?)$"
#define kRegexFloatMaxChar                      @"^([-]?[0-9]{0,%zd}(\\.[0-9]{0,%zd})?)$"
#define kRegexLettersMaxChar                    @"^([a-zA-Z]{0,%zd})$"
#define kRegexAlphanumericMaxChar               @"^([a-zA-Z0-9]{0,%zd})$"
#define kRegexHTML                              @"<.+?>"

#pragma mark - constant strings

#define LOCALIZED(s)                            NSLocalizedString(s, nil)

#define kSingleEmptyString                      @" "
#define kColonEmptyString                       @": "
#define kEmptyString                            @""
#define kElipsisString                          @"..."

#define kInkBlueHEXValue                        0x0039a6

#pragma mark - removed from SDKs

#define kPBKDFRounds                            10000 //used in crypto


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
    ServerEnvironment_QA,
    ServerEnvironment_PROD,
    ServerEnvironment_BASE
};

enum {
    TargetType_NONE = -1,
    TargetType_BASE
};

typedef NS_ENUM(NSInteger, MKU_TEXT_TYPE) {
    MKU_TEXT_TYPE_NONE = -1,
    MKU_TEXT_TYPE_STRING,
    MKU_TEXT_TYPE_INT,
    MKU_TEXT_TYPE_INT_POSITIVE,
    MKU_TEXT_TYPE_FLOAT,
    MKU_TEXT_TYPE_FLOAT_POSITIVE,
    MKU_TEXT_TYPE_ALPHABET,
    MKU_TEXT_TYPE_ALPHANUMERIC,
    MKU_TEXT_TYPE_ALPHASPACEDOT,
    MKU_TEXT_TYPE_NAME,
    MKU_TEXT_TYPE_EMAIL,
    MKU_TEXT_TYPE_PHONE,
    MKU_TEXT_TYPE_ADDRESS,
    MKU_TEXT_TYPE_DATE,
    MKU_TEXT_TYPE_GENDER,
    MKU_TEXT_TYPE_PASSWORD,
    MKU_TEXT_TYPE_HTML,
    MKU_TEXT_TYPE_COUNT
};

typedef NS_OPTIONS(NSUInteger, MKU_IMAGE_PICKER_TYPE) {
    MKU_IMAGE_PICKER_TYPE_CAMERA        = 1 << 0,
    MKU_IMAGE_PICKER_TYPE_VISION        = 1 << 1,
    MKU_IMAGE_PICKER_TYPE_DOCS_IMPORT   = 1 << 2,
    MKU_IMAGE_PICKER_TYPE_DOCS_EXPORT   = 1 << 3,
    MKU_IMAGE_PICKER_TYPE_PHOTOS_IMPORT = 1 << 4,
    MKU_IMAGE_PICKER_TYPE_PHOTOS_EXPORT = 1 << 5,
    MKU_IMAGE_PICKER_TYPE_BROWSER       = 1 << 6
};

typedef NS_ENUM(NSUInteger, ViewPosition) {
    ViewPosition_TOP,
    ViewPosition_LEFT,
    ViewPosition_BOTTOM,
    ViewPosition_RIGHT
};

typedef NS_ENUM(NSUInteger, MoveDirection) {
    MoveDirection_NONE,
    MoveDirection_FORWARD,
    MoveDirection_BACKWARD
};

typedef NS_ENUM(NSUInteger, CELL_SIZE_TYPE) {
    CELL_SIZE_TYPE_SMALL,
    CELL_SIZE_TYPE_MEDIUM,
    CELL_SIZE_TYPE_LARGE
};

typedef NS_OPTIONS(NSUInteger, LINEAR_BOUNDARY_POINT) {
    LINEAR_BOUNDARY_POINT_START = 1 << 0,
    LINEAR_BOUNDARY_POINT_END   = 1 << 1
};

typedef NS_ENUM(NSUInteger, MKU_BINARY_TYPE) {
    MKU_BINARY_TYPE_NO,
    MKU_BINARY_TYPE_YES,
    MKU_BINARY_TYPE_COUNT
};

typedef NS_ENUM(NSInteger, MKU_TENARY_TYPE) {
    MKU_TENARY_TYPE_NONE = -1,
    MKU_TENARY_TYPE_NO,
    MKU_TENARY_TYPE_YES
};

typedef NS_ENUM(NSUInteger, MKU_COLUMN_TYPE) {
    MKU_COLUMN_TYPE_LEFT,
    MKU_COLUMN_TYPE_RIGHT,
    MKU_COLUMN_TYPE_COUNT
};

typedef NS_ENUM(NSUInteger, MKU_ROW_TYPE) {
    MKU_ROW_TYPE_TOP,
    MKU_ROW_TYPE_BOTTOM,
    MKU_ROW_TYPE_COUNT
};

typedef NS_ENUM(NSUInteger, MKU_VIEW_ALIGNMENT_TYPE) {
    MKU_VIEW_ALIGNMENT_TYPE_HORIZONTAL,
    MKU_VIEW_ALIGNMENT_TYPE_VERTICAL
};

typedef NS_ENUM(NSUInteger, MKU_IMAGE_TITLE_BORDER_STYLE) {
    MKU_IMAGE_TITLE_BORDER_STYLE_NONE,
    MKU_IMAGE_TITLE_BORDER_STYLE_IMAGE,
    MKU_IMAGE_TITLE_BORDER_STYLE_ALL
};

typedef NS_ENUM(NSUInteger, MKU_ACTION_ALERT_TYPE) {
    MKU_ACTION_ALERT_TYPE_OK,
    MKU_ACTION_ALERT_TYPE_YESNO,
    MKU_ACTION_ALERT_TYPE_RETRY
};

typedef NS_ENUM(NSUInteger, MKU_LIST_ITEM_SELECTED_ACTION) {
    MKU_LIST_ITEM_SELECTED_ACTION_NONE,
    MKU_LIST_ITEM_SELECTED_ACTION_SELECT,
    MKU_LIST_ITEM_SELECTED_ACTION_SHOW_DETAIL,
    MKU_LIST_ITEM_SELECTED_ACTION_TRANSITION_TO_DETAIL
};

typedef NS_ENUM(NSUInteger, MKU_VIEW_HIERARCHY_POSITION) {
    MKU_VIEW_HIERARCHY_POSITION_NEUTRAL,
    MKU_VIEW_HIERARCHY_POSITION_BACK,
    MKU_VIEW_HIERARCHY_POSITION_FRONT
};

typedef NS_OPTIONS(NSUInteger, MKU_VIEW_POSITION) {
    MKU_VIEW_POSITION_NONE      = 0,
    MKU_VIEW_POSITION_TOP       = 1 << 0,
    MKU_VIEW_POSITION_LEFT      = 1 << 1,
    MKU_VIEW_POSITION_BOTTOM    = 1 << 2,
    MKU_VIEW_POSITION_RIGHT     = 1 << 3,
    MKU_VIEW_POSITION_CENTER_Y  = 1 << 4,
    MKU_VIEW_POSITION_CENTER_X  = 1 << 5
};

typedef NS_ENUM(NSUInteger, MKU_UI_TYPE) {
    MKU_UI_TYPE_IPHONE,
    MKU_UI_TYPE_IPAD
};

typedef NS_ENUM(NSUInteger, MKU_APP_TARGET_TYPE) {
    MKU_APP_TARGET_TYPE_DEFAULT,
    MKU_APP_TARGET_TYPE_ENTERPRISE
};

typedef NS_OPTIONS(NSUInteger, MKU_VIEW_STYLE) {
    MKU_VIEW_STYLE_PLAIN         = 0,
    MKU_VIEW_STYLE_BORDER        = 1 << 0,
    MKU_VIEW_STYLE_ROUND_CORNERS = 1 << 1
};

typedef UIView * (^VIEW_CREATION_HANDLER)(void);
typedef UIView * (^SINGLE_INDEX_VIEW_CREATION_HANDLER)(NSUInteger index);
typedef UIView * (^SINGLE_INDEX_SIZE_VIEW_CREATION_HANDLER)(NSUInteger index, CGFloat size);
typedef UIView * (^DOUBLE_INDEX_VIEW_CREATION_HANDLER)(NSUInteger row, NSUInteger column);
typedef UIView * (^DOUBLE_INDEX_SIZE_VIEW_CREATION_HANDLER)(NSUInteger row, NSUInteger column, CGFloat width, CGFloat height);

typedef BOOL (^EvaluateSelectedObjectHandler)(id obj);
typedef void (^VoidActionHandler)();
typedef MKU_LIST_ITEM_SELECTED_ACTION (^LIST_ITEM_SELECTED_ACTION_HANDLER)(NSUInteger type);
typedef NSDictionary <NSString *, VoidActionHandler> *TitleVoidActionHandlers;

typedef NSSet<NSString *>                                       StringSet;
typedef NSMutableSet<NSString *>                                MStringSet;

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

typedef NSDictionary <Class, NSString *>                        ClassStringDict;

typedef NSDictionary<NSString *, NSString *>                    StringDict;
typedef NSMutableDictionary<NSString *, NSString *>             MStringDict;

typedef NSDictionary<NSNumber *, NSString *>                    NumStringDict;
typedef NSMutableDictionary<NSNumber *, NSString *>             MNumStringDict;

typedef NSDictionary<NSString *, NSNumber *>                    StringNumDict;
typedef NSMutableDictionary<NSString *, NSNumber *>             MStringNumDict;

typedef NSDictionary<NSNumber *, NSNumber *>                    NumNumDict;
typedef NSMutableDictionary<NSNumber *, NSNumber *>             MNumNumDict;


#pragma mark - defaults

extern NSString * const DefaultLoggedInUsersKey;
extern NSString * const DefaultVersionKey;
extern NSString * const DefaultSavedUsersKey;
extern NSString * const DefaultPushNotificationDeviceTokenKey;

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
extern NSString * const DateFormatFullTimeStyle;
extern NSString * const DateFormatTimeStyle;
extern NSString * const DateFormatShortAPMStyle;
extern NSString * const DateFormatWeekdayMonthLongStyle;
extern NSString * const DateFormatTimeAPMStyle;
extern NSString * const DateFormatFullTimeZoneStyle;
extern NSString * const DateFormatLongStyle;
extern NSString * const DateFormatShortSlashStyle;
extern NSString * const DateFormatTimeLongStyle;
extern NSString * const DateFormatTimeShortStyle;
extern NSString * const DateFormatDayTimeStyle;
extern NSString * const DateFormatDayTimeStyleLineBreak;
extern NSString * const DateFormatDayStyle;
extern NSString * const DateFormatDateTimeStyle;
extern NSString * const DateFormatDateTimeCompactStyle;
extern NSString * const DateFormatMonthTimeCompactStyle;

typedef NS_ENUM(NSUInteger, DATE_FORMAT_STYLE) {
    DATE_FORMAT_SERVER_STYLE,
    DATE_FORMAT_SHORT_STYLE,
    DATE_FORMAT_WEEKDAY_SHORT_STYLE,
    DATE_FORMAT_FULL_STYLE,
    DATE_FORMAT_MONTHDAY_YEAR_STYLE,
    DATE_FORMAT_MONTH_YEAR_STYLE,
    DATE_FORMAT_DAY_MONTH_YEAR_STYLE,
    DATE_FORMAT_DAY_MONTH_YEAR_NUMERIC_STYLE,
    DATE_FORMAT_WEEKDAY_DAY_STYLE,
    DATE_FORMAT_FULL_TIME_STYLE,
    DATE_FORMAT_TIME_STYLE,
    DATE_FORMAT_SHORT_APM_STYLE,
    DATE_FORMAT_WEEKDAY_MONTH_LONG_STYLE,
    DATE_FORMAT_TIME_APM_STYLE,
    DATE_FORMAT_FULL_TIMEZONE_STYLE,
    DATE_FORMAT_LONG_STYLE,
    DATE_FORMAT_SHORT_SLASH_STYLE,
    DATE_FORMAT_TIME_LONG_STYLE,
    DATE_FORMAT_TIME_SHORT_STYLE,
    DATE_FORMAT_DAY_TIME_STYLE,
    DATE_FORMAT_DAY_TIME_LINEBREAK_STYLE,
    DATE_FORMAT_DAY_STYLE,
    DATE_FORMAT_DATE_TIME_STYLE,
    DATE_FORMAT_DATE_TIME_COMPACT_STYLE,
    DATE_FORMAT_MONTH_TIME_COMPACT_STYLE
};

typedef NS_ENUM(NSUInteger, NUMBER_FORMAT_STYLE) {
    NUMBER_FORMAT_STYLE_FLOAT,
    NUMBER_FORMAT_STYLE_INT,
    NUMBER_FORMAT_STYLE_FLOAT_PERCENT,
    NUMBER_FORMAT_STYLE_INT_PERCENT,
    NUMBER_FORMAT_STYLE_TWO_FLOAT
};

typedef NS_ENUM(NSUInteger, MKU_LIST_DATE_SECTION) {
    MKU_LIST_DATE_SECTION_DATE,
    MKU_LIST_DATE_SECTION_LIST,
    MKU_LIST_DATE_SECTION_COUNT
};

typedef NS_ENUM(NSUInteger, MKU_BADGE_VIEW_STATE) {
    MKU_BADGE_VIEW_STATE_ALERT,
    MKU_BADGE_VIEW_STATE_DONE
};

#pragma mark - classes
/** @brief This class contains the constants used throughout the app
 @note Projects must define a subclass of this class called AppCommon containing app specific constants.
 @note Define a Category Constants+[YourAppName] to swizzle implementations of this base class.
 Different implementations are done via swizzling in A category of Constants. All methods are class methods, no instance of this class is created.
 */
@interface Constants : NSObject

#pragma mark - networking

+ (ServerEnvironment)ServerEnvironmentVariable;
+ (BOOL)USING_HTTPS;
/** @brief Default is NO. If NO, JSONModel methods will be used, otherwise XMLSerialize which is compatible with XML will be done. */
+ (BOOL)USING_SOAP;
/** @brief This url must be of form ://domain */
+ (NSString *)BaseLocalHostURL;
/** @brief This url must be of form ://domain */
+ (NSString *)BaseTestingInURL;
/** @brief This url must be of form ://domain */
+ (NSString *)BaseTestingOutURL;
/** @brief This url must be of form ://domain */
+ (NSString *)BaseDevInURL;
/** @brief This url must be of form ://domain */
+ (NSString *)BaseDevOutURL;
/** @brief This url must be of form ://domain */
+ (NSString *)BaseQAURL;
/** @brief This url must be of form ://domain */
+ (NSString *)BaseProductionURL;
+ (NSString *)BaseURLString;
/** @brief The url used to generate BaseURLString, it can be  BaseDevInURL etc. or other defined values */
+ (NSString *)CommonURLString;
+ (NSString *)BasePort;
+ (NSString *)URLStringWithHttps:(NSString *)https url:(NSString *)url port:(NSString *)port;
+ (NSString *)TestUsername;
+ (NSString *)TestPassword;
+ (StringArr *)ServerDateFormats;

#pragma mark - constants

+ (CGFloat)TransitionAnimationDuration;
+ (CGFloat)PrimaryColumnWidth;
+ (CGFloat)MaxPrimaryColumnWidth;
+ (CGFloat)MinPrimaryColumnWidth;
+ (CGFloat)PrimaryColumnShrunkenWidth;
+ (CGFloat)BarButtonItemSpaceWidth;
+ (CGFloat)TextFieldHeight;
+ (CGFloat)TextViewTitleHeight;
+ (CGFloat)TextViewMediumHeight;
+ (CGFloat)NumericInputTextFieldWidth;
+ (CGFloat)InputTextFieldWidth;
+ (CGFloat)DefaultRowHeight;
+ (CGFloat)ExtendedRowHeight;
+ (CGFloat)TableSectionHeaderHeight;
+ (CGFloat)TableSectionHeaderMediumHeight;
+ (CGFloat)TableSectionHeaderShortHeight;
+ (CGFloat)TableSectionFooterHeight;
+ (CGFloat)TableFooterHeight;
+ (CGFloat)TableCellAccessorySize;
+ (CGFloat)TableIconImageSmallSize;
+ (CGFloat)TableIconImageLargeSize;
+ (CGFloat)TableCellLineHeight;
+ (CGFloat)TableCellContentHorizontalMargin;
+ (CGFloat)TableCellContentVerticalMargin;
+ (CGFloat)BorderWidth;
+ (CGFloat)ButtonCornerRadious;
+ (CGFloat)GeoFenceRadiousMeter;
+ (CGFloat)GeoFenceRadiousKiloMeter;
+ (CGFloat)TextPadding;
+ (CGFloat)HorizontalSpacing;
+ (CGFloat)VerticalSpacing;
+ (UIEdgeInsets)TabBarItemImageInsets;
+ (CGFloat)TabBarHeight;
+ (CGFloat)NavbarItemSpaceWidth;
+ (CGFloat)SplitViewPrimaryWidth;
+ (CGFloat)LoginViewInset;
+ (CGFloat)LoginViewWidth;
+ (CGFloat)BadgeHeight;
+ (CGFloat)SpinnerBadgeSpacing;
+ (CGSize)TableCellDisclosureIndicatorSize;
+ (CGFloat)Toast_Length_Seconds;
+ (CGFloat)Subsection_Left_Spacing;
+ (CGFloat)DatePickerPopOverHeight;
+ (CGFloat)DatePickerCalendarHeight;
+ (CGFloat)ButtonChevronSize;
+ (CGSize)SpinnerSize;
+ (CGSize)ImageShrinkMaxSize;
+ (CGSize)DateViewControllerPopoverSize;
+ (CGSize)DateViewControllerCalPopoverSize;
+ (NSUInteger)MaxValue1CellCharacterCount;
+ (NSUInteger)MaxTextViewCharacters;
+ (NSUInteger)MaxTextViewCharactersLong;

#pragma mark - defaults

+ (NSString *)DefaultsVersion;

#pragma mark - flags

+ (BOOL)IS_TESTING;

#pragma mark - strings

+ (NSString *)Exit_Title_STR;
+ (NSString *)Exit_Message_STR;
+ (NSString *)Login_Failed_Title_STR;
+ (NSString *)Login_Failed_Message_STR;
+ (NSString *)Update_Failed_Title_STR;
+ (NSString *)Save_Successful_STR;
+ (NSString *)Success_STR;
+ (NSString *)FaceID_STR;
+ (NSString *)TouchID_STR;
+ (NSString *)Done_STR;
+ (NSString *)Save_STR;
+ (NSString *)Reset_STR;
+ (NSString *)Replace_STR;
+ (NSString *)Remove_STR;
+ (NSString *)Delete_STR;
+ (NSString *)Delete_Prompt_Message_STR;
+ (NSString *)OK_STR;
+ (NSString *)Cancel_STR;
+ (NSString *)Clear_STR;
+ (NSString *)Close_STR;
+ (NSString *)Skip_STR;
+ (NSString *)Yes_STR;
+ (NSString *)No_STR;
+ (NSString *)Retry_STR;
+ (NSString *)Choose_STR;
+ (NSString *)Select_STR;
+ (NSString *)Comments_STR;
+ (NSString *)Notes_STR;
+ (NSString *)Details_STR;
+ (NSString *)Other_STR;
+ (NSString *)Sign_STR;
+ (NSString *)Register_STR;
+ (NSString *)Update_STR;
+ (NSString *)PIN_STR;
+ (NSString *)Username_STR;
+ (NSString *)Password_STR;
+ (NSString *)Enter_Password_STR;
+ (NSString *)Login_STR;
+ (NSString *)Enter_BLANK_STR;
+ (NSString *)Incorrect_BLANK_STR;
+ (NSString *)LocationRestrictedTitle_STR;
+ (NSString *)LocationRestrictedMessage_STR;
+ (NSString *)Camera_STR;
+ (NSString *)Photo_Library_STR;
+ (NSString *)Document_Picker_STR;
+ (NSString *)Document_Browser_STR;
+ (NSString *)Document_Detection_STR;
+ (NSString *)CameraDisabledTitle_STR;
+ (NSString *)CameraAccessMessage_BLANK_STR;
+ (NSString *)TakingPicture_STR;
+ (NSString *)ScanningBarcode_STR;
+ (NSString *)NoCamera_STR;
+ (NSString *)Invalid_STR;
+ (NSString *)Error_STR;
+ (NSString *)Untitled_STR;
+ (NSString *)First_Name_STR;
+ (NSString *)Last_Name_STR;
+ (NSString *)No_Items_Available_STR;
+ (NSString *)Placeholder_Date_STR;
+ (NSString *)Placeholder_Phone_STR;
+ (NSString *)NO_Connection_Title_STR;
+ (NSString *)Add_New_Item_STR;
+ (NSString *)Generic_Error_Message_STR;
+ (NSString *)No_Camera_Error_Message_STR;
+ (NSString *)Camera_Disabled_Error_Title_STR;
+ (NSString *)Camera_Disabled_Error_Message_STR;
+ (NSString *)Missing_Value_Error_Message_STR;
+ (NSString *)Missing_Object_Error_Message_STR;
+ (NSString *)Search_Not_Found_STR;
+ (NSString *)Save_Failed_STR;
+ (NSString *)Delete_Failed_STR;
+ (NSString *)Try_Again_STR;
+ (NSString *)Touch_ID_STR;
+ (NSString *)Face_ID_STR;
+ (NSString *)Login_Biometrics_Message_STR;
+ (NSString *)Biometrics_Authentication_Failed_Message_STR;
+ (NSString *)Biometrics_Cannot_Perform_Message_STR;
+ (NSString *)Biometrics_User_Mismatch_Message_STR;
+ (NSString *)Colon_Empty_STR;

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
+ (UIEdgeInsets)safeAreaInsets;
+ (CGFloat)safeAreaHeight;
+ (CGFloat)bottomSafeAreaHeight;
+ (NSDictionary *)appVersionDict;
+ (NSString *)appVersion;
+ (NSString *)appVersionBuild;
+ (CGFloat)detailMinScreenWidth;
+ (MKU_UI_TYPE)UIType;

#pragma mark - Push Notification

/** @brief By default removes the "<>" and spaces */
+ (void)setPushNotificationDeviceToken:(NSData *)deviceToken;
+ (NSString *)tokenStringFromTokenDate:(NSData *)deviceToken;
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
+ (NSString *)Regex_Password;
+ (NSString *)Regex_Password_Strong;
+ (NSString *)Search_Predicate_Format_Begins;
+ (NSString *)Search_Predicate_Format_Contains;
+ (NSString *)Search_Predicate_Format_Int_Equals;

#pragma mark - core date and archive

+ (NSString *)CoreData_StorePath;
+ (NSString *)CoreData_ModelPath;

+ (NSString *)Archive_Data_Path;
+ (NSString *)Archive_Data_Key;
/** @biref File ID is timestamp-GUID */
+ (NSString *)Archive_File_ID_Key;

#pragma mark - util update

+ (CGFloat)CheckBoxSize;
+ (UIEdgeInsets)CheckBoxInsets;
+ (UIEdgeInsets)CheckBoxSubsectionInsets;
+ (CGFloat)LoginLogoHeight;
+ (CGFloat)TableHeaderPadding;

+ (NSString *)OR_STR;
+ (NSString *)Remember_Me_STR;
+ (NSString *)Next_STR;

+ (NSString *)Month_s_STR;
+ (NSString *)Day_s_STR;
+ (NSString *)Hour_s_STR;
+ (NSString *)Minute_s_STR;

+ (NSString *)documentsDirectory;

+ (CGFloat)textFieldContentHorizontalPadding;
+ (CGFloat)textFieldContentVerticalPadding;
+ (CGSize)textFieldOverlayViewSize;

+ (NSUInteger)Image_Shrink_Max_Size_Bytes;
+ (NSUInteger)Image_Shrink_Compression_Ratio;
+ (NSUInteger)Image_Shrink_Resize_Factor;
+ (NSUInteger)Image_Picker_Max_Selection;

+ (NSUInteger)Max_Stepper_Quantity;

#pragma mark - methods and actions

+ (void)callPhoneNumber:(NSString *)num;
+ (void)copyToClipboard:(NSString *)text;
+ (void)emailToAddress:(NSString *)text;
+ (void)clearTempDirectory;
+ (NSURL *)writeToTempDirectoryWithFileName:(NSString *)fileName directory:(NSString *)directory data:(NSData *)data;
+ (NSString *)tempDirectoryWithDirectory:(NSString *)directory;

#pragma mark - biometrics

+ (BOOL)canAutentiacteWithBiometrics;
+ (BOOL)touchIDIsAvaialable;
+ (BOOL)faceIDIsAvaialable;
+ (NSString *)bioMetricName;
+ (void)autentiacteWithBiometrics:(void (^)(BOOL success, NSError *error))completion;

@end


