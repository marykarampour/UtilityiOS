//
//  NSString+Number.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2015-10-08.
//  Copyright © 2015 BHS Consultants. All rights reserved.
//

#import "NSString+Number.h"

@implementation NSString (Number)

+ (NSDecimalNumber *)decimalValueWithString:(NSString *)amount {
    
    NSDecimalNumber *zero = [NSDecimalNumber decimalNumberWithString:@"0.0"];
    if (!amount) return zero;
    
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:amount];
    if ([num isEqualToNumber:@(NAN)]) {
        return zero;
    }
    return num;
}

- (NSNumber *)stringToNumber {
    NSNumber *num = [self stringToNullableNumber];
    return num ? num : @0;
}

- (NSNumber *)stringToNullableNumber {
    for (NSNumberFormatterStyle i=NSNumberFormatterNoStyle; i<NSNumberFormatterSpellOutStyle; i++) {
        NSNumber *num = [self stringToNullableNumberWithStyle:i];
        if (num) return num;
    }
    return nil;
}

- (NSNumber *)stringToNullableNumberWithStyle:(NSNumberFormatterStyle)style {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = style;
    NSNumber *num = [formatter numberFromString:self];
    return num;
}

- (NSNumber *)plusMinus {
    NSString *temp = (([self characterAtIndex:0] == '-') ? [self stringByReplacingOccurrencesOfString:@"-" withString:@""] : [@"-" stringByAppendingString:self]);
    return [temp stringToNumber];
}

- (NSString *)amount {
    if (![self stringToNumber]) {
        return nil;
    }
    NSString *str = ([self containsString:@"."] && [self rangeOfString:@"."].location < self.length-2) ? self : [self stringByAppendingString:@".00"];
    return str;
}

- (NSNumber *)stringToNumberWithFormat:(NSNumberFormatterStyle)format {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = format;
    return [formatter numberFromString:self];
}

- (NSNumber *)firstNumber {
    return [[self substringWithRange:[self rangeOfFirstNumber]] stringToNumber];
}

- (NSRange)rangeOfFirstNumber {
    return [self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
}

- (NSString *)numbersOnly {
    return [NSString onlyNumbersIn:self];
}

+ (NSString *)onlyNumbersIn:(NSString *)text {
    if (text.length == 0) return nil;
    return [[text componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
}

- (NSArray<NSNumber *> *)allNumbers {
    StringArr *arr = [self componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    for (NSString *str in arr) {
        NSNumber *num = [str stringToNullableNumber];
        if (num) [numbers addObject:num];
    }
    return numbers;
}

@end

