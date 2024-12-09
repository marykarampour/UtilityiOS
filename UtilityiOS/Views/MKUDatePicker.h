//
//  MKUDatePicker.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUDateViewInfoObject.h"

@class MKUDatePicker;

@protocol MKUDatePickerDelegate <NSObject>

@required
- (void)datePicker:(MKUDatePicker *)datePicker didChangeDate:(NSDate *)date;

@end

@interface MKUDatePicker : UIDatePicker

@property (nonatomic, strong) MKUDateViewInfoObject *infoObject;
@property (nonatomic, weak) id<MKUDatePickerDelegate> delegate;

+ (UIDatePickerMode)datePickerModeForDateFormat:(DATE_FORMAT_STYLE)format;
+ (CGSize)datePickerSizeForDateFormat:(DATE_FORMAT_STYLE)format;

@end

