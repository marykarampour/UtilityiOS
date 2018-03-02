//
//  NSDate+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-04.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

- (NSDate *)midnightLocal {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    return [calendar dateFromComponents:nowComponents];
}

- (NSDate *)midnightGMT {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    return [calendar dateFromComponents:nowComponents];
}

- (NSDate *)endOfWeekLocal {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    
    [nowComponents setWeekday:7];
    [nowComponents setHour:24];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    return [calendar dateFromComponents:nowComponents];
}

- (NSDate *)startOfWeekLocal {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    NSDate *newDate = [calendar dateFromComponents:nowComponents];
    
    return [calendar dateByAddingUnit:NSCalendarUnitDay value:-6 toDate:newDate options:0];
}

- (NSDate *)endOfWeekGMT {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    
    [nowComponents setWeekday:7];
    [nowComponents setHour:24];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    return [calendar dateFromComponents:nowComponents];
}

- (NSDate *)startOfWeekGMT {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    
    [nowComponents setHour:0];
    [nowComponents setMinute:0];
    [nowComponents setSecond:0];
    
    NSDate *newDate = [calendar dateFromComponents:nowComponents];
    
    return [calendar dateByAddingUnit:NSCalendarUnitDay value:-6 toDate:newDate options:0];
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
#warning - fix these
#pragma mark - update

- (NSDate *)updateDayWithValue:(NSInteger)value {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    [components setDay:components.day+value];
    return [cal dateFromComponents:components];
}

- (NSDate *)updateMonthWithValue:(NSInteger)value {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    [components setMonth:components.month+value];
    return [cal dateFromComponents:components];
}

- (NSDate *)updateYearWithValue:(NSInteger)value {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    [components setYear:components.year+value];
    return [cal dateFromComponents:components];
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

- (MKDateRange *)yearRange {
    MKDateRange *range = [[MKDateRange alloc] init];
    
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

- (MKDateRange *)monthRange {
    MKDateRange *range = [[MKDateRange alloc] init];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    [components setDay:1];
    range.fromDate = [cal dateFromComponents:components];
    
    [components setDay:0];
    [components setMonth:components.month+1];
    range.toDate = [cal dateFromComponents:components];
    
    return range;
}

- (NSUInteger)year {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear fromDate:self];
    return components.year;
}

- (NSUInteger)month {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self];
    return components.month;
}

- (NSString *)dateStringWithFormat:(NSString *)format {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setLocalizedDateFormatFromTemplate:format];
    return [formatter stringFromDate:self];
}

- (NSArray *)monthStringsWithFormat:(NSString *)format untilDate:(NSDate *)date {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSUInteger components = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *selfComponents = [cal components:components fromDate:self];
    NSDateComponents *dateComponents = [cal components:components fromDate:date];
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

- (NSNumber *)unixtimestamp {
    return @([self timeIntervalSince1970]);
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


@end
