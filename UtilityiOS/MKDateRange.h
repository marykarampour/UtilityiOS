//
//  MKDateRange.h
//  Dot Schedule
//
//  Created by Maryam Karampour on 2017-05-14.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKModel.h"

@class MKDateRange;
@class MKInterval;

typedef NSArray<MKDateRange *>          DatePairArr;
typedef NSMutableArray<MKDateRange *>   MDatePairArr;

@interface MKDateRange : MKModel

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;

@property (nonatomic, strong) __kindof MKInterval *interval;

@property (nonatomic, strong) NSDate *maxDate;

- (BOOL)isValidRange;
- (BOOL)containsDate:(NSDate *)date;
- (BOOL)containsTimestamp:(NSNumber *)date;
- (void)resetDates;
- (MKDateRange *)rangeForFuture;
- (DatePairArr *)dividedRange:(NSCalendarUnit)range;
- (DatePairArr *)dividedRange;
- (DatePairArr *)sortedDividedRange:(NSComparisonResult)order;
+ (DatePairArr *)sortedDividedRange:(DatePairArr *)pairs order:(NSComparisonResult)order;
- (NSDate *)middleDate;
- (MKDateRange *)midnightToEndOfDay;

@end

@interface MKRange : MKModel

@property (nonatomic, strong) NSNumber *start;
@property (nonatomic, strong) NSNumber *end;

//increases the value of end
- (void)extendEnd:(NSUInteger)value;
//decreases the value of start
- (void)extendStart:(NSUInteger)value;

- (NSUInteger)lenght;

+ (instancetype)rangeWithStart:(NSNumber *)start end:(NSNumber *)end;

@end

@interface MKInterval : MKRange

- (instancetype)initWithDateRange:(MKDateRange *)range;
- (MKDateRange *)dateRange;

@end
