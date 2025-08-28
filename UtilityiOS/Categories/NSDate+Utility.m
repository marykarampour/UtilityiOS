//
//  NSDate+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-04.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSDate+Utility.h"
#import "NSString+AttributedText.h"

@implementation NSDate (Utility)

- (NSDate *)midnightLocal {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    return [calendar dateFromComponents:nowComponents];
}

- (NSDate *)endOfDay {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [cal dateFromComponents:components];
}

- (NSDate *)weekStartDate {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    [components setDay:(components.day - components.weekday + 1)];
    return [cal dateFromComponents:components];
}

- (NSInteger)dayDifferenceWithWeekStartDate {
    NSDate *startDate = [self weekStartDate];
    return [NSDate daysBetweenFromDate:self toDate:startDate];
}

- (NSDate *)updateCalendarUnit:(NSCalendarUnit)unit value:(NSInteger)value {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setValue:value forComponent:unit];
    NSDate *date = [cal dateByAddingComponents:components toDate:self options:0];
    return date;
}

- (NSUInteger)valueForCalendarUnit:(NSCalendarUnit)unit {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:unit fromDate:self];
    return [components valueForComponent:unit];
}

- (MKUDateRange *)yearRange {
    MKUDateRange *range = [[MKUDateRange alloc] init];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    [components setDay:1];
    [components setMonth:1];
    range.fromDate = [cal dateFromComponents:components];
    
    [components setDay:0];
    [components setMonth:1];
    [components setYear:components.year+1];
    range.toDate = [cal dateFromComponents:components];
    
    return range;
}

- (MKUDateRange *)monthRange {
    MKUDateRange *range = [[MKUDateRange alloc] init];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    [components setDay:1];
    range.fromDate = [cal dateFromComponents:components];
    
    [components setDay:0];
    [components setMonth:components.month+1];
    range.toDate = [cal dateFromComponents:components];
    
    return range;
}

+ (NSDate *)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    return [[NSDate date] dateWithYear:year month:month day:day];
}

- (NSDate *)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    
    if (0 < year)
        [components setYear:year];
    if (0 < month)
        [components setMonth:month];
    if (0 < day)
        [components setDay:day];
    
    return [cal dateFromComponents:components];
}

- (NSNumber *)unixtimestamp {
    return [NSNumber numberWithInteger:[self timeIntervalSince1970]];
}

+ (StringArr *)charDaysOfWeek {
    StringArr *days = [[NSDateFormatter alloc] init].shortWeekdaySymbols;
    MStringArr *arr = [[NSMutableArray alloc] init];
    [days enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:[obj substringToIndex:1]];
    }];
    return arr;
}

+ (StringArr *)daysOfWeek {
    return [[NSDateFormatter alloc] init].shortWeekdaySymbols;
}

+ (StringArr *)monthsOfYear {
    return [[NSDateFormatter alloc] init].shortMonthSymbols;
}

+ (StringArr *)longMonthsOfYear {
    return [[NSDateFormatter alloc] init].monthSymbols;
}

- (NSString *)dateFormatStringForFormat:(DATE_FORMAT_STYLE)format {
    switch (format) {
        case DATE_FORMAT_FULL_STYLE:
            return DateFormatFullStyle;
        case DATE_FORMAT_FULL_TIMEZONE_STYLE:
            return DateFormatFullTimeZoneStyle;
        case DATE_FORMAT_LONG_STYLE:
            return DateFormatLongStyle;
        case DATE_FORMAT_SHORT_STYLE:
            return DateFormatShortStyle;
        case DATE_FORMAT_MONTH_YEAR_STYLE:
            return DateFormatMonthYearStyle;
        case DATE_FORMAT_TIME_LONG_STYLE:
            return DateFormatTimeLongStyle;
        case DATE_FORMAT_TIME_SHORT_STYLE:
            return DateFormatTimeShortStyle;
        case DATE_FORMAT_DAY_TIME_STYLE:
            return DateFormatDayTimeStyle;
        case DATE_FORMAT_DAY_TIME_LINEBREAK_STYLE:
            return DateFormatDayTimeStyleLineBreak;
        case DATE_FORMAT_DAY_STYLE:
            return DateFormatDayStyle;
        case DATE_FORMAT_DATE_TIME_STYLE:
            return DateFormatDateTimeStyle;
        case DATE_FORMAT_DATE_TIME_COMPACT_STYLE:
            return DateFormatDateTimeCompactStyle;
        case DATE_FORMAT_TIME_STYLE:
            return DateFormatTimeStyle;
        case DATE_FORMAT_MONTH_TIME_COMPACT_STYLE:
            return DateFormatMonthTimeCompactStyle;
        default:
            return @"";
    }
}

