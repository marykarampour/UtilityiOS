//
//  NSString+AttributedText.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-01.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "NSString+AttributedText.h"
#import "NSString+Utility.h"

typedef NS_OPTIONS(NSUInteger, MKU_LABEL_ATTRIBUTES_TYPE) {
    MKU_LABEL_ATTRIBUTES_TYPE_NONE          = 0,
    MKU_LABEL_ATTRIBUTES_TYPE_PLACEHOLDER   = 1 << 0,
    MKU_LABEL_ATTRIBUTES_TYPE_VALUE         = 1 << 1,
    MKU_LABEL_ATTRIBUTES_TYPE_SUBVALUE      = 1 << 3,
    MKU_LABEL_ATTRIBUTES_TYPE_ATTR_VALUE    = 1 << 5,
    MKU_LABEL_ATTRIBUTES_TYPE_ATTR_SUBVALUE = 1 << 6
};

@implementation MKUStringAttributes

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    if (self = [super init]) {
        self.text = text;
        self.font = font;
        self.color = color;
    }
    return self;
}

+ (instancetype)attributesWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    return [[MKUStringAttributes alloc] initWithText:text font:font color:color];
}

- (instancetype)initWithFont:(UIFont *)font color:(UIColor *)color {
    return [self initWithText:nil font:font color:color];
}

+ (instancetype)attributesWithFont:(UIFont *)font color:(UIColor *)color {
    return [[MKUStringAttributes alloc] initWithText:nil font:font color:color];
}

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing {
    if (self = [super init]) {
        self.text = text;
        self.font = font;
        self.color = color;
        self.lineSpacing = lineSpacing;
    }
    return self;
}

+ (instancetype)attributesWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing {
    return [[MKUStringAttributes alloc] initWithText:text font:font color:color lineSpacing:lineSpacing];
}

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    if (self = [super init]) {
        self.text = text;
        self.font = font;
        self.color = color;
        self.alignment = alignment;
    }
    return self;
}

+ (instancetype)attributesWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    return [[MKUStringAttributes alloc] initWithText:text font:font color:color alignment:alignment];
}

- (BOOL)isValid {
    return 0 < self.text.length && self.font && self.color;
}

+ (instancetype)copy:(MKUStringAttributes *)attrs withText:(NSString *)text {
    return [[MKUStringAttributes alloc] initWithText:text font:attrs.font color:attrs.color alignment:attrs.alignment];
}

+ (instancetype)copy:(MKUStringAttributes *)attrs alignment:(NSTextAlignment)alignment {
    return [[MKUStringAttributes alloc] initWithText:attrs.text font:attrs.font color:attrs.color alignment:alignment];
}

+ (instancetype)blueBoldAttrsWithText:(NSString *)text {
    return [MKUStringAttributes attributesWithText:text font:[AppTheme mediumBoldLabelFont] color:[AppTheme brightBlueColorWithAlpha:1.0]];
}

