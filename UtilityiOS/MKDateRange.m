//
//  MKDateRange.m
//  Dot Schedule
//
//  Created by Maryam Karampour on 2017-05-14.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKDateRange.h"
#import "NSDate+Utility.h"

@interface MKDateRange ()

- (NSDate *)adjustedForMaxDate:(NSDate *)date;

@end

@implementation MKDateRange

- (instancetype)init {
    if (self = [super init]) {
        [self resetDates];
    }
    return self;
}

- (void)resetDates {
    self.fromDate = nil;
    self.toDate = nil;
}

- (NSString *)description {
    if ([self calendarUnit] == NSCalendarUnitDay) {
        return self.fromDate ? [NSString stringWithFormat:@"%@", [self.fromDate dateStringWithFormat:DateFormatShortStyle]] : @"";
    }
    
    NSString *from = self.fromDate ? [NSString stringWithFormat:@"%@", [self.fromDate dateStringWithFormat:DateFormatShortStyle]] : @"";
    NSString *to = self.toDate ? [NSString stringWithFormat:@"%@", [self.toDate dateStringWithFormat:DateFormatShortStyle]] : @"";
    
    return [NSString stringWithFormat:@"%@ - %@", from, to];
}

- (NSString *)titleText {
    return self.description;
}

- (BOOL)isValidRange {
    return (self.fromDate && self.toDate && ([self.fromDate compare:self.toDate] == NSOrderedAscending) ? YES : NO);
}

- (BOOL)containsDate:(NSDate *)date {
    return [self containsTimestamp:[date unixtimestamp]];
}

- (BOOL)containsTimestamp:(NSNumber *)date {
    NSInteger dateTime = [date intValue];
    NSInteger fdate = [[self.fromDate unixtimestamp] intValue];
    NSInteger tdate = [[self.toDate unixtimestamp] intValue];
    return ((self.toDate && (dateTime >= fdate && dateTime <= tdate)) || (dateTime == fdate));
}

- (void)setInterval:(MKInterval *)interval {
    _interval = interval;
    self.fromDate = [NSDate dateWithTimeIntervalSince1970:interval.start.longValue];
    self.toDate = [NSDate dateWithTimeIntervalSince1970:interval.end.longValue];
}

- (void)setFromDate:(NSDate *)fromDate {
    _fromDate = [self adjustedForMaxDate:fromDate];
    _interval.start = @([_fromDate timeIntervalSince1970]);
}

- (void)setToDate:(NSDate *)toDate {
    _toDate = [self adjustedForMaxDate:toDate];
    _interval.end = @([_toDate timeIntervalSince1970]);
}

- (NSDate *)adjustedForMaxDate:(NSDate *)date {
    if (!self.maxDate || (self.maxDate && [date compare:self.maxDate] == NSOrderedAscending)) {
        return date;
    }
    else {
        return self.maxDate;
    }
}

- (MKDateRange *)rangeForFuture {
    MKDateRange *futureDateRange = [[MKDateRange alloc] init];
    NSDate *today = [[NSDate date] midnightLocal];
    NSDate *fromDate = ([self.fromDate compare:today] == NSOrderedAscending ? today : self.fromDate);
    futureDateRange.fromDate = fromDate;
    futureDateRange.toDate = [self.toDate endOfDay];
    return futureDateRange;
}

- (DatePairArr *)dividedRange:(NSCalendarUnit)range {
    if (!self.fromDate || !self.toDate) return @[self];
    
    MDatePairArr *pairs = [[MDatePairArr alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *fromComps = [cal components:range fromDate:self.fromDate];
    [fromComps setValue:1 forComponent:range];
    
    MKDateRange *currentPair = [[MKDateRange alloc] init];
    currentPair.fromDate = [[self.fromDate midnightLocal] copy];
    currentPair.toDate = [cal dateByAddingComponents:fromComps toDate:currentPair.fromDate options:0];
    
    while ([currentPair.fromDate compare:self.toDate] != NSOrderedDescending) {
        [pairs addObject:[currentPair copy]];
        currentPair.fromDate = [currentPair.toDate copy];
        currentPair.toDate = [cal dateByAddingComponents:fromComps toDate:currentPair.fromDate options:0];
    }
    
    return pairs;
}

- (DatePairArr *)dividedRange {
    return [self dividedRange:[self calendarUnit]];
}

- (NSCalendarUnit)calendarUnit {
    NSUInteger range = [NSDate daysBetweenFromDate:self.fromDate toDate:self.toDate];
    if (range >= 160) {
        return NSCalendarUnitMonth;
    }
    else if (range >= 1) {
        return NSCalendarUnitWeekOfYear;
    }
    else {
        return NSCalendarUnitDay;
    }
}

- (DatePairArr *)sortedDividedRange:(NSComparisonResult)order {
    return [MKDateRange sortedDividedRange:[self dividedRange] order:order];
}

+ (DatePairArr *)sortedDividedRange:(DatePairArr *)pairs order:(NSComparisonResult)order {
    if (!pairs.count || ![pairs isKindOfClass:[DatePairArr class]]) {
        return pairs;
    }
    return [pairs sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (![obj1 isKindOfClass:[MKDateRange class]] || ![obj2 isKindOfClass:[MKDateRange class]]) {
            return NSOrderedSame;
        }
        MKDateRange *pair1 = (MKDateRange *)obj1;
        MKDateRange *pair2 = (MKDateRange *)obj2;
        return ([pair2.fromDate compare:pair1.fromDate] == order);
    }];
}

- (NSDate *)middleDate {
    if (!self.fromDate || !self.toDate) return nil;
    NSTimeInterval interval = [self.toDate timeIntervalSinceDate:self.fromDate];
    return [self.fromDate dateByAddingTimeInterval:interval/2];
}

- (MKDateRange *)midnightToEndOfDay {
    MKDateRange *range = [[MKDateRange alloc] init];
    range.fromDate = [self.fromDate midnightLocal];
    range.toDate = [self.toDate endOfDay];
    return range;
}

@end

@implementation MKRange

+ (instancetype)rangeWithStart:(NSNumber *)start end:(NSNumber *)end {
    id range = [[[self class] alloc] init];
    [range setStart:start];
    [range setEnd:end];
    return range;
}

- (void)extendEnd:(NSUInteger)value {
    self.end = @(self.end.integerValue+value);
}

- (void)extendStart:(NSUInteger)value {
    self.start = @(self.start.integerValue-value);
}

- (NSUInteger)lenght {
    return abs(self.end.integerValue - self.start.integerValue);
}

@end

@implementation MKInterval

- (instancetype)initWithDateRange:(MKDateRange *)range {
    if (self = [super init]) {
        self.start = range.fromDate ? @([[range adjustedForMaxDate:range.fromDate] timeIntervalSince1970]) : nil;
        self.end = range.toDate ? @([[range adjustedForMaxDate:range.toDate] timeIntervalSince1970]) : nil;
    }
    return self;
}

- (MKDateRange *)dateRange {
    MKDateRange *range = [[MKDateRange alloc] init];
    range.fromDate = self.start ? [NSDate dateWithTimeIntervalSince1970:self.start.doubleValue] : nil;
    range.toDate = self.end ? [NSDate dateWithTimeIntervalSince1970:self.end.doubleValue] : nil;
    return range;
}

@end
