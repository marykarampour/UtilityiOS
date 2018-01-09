//
//  NSString+Validation.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-09.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isValidStringOfType:(TextType)type maxLength:(NSUInteger)length {
    NSPredicate *predicate;
    NSString *format = [Constants Predicate_MatchesSelf];
    NSString *regex;
    switch (type) {
        case TextTypeInt: {
            regex = [Constants Regex_CharRange_Int];
        }
            break;
        case TextTypeIntPositive: {
            regex = [Constants Regex_CharRange_IntPositive];
        }
            break;
        case TextTypeFloat: {
            regex = [Constants Regex_CharRange_Float];
        }
            break;
        case TextTypeFloatPositive: {
            regex = [Constants Regex_CharRange_FloatPositive];
        }
            break;
        case TextTypeAlphabet: {
            regex = [Constants Regex_CharRange_Letters];
        }
            break;
        case TextTypeAlphaNumeric: {
            regex = [Constants Regex_CharRange_Alphanumeric];
        }
            break;
        default:
            break;
    }
    if (regex) {
        predicate = [NSPredicate predicateWithFormat:format, [NSString stringWithFormat:regex, 0, length]];
        return [predicate evaluateWithObject:self];
    }
    return YES;
}


@end
