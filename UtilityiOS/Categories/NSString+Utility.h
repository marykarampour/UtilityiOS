//
//  NSString+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Additional supported formats are:
 
//camelCasing the input string, example:
//1. example_string -> ExampleString
//2. exampleString -> ExampleString
//3. example_string_0 -> exampleString0
 MKU_STRING_FORMAT_CAPITALIZED and MKU_STRING_FORMAT_CAMELCASE,

//camelCase to under_score with all characters uppercased
//1. exampleString -> EXAMPLE_STRING
//2. exampleString0 -> EXAMPLE_STRING_0
MKU_STRING_FORMAT_UNDERSCORE and MKU_STRING_FORMAT_UPPERCASE_ALL,

//camelCase to under_score - this option will not underscore digits
//1. exampleString -> example_string
//2. exampleString0 -> example_string0
MKU_STRING_FORMAT_UNDERSCORE and MKU_STRING_FORMAT_IGNORE_DIGITS,

//camelCase to under_score with all characters uppercased - this option will not underscore digits
//1. exampleString -> EXAMPLE_STRING
//2. exampleString0 -> EXAMPLE_STRING0
MKU_STRING_FORMAT_UNDERSCORE and MKU_STRING_FORMAT_IGNORE_DIGITS and MKU_STRING_FORMAT_UPPERCASE_ALL,

//capitalized__IS_Under_score to CapitalizedISCamelCase
//1. example_string -> Example String
//2. example__string_0 -> Example String0
 MKU_STRING_FORMAT_CAPITALIZED and MKU_STRING_FORMAT_CAMELCASE and MKU_STRING_FORMAT_SPACED_SANITIZED_GROUPED_ONE_CHARS
*/
typedef NS_OPTIONS(NSUInteger, MKU_STRING_FORMAT) {
    //No change, the output string will be the same as input, example:
    //1. example_string -> example_string
    //2. exampleString -> exampleString
    MKU_STRING_FORMAT_NONE                                  = 0,
    
    //Capitaliazing the input string, example:
    //1. example_string -> Example_string
    //2. exampleString -> ExampleString
    MKU_STRING_FORMAT_CAPITALIZED                           = 1 << 0,
    
    //camelCasing the input string, example:
    //1. example_string -> exampleString
    //2. exampleString -> exampleString
    MKU_STRING_FORMAT_CAMELCASE                             = 1 << 1,
    
    //Upper case all charachters of input string, example:
    //1. example_string -> EXAMPLE_STRING
    //2. exampleString -> EXAMPLESTRING
    MKU_STRING_FORMAT_UPPERCASE_ALL                         = 1 << 2,
    
    //camelCase to under_score
    //1. exampleString -> example_string
    //2. exampleString0 -> example_string_0
    MKU_STRING_FORMAT_UNDERSCORE                            = 1 << 3,
    
    //camelCase to under_score - this option will not underscore digits
    //1. exampleString -> example_string
    //2. exampleString0 -> example_string0
    MKU_STRING_FORMAT_IGNORE_DIGITS                         = 1 << 4,
    
    //capitalized__IS_Under_score to CapitalizedISCamelCase
    //1. example_string -> Example String
    //2. example__string_0 -> Example String0
    MKU_STRING_FORMAT_SPACED_SANITIZED_GROUPED_ONE_CHARS    = 1 << 5
};

@interface NSString (Utility)

- (NSString *)format:(MKU_STRING_FORMAT)format;
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

+ (NSString *)telFromString:(NSString *)string;
+ (NSString *)telPromptFromString:(NSString *)string;

+ (NSString *)notnullString:(NSString *)string;
+ (NSString *)notnullString:(NSString *)string defaultText:(NSString * __nonnull)defaultText;
- (NSString *)quotations;
- (NSString *)spaced;
/** @brief concatinates the same string count times */
- (NSString *)multiplyWithCount:(NSUInteger)count;
- (NSString *)numbersOnly;

