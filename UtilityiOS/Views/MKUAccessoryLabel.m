//
//  MKUHeaderLabel.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUAccessoryLabel.h"
#import "UIView+Utility.h"
#import "NSString+AttributedText.h"

@implementation MKUAccessoryLabel

- (instancetype)init {
    return [self initWithText:@""];
}

- (instancetype)initWithText:(NSString *)text {
    if (self = [super initWithText:text]) {
        CGFloat padding = [Constants TextPadding];
        self.insets = UIEdgeInsetsMake(padding, padding, padding, padding);
    }
    return self;
}

+ (instancetype)headerWithTitle:(NSString *)title type:(MKU_ACCESSORY_VIEW_TYPE)type {
    
    MKUAccessoryLabel *header;
    if (0 < title.length) {
        header = [[self alloc] init];
        [header setTitle:title type:type];
    }
    return header;
}

+ (instancetype)headerWithAttributedTitle:(NSAttributedString *)attributedString {
    return [self headerWithAttributedTitle:attributedString backgroundColor:[AppTheme tableHeaderBackgroundColor]];
}

+ (instancetype)headerWithAttributedTitle:(NSAttributedString *)attributedString backgroundColor:(UIColor *)backgroundColor {
    
    MKUAccessoryLabel *header;
    if (0 < attributedString.string.length) {
        header = [[self alloc] init];
        header.attributedText = attributedString;
        header.backgroundColor = backgroundColor;
    }
    return header;
}

- (void)setTitle:(NSString *)title type:(MKU_ACCESSORY_VIEW_TYPE)type {
    
    UIFont *font = [AppTheme mediumBoldLabelFont];
    UIColor *textColor;
    UIColor *backgroundColor;
    
    switch (type) {
        case MKU_ACCESSORY_VIEW_TYPE_BOLD: {
            textColor = [UIColor whiteColor];
            backgroundColor = [UIColor redColor];
        }
            break;
            
        default: {
            textColor = [AppTheme textMediumColor];
            backgroundColor = [AppTheme tableHeaderBackgroundColor];
        }
            break;
    }
    
    MKUStringAttributes *attrs = [MKUStringAttributes attributesWithText:title font:font color:textColor];
    [self setAttributedTitle:[NSString attributedTextWithIndent:8.0 firstLineIndent:8.0 attributes:attrs] backgroundColor:backgroundColor];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedString backgroundColor:(UIColor *)backgroundColor {
    self.attributedText = attributedString;
    self.backgroundColor = backgroundColor;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width  += (self.insets.left + self.insets.right);
    size.height += (self.insets.top + self.insets.bottom);
    return size;
}

@end


@interface MKUPaddingLabel ()

@property (nonatomic, strong, readwrite) MKULabel *titleLabel;

@end

@implementation MKUPaddingLabel

- (instancetype)initWithInsets:(UIEdgeInsets)insets {
    if (self = [super init]) {
        [self initBaseWithInsets:insets];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets {
    if (self = [super initWithFrame:frame]) {
        [self initBaseWithInsets:insets];
    }
    return self;
}

- (void)initBaseWithInsets:(UIEdgeInsets)insets {
    
    self.titleLabel = [[MKULabel alloc] init];
    [self addSubview:self.titleLabel];
    [self removeConstraintsMask];
    [self constraintSidesForView:self.titleLabel insets:insets];
}

@end
