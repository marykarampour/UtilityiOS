//
//  NSString+AttributedText.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-01.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUModel.h"

@interface MKUStringAttributes : MKUModel

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) NSTextAlignment alignment;

- (instancetype)initWithFont:(UIFont *)font color:(UIColor *)color;
+ (instancetype)attributesWithFont:(UIFont *)font color:(UIColor *)color;
- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;
+ (instancetype)attributesWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;
- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing;
+ (instancetype)attributesWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing;
- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment;
+ (instancetype)attributesWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment;
- (BOOL)isValid;
+ (instancetype)copy:(MKUStringAttributes *)attrs withText:(NSString *)text;
+ (instancetype)copy:(MKUStringAttributes *)attrs alignment:(NSTextAlignment)alignment;
+ (instancetype)blueBoldAttrsWithText:(NSString *)text;
+ (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle forLabel:(UILabel *)label;
+ (void)setTitle:(NSString *)title value:(NSString *)value forLabel:(UILabel *)label delimiter:(NSString *)delimiter;

@end


@protocol MKULabelAttributesProtocol <NSObject>

@required
- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel;
- (CGFloat)heightForWidth:(CGFloat)width;

@end

@interface MKULabelAttributes : MKUModel <MKULabelAttributesProtocol>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *subvalue;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attrValue;
@property (nonatomic, strong) NSAttributedString *attrSubvalue;
@property (nonatomic, strong) NSString *labelDelimiter;
@property (nonatomic, strong) NSString *sublabelDelimiter;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle value:(NSString *)value subvalue:(NSString *)subvalue placeholder:(NSString *)placeholder attrValue:(NSAttributedString *)attrValue attrSubvalue:(NSAttributedString *)attrSubvalue;
+ (instancetype)attributesWithTitle:(NSString *)title subtitle:(NSString *)subtitle value:(NSString *)value subvalue:(NSString *)subvalue placeholder:(NSString *)placeholder attrValue:(NSAttributedString *)attrValue attrSubvalue:(NSAttributedString *)attrSubvalue;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle value:(NSString *)value subvalue:(NSString *)subvalue placeholder:(NSString *)placeholder attrValue:(NSAttributedString *)attrValue attrSubvalue:(NSAttributedString *)attrSubvalue labelDelimiter:(NSString *)labelDelimiter sublabelDelimiter:(NSString *)sublabelDelimiter;
+ (instancetype)attributesWithTitle:(NSString *)title subtitle:(NSString *)subtitle value:(NSString *)value subvalue:(NSString *)subvalue placeholder:(NSString *)placeholder attrValue:(NSAttributedString *)attrValue attrSubvalue:(NSAttributedString *)attrSubvalue labelDelimiter:(NSString *)labelDelimiter sublabelDelimiter:(NSString *)sublabelDelimiter;

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel;
+ (void)setAttributedTitles:(MKULabelAttributes *)obj label:(UILabel *)label sublabel:(UILabel *)sublabel;

@end

@interface NSString (AttributedText)

- (NSAttributedString *)attributedTextWithColor:(UIColor *)color;
- (NSAttributedString *)attributedTextWithColor:(UIColor *)color font:(UIFont *)font;
+ (NSAttributedString *)attributedTitle:(NSString *)title number:(NSNumber *)number style:(MKU_THEME_STYLE)style;

+ (NSAttributedString *)multiLineTextWithAttributes:(NSArray <MKUStringAttributes *> *)attrs;
+ (NSAttributedString *)dashedTextWithAttributes:(NSArray <MKUStringAttributes *> *)attrs;
+ (NSAttributedString *)attributedTextWithIndent:(CGFloat)indent firstLineIndent:(CGFloat)firstLineIndent attributes:(MKUStringAttributes *)attrs;
+ (NSAttributedString *)bulletedTextWithArray:(StringArr *)strings;
+ (NSAttributedString *)bulletedTextWithAttributedStrings:(NSArray<NSAttributedString *> *)attrs bullet:(NSString *)symbol;
+ (NSAttributedString *)bulletedTextWithAttributes:(NSArray<MKUStringAttributes *> *)attrs bullet:(NSString *)symbol;

+ (NSAttributedString *)attributedTextWithStringAttributes:(MKUStringAttributes *)attrs, ...;
+ (NSAttributedString *)attributedTextWithDelimiter:(NSString *)delimiter attributes:(MKUStringAttributes *)attrs, ...;
+ (NSAttributedString *)attributedTextWithDelimiter:(NSString *)delimiter attributedTexts:(NSAttributedString *)attrs, ...;
+ (NSAttributedString *)attributedTextWithAttributedStrings:(NSArray<NSAttributedString *> *)attrs delimiter:(NSString *)delimiter;
+ (NSAttributedString *)attributedTextWithAttributedStrings:(NSArray<NSAttributedString *> *)attrs delimiter:(NSString *)delimiter alignment:(NSTextAlignment)alignment;

+ (NSAttributedString *)attributedTextWithImage:(UIImage *)image;
+ (NSAttributedString *)attributedTextWithAttribute:(MKUStringAttributes *)attr;
+ (NSAttributedString *)attributedTextWithAttributes:(NSArray <MKUStringAttributes *> *)attrs;
+ (NSAttributedString *)attributedTextWithAttributes:(NSArray <MKUStringAttributes *> *)attrs delimiter:(NSString *)delimiter;

- (NSAttributedString *)attributedTextWithAttributes:(MKUStringAttributes *)attrs titleAttributes:(MKUStringAttributes *)titleAttrs title:(NSString *)title;
+ (NSAttributedString *)attributedTextWithAttributes:(MKUStringAttributes *)attrs text:(NSString *)text titleAttributes:(MKUStringAttributes *)titleAttrs title:(NSString *)title;

- (NSAttributedString *)attributedTextWithAttributes:(MKUStringAttributes *)attrs titleAttributes:(MKUStringAttributes *)titleAttrs title:(NSString *)title delimiter:(NSString *)delimiter;
+ (NSAttributedString *)attributedTextWithAttributes:(MKUStringAttributes *)attrs text:(NSString *)text titleAttributes:(MKUStringAttributes *)titleAttrs title:(NSString *)title delimiter:(NSString *)delimiter;

- (MKUStringAttributes *)titleAttributes;
- (MKUStringAttributes *)detailAttributes;
- (MKUStringAttributes *)titleBoldAttributes;
- (MKUStringAttributes *)detailBoldAttributes;
- (MKUStringAttributes *)smallAttributes;
- (MKUStringAttributes *)smallBoldAttributes;

+ (NSString *)bullet;
+ (NSString *)spaceBullet;
+ (NSString *)bulletSpace;
+ (NSString *)tabBullet;
+ (NSString *)tab;
- (NSString *)tabNewLines;

+ (NSAttributedString *)attributedTextWithAttributes:(NSArray <MKUStringAttributes *> *)attrs attributedDelimiter:(NSAttributedString *)delimiter;
+ (NSAttributedString *)attributedTextWithAttributedStrings:(NSArray<NSAttributedString *> *)attrs attributedDelimiter:(NSAttributedString *)delimiter;

@end

