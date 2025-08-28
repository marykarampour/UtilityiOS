//
//  MKUDateViewInfoObject.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUDateViewInfoObject.h"

@implementation MKUDateViewInfoObject

- (instancetype)initWithType:(DATE_INFO_OBJECT_TYPE)type section:(NSUInteger)section {
    if (self = [super init]) {
        switch (type) {
            case DATE_INFO_OBJECT_TYPE_FIRST_OF_MONTH: {
                self.format = DATE_FORMAT_MONTH_YEAR_STYLE;
                self.isFirstDateOfMonth = YES;
            }
                break;
            case DATE_INFO_OBJECT_TYPE_DAY: {
                self.format = DATE_FORMAT_DAY_STYLE;
            }
                break;
            default:
                break;
        }
        self.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        self.canChooseFutureDate = YES;
        self.isEditable = YES;
        [self clear];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.canChooseFutureDate = YES;
    }
    return self;
}

- (NSDate *)getAdjustedDate {
    return (self.isFirstDateOfMonth ? [self.date firstDateOfMonth] : self.date);
}

- (void)setDate:(NSDate *)date {
    [self willSetDate:date];
    
    self.clearTitle = !self.date;
}

- (void)clear {
    self.date = [NSDate date];
}

- (void)reset {
    _date = nil;
    self.clearTitle = YES;
}

- (NSString *)clearedTitle {
    return @"No Date Selected";
}

- (NSString *)title {
    if (self.clearTitle) return [self clearedTitle];
        
    DATE_FORMAT_STYLE format = self.mode == UIDatePickerModeDateAndTime ? DATE_FORMAT_DAY_TIME_STYLE : self.format;
    return [self.date dateStringWithFormat:format isUTC:self.isUTC];
}

- (void)willSetDate:(NSDate *)date {
    NSDate *newDate = date;
    
    if (!date || (!self.canChooseFutureDate && [[NSDate date] compare:date] == NSOrderedAscending))
        newDate = [NSDate date];
    
    _date = ((newDate && self.isFirstDateOfMonth) ? [newDate firstDateOfMonth] : newDate);
}

- (NSTimeZone *)timeZone {
    return self.isUTC ? [NSDate UTCTimeZone] : [NSDate systemTimeZone];
}

@end