+ (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle forLabel:(UILabel *)label {
    [self setTitle:title value:subtitle forLabel:label delimiter:@"\n"];
}

+ (void)setTitle:(NSString *)title value:(NSString *)value forLabel:(UILabel *)label delimiter:(NSString *)delimiter {
    if (title.length == 0) {
        label.attributedText = nil;
        label.text = value;
        label.textAlignment = NSTextAlignmentLeft;
        return;
    }
    
    NSArray <MKUStringAttributes *> *attrs = @[[MKUStringAttributes attributesWithText:title font:[AppTheme mediumBoldLabelFont] color:[AppTheme brightBlueColorWithAlpha:1.0]],
                                               [MKUStringAttributes attributesWithText:value font:[AppTheme mediumLabelFont] color:[AppTheme textDarkColor]]];
    label.attributedText = [NSString attributedTextWithAttributes:attrs delimiter:delimiter];
    label.textAlignment = (0 == title.length || 0 == value.length) ? NSTextAlignmentCenter : NSTextAlignmentLeft;
}

@end


@interface MKULabelAttributes ()

@property (nonatomic, assign) NSUInteger type;

- (CGFloat)heightForWidth:(CGFloat)width text:(NSString *)text;
- (instancetype)initWithType:(NSUInteger)type;

@end

@interface MKULabelAttributes_1 : MKULabelAttributes

@end

@interface MKULabelAttributes_2 : MKULabelAttributes

@end

@interface MKULabelAttributes_21 : MKULabelAttributes_2

@end

@interface MKULabelAttributes_22 : MKULabelAttributes_2

@end

@interface MKULabelAttributes_3 : MKULabelAttributes

@end

@interface MKULabelAttributes_31 : MKULabelAttributes_3

@end

@interface MKULabelAttributes_32 : MKULabelAttributes_3

@end

@interface MKULabelAttributes_4 : MKULabelAttributes

@end

@interface MKULabelAttributes_5 : MKULabelAttributes

@end

@implementation MKULabelAttributes_1

- (CGFloat)heightForWidth:(CGFloat)width {
    return [self heightForWidth:width text:self.placeholder] + [Constants TableCellLineHeight];
}

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel {
    label.font = [AppTheme mediumBoldLabelFont];
    label.text = self.placeholder;
    sublabel.text = nil;
}

@end

@implementation MKULabelAttributes_2

- (instancetype)initWithType:(NSUInteger)type {
    if (type & MKU_LABEL_ATTRIBUTES_TYPE_SUBVALUE) {
        self = [[MKULabelAttributes_21 alloc] init];
    }
    else if (type & MKU_LABEL_ATTRIBUTES_TYPE_ATTR_SUBVALUE) {
        self = [[MKULabelAttributes_22 alloc] init];
    }
    else {
        self = [super initWithType:type];
    }
    return self;
}

- (CGFloat)heightForWidth:(CGFloat)width {
    return [self heightForWidth:width text:self.value] + [Constants TableCellLineHeight];
}

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel {
    label.text = self.value;
}

@end

@implementation MKULabelAttributes_21

- (instancetype)init {
    return [super init];
}

- (CGFloat)heightForWidth:(CGFloat)width {
    return [super heightForWidth:width] + [self heightForWidth:width text:self.subvalue] + [Constants TableCellLineHeight];
}

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel {
    [super setAttributedTitlesForLabel:label sublabel:sublabel];
    sublabel.text = self.subvalue;
}

@end

@implementation MKULabelAttributes_22

- (instancetype)init {
    return [super init];
}

- (CGFloat)heightForWidth:(CGFloat)width {
    return [super heightForWidth:width] + [self heightForWidth:width text:self.attrSubvalue.string] + [Constants TableCellLineHeight];
}

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel {
    [super setAttributedTitlesForLabel:label sublabel:sublabel];
    sublabel.attributedText = self.attrSubvalue;
}

@end

@implementation MKULabelAttributes_3

- (instancetype)initWithType:(NSUInteger)type {
    if (type & MKU_LABEL_ATTRIBUTES_TYPE_SUBVALUE) {
        self = [[MKULabelAttributes_31 alloc] init];
    }
    else if (type & MKU_LABEL_ATTRIBUTES_TYPE_ATTR_SUBVALUE) {
        self = [[MKULabelAttributes_32 alloc] init];
    }
    else {
        self = [super initWithType:type];
    }
    return self;
}

- (CGFloat)heightForWidth:(CGFloat)width {
    return [self heightForWidth:width text:self.attrValue.string] + [Constants TableCellLineHeight];
}

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel {
    label.attributedText = self.attrValue;
}

@end

@implementation MKULabelAttributes_31

- (instancetype)init {
    return [super init];
}

- (CGFloat)heightForWidth:(CGFloat)width {
    return [super heightForWidth:width] + [self heightForWidth:width text:self.subvalue] + [Constants TableCellLineHeight];
}

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel {
    [super setAttributedTitlesForLabel:label sublabel:sublabel];
    sublabel.text = self.subvalue;
}

@end

@implementation MKULabelAttributes_32

- (instancetype)init {
    return [super init];
}

- (CGFloat)heightForWidth:(CGFloat)width {
    return [super heightForWidth:width] + [self heightForWidth:width text:self.attrSubvalue.string] + [Constants TableCellLineHeight];
}

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel {
    [super setAttributedTitlesForLabel:label sublabel:sublabel];
    sublabel.attributedText = self.attrSubvalue;
}

@end

@implementation MKULabelAttributes_4

- (instancetype)init {
    return [super init];
}

- (CGFloat)heightForWidth:(CGFloat)width {
    return [self heightForWidth:width text:self.title] + [self heightForWidth:width text:self.subvalue] + [Constants TableCellLineHeight];
}

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel {
    label.text = self.title;
    sublabel.text = self.subvalue;
}

@end
@implementation MKULabelAttributes_5

- (instancetype)init {
    return [super init];
}

- (CGFloat)heightForWidth:(CGFloat)width {
    return [self heightForWidth:width text:self.title] + [self heightForWidth:width text:self.attrSubvalue.string] + [Constants TableCellLineHeight];
}

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel {
    label.text = self.title;
    sublabel.attributedText = self.attrSubvalue;
}

@end

@implementation MKULabelAttributes

- (instancetype)initWithType:(NSUInteger)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle value:(NSString *)value subvalue:(NSString *)subvalue placeholder:(NSString *)placeholder attrValue:(NSAttributedString *)attrValue attrSubvalue:(NSAttributedString *)attrSubvalue {
    return [self initWithTitle:title subtitle:subtitle value:value subvalue:subvalue placeholder:placeholder attrValue:attrValue attrSubvalue:attrSubvalue labelDelimiter:kColonEmptyString sublabelDelimiter:kColonEmptyString];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle value:(NSString *)value subvalue:(NSString *)subvalue placeholder:(NSString *)placeholder attrValue:(NSAttributedString *)attrValue attrSubvalue:(NSAttributedString *)attrSubvalue labelDelimiter:(NSString *)labelDelimiter sublabelDelimiter:(NSString *)sublabelDelimiter {
    
    MKU_LABEL_ATTRIBUTES_TYPE type = MKU_LABEL_ATTRIBUTES_TYPE_NONE;
    
    if (0 < placeholder.length && value.length == 0 && subvalue.length == 0) {
        type = MKU_LABEL_ATTRIBUTES_TYPE_PLACEHOLDER;
    }
    else {
        if (0 < value.length) {
            if (0 < title.length) {
                type = MKU_LABEL_ATTRIBUTES_TYPE_ATTR_VALUE;
            }
            else {
                type = MKU_LABEL_ATTRIBUTES_TYPE_VALUE;
            }
        }
        else if (attrValue) {
            type = MKU_LABEL_ATTRIBUTES_TYPE_ATTR_VALUE;
        }
        else {
            type = MKU_LABEL_ATTRIBUTES_TYPE_NONE;
        }
        
        if (0 < subvalue.length) {
            if (0 < subtitle.length) {
                type = type | MKU_LABEL_ATTRIBUTES_TYPE_ATTR_SUBVALUE;
            }
            else {
                type = type | MKU_LABEL_ATTRIBUTES_TYPE_SUBVALUE;
            }
        }
        else if (attrSubvalue) {
            type = type | MKU_LABEL_ATTRIBUTES_TYPE_ATTR_SUBVALUE;
        }
        else {
            type = type | MKU_LABEL_ATTRIBUTES_TYPE_NONE;
        }
    }
    
    if (type & MKU_LABEL_ATTRIBUTES_TYPE_PLACEHOLDER) {
        self = [[MKULabelAttributes_1 alloc] init];
    }
    else if (type & MKU_LABEL_ATTRIBUTES_TYPE_VALUE) {
        self = [[MKULabelAttributes_2 alloc] initWithType:type];
    }
    else if (type & MKU_LABEL_ATTRIBUTES_TYPE_ATTR_VALUE) {
        self = [[MKULabelAttributes_3 alloc] initWithType:type];
    }
    else if (type & MKU_LABEL_ATTRIBUTES_TYPE_SUBVALUE) {
        self = [[MKULabelAttributes_4 alloc] init];
    }
    else if (type & MKU_LABEL_ATTRIBUTES_TYPE_ATTR_SUBVALUE) {
        self = [[MKULabelAttributes_5 alloc] init];
    }
    else {
        self = [super init];
    }
    
    self.type = type;
    
    [self setTitle:title subtitle:subtitle value:value subvalue:subvalue placeholder:placeholder attrValue:attrValue attrSubvalue:attrSubvalue labelDelimiter:labelDelimiter sublabelDelimiter:sublabelDelimiter];
    
    return self;
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle value:(NSString *)value subvalue:(NSString *)subvalue placeholder:(NSString *)placeholder attrValue:(NSAttributedString *)attrValue attrSubvalue:(NSAttributedString *)attrSubvalue labelDelimiter:(NSString *)labelDelimiter sublabelDelimiter:(NSString *)sublabelDelimiter {
    
    self.title = title;
    self.subtitle = subtitle;
    self.value = value;
    self.subvalue = subvalue;
    self.placeholder = placeholder;
    self.attrValue = attrValue;
    self.attrSubvalue = attrSubvalue;
    self.labelDelimiter = labelDelimiter;
    self.sublabelDelimiter = sublabelDelimiter;
    
    if (!self.attrValue && (self.type & MKU_LABEL_ATTRIBUTES_TYPE_ATTR_VALUE)) {
        NSArray<MKUStringAttributes *> *attrs = @[
            [MKUStringAttributes attributesWithText:self.title font:[AppTheme mediumBoldLabelFont] color:[UIColor blackColor]],
            [MKUStringAttributes attributesWithText:self.value font:[AppTheme mediumLabelFont] color:[UIColor darkGrayColor]]];
        
        self.attrValue = [NSString attributedTextWithAttributes:attrs delimiter:self.labelDelimiter];
    }
    if (!self.attrSubvalue && (self.type & MKU_LABEL_ATTRIBUTES_TYPE_ATTR_SUBVALUE)) {
        NSArray<MKUStringAttributes *> *subattrs = @[
            [MKUStringAttributes attributesWithText:self.subtitle font:[AppTheme smallBoldLabelFont] color:[AppTheme textDarkColor]],
            [MKUStringAttributes attributesWithText:self.subvalue font:[AppTheme mediumLabelFont] color:[AppTheme brightBlueColorWithAlpha:1.0]]];
        
        self.attrSubvalue = [NSString attributedTextWithAttributes:subattrs delimiter:self.sublabelDelimiter];
    }
}

+ (MKULabelAttributes *)attributesWithTitle:(NSString *)title subtitle:(NSString *)subtitle value:(NSString *)value subvalue:(NSString *)subvalue placeholder:(NSString *)placeholder attrValue:(NSAttributedString *)attrValue attrSubvalue:(NSAttributedString *)attrSubvalue {
    return [[MKULabelAttributes alloc] initWithTitle:title subtitle:subtitle value:value subvalue:subvalue placeholder:placeholder attrValue:attrValue attrSubvalue:attrSubvalue labelDelimiter:kColonEmptyString sublabelDelimiter:kColonEmptyString];
}

+ (MKULabelAttributes *)attributesWithTitle:(NSString *)title subtitle:(NSString *)subtitle value:(NSString *)value subvalue:(NSString *)subvalue placeholder:(NSString *)placeholder attrValue:(NSAttributedString *)attrValue attrSubvalue:(NSAttributedString *)attrSubvalue labelDelimiter:(NSString *)labelDelimiter sublabelDelimiter:(NSString *)sublabelDelimiter {
    return [[MKULabelAttributes alloc] initWithTitle:title subtitle:subtitle value:value subvalue:subvalue placeholder:placeholder attrValue:attrValue attrSubvalue:attrSubvalue labelDelimiter:labelDelimiter sublabelDelimiter:sublabelDelimiter];
}

- (void)setAttributedTitlesForLabel:(UILabel *)label sublabel:(UILabel *)sublabel {
    label.text = nil;
    label.attributedText = nil;
    sublabel.text = nil;
    sublabel.attributedText = nil;
}

+ (void)setAttributedTitles:(MKULabelAttributes *)obj label:(UILabel *)label sublabel:(UILabel *)sublabel {
    [self setAttributedTitles:obj label:label sublabel:sublabel];
}

- (CGFloat)heightForWidth:(CGFloat)width {
    return 0.0;
}

- (CGFloat)heightForWidth:(CGFloat)width text:(NSString *)text {
    return [text rectForWidth:width font:nil].size.height;
}

@end

@implementation NSString (AttributedText)

- (NSAttributedString *)attributedTextWithColor:(UIColor *)color {
    return [self attributedTextWithColor:color font:nil];
}

- (NSAttributedString *)attributedTextWithColor:(UIColor *)color font:(UIFont *)font {
    return [NSString attributedTextWithAttribute:[MKUStringAttributes attributesWithText:self font:font color:color]];
}

+ (NSAttributedString *)attributedTitle:(NSString *)title number:(NSNumber *)number style:(MKU_THEME_STYLE)style {
    
    if (!number) number = @0;
    
    UIColor *titleColor = style == MKU_THEME_STYLE_DARK ? [AppTheme mistBlueColorWithAlpha:1.0] : [AppTheme textDarkColor];
    UIColor *subtitleColor = style == MKU_THEME_STYLE_DARK ? [AppTheme textMediumColor] : [AppTheme textMediumColor];
    
    NSArray <MKUStringAttributes *> *attrs =
    @[[MKUStringAttributes attributesWithText:title font:[AppTheme smallBoldLabelFont] color:titleColor alignment:NSTextAlignmentCenter],
      [MKUStringAttributes attributesWithText:[number stringValue] font:[AppTheme mediumBoldLabelFont] color:subtitleColor alignment:NSTextAlignmentCenter]];
    return [NSString attributedTextWithAttributes:attrs delimiter:@"\n"];
}

+ (NSAttributedString *)multiLineTextWithAttributes:(NSArray<MKUStringAttributes *> *)attrs {
    
    NSAttributedString *lineBreak = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@""];
    
    for (MKUStringAttributes *attr in attrs) {
        if (attr.text) {
            NSAttributedString *nextStr = [[NSMutableAttributedString alloc] initWithString:attr.text attributes:@{NSFontAttributeName:attr.font, NSForegroundColorAttributeName:attr.color}];
            [attrStr appendAttributedString:nextStr];
            if (![[attrs lastObject] isEqual:attr]) {
                [attrStr appendAttributedString:lineBreak];
            }
        }
    }
    return attrStr;
}

+ (NSAttributedString *)dashedTextWithAttributes:(NSArray<MKUStringAttributes *> *)attrs {
    
    NSAttributedString *dash = [[NSMutableAttributedString alloc] initWithString:@" - " attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@""];
    
    for (MKUStringAttributes *attr in attrs) {
        if (attr.text) {
            NSAttributedString *nextStr = [[NSMutableAttributedString alloc] initWithString:attr.text attributes:@{NSFontAttributeName:attr.font, NSForegroundColorAttributeName:attr.color}];
            [attrStr appendAttributedString:nextStr];
            if (![[attrs lastObject] isEqual:attr]) {
                [attrStr appendAttributedString:dash];
            }
        }
    }
    return attrStr;
}

+ (NSAttributedString *)attributedTextWithIndent:(CGFloat)indent firstLineIndent:(CGFloat)firstLineIndent attributes:(MKUStringAttributes *)attrs {
    if (attrs.text.length == 0) return nil;
    
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

+ (NSArray<NSAttributedString *> *)attributedStringsFromAttributes:(NSArray<MKUStringAttributes *> *)attrs {
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    for (MKUStringAttributes *attr in attrs) {
        NSAttributedString *nextStr = [[NSMutableAttributedString alloc] initWithString:attr.text attributes:@{NSFontAttributeName:attr.font, NSForegroundColorAttributeName:attr.color}];
        [strings addObject:nextStr];
    }
    return strings;
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

+ (NSAttributedString *)bulletedTextWithAttributedStrings:(NSArray<NSAttributedString *> *)attrs bullet:(NSString *)symbol {
    NSMutableAttributedString *fullStr = [[NSMutableAttributedString alloc] init];
    for (NSAttributedString *attr in attrs) {
        NSString *symbolSTR = symbol ? symbol : [NSString stringWithFormat:@"%ld.", [attrs indexOfObject:attr]+1];
        NSString *bullet = [NSString stringWithFormat:@"%@\t", symbolSTR];
        NSMutableAttributedString *multi = [[NSMutableAttributedString alloc] initWithString:bullet];
        [multi appendAttributedString:attr];
        [multi appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        CGFloat tab = 24.0;
        style.paragraphSpacing = 4;
        style.paragraphSpacingBefore = 4;
        style.firstLineHeadIndent = 0.0;
        style.headIndent = 24.0;
        style.defaultTabInterval = tab;
        style.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:tab options:@{}]];
        
        NSRange range = NSMakeRange(0, attr.length);
        [multi addAttribute:NSParagraphStyleAttributeName value:style range:range];
        
        [fullStr appendAttributedString:multi];
    }
    return fullStr;
}

+ (NSAttributedString *)bulletedTextWithAttributes:(NSArray<MKUStringAttributes *> *)attrs bullet:(NSString *)symbol {
    return [self bulletedTextWithAttributedStrings:[self attributedStringsFromAttributes:attrs] bullet:symbol];
}

+ (NSAttributedString *)attributedTextWithAttributes:(NSArray<MKUStringAttributes *> *)attrs attributedDelimiter:(NSAttributedString *)delimiter {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@""];
    
    [[self validatedAttrs:attrs] enumerateObjectsUsingBlock:^(MKUStringAttributes * _Nonnull attr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (0 < attr.text.length) {
            
            NSMutableAttributedString *nextStr = [[NSMutableAttributedString alloc] initWithString:attr.text];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByWordWrapping;
            
            if (attr.font)
                [nextStr addAttribute:NSFontAttributeName value:attr.font range:NSMakeRange(0, nextStr.length)];
            if (attr.color)
                [nextStr addAttribute:NSForegroundColorAttributeName value:attr.color range:NSMakeRange(0, nextStr.length)];
            if (0.0 < attr.lineSpacing)
                style.lineSpacing = attr.lineSpacing;
            if (0 < attr.alignment)
                style.alignment = attr.alignment;
            
            [nextStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, nextStr.length)];
            [attrStr appendAttributedString:nextStr];
            
            BOOL isLast = idx+1 == attrs.count;
            if (!isLast && delimiter) {
                MKUStringAttributes *nextAttr = attrs[idx+1];
                NSMutableAttributedString *delimiterAttr = [[NSMutableAttributedString alloc] initWithAttributedString:delimiter];
                
                if (0 < nextAttr.text.length) {
                    if (attr.font)
                        [delimiterAttr addAttribute:NSFontAttributeName value:attr.font range:NSMakeRange(0, delimiter.length)];
                    if (attr.color)
                        [delimiterAttr addAttribute:NSForegroundColorAttributeName value:attr.color range:NSMakeRange(0, delimiter.length)];
                    [attrStr appendAttributedString:delimiterAttr];
                }
            }
        }
    }];
    
    return attrStr;
}

+ (NSArray<MKUStringAttributes *> *)validatedAttrs:(NSArray<MKUStringAttributes *> *)attrs {
    
    NSMutableArray<MKUStringAttributes *> *arr = [[NSMutableArray alloc] init];
    for (MKUStringAttributes *obj in attrs) {
        if (obj) {
            [arr addObject:obj];
        }
    }
    return arr;
}

+ (NSAttributedString *)attributedTextWithImage:(UIImage *)image {
    if (!image) return nil;
    
    NSTextAttachment *attachment = [NSTextAttachment textAttachmentWithImage:image];
    NSMutableAttributedString *attr = [[NSMutableAttributedString attributedStringWithAttachment:attachment] mutableCopy];
    return attr;
}

+ (NSAttributedString *)attributedTextWithAttribute:(MKUStringAttributes *)attr {
    if (!attr) return nil;
    return [NSString attributedTextWithAttributes:@[attr]];
}

+ (NSAttributedString *)attributedTextWithAttributes:(NSArray<MKUStringAttributes *> *)attrs delimiter:(NSString *)delimiter {
    NSMutableAttributedString *attrDelimiter = [[NSMutableAttributedString alloc] initWithString:[NSString nonNullOrSpaceString:delimiter]];
    return [self attributedTextWithAttributes:attrs attributedDelimiter:attrDelimiter];
}

+ (NSAttributedString *)attributedTextWithAttributes:(NSArray<MKUStringAttributes *> *)attrs {
    return [self attributedTextWithAttributes:attrs attributedDelimiter:nil];
}

+ (NSAttributedString *)attributedTextWithAttributedStrings:(NSArray<NSAttributedString *> *)attrs delimiter:(NSString *)delimiter {
    return [self attributedTextWithAttributedStrings:attrs delimiter:delimiter alignment:NSTextAlignmentLeft];
}

+ (NSAttributedString *)attributedTextWithAttributedStrings:(NSArray<NSAttributedString *> *)attrs delimiter:(NSString *)delimiter alignment:(NSTextAlignment)alignment {
    
    NSMutableAttributedString *strings = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *attrDelimiter = 0 < delimiter.length ? [[NSMutableAttributedString alloc] initWithString:delimiter] : nil;
    
    [attrs enumerateObjectsUsingBlock:^(NSAttributedString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [strings appendAttributedString:obj];
        
        BOOL isLast = idx+1 == attrs.count;
        if (!isLast && attrDelimiter) {
            
            NSAttributedString *nextAttr = attrs[idx+1];
            if (0 < nextAttr.length) {
                [strings appendAttributedString:attrDelimiter];
            }
        }
    }];
    
    if (0 < alignment) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = alignment;
        [strings addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, strings.length)];
    }
    
    return strings;
}

