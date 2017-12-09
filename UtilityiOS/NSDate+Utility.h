//
//  NSDate+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-04.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

- (NSDate *)endOfWeekLocal;
- (NSDate *)startOfWeekLocal;
- (NSDate *)endOfWeekGMT;
- (NSDate *)startOfWeekGMT;
- (NSDate *)midnightLocal;
- (NSDate *)midnightGMT;
- (NSDate *)updateDayWithValue:(NSInteger)value;
- (NSDate *)updateMonthWithValue:(NSInteger)value;
- (NSDate *)updateYearWithValue:(NSInteger)value;
- (NSString *)dateStringWithFormat:(NSString *)format;
- (NSArray *)monthStringsWithFormat:(NSString *)format untilDate:(NSDate *)date;
+ (NSUInteger)daysBetweenFromDate:(NSDate *)from toDate:(NSDate *)to;

@end