- (NSString *)dateStringWithFormat:(DATE_FORMAT_STYLE)format isUTC:(BOOL)isUTC {
    return isUTC ? [self UTCDateStringWithFormat:format] : [self localDateStringWithFormat:format];
}

- (NSString *)UTCDateString {
    return [self UTCDateStringWithFormat:DATE_FORMAT_FULL_STYLE];
}

- (NSString *)UTCDateStringWithFormat:(DATE_FORMAT_STYLE)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSDate UTCTimeZone]];
    [formatter setDateFormat:[self dateFormatStringForFormat:format]];
    return [formatter stringFromDate:[self copy]];
}

- (NSString *)localDateStringWithFormat:(DATE_FORMAT_STYLE)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSDate systemTimeZone]];
    [formatter setDateFormat:[self dateFormatStringForFormat:format]];
    return [formatter stringFromDate:[self copy]];
}

- (NSComparisonResult)compareDayComponents:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay fromDate:[self copy]];
    NSDateComponents *dateComponents = [cal components:NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay fromDate:[date copy]];
    if (components.day == dateComponents.day) {
        if (components.hour < dateComponents.hour) {
            return NSOrderedAscending;
        }
        if (components.hour > dateComponents.hour) {
            return NSOrderedDescending;
        }
        else {
            if (components.minute < dateComponents.minute) {
                return NSOrderedAscending;
            }
            if (components.minute > dateComponents.minute) {
                return NSOrderedDescending;
            }
        }
        return NSOrderedSame;
    }
    else if (components.day < dateComponents.day) {
        return NSOrderedAscending;
    }
    return NSOrderedDescending;
}

- (NSComparisonResult)compareTimeComponents:(NSDate *)date {
    if (!date) return NSOrderedDescending;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSDate UTCTimeZone]];
    
    NSDateComponents *components = [cal components:NSCalendarUnitMinute | NSCalendarUnitHour fromDate:[self copy]];
    NSDateComponents *dateComponents = [cal components:NSCalendarUnitMinute | NSCalendarUnitHour fromDate:[date copy]];
    if (components.hour < dateComponents.hour) {
        return NSOrderedAscending;
    }
    if (components.hour > dateComponents.hour) {
        return NSOrderedDescending;
    }
    else {
        if (components.minute < dateComponents.minute) {
            return NSOrderedAscending;
        }
        if (components.minute > dateComponents.minute) {
            return NSOrderedDescending;
        }
    }
    return NSOrderedSame;
}

- (NSNumber *)minute {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSDate UTCTimeZone]];
    
    NSDateComponents *components = [cal components:NSCalendarUnitMinute fromDate:[self copy]];
    return @(components.minute);
}

- (NSNumber *)hour {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSDate UTCTimeZone]];
    
    NSDateComponents *components = [cal components:NSCalendarUnitHour fromDate:[self copy]];
    return @(components.hour);
}

- (NSNumber *)day {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSDate UTCTimeZone]];
    
    NSDateComponents *components = [cal components:NSCalendarUnitDay fromDate:[self copy]];
    return @(components.day);
}

- (NSNumber *)month {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSDate UTCTimeZone]];
    
    NSDateComponents *components = [cal components:NSCalendarUnitMonth fromDate:[self copy]];
    return @(components.month);
}

- (NSNumber *)year {
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSDate UTCTimeZone]];
    
    NSDateComponents *components = [cal components:NSCalendarUnitYear fromDate:[self copy]];
    return @(components.year);
}

- (NSDate *)firstDateOfMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[self copy]];
    components.day = 1;
    return [cal dateFromComponents:components];
}

- (NSDate *)secondBeforeNextMidnightLocal {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    
    [nowComponents setHour:23];
    [nowComponents setMinute:59];
    [nowComponents setSecond:59];
    
    return [calendar dateFromComponents:nowComponents];
}

- (NSDate *)midnightGMT {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSDate UTCTimeZone]];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    return [calendar dateFromComponents:nowComponents];
}

- (NSDate *)endOfWeekLocal {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    
    [nowComponents setWeekday:7];
    [nowComponents setHour:24];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    return [calendar dateFromComponents:nowComponents];
}

