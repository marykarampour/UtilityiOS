//
//  MKTextField.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKTextField.h"

@interface MKTextField ()

@property (nonatomic, strong, readwrite) MKText *textObject;

@end

@implementation MKTextField

- (instancetype)init {
    return [self initWithPlaceholder:@"" type:TextFieldTypeDefault];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder type:(TextFieldType)type {
    
    if (self = [super init]) {
        self.textObject = [[MKText alloc] init];
        
        self.clearButtonMode = UITextFieldViewModeNever;
        
        if (TextFieldTypePlain & type) {
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        }
        else if (TextFieldTypeSecure & type) {
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.secureTextEntry = YES;
        }
        if (TextFieldTypeBorder & type) {
            self.layer.cornerRadius = [Constants ButtonCornerRadious];
            self.layer.masksToBounds = YES;
            self.layer.borderColor = [AppTheme textFieldBorderColor].CGColor;
            self.layer.borderWidth = [Constants BorderWidth];
        }
        
        self.font = [AppTheme textFieldFont];
        self.textColor = [AppTheme textFieldTextColor];
        [self setPlaceholderText:placeholder];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setPlaceholderText:(NSString *)placeholder {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[AppTheme textFieldPlaceholderColor]}];
    self.placeholder = placeholder;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 16, 4);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 16, 4);
}

@end
