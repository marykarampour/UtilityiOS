//
//  MKUTextField.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUTextField.h"

@interface MKUTextField ()

@property (nonatomic, strong, readwrite) TextFieldController *controller;

@end

@implementation MKUTextField

- (instancetype)init {
    return [self initWithPlaceholder:@""];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder {
    return [self initWithPlaceholder:placeholder type:MKU_TEXT_FIELD_TYPE_BORDER | MKU_TEXT_FIELD_TYPE_CORNER textType:MKU_TEXT_TYPE_STRING];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder textType:(MKU_TEXT_TYPE)textType {
    return [self initWithPlaceholder:placeholder type:MKU_TEXT_FIELD_TYPE_BORDER | MKU_TEXT_FIELD_TYPE_CORNER textType:textType];
}

- (instancetype)initWithTextType:(MKU_TEXT_TYPE)type {
    return [self initWithPlaceholder:@"" type:MKU_TEXT_FIELD_TYPE_BORDER | MKU_TEXT_FIELD_TYPE_CORNER textType:type];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder type:(MKU_TEXT_FIELD_TYPE)type textType:(MKU_TEXT_TYPE)textType {
    if (self = [super init]) {
        
        if (MKU_TEXT_FIELD_TYPE_PLAIN & type) {
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        else if (MKU_TEXT_FIELD_TYPE_SECURE & type) {
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.secureTextEntry = YES;
        }
        if (MKU_TEXT_FIELD_TYPE_BORDER & type) {
            self.layer.borderColor = [AppTheme textFieldBorderColor].CGColor;
            self.layer.borderWidth = [Constants BorderWidth];
        }
        if (MKU_TEXT_FIELD_TYPE_CORNER & type) {
            self.layer.cornerRadius = [Constants ButtonCornerRadious];
            self.layer.masksToBounds = YES;
        }
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.font = [AppTheme textFieldFont];
        self.textColor = [AppTheme textFieldTextColor];
        self.backgroundColor = [AppTheme textFieldBackgroundColor];
        self.placeholder = placeholder;
        
        self.controller = [[TextFieldController alloc] initWithType:textType];
        self.controller.textField = self;
    }
    return self;
}

- (void)setPlaceholderText:(NSString *)placeholder {
    self.placeholder = placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];

    self.attributedPlaceholder = placeholder.length ? [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[AppTheme textFieldPlaceholderColor]}] : nil;
}

- (void)setControllerDelegate:(id<TextFieldDelegate>)object {
    self.controller.delegate = object;
}

// Text Field Insets
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 12, 4);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 12, 4);
}

@end
