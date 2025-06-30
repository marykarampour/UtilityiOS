//
//  NSNumber+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKUDateRange.h"

@interface NSNumber (Utility)

- (NSString *)stringValueWithStyle:(NSNumberFormatterStyle)style;
- (BOOL)isInRange:(MKURange *)range;
- (BOOL)isBOOL;
+ (BOOL)isBOOL:(NSObject *)obj;
+ (NSNumber *)numberWith:(NSNumber *)num min:(NSNumber *)min max:(NSNumber *)max;
+ (BOOL)nullableNumber:(NSNumber *)number1 isEqualToNumber:(NSNumber *)number2;

@end
