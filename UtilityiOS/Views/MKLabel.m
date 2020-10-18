//
//  MKLabel.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKLabel.h"
#import "UIView+Utility.h"

@implementation MKLabel

- (instancetype)init {
    if (self = [super init]) {
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        [self sizeToFit];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += [Constants TextPadding]*2;
    size.height += [Constants TextPadding]*2;
    return size;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake([Constants TextPadding], [Constants TextPadding], [Constants TextPadding], [Constants TextPadding]);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end

@interface MKEmbededLabel ()

@property (nonatomic, strong, readwrite) MKLabel *label;
@property (nonatomic, strong) NSLayoutConstraint *top;
@property (nonatomic, strong) NSLayoutConstraint *left;
@property (nonatomic, strong) NSLayoutConstraint *right;
@property (nonatomic, strong) NSLayoutConstraint *bottom;

@end

@implementation MKLabelMetaData

+ (MKLabelMetaData *)dataWithInsets:(UIEdgeInsets)insets font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor {

    MKLabelMetaData *data = [[MKLabelMetaData alloc] init];
    data.insets = insets;
    data.font = font;
    data.textColor = textColor;
    data.backgroundColor = backgroundColor;
    return data;
}

@end

@implementation MKEmbededLabel

- (instancetype)init {
    if (self = [super init]) {
        
        self.label = [[MKLabel alloc] init];
        self.label.numberOfLines = 0;
        self.label.lineBreakMode = NSLineBreakByWordWrapping;
        [self.label sizeToFit];
        [self addSubview:self.label];
        
        [self removeConstraintsMask];
        
        self.top = [self layoutConstraint:NSLayoutAttributeTop view:self.label margin:0.0];
        self.left = [self layoutConstraint:NSLayoutAttributeLeft view:self.label margin:0.0];
        self.right = [self layoutConstraint:NSLayoutAttributeRight view:self.label margin:0.0];
        self.bottom = [self layoutConstraint:NSLayoutAttributeBottom view:self.label margin:0.0];
        
        [self addConstraint:self.top];
        [self addConstraint:self.left];
        [self addConstraint:self.right];
        [self addConstraint:self.bottom];
    }
    return self;
}

- (void)setMetaData:(MKLabelMetaData *)metaData {
    _metaData = metaData;
    [self setFont:metaData.font];
    [self setInsets:metaData.insets];
    [self setTextColor:metaData.textColor];
    if (metaData.backgroundColor)
    [self setBackgroundColor:metaData.backgroundColor];
}

- (void)setFont:(UIFont *)font {
    if (!font) return;
    self.label.font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    if (!textColor) return;
    self.label.textColor = textColor;
}

- (void)setInsets:(UIEdgeInsets)insets {
    self.top.constant = insets.top;
    self.left.constant = insets.left;
    self.right.constant = insets.right;
    self.bottom.constant = insets.bottom;
    [self layoutIfNeeded];
}

@end