- (NSDate *)startOfWeekLocal {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    NSDate *newDate = [calendar dateFromComponents:nowComponents];
    
    return [calendar dateByAddingUnit:NSCalendarUnitDay value:-6 toDate:newDate options:0];
}

- (NSDate *)endOfWeekGMT {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSDate UTCTimeZone]];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    
    [nowComponents setWeekday:7];
    [nowComponents setHour:24];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    return [calendar dateFromComponents:nowComponents];
}

- (NSDate *)startOfWeekGMT {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSDate UTCTimeZone]];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    NSDate *newDate = [calendar dateFromComponents:nowComponents];
    
    return [calendar dateByAddingUnit:NSCalendarUnitDay value:-6 toDate:newDate options:0];
}

- (NSDate *)updateHourWithValue:(NSInteger)value {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    [components setHour:components.hour+value];
    return [cal dateFromComponents:components];
}

- (NSDate *)updateDayWithValue:(NSInteger)value {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    [components setDay:components.day+value];
    return [cal dateFromComponents:components];
}

- (NSDate *)updateMonthWithValue:(NSInteger)value {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    [components setMonth:components.month+value];
    return [cal dateFromComponents:components];
}

- (NSDate *)updateYearWithValue:(NSInteger)value {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    [components setYear:components.year+value];
    return [cal dateFromComponents:components];
}

- (NSString *)dateStringWithFormat:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:[self copy]];
}

- (NSArray *)monthStringsWithFormat:(NSString *)format untilDate:(NSDate *)date {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSUInteger components = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *selfComponents = [cal components:components fromDate:[self copy]];
    NSDateComponents *dateComponents = [cal components:components fromDate:[date copy]];
    NSInteger months = 0;
    
    if ([date compare:self] == NSOrderedAscending) {
        
        if (dateComponents.year < selfComponents.year) {
            months = selfComponents.month - dateComponents.month + 1 + 12*(selfComponents.year - dateComponents.year);
        }
        else {
            months = selfComponents.month - dateComponents.month + 1;
        }
        
        for (unsigned int i=0; i<months; i++) {
            
            NSDate *newDate = [self updateMonthWithValue:-i];
            [arr addObject:[newDate dateStringWithFormat:format]];
        }
    }
    else if ([date compare:self] == NSOrderedDescending) {
        
        if (selfComponents.year < dateComponents.year) {
            months = dateComponents.month - selfComponents.month + 1 + 12*(dateComponents.year - selfComponents.year);
        }
        else {
            months = dateComponents.month - selfComponents.month + 1;
        }
        
        for (unsigned int i=0; i<months; i++) {
            
            NSDate *newDate = [date updateMonthWithValue:-i];
            [arr addObject:[newDate dateStringWithFormat:format]];
        }
    }
    else {
        [arr addObject:[self dateStringWithFormat:format]];
    }
    return arr;
}

+ (NSUInteger)componentValueWithUnit:(NSCalendarUnit)unit betweenFromDate:(NSDate *)from toDate:(NSDate *)to inclusive:(BOOL)inclusive {
    if (!from || !to) return 0;
    
    NSDate *fromDate = [from copy];
    NSDate *toDate = [to copy];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    if (!inclusive) {
        [cal rangeOfUnit:unit startDate:&fromDate interval:NULL forDate:from];
        [cal rangeOfUnit:unit startDate:&toDate interval:NULL forDate:to];
    }
    
    NSDateComponents *diffComps = [cal components:unit fromDate:fromDate toDate:toDate options:0];
    return [diffComps valueForComponent:unit];
}

+ (NSDateComponents *)componentsWithUnits:(NSCalendarUnit)unit betweenFromDate:(NSDate *)from toDate:(NSDate *)to inclusive:(BOOL)inclusive {
   
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:unit fromDate:[NSDate date]];
    
    [comps setYear:0];
    [comps setMonth:0];
    [comps setDay:0];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    
    if (unit & NSCalendarUnitYear)   [comps setYear:   [self componentValueWithUnit:NSCalendarUnitYear betweenFromDate:from toDate:to inclusive:inclusive]];
    if (unit & NSCalendarUnitMonth)  [comps setMonth:  [self componentValueWithUnit:NSCalendarUnitMonth betweenFromDate:from toDate:to inclusive:inclusive]];
    if (unit & NSCalendarUnitDay)    [comps setDay:    [self componentValueWithUnit:NSCalendarUnitDay betweenFromDate:from toDate:to inclusive:inclusive]];
    if (unit & NSCalendarUnitHour)   [comps setHour:   [self componentValueWithUnit:NSCalendarUnitHour betweenFromDate:from toDate:to inclusive:inclusive]];
    if (unit & NSCalendarUnitMinute) [comps setMinute: [self componentValueWithUnit:NSCalendarUnitMinute betweenFromDate:from toDate:to inclusive:inclusive]];
    if (unit & NSCalendarUnitSecond) [comps setSecond: [self componentValueWithUnit:NSCalendarUnitSecond betweenFromDate:from toDate:to inclusive:inclusive]];
    
    return comps;
}

