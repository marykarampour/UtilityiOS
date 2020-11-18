//
//  NSString+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSString+Utility.h"
#import "NSString+Validation.h"

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

- (NSString *)CapitalizedCamelCase {
    return [[self underScoreToCamelCaseUpperCaseAll:NO] capitalizedString];
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
    
    NSMutableString *result = [NSMutableString stringWithString:[self lowercaseFirstChar]];
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

- (NSNumber *)stringToNumberWithFormat:(NSNumberFormatterStyle)format {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = format;
    return [formatter numberFromString:self];
}

- (NSString *)pluralToSingle {
    NSString *name = self;
    if ([[self substringFromIndex:self.length-1] isEqualToString:@"s"]) {
        if ([[self substringFromIndex:self.length-3] isEqualToString:@"ies"]) {
            name = [self stringByReplacingCharactersInRange:NSMakeRange(self.length-3, 3) withString:@"ys"];//Objectiv-C doesn't know grammer XD
        }
        name = [name stringByReplacingCharactersInRange:NSMakeRange(name.length-1, 1) withString:@""];
    }
    return name;
}

- (NSString *)singleToPlural {
    NSString *name;
    if ([[self substringFromIndex:self.length-1] isEqualToString:@"y"]) {
        name = [self stringByReplacingCharactersInRange:NSMakeRange(self.length-1, 1) withString:@"ies"];//Objectiv-C doesn't know grammer XD
    }
    else {
        name = [self stringByAppendingString:@"s"];
    }
    return name;
}

- (NSString *)amount {
    if (![self stringToNumber]) {
        return nil;
    }
    NSString *str = ([self containsString:@"."] && [self rangeOfString:@"."].location < self.length-2) ? self : [self stringByAppendingString:@".00"];
    return str;
}

- (NSString *)numbersOnly {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet] componentsJoinedByString:@""];
}

+ (NSString *)randomStringWithLenght:(NSUInteger)length {
    NSString *seed = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomStr = [[NSMutableString alloc] initWithCapacity:length];
    for (unsigned int i=0; i<length; i++) {
        [randomStr appendFormat:@"%C", [seed characterAtIndex:arc4random_uniform(seed.length)]];
    }
    return randomStr;
}

+ (NSString *)telFromString:(NSString *)string {
    return [NSString stringWithFormat:@"tel://%@", string];
}

+ (NSString *)notnullString:(NSString *)string {
    return [self notnullString:string defaultText:@""];
}

+ (NSString *)notnullString:(NSString *)string defaultText:(NSString * __nonnull)defaultText {
    return (string && ![string isEqualToString:@"null"]) ? string : defaultText;
}

- (NSString *)quotations {
    return [NSString stringWithFormat:@"\"%@\"", self];
}

- (NSString *)spaced {
    return [NSString stringWithFormat:@" %@ ", self];
}

- (NSString *)removeSubstring:(NSString *)str {
    return [self stringByReplacingOccurrencesOfString:str withString:@""];
}

- (NSString *)trimCharSet:(NSString *)chars {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:chars];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)multiplyWithCount:(NSUInteger)count {
    NSString *string = @"";
    for (NSUInteger i=0; i<count; i++) {
        string = [string stringByAppendingString:self];
    }
    return string;
}

- (NSString *)obscuredEmail {
    
    NSString *email = self;
    if (![self isValidStringOfType:TextType_Email maxLength:0 isEditing:NO]) return email;
    
    NSArray <NSString *> *components = [self componentsSeparatedByString:@"@"];
    
    if (1 < components.count) {

        NSString *obsecured = @"****";
        
        NSString *prefix = components[0];
        NSUInteger prefixObscuredLength = (int)(prefix.length / 2);
        NSRange prefixObscuredRange = NSMakeRange(prefixObscuredLength, prefix.length - prefixObscuredLength);
        prefix = [prefix stringByReplacingCharactersInRange:prefixObscuredRange withString:obsecured];
        
        NSString *suffix = components[1];
        NSUInteger suffixObscuredLength = (int)(suffix.length / 2);
        NSRange suffixObscuredRange = NSMakeRange(0, suffixObscuredLength);
        suffix = [suffix stringByReplacingCharactersInRange:suffixObscuredRange withString:obsecured];
        
        email = [NSString stringWithFormat:@"%@@%@", prefix, suffix];
    }
    return email;
}

- (NSString *)splitedStringForUppercaseComponentsAndGroupUppercase:(BOOL)groupUppercase {
    if (self.length < 2) {
        return self;
    }
    
    NSMutableString *result = [NSMutableString stringWithString:self];
    NSRange range = [result rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    NSString *croppedString = self;
    NSRange croppedRange = NSMakeRange(range.location+range.length, croppedString.length-range.length);
    
    while (range.location != NSNotFound && croppedRange.length > 0) {
        
        croppedString = [result substringWithRange:croppedRange];
        NSRange newRange = [croppedString rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
        if (newRange.location == NSNotFound) {
            break;
        }
        //if (newRange.location > range.location) {? From PB
        range = NSMakeRange(newRange.location+croppedRange.location, newRange.length);
        [result insertString:@" " atIndex:range.location];//}
        range = NSMakeRange(range.location+1, range.length);
        croppedRange = NSMakeRange(range.location+range.length, result.length-range.location-range.length);
    }
    return groupUppercase ? [result removeSpaceBetweenOneCharacterSubstrings] : result;
}

- (NSString *)removeSpaceBetweenOneCharacterSubstrings {
    
    NSArray<NSString *> *components = [self componentsSeparatedByString:@" "];
    NSMutableArray<NSString *> *newComponents = [[NSMutableArray alloc] init];
    NSString *tmpStr;
    unsigned int tmpIndex;
    
    for (unsigned int i=0; i<components.count;) {
        if (components[i].length == 1) {
            tmpIndex = i;
            while (tmpIndex+1 < components.count && components[tmpIndex+1].length == 1) {
                tmpIndex ++;
            }
            if (tmpIndex == i) {
                [newComponents addObject:components[i]];
                i++;
            }
            else {
                NSMutableArray<NSString *> *letters = [[NSMutableArray alloc] init];
                for (unsigned int j=i; j<=tmpIndex; j++) {
                    [letters addObject:components[j]];
                }
                
                tmpStr = [letters componentsJoinedByString:@""];
                [newComponents addObject:tmpStr];
                i = tmpIndex+1;
            }
        }
        else {
            [newComponents addObject:components[i]];
            i++;
        }
    }
    return [newComponents componentsJoinedByString:@" "];
}

@end
