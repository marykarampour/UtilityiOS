//
//  NSDate+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-04.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUDateRange.h"

typedef NS_ENUM(NSUInteger, MKU_REFERENCE_DATE_TYPE) {
    MKU_REFERENCE_DATE_TYPE_0,//No change - same date as self
    MKU_REFERENCE_DATE_TYPE_1970,
    MKU_REFERENCE_DATE_TYPE_1900,
    MKU_REFERENCE_DATE_TYPE_2001
};

@interface NSDate (Utility)

- (NSDate *)endOfWeekLocal;
- (NSDate *)startOfWeekLocal;
- (NSDate *)endOfWeekGMT;
- (NSDate *)startOfWeekGMT;
- (NSDate *)midnightLocal;
- (NSDate *)midnightGMT;
- (NSDate *)endOfDay;

- (NSDate *)weekStartDate;
- (NSInteger)dayDifferenceWithWeekStartDate;

- (NSDate *)updateCalendarUnit:(NSCalendarUnit)unit value:(NSInteger)value;
- (NSUInteger)valueForCalendarUnit:(NSCalendarUnit)unit;

- (NSDate *)updateDayWithValue:(NSInteger)value;
- (NSDate *)updateMonthWithValue:(NSInteger)value;
- (NSDate *)updateYearWithValue:(NSInteger)value;
- (NSString *)dateStringWithFormat:(NSString *)format;
- (NSArray *)monthStringsWithFormat:(NSString *)format untilDate:(NSDate *)date;
+ (NSUInteger)daysBetweenFromDate:(NSDate *)from toDate:(NSDate *)to;

/** @brief Any component which is 0 will not be set */
+ (NSDate *)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

/** @brief Any component which is 0 will not be set */
- (NSDate *)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;

- (__kindof MKUDateRange *)yearRange;
- (__kindof MKUDateRange *)monthRange;

- (NSNumber *)unixtimestamp;

/** @brief array of the first character of day symbols */
+ (StringArr *)charDaysOfWeek;
+ (StringArr *)daysOfWeek;
+ (StringArr *)monthsOfYear;
+ (StringArr *)longMonthsOfYear;

- (NSString *)dateStringWithFormat:(DATE_FORMAT_STYLE)format isUTC:(BOOL)isUTC;
- (NSString *)UTCDateString;
- (NSString *)UTCDateStringWithFormat:(DATE_FORMAT_STYLE)format;
- (NSString *)localDateStringWithFormat:(DATE_FORMAT_STYLE)format;
- (NSComparisonResult)compareDayComponents:(NSDate *)date;
- (NSComparisonResult)compareTimeComponents:(NSDate *)date;

- (NSNumber *)minute;
- (NSNumber *)hour;
- (NSNumber *)day;
- (NSNumber *)month;
- (NSNumber *)year;
- (NSDate *)firstDateOfMonth;

- (NSDate *)setTimeComponentToDate:(NSDate *)date;
- (NSDate *)setTimeComponentToDate:(NSDate *)date startDate:(NSDate *)startDate;
- (NSDate *)setDayComponentToDate:(NSDate *)date;
- (NSDate *)setNoneTimeComponentToDate:(NSDate *)date;
+ (NSDate *)dateWithTimeIntervalSince1900;
/** @brief Creates a date with date part from the given MKU_REFERENCE_DATE_TYPE and the time portion of self. */
- (NSDate *)dateWithReferenceDateType:(MKU_REFERENCE_DATE_TYPE)type;
/** @brief Creates a date with date part from the given MKU_REFERENCE_DATE_TYPE and the time portion of date. */
+ (NSDate *)dateWithReferenceDateType:(MKU_REFERENCE_DATE_TYPE)type date:(NSDate *)date;
/** @brief Adds the differene between the given MKU_REFERENCE_DATE_TYPE and fromDate in seconds to self. */
- (NSDate *)addDifferenceBetweenReferenceDateType:(MKU_REFERENCE_DATE_TYPE)type andDate:(NSDate *)fromDate;
/** @brief Adds the differene between the given MKU_REFERENCE_DATE_TYPE and fromDate in seconds to toDate. */
+ (NSDate *)addDifferenceBetweenReferenceDateType:(MKU_REFERENCE_DATE_TYPE)type andDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

+ (NSTimeZone *)UTCTimeZone;
+ (NSTimeZone *)systemTimeZone;

#pragma mark - string formatting

- (NSAttributedString *)attributedDescriptionWithTitle:(NSString *)title;

@end
