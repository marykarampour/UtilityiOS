//
//  NSString+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "NSString+Utility.h"
#import "NSObject+Utility.h"
#import "NSString+Validation.h"
#import <CommonCrypto/CommonDigest.h>

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
        case StringFormatCapitalizedCamelCase:
            return [[self underScoreToCamelCaseUpperCaseAll:NO] capitalizedString];
            break;
        case StringFormatCapitalizedCamelCaseSpacedSanitizedGroupedOneChars:
            return [self sanitizeCapitalizedCamelCaseSpaced];
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
            name = [self stringByReplacingCharactersInRange:NSMakeRange(self.length-3, 3) withString:@"ys"];
        }
        name = [name stringByReplacingCharactersInRange:NSMakeRange(name.length-1, 1) withString:@""];
    }
    return name;
}

- (NSString *)singleToPlural {
    NSString *name;
    if ([[self substringFromIndex:self.length-1] isEqualToString:@"y"]) {
        name = [self stringByReplacingCharactersInRange:NSMakeRange(self.length-1, 1) withString:@"ies"];
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
        [randomStr appendFormat:@"%C", [seed characterAtIndex:arc4random_uniform((uint32_t)seed.length)]];
    }
    return randomStr;
}

- (NSString *)securedHashWithName:(NSString *)name salt:(NSString *)salt {
    name = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *hashStr = [NSString stringWithFormat:@"%@%@%@", name, self, salt];
    return [hashStr computeHash];
}

- (NSString *)computeHash {
    return [NSString computeHashForString:self];
}

+ (NSString *)computeHashForString:(NSString *)string {
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *mString = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for (unsigned int i=0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [mString appendFormat:@"%02x", digest[i]];
    }
    return mString;
}

+ (NSString *)telFromString:(NSString *)string {
    return [NSString stringWithFormat:@"tel://%@", string];
}

+ (NSString *)telPromptFromString:(NSString *)string {
    return [NSString stringWithFormat:@"telprompt://%@", string];
}

+ (NSString *)notnullString:(NSString *)string {
    return [self notnullString:string defaultText:@""];
}

+ (NSString *)notnullString:(NSString *)string defaultText:(NSString * __nonnull)defaultText {
    return (0 < string.length && ![string isEqualToString:@"null"]) ? string : defaultText;
}

- (NSString *)quotations {
    return [NSString stringWithFormat:@"\"%@\"", self];
}

- (NSString *)spaced {
    return [NSString stringWithFormat:@" %@ ", self];
}

- (NSString *)multiplyWithCount:(NSUInteger)count {
    NSString *string = @"";
    for (NSUInteger i=0; i<count; i++) {
        string = [string stringByAppendingString:self];
    }
    return string;
}

- (NSString *)splitedStringForUppercaseComponents {
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
        if (newRange.location > range.location) {
            range = NSMakeRange(newRange.location+croppedRange.location, newRange.length);
            [result insertString:@" " atIndex:range.location];
        }
        range = NSMakeRange(range.location+1, range.length);
        croppedRange = NSMakeRange(range.location+range.length, result.length-range.location-range.length);
    }
    return result;
}

