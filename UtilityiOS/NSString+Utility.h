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
    StringFormatUnderScoreIgnoreDigitsUpperCaseAll
};

@interface NSString (Utility)

- (NSString *)format:(StringFormat)format;
- (NSString *)capitalizeFirstChar;

/** @brief under_score to camelCase
 @remark Only use for one word property names
 @param ignoreDigits Pass YES if you want digits be ignored, example exampleWord00: passing YES will result in example_word00 but passing NO will result in example_word_00
 @param upperCaseAll Pass YES if you want the resulting underscore word be all uppercase, example: EXAMPLE_WORD
 */
//Made public just for Unit Testing
- (NSString *)camelCaseToUnderScoreIgnoreDigits:(BOOL)ignoreDigits upperCaseAll:(BOOL)upperCaseAll;


- (NSNumber *)stringToNumber;

@end