- (NSAttributedString *)attributedTextWithAttributes:(MKUStringAttributes *)attrs titleAttributes:(MKUStringAttributes *)titleAttrs title:(NSString *)title delimiter:(NSString *)delimiter {
    return self.length ? [NSString attributedTextWithDelimiter:delimiter attributes:[MKUStringAttributes copy:titleAttrs withText:title], [MKUStringAttributes copy:attrs withText:self], nil] : nil;
}

+ (NSAttributedString *)attributedTextWithAttributes:(MKUStringAttributes *)attrs text:(NSString *)text titleAttributes:(MKUStringAttributes *)titleAttrs title:(NSString *)title delimiter:(NSString *)delimiter {
    return [text attributedTextWithAttributes:attrs titleAttributes:titleAttrs title:title delimiter:delimiter];
}

- (NSAttributedString *)attributedTextWithAttributes:(MKUStringAttributes *)attrs titleAttributes:(MKUStringAttributes *)titleAttrs title:(NSString *)title {
    return [self attributedTextWithAttributes:attrs titleAttributes:titleAttrs title:title delimiter:nil];
}

+ (NSAttributedString *)attributedTextWithAttributes:(MKUStringAttributes *)attrs text:(NSString *)text titleAttributes:(MKUStringAttributes *)titleAttrs title:(NSString *)title {
    return [text attributedTextWithAttributes:attrs titleAttributes:titleAttrs title:title delimiter:nil];
}