- (NSString *)obscuredEmail {
    
    NSString *email = self;
    if (![self isValidStringOfType:MKU_TEXT_TYPE_EMAIL maxLength:0 isEditing:NO]) return email;
    
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

- (NSString *)sanitizeCapitalizedCamelCaseSpaced {
    
    NSString *string = [self format:StringFormatUnderScore];
    string = [string stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    string = [string capitalizedString];
    string = [string removeSpaceBetweenOneCharacterSubstrings];
    string = [string stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    return string;
}

- (NSString *)addSpaceBefore {
    return [NSString stringWithFormat:@" %@", self];
}

- (NSString *)addSpaceAfter {
    return [NSString stringWithFormat:@"%@ ", self];
}

- (NSString *)timestamp {
    return [NSString stringWithFormat:@"%@-%d", self, (int)[[NSDate date] timeIntervalSince1970]];
}

- (NSString *)GUID {
    return [NSString stringWithFormat:@"%@-%@", self, [NSString GUID]];
}

- (NSString *)removeSubstring:(NSString *)str {
    return [self stringByReplacingOccurrencesOfString:str withString:@""];
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimCharSet:(NSString *)chars {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:chars];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)trimWithSubstring:(NSString *)string boundary:(LINEAR_BOUNDARY_POINT)boundary inclusive:(BOOL)inclusive {
    if (![self containsString:string] || boundary <= 0) return self;
    
    NSRange searchRange = NSMakeRange(0, self.length);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:string options:0 error:nil];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:self options:0 range:searchRange];
    
    switch (boundary) {
        case LINEAR_BOUNDARY_POINT_START: {
            NSRange range = matches.firstObject.range;
            return [self substringFromIndex:inclusive ? range.location + range.length : range.location];
        }
            break;
            
        case LINEAR_BOUNDARY_POINT_END: {
            NSRange range = matches.lastObject.range;
            return [self substringToIndex:inclusive ? range.location : range.location + range.length];
        }
            break;
            
        default: {
            NSString *start = [self trimWithSubstring:string boundary:LINEAR_BOUNDARY_POINT_START inclusive:inclusive];
            return [start trimWithSubstring:string boundary:LINEAR_BOUNDARY_POINT_END inclusive:inclusive];
        }
            break;
    }
}

- (NSString *)lastCharacters:(NSUInteger)chars {
    if (self.length <= chars) return self;
    return [self substringFromIndex:self.length - chars];
}

- (NSString *)splitedStringForUppercaseComponentsAndGroupUppercase:(BOOL)groupUppercase {
    if (self.length < 2) {
        return self;
    }
    
    NSMutableString *result = [NSMutableString stringWithString:self];
    NSRange range = [result rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    NSString *croppedString = self;
    NSRange croppedRange = NSMakeRange(range.location+range.length, croppedString.length-range.length);
    
    while (range.location != NSNotFound && 0 < croppedRange.length && croppedRange.length + croppedRange.location <= result.length) {
        
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
    return [self removeBetweenOneCharacterSubstringsOccurrenceaOfSpacer:@" "];
}
//TODO: Fix
//Matching Photo on ID?\n(Check for Yes)
//Matching  Photo on  I D? ( Check for  Yes)
- (NSString *)removeBetweenOneCharacterSubstringsOccurrenceaOfSpacer:(NSString *)spacer {
    
    NSArray<NSString *> *components = [self componentsSeparatedByString:spacer];
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
    return [newComponents componentsJoinedByString:spacer];
}

- (NSString *)displayNameForProperty {
    return [[self splitedStringForUppercaseComponents] removeSpaceBetweenOneCharacterSubstrings];
}

- (NSString *)addResultForTag:(NSString *)tag {
    return [self addResultTag:@"Result" forTag:tag];
}

- (NSString *)addResultTag:(NSString *)result forTag:(NSString *)tag {
    NSString *string = [self copy];
    NSString *tagStr = [NSString stringWithFormat:@"<%@>", tag];
    NSString *tagCloseStr = [NSString stringWithFormat:@"</%@>", tag];
    
    string = [string stringByReplacingOccurrencesOfString:tagStr withString:[NSString stringWithFormat:@"%@<%@>", tagStr, result]];
    string = [string stringByReplacingOccurrencesOfString:tagCloseStr withString:[NSString stringWithFormat:@"</%@>%@", result, tagCloseStr]];
    return string;
}

- (NSString *)removeXMLNilTrueForTag:(NSString *)tag {
    NSString *string = [self copy];
    NSString *tagStr = [NSString stringWithFormat:@"<%@ xsi:nil=\"true\" />", tag];
    string = [string stringByReplacingOccurrencesOfString:tagStr withString:@""];
    return string;
}

- (NSString *)replaceXMLLessGreaterWithTags {
    NSString *string = [self copy];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    return string;
}

- (NSString *)replaceXMLLongWithTag:(NSString *)tag {
    NSString *string = [self copy];
    NSString *tagStr = [NSString stringWithFormat:@"<%@>", tag];
    NSString *tagCloseStr = [NSString stringWithFormat:@"</%@>", tag];
    
    string = [string stringByReplacingOccurrencesOfString:@"<long>" withString:tagStr];
    string = [string stringByReplacingOccurrencesOfString:@"</long>" withString:tagCloseStr];
    return string;
}

- (NSString *)removeXMLContentsOfTag:(NSString *)tag {
    if (![self containsString:tag]) return self;
    
    NSString *string = [self copy];
    NSString *tagStr = [NSString stringWithFormat:@"<%@>", tag];
    NSString *tagCloseStr = [NSString stringWithFormat:@"</%@>", tag];
    
    if (![self containsString:tagStr] || ![self containsString:tagCloseStr]) return self;
    
    NSRange startRange = [string rangeOfString:tagStr];
    NSRange endRange = [string rangeOfString:tagCloseStr];
    NSUInteger index = startRange.location + startRange.length;
    NSRange range = NSMakeRange(index, endRange.location - index);
    
    string = [string stringByReplacingCharactersInRange:range withString:@""];
    
    return string;
}

- (NSString *)multipliedStringOfLenght:(NSUInteger)lenght {
    NSString *str = @"";
    for (unsigned int i=0; i<lenght; i++) {
        str = [str stringByAppendingString:self];
    }
    return str;
}

+ (NSString *)nonNullString:(NSString *)string {
    return string ? string : @"";
}

+ (NSString *)nonNullOrSpaceString:(NSString *)string {
    return string ? string : @" ";
}

+ (NSString *)nonEmptyOrNoneString:(NSString *)string {
    return string.length == 0 ? @"None" : string;
}

+ (NSString *)combineString:(NSString *)str1 withString:(NSString *)str2 {
    if (0 < str1.length && 0 < str2.length) {
        if ([str1 isEqualToString:str2]) {
            return str1;
        }
        return [NSString stringWithFormat:@"%@ %@", str1, str2];
    }
    else if (0 < str1.length) {
        return str1;
    }
    return str2;
}

//not used
- (NSString *)xmlByEscapingControlCharacters {
    
    NSString *str = self;
    NSRange rangeOfSmaller;
    NSString *smallerSubStr = [str copy];
    rangeOfSmaller = [str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<"]];
    //how about >
    while (smallerSubStr.length > 0 && rangeOfSmaller.location != NSNotFound) {
        //str should be replaced by after <
        rangeOfSmaller = [str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"<"]];
        if (rangeOfSmaller.location != NSNotFound) {
            smallerSubStr = [str substringFromIndex:rangeOfSmaller.location];
            if (smallerSubStr.length > 0 && str.length > rangeOfSmaller.location) {
                NSRange rangeOfgreater = [smallerSubStr rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@">"]];
                //what if not any closing tag?
                if (rangeOfgreater.location != NSNotFound) {
                    
                    NSString *tagStr = [smallerSubStr substringWithRange:NSMakeRange(0, rangeOfgreater.location+1)];
                    NSString *innerStr = [tagStr substringWithRange:NSMakeRange(1, tagStr.length-2)];
                    NSMutableString *closingTag = [NSMutableString stringWithString:tagStr];
                    [closingTag insertString:@"/" atIndex:1];
                    if (![str containsString:closingTag]) {
                        //check if tagStr is > 1 char
                        NSString *escapedStr = [NSString stringWithFormat:@"&lt;%@&gt;", innerStr];
                        str = [str stringByReplacingOccurrencesOfString:tagStr withString:escapedStr];
                    }
                }
            }
        }
    }
    return str;
}

- (CGRect)rectForWidth:(CGFloat)width font:(UIFont *)font {
    
    UIFont *fontAttr = font ? [font copy] : [AppTheme mediumLabelFont];
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    NSUInteger newLines = [self numberOfOccurrencesOfString:@"\n\n"];
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontAttr} context:nil];
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + newLines*[Constants TableCellLineHeight]);
}