+ (NSString *)componentsDescriptionWithUnits:(NSCalendarUnit)unit betweenFromDate:(NSDate *)from toDate:(NSDate *)to {
    
    NSArray<MKUPair<NSString *,NSNumber *> *> *values = [self componentsValuesWithUnits:unit betweenFromDate:from toDate:to];
    
    if (values.count == 0) return nil;

    NSMutableString *string = [[NSMutableString alloc] init];
    
    for (MKUPair *pair in values) {
        [string appendString:[NSString stringWithFormat:@"%@ %@", pair.second, pair.first]];
        if (pair != values.lastObject)
            [string appendString:@", "];
    }
    
    return string;
}

+ (NSArray<MKUPair<NSString *,NSNumber *> *> *)componentsValuesWithUnits:(NSCalendarUnit)unit betweenFromDate:(NSDate *)from toDate:(NSDate *)to {
    
    NSDateComponents *comps = [self componentsWithUnits:unit betweenFromDate:from toDate:to inclusive:YES];
    NSMutableArray<MKUPair<NSString *,NSNumber *> *> *arr = [[NSMutableArray alloc] init];
    
    if ((unit & NSCalendarUnitYear)     && 0 < comps.year)   [arr addObject:[MKUPair pairWithFirst:NSStringFromSelector(@selector(year))   second:@(comps.year)]];
    if ((unit & NSCalendarUnitMonth)    && 0 < comps.month)  [arr addObject:[MKUPair pairWithFirst:NSStringFromSelector(@selector(month))  second:@(comps.month - comps.year*12)]];
    if ((unit & NSCalendarUnitDay)      && 0 < comps.day)    [arr addObject:[MKUPair pairWithFirst:NSStringFromSelector(@selector(day))    second:@(comps.day - comps.month*30)]];//TODO: This one is not correct
    if ((unit & NSCalendarUnitHour)     && 0 < comps.hour)   [arr addObject:[MKUPair pairWithFirst:NSStringFromSelector(@selector(hour))   second:@(comps.hour - comps.day*24)]];
    if ((unit & NSCalendarUnitMinute)   && 0 < comps.minute) [arr addObject:[MKUPair pairWithFirst:NSStringFromSelector(@selector(minute)) second:@(comps.minute - comps.hour*60)]];
    if ((unit & NSCalendarUnitSecond)   && 0 < comps.second) [arr addObject:[MKUPair pairWithFirst:NSStringFromSelector(@selector(second)) second:@(comps.second - comps.minute*60)]];
    
    return arr;
}

+ (NSUInteger)daysBetweenFromDate:(NSDate *)from toDate:(NSDate *)to {
    if (!from || !to) {
        return 0;
    }
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:from];
    [cal rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:to];
    
    NSDateComponents *diffComps = [cal components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return diffComps.day;
}

- (NSDate *)setTimeComponentToDate:(NSDate *)date startDate:(NSDate *)startDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[date copy]];
    
    NSDateComponents *startDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:startDate];
    
    [dateComponents setYear:(nowComponents.year - startDateComponents.year) + dateComponents.year];
    [dateComponents setMonth:(nowComponents.month - startDateComponents.month) + dateComponents.month];
    [dateComponents setDay:(nowComponents.day - startDateComponents.day) + dateComponents.day];
    [dateComponents setHour:nowComponents.hour];
    [dateComponents setMinute:nowComponents.minute];
    [dateComponents setSecond:nowComponents.second];
    
    NSDate *newDate = [calendar dateFromComponents:dateComponents];
    return newDate;
    
}

- (NSDate *)setTimeComponentToDate:(NSDate *)date {
    if (!date) return nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[date copy]];
    
    [dateComponents setHour:nowComponents.hour];
    [dateComponents setMinute:nowComponents.minute];
    [dateComponents setSecond:nowComponents.second];
    
    NSDate *newDate = [calendar dateFromComponents:dateComponents];
    return newDate;
    
}