+ (NSAttributedString *)attributedTextWithStringAttributes:(MKUStringAttributes *)attrs, ... {
    
    NSMutableArray<MKUStringAttributes *> *arr = [[NSMutableArray alloc] init];
    [arr addObject:attrs];
    
    va_list args;
    va_start(args, attrs);
    id arg = nil;
    
    while ((arg = va_arg(args, id))) {
        [arr addObject:arg];
    }
    va_end(args);
    
    return [self attributedTextWithAttributes:arr attributedDelimiter:nil];
}

+ (NSAttributedString *)attributedTextWithDelimiter:(NSString *)delimiter attributes:(MKUStringAttributes *)attrs, ... {
    
    NSMutableAttributedString *attrDelimiter = delimiter.length ? [[NSMutableAttributedString alloc] initWithString:delimiter] : nil;
    
    NSMutableArray<MKUStringAttributes *> *arr = [[NSMutableArray alloc] init];
    [arr addObject:attrs];
    
    va_list args;
    va_start(args, attrs);
    id arg = nil;
    
    while ((arg = va_arg(args, id))) {
        [arr addObject:arg];
    }
    va_end(args);
    
    return [self attributedTextWithAttributes:arr attributedDelimiter:attrDelimiter];
}

+ (NSAttributedString *)attributedTextWithDelimiter:(NSString *)delimiter attributedTexts:(NSAttributedString *)attrs, ... {
    
    NSMutableAttributedString *strings = [[NSMutableAttributedString alloc] init];
    
    va_list args;
    va_start(args, attrs);
    id arg = nil;
    
    while ((arg = va_arg(args, id))) {
        [strings appendAttributedString:arg];
    }
    va_end(args);
    
    NSMutableAttributedString *attrDelimiter = delimiter.length ? [[NSMutableAttributedString alloc] initWithString:delimiter] : nil;
    if (attrDelimiter) {
        [strings appendAttributedString:attrDelimiter];
    }
    return strings;
}

