//
//  NSString+Validation.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-09.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isValidHTML {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kRegexHTML options:NSRegularExpressionCaseInsensitive error:nil];
    return 0 < [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])].count;
}

- (BOOL)isValidStringOfType:(MKU_TEXT_TYPE)type maxLength:(NSUInteger)length {
    NSPredicate *predicate;
    switch (type) {
        case MKU_TEXT_TYPE_INT: {
            predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [NSString stringWithFormat:kRegexIntMaxChar, length]];
        }
            break;
        case MKU_TEXT_TYPE_INT_POSITIVE: {
            predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [NSString stringWithFormat:kRegexIntPositiveMaxChar, length]];
        }
            break;
        case MKU_TEXT_TYPE_FLOAT: {
            predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [NSString stringWithFormat:kRegexFloatMaxChar, length, length]];
        }
            break;
        case MKU_TEXT_TYPE_FLOAT_POSITIVE: {
            predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [NSString stringWithFormat:kRegexFloatPositiveMaxChar, length, length]];
        }
            break;
        case MKU_TEXT_TYPE_ALPHABET: {
            predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [NSString stringWithFormat:kRegexLettersMaxChar, length]];
        }
            break;
        case MKU_TEXT_TYPE_ALPHANUMERIC: {
            predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [NSString stringWithFormat:kRegexAlphanumericMaxChar, length]];
        }
            break;
        default:
            break;
    }
    if (predicate) {
        return [predicate evaluateWithObject:self];
    }
    return YES;
}

- (NSString *)alphanumericSpace {
    NSMutableCharacterSet *set = [NSMutableCharacterSet alphanumericCharacterSet];
    [set addCharactersInString:@" ."];
    
    StringArr *arr = [self componentsSeparatedByCharactersInSet:[set invertedSet]];
    return [arr componentsJoinedByString:@""];
}

- (BOOL)isValidStringOfType:(MKU_TEXT_TYPE)type maxLength:(NSUInteger)length isEditing:(BOOL)isEditing {
    NSPredicate *predicate;
    NSString *format = [Constants Predicate_MatchesSelf];
    NSString *regex;
    switch (type) {
        case MKU_TEXT_TYPE_INT: {
            regex = [Constants Regex_CharRange_Int];
            regex = [NSString stringWithFormat:regex, 0, length];
        }
            break;
        case MKU_TEXT_TYPE_INT_POSITIVE: {
            regex = [Constants Regex_CharRange_IntPositive];
            regex = [NSString stringWithFormat:regex, 0, length];
        }
            break;
        case MKU_TEXT_TYPE_FLOAT: {
            regex = [Constants Regex_CharRange_Float];
            regex = [NSString stringWithFormat:regex, 0, length, 0, 2];
        }
            break;
        case MKU_TEXT_TYPE_FLOAT_POSITIVE: {
            regex = [Constants Regex_CharRange_FloatPositive];
            regex = [NSString stringWithFormat:regex, 0, length, 0, 2];
        }
            break;
        case MKU_TEXT_TYPE_ALPHABET: {
            regex = [Constants Regex_CharRange_Alphabet];
            regex = [NSString stringWithFormat:regex, 0, length];
        }
            break;
        case MKU_TEXT_TYPE_ALPHANUMERIC: {
            regex = [Constants Regex_CharRange_Alphanumeric];
            regex = [NSString stringWithFormat:regex, 0, length];
        }
            break;
        case MKU_TEXT_TYPE_ALPHASPACEDOT: {
            regex = [Constants Regex_CharRange_AlphaSpaceDot];
            regex = [NSString stringWithFormat:regex, 0, length];
        }
            break;
        case MKU_TEXT_TYPE_EMAIL: {
            if (isEditing) {
                if (![self containsString:@"@"]) {
                    regex = [Constants Regex_Email_NoCheck];
                }
                else if (![self containsString:@"."] || [self rangeOfString:@"." options:NSBackwardsSearch].location < [self rangeOfString:@"@"].location) {
                    regex = [Constants Regex_Email_Has_AT];
                }
                else {
                    regex = [Constants Regex_Email_Has_AT_Dot];
                }
            }
            else {
                regex = [Constants Regex_Email];
            }
        }
            break;
        case MKU_TEXT_TYPE_PHONE: {
            if (isEditing) {
                regex = [Constants Regex_CharRange_Int];
                regex = [NSString stringWithFormat:regex, 0, 10];
            }
            else {
                regex = [Constants Regex_Phone];
            }
        }
            break;
        case MKU_TEXT_TYPE_ADDRESS: {
            regex = [Constants Regex_Address];
        }
            break;
        case MKU_TEXT_TYPE_DATE: {
            if (isEditing) {
                regex = [Constants Regex_CharRange_Dash_Numeric];
                regex = [NSString stringWithFormat:regex, 0, 10];
            }
            else {
                regex = [Constants Regex_Date];
            }
        }
            break;
        case MKU_TEXT_TYPE_GENDER: {
            regex = [Constants Regex_Gender];
        }
            break;
        case MKU_TEXT_TYPE_STRING:
        default:
            return self.length <= length;
    }
    if (regex) {
        predicate = [NSPredicate predicateWithFormat:format, regex];
        return [predicate evaluateWithObject:self];
    }
    return YES;
}

@end