- (NSUInteger)numberOfOccurrencesOfString:(NSString *)string {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:string options:NSRegularExpressionCaseInsensitive error:nil];
    return [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
}

- (NSString *)makePrefix {
    if (0 < self.length) {
        return [NSString stringWithFormat:@"%@-", self];
    }
    return @"";
}

- (NSString *)fileNameWithExtension:(NSString *)ext {
    if (ext.length == 0) return self;
    
    StringArr *arr = [self componentsSeparatedByString:@"."];
    if (1 < arr.count) {
        NSString *str = [self substringToIndex:self.length-arr.lastObject.length-1];
        return [NSString stringWithFormat:@"%@.%@", str, ext];
    }
    return [NSString stringWithFormat:@"%@.%@", self, ext];
}

- (NSString *)extension {
    NSArray *arr = [self componentsSeparatedByString:@"."];
    if (1 < arr.count)
        return arr.lastObject;
    else
        return nil;
}

- (NSString *)filename {
    NSArray *arr = [self componentsSeparatedByString:@"."];
    if (1 < arr.count)
        return arr.firstObject;
    else
        return self;
}

+ (NSString *)addString:(NSString *)string toSource:(NSString *)source delimiter:(NSString *)delimiter {
    if (0 < string.length && ![source containsString:string]) {
        source = [NSString stringWithFormat:@"%@%@%@", source, delimiter, string];
    }
    return source;
}

- (NSString *)addString:(NSString *)string delimiter:(NSString *)delimiter {
    return [NSString addString:string toSource:self delimiter:delimiter];
}

- (NSString *)stringByRemovingHTMLTags {
    NSString *textWithoutTags = [self stringByReplacingOccurrencesOfString:@"<p>|</p>|>|<br />|<a href=|/>|<img[^>]*>" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
    textWithoutTags = [textWithoutTags stringByReplacingOccurrencesOfString:@"</a" withString:@"\n\n" options:NSRegularExpressionSearch range:NSMakeRange(0, textWithoutTags.length)];
    textWithoutTags = [textWithoutTags stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, textWithoutTags.length)];
    return textWithoutTags;
}

+ (NSString *)removeHTMLTagsFromString:(NSString *)text {
    return [text stringByRemovingHTMLTags];
}

- (NSString *)shortenedStringToMaxLength:(NSUInteger)maxLength {
    if (self.length <= maxLength) {
        return self;
    }
    NSString *substring = [self substringToIndex:maxLength];
    return [substring stringByAppendingString:kElipsisString];
}

- (NSString *)replaceCharacters:(NSString *)charactersToReplace withString:(NSString *)replacementString {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:charactersToReplace];
    return [[self componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:replacementString];
}

@end

