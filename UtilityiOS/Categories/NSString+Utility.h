//
//  NSString+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, StringFormat) {
    
    //No change, the output string will be the same as input, example:
    //1. example_string -> example_string
    //2. exampleString -> exampleString
    StringFormatNone,
    
    //Capitaliazing the input string, example:
    //1. example_string -> Example_string
    //2. exampleString -> ExampleString
    StringFormatCapitalized,
    
    //camelCasing the input string, example:
    //1. example_string -> exampleString
    //2. exampleString -> exampleString
    StringFormatCamelCase,
    
    //camelCasing the input string, example:
    //1. example_string -> ExampleString
    //2. exampleString -> ExampleString
    //3. example_string_0 -> exampleString0
    StringFormatCapitalizedCamelCase,
    
    //Upper case all charachters of input string, example:
    //1. example_string -> EXAMPLE_STRING
    //2. exampleString -> EXAMPLESTRING
    StringFormatUpperCaseAll,
    
    //camelCase to under_score
    //1. exampleString -> example_string
    //2. exampleString0 -> example_string_0
    StringFormatUnderScore,
    
    //camelCase to under_score with all characters uppercased
    //1. exampleString -> EXAMPLE_STRING
    //2. exampleString0 -> EXAMPLE_STRING_0
    StringFormatUnderScoreUpperCaseAll,
    
    //camelCase to under_score - this option will not underscore digits
    //1. exampleString -> example_string
    //2. exampleString0 -> example_string0
    StringFormatUnderScoreIgnoreDigits,
    
    //camelCase to under_score with all characters uppercased - this option will not underscore digits
    //1. exampleString -> EXAMPLE_STRING
    //2. exampleString0 -> EXAMPLE_STRING0
    StringFormatUnderScoreIgnoreDigitsUpperCaseAll,
};

@interface NSString (Utility)

- (NSString *)format:(StringFormat)format;
- (NSString *)capitalizeFirstChar;
- (NSString *)lowercaseFirstChar;

/** @brief under_score to camelCase
 @remark Only use for one word property names
 @param ignoreDigits Pass YES if you want digits be ignored, example exampleWord00: passing YES will result in example_word00 but passing NO will result in example_word_00
 @param upperCaseAll Pass YES if you want the resulting underscore word be all uppercase, example: EXAMPLE_WORD
 */
//Made public just for Unit Testing
- (NSString *)camelCaseToUnderScoreIgnoreDigits:(BOOL)ignoreDigits upperCaseAll:(BOOL)upperCaseAll;

- (NSString *)pluralToSingle;
- (NSString *)singleToPlural;

- (NSNumber *)stringToNumber;
- (NSNumber *)stringToNumberWithFormat:(NSNumberFormatterStyle)format;
- (NSString *)amount;
+ (NSString *)randomStringWithLenght:(NSUInteger)length;
+ (NSString *)telFromString:(NSString *)string;

+ (NSString *)notnullString:(NSString *)string;
+ (NSString *)notnullString:(NSString *)string defaultText:(NSString * __nonnull)defaultText;
- (NSString *)quotations;
- (NSString *)spaced;
- (NSString *)removeSubstring:(NSString *)str;
- (NSString *)trimCharSet:(NSString *)chars;
/** @brief concatinates the same string count times */
- (NSString *)multiplyWithCount:(NSUInteger)count;

/** @brief splits a string based on uppercase letters
 @code
 UpperCaseString --> Upper Case String
 @endcode
 */
- (NSString *)splitedStringForUppercaseComponents;

- (NSString *)numbersOnly;

/** @brief If is valid like email@gmail.com it returns emi**@**ail.com otherwise returs self */
- (NSString *)obscuredEmail;
/** @brief splits a string based on uppercase letters
 @code
 UpperCaseString --> Upper Case String
 @endcode
 */
/** @param groupUppercase If YES it will not put extra space between consecutive uppercase letters */
- (NSString *)splitedStringForUppercaseComponentsAndGroupUppercase:(BOOL)groupUppercase;
- (NSString *)removeSpaceBetweenOneCharacterSubstrings;

@end
