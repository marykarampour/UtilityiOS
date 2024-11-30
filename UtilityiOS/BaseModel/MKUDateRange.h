//
//  MKUDateRange.h
//  Dot Schedule
//
//  Created by Maryam Karampour on 2017-05-14.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUModel.h"

@class MKUDateRange;
@class MKUInterval;

typedef NSArray<MKUDateRange *>          DatePairArr;
typedef NSMutableArray<MKUDateRange *>   MDatePairArr;

@interface MKUDateRange : MKUModel

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;

@property (nonatomic, strong) __kindof MKUInterval *interval;

@property (nonatomic, strong) NSDate *maxDate;

- (BOOL)isValidRange;
- (BOOL)containsDate:(NSDate *)date;
- (BOOL)containsTimestamp:(NSNumber *)date;
- (void)resetDates;
- (MKUDateRange *)rangeForFuture;
- (DatePairArr *)dividedRange:(NSCalendarUnit)range;
- (DatePairArr *)dividedRange;
- (DatePairArr *)sortedDividedRange:(NSComparisonResult)order;
+ (DatePairArr *)sortedDividedRange:(DatePairArr *)pairs order:(NSComparisonResult)order;
- (NSDate *)middleDate;
- (MKUDateRange *)midnightToEndOfDay;

@end

@interface MKURange : MKUModel

@property (nonatomic, strong) NSNumber *start;
@property (nonatomic, strong) NSNumber *end;

//increases the value of end
- (void)extendEnd:(NSInteger)value;
//decreases the value of start
- (void)extendStart:(NSInteger)value;

- (NSUInteger)lenght;

+ (instancetype)rangeWithStart:(NSNumber *)start end:(NSNumber *)end;

- (BOOL)containsNumber:(NSNumber *)number;
- (BOOL)containsRange:(__kindof MKURange *)range;
- (BOOL)strictlyContainsNumber:(NSNumber *)number;
- (BOOL)strictlyContainsRange:(__kindof MKURange *)range;
+ (NSArray<__kindof MKURange *> *)setMinusOfRange:(__kindof MKURange *)range1 withRange:(__kindof MKURange *)range2;
- (void)adjustContinuousRangeWithNumber:(NSNumber *)number;
- (__kindof MKURange *)unionWithRange:(__kindof MKURange *)range;

@end

@interface MKUInterval : MKURange

- (instancetype)initWithDateRange:(MKUDateRange *)range;
- (MKUDateRange *)dateRange;

@end


typedef NSArray<MKURange *>              MKURangeArr;
