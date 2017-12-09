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

- (NSString *)dateStringWithFormat:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
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

@end
