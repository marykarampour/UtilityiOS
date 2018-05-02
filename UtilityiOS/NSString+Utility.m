//
//  NSString+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

- (NSString *)format:(StringFormat)format {
    switch (format) {
        case StringFormatNone:
            return self;
            break;
        case StringFormatCapitalized:
            return [self capitalizeFirstChar];
            break;
        case StringFormatUpperCaseAll:
            return [self uppercaseString];
            break;
        case StringFormatUnderScore:
            return [self camelCaseToUnderScoreIgnoreDigits:NO upperCaseAll:NO];
            break;
        case StringFormatUnderScoreUpperCaseAll:
            return [self camelCaseToUnderScoreIgnoreDigits:NO upperCaseAll:YES];
            break;
        case StringFormatUnderScoreIgnoreDigits:
            return [self camelCaseToUnderScoreIgnoreDigits:YES upperCaseAll:NO];
            break;
        case StringFormatUnderScoreIgnoreDigitsUpperCaseAll:
            return [self camelCaseToUnderScoreIgnoreDigits:YES upperCaseAll:YES];
            break;
        case StringFormatCamelCase:
            return [self underScoreToCamelCaseUpperCaseAll:NO];
            break;
        default:
            return self;
            break;
    }
}

- (NSString *)capitalizeFirstChar {
    return [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)lowercaseFirstChar {
    return [[[self substringToIndex:1] lowercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)camelCaseToUnderScoreIgnoreDigits:(BOOL)ignoreDigits upperCaseAll:(BOOL)upperCaseAll {
    
    NSMutableString *result = [NSMutableString stringWithString:self];
    NSRange upperCaseRange = [result rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    
    while (upperCaseRange.location != NSNotFound) {
        NSString *lowerCase = [[result substringWithRange:upperCaseRange] lowercaseString];
        [result replaceCharactersInRange:upperCaseRange withString:[NSString stringWithFormat:@"_%@", lowerCase]];
        upperCaseRange = [result rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    }
    
    if (!ignoreDigits) {
        NSRange digitsRange = [result rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
        
        while (digitsRange.location != NSNotFound) {
            NSRange digitsRangeEnd = [result rangeOfString:@"\\D" options:NSRegularExpressionSearch range:NSMakeRange(digitsRange.location, result.length-digitsRange.location)];
            if (digitsRangeEnd.location == NSNotFound) {
                digitsRangeEnd = NSMakeRange(result.length, 1);
            }
            NSRange replaceRange = NSMakeRange(digitsRange.location, digitsRangeEnd.location-digitsRange.location);
            NSString *digits = [result substringWithRange:replaceRange];
            [result replaceCharactersInRange:replaceRange withString:[NSString stringWithFormat:@"_%@", digits]];
            digitsRange = [result rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:kNilOptions range:NSMakeRange(digitsRangeEnd.location+1, result.length-digitsRangeEnd.location-1)];
        }
    }
    
    if ([result characterAtIndex:0] == '_') {
        [result replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    if (upperCaseAll) {
        result = [NSMutableString stringWithString:[result uppercaseString]];
    }
    
    return result;
}

- (NSString *)underScoreToCamelCaseUpperCaseAll:(BOOL)upperCaseAll {
    
    NSMutableString *result = [NSMutableString stringWithString:self];
    if ([result characterAtIndex:0] == '_') {
        [result replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    NSRange underScoreRange = [result rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
    
    while (underScoreRange.location != NSNotFound) {
        [result replaceCharactersInRange:underScoreRange withString:[NSString stringWithFormat:@""]];
        
        if (underScoreRange.location < result.length) {
            NSString *upperCase = [[result substringWithRange:underScoreRange] uppercaseString];
            [result replaceCharactersInRange:underScoreRange withString:upperCase];
        }

        underScoreRange = [result rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
    }
    
    if (upperCaseAll) {
        result = [NSMutableString stringWithString:[result uppercaseString]];
    }
    
    return result;
}

- (NSNumber *)stringToNumber {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    return [formatter numberFromString:self];
}

- (NSString *)amount {
    if (![self stringToNumber]) {
        return nil;
    }
    NSString *str = ([self containsString:@"."] && [self rangeOfString:@"."].location < self.length-2) ? self : [self stringByAppendingString:@".00"];
    return str;
}

+ (NSString *)randomStringWithLenght:(NSUInteger)length {
    NSString *seed = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomStr = [[NSMutableString alloc] initWithCapacity:length];
    for (unsigned int i=0; i<length; i++) {
        [randomStr appendFormat:@"%C", [seed characterAtIndex:arc4random_uniform(seed.length)]];
    }
    return randomStr;
}

@end