/** @brief If is valid like email@gmail.com it returns emi**@**ail.com otherwise returs self */
- (NSString *)obscuredEmail;
- (NSString *)addSpaceBefore;
- (NSString *)addSpaceAfter;
/** @brief Adds a timestamp to the end of self */
- (NSString *)timestamp;
/** @brief Adds a UUID to the end of self */
- (NSString *)GUID;
- (NSString *)removeSubstring:(NSString *)str;
/** @brief Trims white space. */
- (NSString *)trim;
- (NSString *)trimCharSet:(NSString *)chars;
/** @brief Trims linear boundaries of a string with a given string.
 @param string The string that acts as a boundary indicator. Anything before or after that will be removed.
 @param boundary It can be start or end of the string or both.
 @param inclusive If Yes, it will remove string, otherwise, it will remove up to string. */
- (NSString *)trimWithSubstring:(NSString *)string boundary:(LINEAR_BOUNDARY_POINT)boundary inclusive:(BOOL)inclusive;
- (NSString *)lastCharacters:(NSUInteger)chars;

/** @brief splits a string based on uppercase letters
 @code
 UpperCaseString --> Upper Case String
 @endcode
 */
/** @param groupUppercase If YES it will not put extra space between consecutive uppercase letters */
- (NSString *)splitedStringForUppercaseComponentsAndGroupUppercase:(BOOL)groupUppercase;
- (NSString *)removeSpaceBetweenOneCharacterSubstrings;
- (NSString *)removeBetweenOneCharacterSubstringsOccurrenceaOfSpacer:(NSString *)string;
/** @brief splits a string based on uppercase letters
 @code
 UpperCaseString --> Upper Case String
 @endcode
 */
- (NSString *)splitedStringForUppercaseComponents;
- (NSString *)displayNameForProperty;

- (NSString *)multipliedStringOfLenght:(NSUInteger)lenght;
+ (NSString *)nonNullString:(NSString *)string;
+ (NSString *)nonNullOrSpaceString:(NSString *)string;
+ (NSString *)nonEmptyOrNoneString:(NSString *)string;
/** @param delimiter Pass nil or empty string for no delimiter. */
+ (NSString *)combineString:(NSString *)str1 withString:(NSString *)str2 delimiter:(NSString *)delimiter;

//XML
- (NSString *)addResultForTag:(NSString *)tag;
- (NSString *)addResultTag:(NSString *)result forTag:(NSString *)tag;
- (NSString *)removeXMLNilTrueForTag:(NSString *)tag;
- (NSString *)replaceXMLLessGreaterWithTags;
- (NSString *)replaceXMLLongWithTag:(NSString *)tag;
- (NSString *)removeXMLContentsOfTag:(NSString *)tag;

- (CGRect)rectForWidth:(CGFloat)width font:(UIFont *)font;
- (NSUInteger)numberOfOccurrencesOfString:(NSString *)string;
- (StringArr *)componentsSeparatedByStringPattern:(NSString *)pattern;
- (NSString *)makePrefix;
/** @brief If self has extension and ext is nil it returns self, otherwise ext will be used as the extension. */
- (NSString *)fileNameWithExtension:(NSString *)ext;
- (NSString *)extension;
/** @brief FileName without extension. */
- (NSString *)filename;

+ (NSString *)addString:(NSString *)string toSource:(NSString *)source delimiter:(NSString *)delimiter;
- (NSString *)addString:(NSString *)string delimiter:(NSString *)delimiter;
- (NSString *)stringByRemovingHTMLTags;
+ (NSString *)removeHTMLTagsFromString:(NSString *)text;

/** @brief Returns short form of string (self), given max length param.  */
- (NSString *)shortenedStringToMaxLength:(NSUInteger)maxLength;
/** @brief Removes all occurrences of specified charactersToReplace and replaces them with the given replacementString  */
- (NSString *)replaceCharacters:(NSString *)charactersToReplace withString:(NSString *)replacementString;

#pragma mark - crypto

+ (NSString *)randomStringWithLenght:(NSUInteger)length;
- (NSString *)securedHashWithName:(NSString *)name salt:(NSString *)salt;
- (NSString *)computeHash;
+ (NSString *)computeHashForString:(NSString *)string;
/** @brief Supported operations are kCCEncrypt and kCCDecrypt */
- (NSString *)cryptWithKey:(NSString *)key IV:(NSString *)IV salt:(NSString *)salt op:(int)op;
- (NSString *)decryptWithKey:(NSString *)key IV:(NSString *)IV salt:(NSString *)salt;
- (NSString *)encryptWithKey:(NSString *)key IV:(NSString *)IV salt:(NSString *)salt;

@end
