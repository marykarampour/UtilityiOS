//
//  NSDate+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-04.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKDateRange.h"

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

- (__kindof MKDateRange *)yearRange;
- (__kindof MKDateRange *)monthRange;

- (NSUInteger)year;
- (NSUInteger)month;

- (NSNumber *)unixtimestamp;

/** @brief array of the first character of day symbols */
+ (StringArr *)charDaysOfWeek;
+ (StringArr *)daysOfWeek;
+ (StringArr *)monthsOfYear;
+ (StringArr *)longMonthsOfYear;

@end
