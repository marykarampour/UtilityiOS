//
//  NSString+AttributedText.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-01.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringAttributes : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;
+ (StringAttributes *)attributesWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

@end

@interface NSString (AttributedText)

+ (NSAttributedString *)attributedTextWithAttributes:(NSArray <StringAttributes *> *)attrs;
+ (NSAttributedString *)multiLineTextWithAttributes:(NSArray <StringAttributes *> *)attrs;
+ (NSAttributedString *)dashedTextWithAttributes:(NSArray<StringAttributes *> *)attrs;
+ (NSAttributedString *)attributedTextWithIndent:(CGFloat)indent firstLineIndent:(CGFloat)firstLineIndent attributes:(StringAttributes *)attrs;
+ (NSAttributedString *)bulletedTextWithArray:(StringArr *)strings;

@end