#pragma mark - text attributes

- (MKUStringAttributes *)titleAttributes {
    return [MKUStringAttributes attributesWithText:self font:[AppTheme mediumLabelFont] color:[AppTheme textDarkColor]];
}

- (MKUStringAttributes *)detailAttributes {
    return [MKUStringAttributes attributesWithText:self font:[AppTheme mediumLabelFont] color:[AppTheme textMediumColor]];
}

- (MKUStringAttributes *)titleBoldAttributes {
    return [MKUStringAttributes attributesWithText:self font:[AppTheme mediumBoldLabelFont] color:[AppTheme textDarkColor]];
}

- (MKUStringAttributes *)detailBoldAttributes {
    return [MKUStringAttributes attributesWithText:self font:[AppTheme mediumBoldLabelFont] color:[AppTheme textMediumColor]];
}

- (MKUStringAttributes *)smallAttributes {
    return [MKUStringAttributes attributesWithText:self font:[AppTheme smallLabelFont] color:[AppTheme textDarkColor]];
}

- (MKUStringAttributes *)smallBoldAttributes {
    return [MKUStringAttributes attributesWithText:self font:[AppTheme smallBoldLabelFont] color:[AppTheme textDarkColor]];
}


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

#pragma mark - helpers

+ (NSString *)bullet {
    return  @"\u2022";
}

+ (NSString *)spaceBullet {
    return  @" \u2022";
}

+ (NSString *)bulletSpace {
    return  @"\u2022 ";
}

+ (NSString *)tabBullet {
    return  @"\t \u2022";
}

+ (NSString *)tab {
    return  @"\t";
}

- (NSString *)tabNewLines {
    return [self stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
}

@end


