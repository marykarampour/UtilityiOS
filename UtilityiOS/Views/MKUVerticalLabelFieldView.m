//
//  MKUVerticalLabelFieldView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUVerticalLabelFieldView.h"
#import "UIButton+MKUTheme.h"
#import "UIView+Utility.h"

@interface MKUVerticalLabelFieldView ()

@property (nonatomic, strong, readwrite) MKULabel *titleLabel;
@property (nonatomic, strong, readwrite) MKUTextField *textField;

@end

@implementation MKUVerticalLabelFieldView

- (instancetype)init {
    return [self initWithFieldHeight:[Constants DefaultRowHeight]];
}

- (instancetype)initWithFieldHeight:(CGFloat)fieldHeight {
    return [self initWithTitle:@"" placeholder:@"" fieldHeight:fieldHeight];
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder fieldHeight:(CGFloat)fieldHeight {
    if (self = [super init]) {
        self.textField = [[MKUTextField alloc] initWithPlaceholder:placeholder];
        [self initBaseWithTitle:title];
        [self constraintBaseWithHorizontalMargin:0.0 verticalMargin:0.0 fieldHeight:fieldHeight];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title padding:(CGFloat)padding fieldHeight:(CGFloat)fieldHeight {
    return [self initWithTitle:title horizontalMargin:padding verticalMargin:padding fieldHeight:fieldHeight];
}

- (instancetype)initWithTitle:(NSString *)title horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin fieldHeight:(CGFloat)fieldHeight {
    if (self = [super init]) {
        self.textField = [[MKUTextField alloc] init];
        [self initBaseWithTitle:title];
        [self constraintBaseWithHorizontalMargin:horizontalMargin verticalMargin:verticalMargin fieldHeight:fieldHeight];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin fieldWidth:(CGFloat)fieldWidth {
    if (self = [super init]) {
        self.textField = [[MKUTextField alloc] init];
        [self initBaseWithTitle:title];
        
        [self removeConstraintsMask];
        [self constraintHeight:[UIButton defaultHeight] forView:self.textField];
        
        if (0 < fieldWidth) {
            [self constraintWidth:fieldWidth forView:self.textField];
            [self constraint:NSLayoutAttributeCenterX view:self.textField];
        }
        else {
            [self constraint:NSLayoutAttributeLeft view:self.textField margin:horizontalMargin];
            [self constraint:NSLayoutAttributeRight view:self.textField margin:-horizontalMargin];
        }
        
        [self constraint:NSLayoutAttributeBottom view:self.textField margin:-verticalMargin];
        [self constraint:NSLayoutAttributeLeft view:self.titleLabel margin:horizontalMargin];
        [self constraint:NSLayoutAttributeRight view:self.titleLabel margin:-horizontalMargin];
        [self constraint:NSLayoutAttributeTop view:self.titleLabel margin:verticalMargin];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title horizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin {
    return [self initWithTitle:title horizontalMargin:horizontalMargin verticalMargin:verticalMargin fieldHeight:[UIButton defaultHeight]];
}

- (void)initBaseWithTitle:(NSString *)title {
    
    self.titleLabel = [[MKULabel alloc] init];
    self.titleLabel.font = [AppTheme smallBoldLabelFont];
    self.titleLabel.textColor = [AppTheme textDarkColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 0.5;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = title;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
}

- (void)constraintBaseWithHorizontalMargin:(CGFloat)horizontalMargin verticalMargin:(CGFloat)verticalMargin fieldHeight:(CGFloat)fieldHeight {
    
    [self removeConstraintsMask];
    [self constraintHeight:fieldHeight forView:self.textField];
    
    [self constraint:NSLayoutAttributeLeft view:self.textField margin:horizontalMargin];
    [self constraint:NSLayoutAttributeRight view:self.textField margin:-horizontalMargin];
    [self constraint:NSLayoutAttributeBottom view:self.textField margin:-verticalMargin];
    
    [self constraint:NSLayoutAttributeLeft view:self.titleLabel margin:horizontalMargin];
    [self constraint:NSLayoutAttributeRight view:self.titleLabel margin:-horizontalMargin];
    [self constraint:NSLayoutAttributeTop view:self.titleLabel margin:verticalMargin];
}

@end

