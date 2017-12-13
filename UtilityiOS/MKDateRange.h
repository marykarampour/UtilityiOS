//
//  MKDateRange.h
//  Dot Schedule
//
//  Created by Maryam Karampour on 2017-05-14.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKModel.h"

@class MKDateRange;

typedef NSArray<MKDateRange *>          DatePairArr;
typedef NSMutableArray<MKDateRange *>   MDatePairArr;

@interface MKDateRange : MKModel

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;

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

@interface MKInterval : MKModel

@property (nonatomic, strong) NSNumber *start;
@property (nonatomic, strong) NSNumber *end;

- (instancetype)initWithDateRange:(MKDateRange *)range;
- (MKDateRange *)dateRange;

@end
