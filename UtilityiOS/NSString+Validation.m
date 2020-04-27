//
//  NSString+Validation.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-09.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isValidStringOfType:(TextType)type maxLength:(NSUInteger)length isEditing:(BOOL)isEditing {
    NSPredicate *predicate;
    NSString *format = [Constants Predicate_MatchesSelf];
    NSString *regex;
    switch (type) {
        case TextType_Int: {
            regex = [Constants Regex_CharRange_Int];
            regex = [NSString stringWithFormat:regex, 0, length];
        }
            break;
        case TextType_IntPositive: {
            regex = [Constants Regex_CharRange_IntPositive];
            regex = [NSString stringWithFormat:regex, 0, length];
        }
            break;
        case TextType_Float: {
            regex = [Constants Regex_CharRange_Float];
            regex = [NSString stringWithFormat:regex, 0, length, 0, 2];
        }
            break;
        case TextType_FloatPositive: {
            regex = [Constants Regex_CharRange_FloatPositive];
            regex = [NSString stringWithFormat:regex, 0, length, 0, 2];
        }
            break;
        case TextType_Alphabet: {
            regex = [Constants Regex_CharRange_Alphabet];
            regex = [NSString stringWithFormat:regex, 0, length];
        }
            break;
        case TextType_AlphaNumeric: { 
            regex = [Constants Regex_CharRange_Alphanumeric];
            regex = [NSString stringWithFormat:regex, 0, length];
        }
            break;
        case TextType_AlphaSpaceDot: {
            regex = [Constants Regex_CharRange_AlphaSpaceDot];
            regex = [NSString stringWithFormat:regex, 0, length];
        }
            break;
        case TextType_Email: {
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
        case TextType_Phone: {
            if (isEditing) {
                regex = [Constants Regex_CharRange_Int];
                regex = [NSString stringWithFormat:regex, 0, 10];
            }
            else {
                regex = [Constants Regex_Phone];
            }
        }
            break;
        case TextType_Address: {
            regex = [Constants Regex_Address];
        }
            break;
        case TextType_Date: {
            if (isEditing) {
                regex = [Constants Regex_CharRange_Dash_Numeric];
                regex = [NSString stringWithFormat:regex, 0, 10];
            }
            else {
                regex = [Constants Regex_Date];
            }
        }
            break;
        case TextType_Gender: {
            regex = [Constants Regex_Gender];
        }
            break;
        case TextType_String:
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
