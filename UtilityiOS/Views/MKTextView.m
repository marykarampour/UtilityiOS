//
//  MKTextView.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKTextView.h"
#import "TextViewController.h"
#import "UIView+Utility.h"

@interface MKTextView ()

@property (nonatomic, strong) MKLabel *charView;
@property (nonatomic, strong) MKLabel *placeHolder;
@property (nonatomic, assign, readwrite) BOOL hasCharCount;
@property (nonatomic, strong, readwrite) MKText *textObject;

@end

@implementation MKTextView

- (instancetype)init {
    return [self initWithPlaceholder:@"" hasCharCount:NO];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder hasCharCount:(BOOL)hasCharCount {
    
    if (self = [super init]) {
        self.hasCharCount = hasCharCount;
        self.textObject = [[MKText alloc] init];
        
        self.placeHolder = [[MKLabel alloc] init];
        self.placeHolder.text = placeholder;
        self.placeHolder.font = [AppTheme textViewFont];
        self.placeHolder.backgroundColor = [UIColor clearColor];
        self.placeHolder.textColor = [AppTheme textViewPlaceholderColor];
        [self.placeHolder sizeToFit];
        
        self.charView = [[MKLabel alloc] init];
        self.charView.font = [AppTheme textViewFont];
        self.charView.backgroundColor = [UIColor clearColor];
        self.charView.textColor = [AppTheme textViewCharTextColor];
        [self.charView sizeToFit];
        
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        self.layer.cornerRadius = [Constants ButtonCornerRadious];
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [AppTheme textViewBorderColor].CGColor;
        self.layer.borderWidth = [Constants BorderWidth];
        
        self.font = [AppTheme textViewFont];
        self.textColor = [AppTheme textViewTextColor];
        self.backgroundColor = [AppTheme textViewBackgroundColor];
        
        [self addSubview:self.placeHolder];
        [self addSubview:self.charView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_placeHolder, _charView);
        [self removeConstraintsMask];
        
        [self addConstraintsWithFormat:[NSString stringWithFormat:@"H:|-(%f)-[_placeHolder]", [Constants HorizontalSpacing]] options:0 metrics:nil views:views];
        [self addConstraintsWithFormat:[NSString stringWithFormat:@"V:|-(%f)-[_placeHolder]", [Constants VerticalSpacing]] options:0 metrics:nil views:views];
        
        [self addConstraintWithItem:self.charView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
        [self addConstraintWithItem:self.charView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self showHidePlaceholder];
}

- (void)setCharText:(NSString *)text {
    self.charView.text = text;
}

- (void)showHidePlaceholder {
    [self.placeHolder setHidden:[self hasText]];
}

- (void)setPlaceholderText:(NSString *)text {
    self.placeHolder.text = text;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 12, 4);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 12, 4);
}

@end
