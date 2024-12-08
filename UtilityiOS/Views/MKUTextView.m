//
//  MKUTextView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUTextView.h"
#import "TextViewController.h"
#import "UIView+Utility.h"

@interface MKUTextView ()

@property (nonatomic, strong) MKULabel *charView;
@property (nonatomic, strong) MKULabel *placeHolder;
@property (nonatomic, assign, readwrite) BOOL hasCharCount;
@property (nonatomic, strong, readwrite) MKUText *textObject;

@end

@implementation MKUTextView

- (instancetype)init {
    return [self initWithPlaceholder:@"" hasCharCount:NO];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder {
    return [self initWithPlaceholder:placeholder hasCharCount:NO];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder hasCharCount:(BOOL)hasCharCount {
    if (self = [super init]) {
        self.hasCharCount = hasCharCount;
        self.textObject = [[MKUText alloc] init];
        
        self.placeHolder = [[MKULabel alloc] init];
        self.placeHolder.text = placeholder;
        self.placeHolder.font = [AppTheme textViewFont];
        self.placeHolder.backgroundColor = [UIColor clearColor];
        self.placeHolder.textColor = [AppTheme textViewPlaceholderColor];
        [self.placeHolder sizeToFit];
        
        self.charView = [[MKULabel alloc] init];
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
    [self setCharText:[NSString stringWithFormat:@"%lu", text.length]];
    [self showHidePlaceholder];
}

- (void)setCharText:(NSString *)text {
    self.charView.text = text;
}

- (void)setControllerDelegate:(id)object {
    self.controller.delegate = object;
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
