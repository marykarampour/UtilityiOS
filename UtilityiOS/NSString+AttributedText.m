//
//  NSString+AttributedText.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-01.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "NSString+AttributedText.h"

@implementation StringAttributes

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    if (self = [super init]) {
        self.text = text;
        self.font = font;
        self.color = color;
    }
    return self;
}

+ (StringAttributes *)attributesWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    return [[StringAttributes alloc] initWithText:text font:font color:color];
}

@end

@implementation NSString (AttributedText)

+ (NSAttributedString *)attributedTextWithAttributedStrings:(NSArray<NSAttributedString *> *)attrs attributedDelimiter:(NSAttributedString *)delimiter {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@""];
    
    for (NSAttributedString *attr in attrs) {
        [attrStr appendAttributedString:attr];
        if (delimiter && ![[attrs lastObject] isEqual:attr]) {
            [attrStr appendAttributedString:delimiter];
        }
    }
    return attrStr;
}

+ (NSAttributedString *)attributedTextWithAttributedStrings:(NSArray<NSAttributedString *> *)attrs delimiter:(NSString *)delimiter {
    NSMutableAttributedString *attrDelimiter = [[NSMutableAttributedString alloc] initWithString:delimiter];
    return [self attributedTextWithAttributedStrings:attrs attributedDelimiter:attrDelimiter];
}

+ (NSAttributedString *)attributedTextWithAttributes:(NSArray<StringAttributes *> *)attrs attributedDelimiter:(NSAttributedString *)delimiter {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@""];
    
    for (StringAttributes *attr in attrs) {
        if (attr.text) {
            NSAttributedString *nextStr = [[NSMutableAttributedString alloc] initWithString:attr.text attributes:@{NSFontAttributeName:attr.font, NSForegroundColorAttributeName:attr.color}];
            [attrStr appendAttributedString:nextStr];
            if (delimiter && ![[attrs lastObject] isEqual:attr]) {
                [attrStr appendAttributedString:delimiter];
            }
        }
    }
    return attrStr;
}

+ (NSAttributedString *)attributedTextWithAttributes:(NSArray<StringAttributes *> *)attrs delimiter:(NSString *)delimiter {
    NSMutableAttributedString *attrDelimiter = [[NSMutableAttributedString alloc] initWithString:delimiter];
    return [self attributedTextWithAttributes:attrs attributedDelimiter:attrDelimiter];
}

+ (NSAttributedString *)attributedTextWithAttributes:(NSArray<StringAttributes *> *)attrs {
    return [self attributedTextWithAttributes:attrs attributedDelimiter:nil];
}

+ (NSAttributedString *)attributedTextWithIndent:(CGFloat)indent firstLineIndent:(CGFloat)firstLineIndent attributes:(StringAttributes *)attrs {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = indent;
    style.firstLineHeadIndent = firstLineIndent;
    NSDictionary *styleAttrs = @{NSParagraphStyleAttributeName:style};
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:attrs.text attributes:styleAttrs];
    if (attrs.font) {
        [attr addAttribute:NSFontAttributeName value:attrs.font range:NSMakeRange(0, attrs.text.length)];
    }
    if (attrs.color) {
        [attr addAttribute:NSForegroundColorAttributeName value:attrs.color range:NSMakeRange(0, attrs.text.length)];
    }
    
    return attr;
}

+ (NSAttributedString *)bulletedTextWithArray:(StringArr *)strings {
    NSMutableAttributedString *fullStr = [[NSMutableAttributedString alloc] init];
    for (NSString *str in strings) {
        NSString *symbol = @"●";
        NSString *bullet = [NSString stringWithFormat:@"%@\t", symbol];
        NSString *bulletedString = [NSString stringWithFormat:@"%@%@\n", bullet, [str tabNewLines]];
        NSMutableAttributedString *multi = [[NSMutableAttributedString alloc] initWithString:bulletedString];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        CGFloat tab = 24.0;
        style.paragraphSpacing = 4;
        style.paragraphSpacingBefore = 4;
        style.firstLineHeadIndent = 0.0;
        style.headIndent = 24.0;
        style.defaultTabInterval = tab;
        style.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:tab options:@{}]];
        [multi addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, bulletedString.length)];
        
        [fullStr appendAttributedString:multi];
    }
    return fullStr;
}

- (NSString *)tabNewLines {
    return [self stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
}

@end

