//
//  MKUDateViewInfoObject.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "NSDate+Utility.h"

typedef NS_ENUM(NSUInteger, DATE_INFO_OBJECT_TYPE) {
    DATE_INFO_OBJECT_TYPE_DEFAULT,
    DATE_INFO_OBJECT_TYPE_FIRST_OF_MONTH,
    DATE_INFO_OBJECT_TYPE_DAY
};

@interface MKUDateViewInfoObject : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) DATE_FORMAT_STYLE format;
@property (nonatomic, assign) BOOL isFirstDateOfMonth;
@property (nonatomic, assign) BOOL showDatePicker;
@property (nonatomic, assign) BOOL clearTitle;
@property (nonatomic, assign) BOOL canChooseFutureDate;
@property (nonatomic, assign) BOOL isUTC;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) UIDatePickerMode mode;

- (instancetype)initWithType:(DATE_INFO_OBJECT_TYPE)type section:(NSUInteger)section;
- (NSDate *)getAdjustedDate;
- (NSString *)clearedTitle;
- (NSString *)title;
- (NSTimeZone *)timeZone;
/** @brief Sets date to now. */
- (void)reset;
/** @brief Sets date to nil. */
- (void)clear;

@end
