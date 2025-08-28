//
//  NSNumber+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "NSNumber+Utility.h"
#import "NSString+Number.h"

@implementation NSNumber (Utility)

- (BOOL)isInRange:(MKURange *)range {
    return ([self compare:range.start] == NSOrderedSame &&
            [self compare:range.end] == NSOrderedSame);
}

- (BOOL)isBOOL {
    CFTypeID numID = CFGetTypeID((__bridge CFTypeRef)(self));
    return numID == CFBooleanGetTypeID();
}

+ (BOOL)isBOOL:(NSObject *)obj {
    if (![obj isKindOfClass:[NSNumber class]]) return NO;
    return [(NSNumber *)obj isBOOL];
}

+ (NSNumber *)numberWith:(NSNumber *)num min:(NSNumber *)min max:(NSNumber *)max {
    if (num.integerValue < min.integerValue)
        return min;
    else if (max.integerValue < num.integerValue)
        return max;
    else
        return num;
}

+ (BOOL)nullableNumber:(NSNumber *)number1 isEqualToNumber:(NSNumber *)number2 {
    if (!number1 && !number2) return YES;
    if (!number1 && number2) return NO;
    if (number1 && !number2) return NO;
    if (![number2 isKindOfClass:[NSNumber class]] || ![number1 isKindOfClass:[NSNumber class]]) return NO;
    return [number1 isEqualToNumber:number2];
}

@end

@implementation NSNumber (Formatting)

- (NSString *)toStringWithType:(NUMBER_FORMAT_STYLE)type {
    switch (type) {
        case NUMBER_FORMAT_STYLE_FLOAT:
            return [NSString stringWithFormat:@"%.2f", [self floatValue]];
            break;
        case NUMBER_FORMAT_STYLE_INT:
            return [NSString stringWithFormat:@"%d", [self intValue]];
            break;
        case NUMBER_FORMAT_STYLE_FLOAT_PERCENT:
            return [NSString stringWithFormat:@"%.2f⁒", [self floatValue]];
            break;
        case NUMBER_FORMAT_STYLE_INT_PERCENT:
            return [NSString stringWithFormat:@"%d⁒", [self intValue]];
            break;
        case NUMBER_FORMAT_STYLE_TWO_FLOAT:
            return [self stringValueWithStyle:NSNumberFormatterDecimalStyle digits:2];
            break;
        default:
            return [self description];
            break;
    }
}

- (NSNumber *)plusMinus {
    NSString *string = [self stringValue];
    return [string plusMinus];
}

- (NSString *)stringValueWithStyle:(NSNumberFormatterStyle)style digits:(NSUInteger)digits {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = style;
    if (style == NSNumberFormatterDecimalStyle) {
        formatter.minimumFractionDigits = digits;
        formatter.maximumFractionDigits = digits;
    }
    NSString *num = [formatter stringFromNumber:self];
    return num;
}

@end
