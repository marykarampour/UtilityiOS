//
//  NSString+Number.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2015-10-08.
//  Copyright © 2015 BHS Consultants. All rights reserved.
//

@interface NSString (Number)

/** @brief If self.length == 0 it will return @0. */
- (NSNumber *)stringToNumber;
/** @brief If self.length == 0 it will return nil. Default style is NSNumberFormatterNoStyle */
- (NSNumber *)stringToNullableNumber;
/** @brief If self.length == 0 it will return nil. */
- (NSNumber *)stringToNullableNumberWithStyle:(NSNumberFormatterStyle)style;
- (NSNumber *)plusMinus;
- (NSString *)amount;
- (NSNumber *)stringToNumberWithFormat:(NSNumberFormatterStyle)format;
/** @brief Extracts the first number found in a string. */
- (NSNumber *)firstNumber;
/** @brief Extracts the range of first number found in a string. */
- (NSRange)rangeOfFirstNumber;
- (NSString *)numbersOnly;
+ (NSString *)onlyNumbersIn:(NSString *)text;
- (NSArray<NSNumber *> *)allNumbers;
+ (NSDecimalNumber *)decimalValueWithString:(NSString *)amount;

@end
