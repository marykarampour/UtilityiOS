//
//  MKUDatePicker.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUDatePicker.h"

@implementation MKUDatePicker

- (instancetype)init {
    if (self = [super init]) {
        self.datePickerMode = UIDatePickerModeDate;
        self.infoObject = [[MKUDateViewInfoObject alloc] init];
        [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    [super setDatePickerMode:datePickerMode];
    self.infoObject.mode = datePickerMode;
    [self updateStyle];
}

- (void)setTimeZone:(NSTimeZone *)timeZone {
    [super setTimeZone:timeZone];
    self.infoObject.isUTC = ![timeZone isEqualToTimeZone:[NSDate systemTimeZone]];
}

- (void)updateStyle {
    if (self.datePickerMode == UIDatePickerModeDate || self.datePickerMode == UIDatePickerModeDateAndTime) {
        if (@available(iOS 14.0, *))
            self.preferredDatePickerStyle = UIDatePickerStyleInline;
        else if (@available(iOS 13.4, *))
            self.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    else {
        if (@available(iOS 13.4, *))
            self.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
}

- (void)valueChanged:(UIDatePicker *)picker {
    [self setDate:picker.date];
    
    if ([self.delegate respondsToSelector:@selector(datePicker:didChangeDate:)]) {
        [self.delegate datePicker:self didChangeDate:self.infoObject.date];
    }
}

- (void)setDate:(NSDate *)date {
    [self.infoObject setDate:date];
    [super setDate:self.infoObject.date];
}

+ (UIDatePickerMode)datePickerModeForDateFormat:(DATE_FORMAT_STYLE)format {
    switch (format) {
        case DATE_FORMAT_TIME_SHORT_STYLE:
        case DATE_FORMAT_TIME_STYLE:
        case DATE_FORMAT_DATE_TIME_COMPACT_STYLE:
        case DATE_FORMAT_MONTH_TIME_COMPACT_STYLE:
            return UIDatePickerModeTime;
            
        case DATE_FORMAT_MONTH_YEAR_STYLE:
            if (@available(iOS 17.4, *))
                return UIDatePickerModeYearAndMonth;
            
        case DATE_FORMAT_SHORT_STYLE:
            return UIDatePickerModeDate;
            
        default:
            return UIDatePickerModeDateAndTime;
    }
}

+ (CGSize)datePickerSizeForDateFormat:(DATE_FORMAT_STYLE)format {
    switch (format) {
        case DATE_FORMAT_TIME_SHORT_STYLE:
        case DATE_FORMAT_TIME_STYLE:
        case DATE_FORMAT_DATE_TIME_COMPACT_STYLE:
        case DATE_FORMAT_MONTH_TIME_COMPACT_STYLE:
        case DATE_FORMAT_MONTH_YEAR_STYLE:
        case DATE_FORMAT_SHORT_STYLE:
            return [Constants DateViewControllerPopoverSize];
            
        default:
            return [Constants DateViewControllerCalPopoverSize];
    }
}

@end