- (NSDate *)setDayComponentToDate:(NSDate *)date {
    if (!date) return nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[date copy]];
    
    [dateComponents setDay:nowComponents.day];
    [dateComponents setHour:nowComponents.hour];
    [dateComponents setMinute:nowComponents.minute];
    [dateComponents setSecond:nowComponents.second];
    
    NSDate *newDate = [calendar dateFromComponents:dateComponents];
    return newDate;
    
}

- (NSDate *)setNoneTimeComponentToDate:(NSDate *)date {
    return [self setNoneTimeComponentToDate:date timezone:[NSTimeZone defaultTimeZone]];
}

- (NSDate *)setNoneTimeComponentToDate:(NSDate *)date timezone:(NSTimeZone *)timezone {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = timezone;
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self copy]];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[date copy]];
    
    [dateComponents setDay:nowComponents.day];
    [dateComponents setMonth:nowComponents.month];
    [dateComponents setYear:nowComponents.year];
    
    NSDate *newDate = [calendar dateFromComponents:dateComponents];
    return newDate;
}

+ (NSDate *)dateWithTimeIntervalSince1900 {
    return [[NSDate dateWithTimeIntervalSince1970:0] updateYearWithValue:-70];
}

- (NSDate *)dateWithReferenceDateType:(MKU_REFERENCE_DATE_TYPE)type {
    return [NSDate dateWithReferenceDateType:type date:self];
}

+ (NSDate *)dateWithReferenceDateType:(MKU_REFERENCE_DATE_TYPE)type date:(NSDate *)date {
    
    NSDate *referenceDate = [date copy];
    
    if (type == MKU_REFERENCE_DATE_TYPE_0) return referenceDate;
    
    NSDate *startDate;
    
    switch (type) {
        case MKU_REFERENCE_DATE_TYPE_2001: {
            startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
        }
            break;
        case MKU_REFERENCE_DATE_TYPE_1900: {
            startDate = [self dateWithTimeIntervalSince1900];
        }
            break;
            
        case MKU_REFERENCE_DATE_TYPE_1970: {
            startDate = [NSDate dateWithTimeIntervalSince1970:0];
        }
            break;
            
        default:
            break;
    }
    
    referenceDate = [startDate setNoneTimeComponentToDate:referenceDate];
    return referenceDate;
}

- (NSDate *)addDifferenceBetweenReferenceDateType:(MKU_REFERENCE_DATE_TYPE)type andDate:(NSDate *)fromDate {
    return [NSDate addDifferenceBetweenReferenceDateType:type andDate:fromDate toDate:self];
}

+ (NSDate *)addDifferenceBetweenReferenceDateType:(MKU_REFERENCE_DATE_TYPE)type andDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    NSDate *newDate = [toDate copy];
    
    if (type == MKU_REFERENCE_DATE_TYPE_0) return fromDate;
    
    NSTimeInterval interval = 0;
    
    switch (type) {
        case MKU_REFERENCE_DATE_TYPE_2001: {
            interval = [fromDate timeIntervalSinceReferenceDate];
        }
            break;
        case MKU_REFERENCE_DATE_TYPE_1900: {
            interval = [fromDate timeIntervalSinceDate:[self dateWithTimeIntervalSince1900]];
        }
            break;
            
        case MKU_REFERENCE_DATE_TYPE_1970: {
            interval = [fromDate timeIntervalSince1970];
        }
            break;
            
        default:
            break;
    }
    
    newDate = [toDate dateByAddingTimeInterval:interval];
    return newDate;
}

+ (NSTimeZone *)UTCTimeZone {
    return [NSTimeZone timeZoneWithName:@"UTC"];
}

+ (NSTimeZone *)systemTimeZone {
    return [NSTimeZone systemTimeZone];
}

#pragma mark - string formatting

- (NSAttributedString *)attributedDescriptionWithTitle:(NSString *)title {
    NSArray<MKUStringAttributes *> *attrs = @[
        [MKUStringAttributes attributesWithText:title font:[AppTheme smallBoldLabelFont] color:[UIColor grayColor]],
        [MKUStringAttributes attributesWithText:[self localDateStringWithFormat:DATE_FORMAT_DAY_TIME_STYLE] font:[AppTheme mediumLabelFont] color:[UIColor blackColor]]];
    return [NSString attributedTextWithAttributes:attrs delimiter:@"\n"];
}

@end

