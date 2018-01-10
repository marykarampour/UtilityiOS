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
        case TextType_Int: {
            regex = [Constants Regex_CharRange_Int];
        }
            break;
        case TextType_IntPositive: {
            regex = [Constants Regex_CharRange_IntPositive];
        }
            break;
        case TextType_Float: {
            regex = [Constants Regex_CharRange_Float];
        }
            break;
        case TextType_FloatPositive: {
            regex = [Constants Regex_CharRange_FloatPositive];
        }
            break;
        case TextType_Alphabet: {
            regex = [Constants Regex_CharRange_Letters];
        }
            break;
        case TextType_AlphaNumeric: {
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
