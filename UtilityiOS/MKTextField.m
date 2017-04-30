//
//  MKTextField.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKTextField.h"

@implementation MKTextField

- (instancetype)init {
    return [self initWithPlaceholder:@"" type:TextFieldTypeDefault];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder type:(TextFieldType)type {
    
    if (self = [super init]) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        switch (type) {
            case TextFieldTypePlain: {
                self.autocorrectionType = UITextAutocorrectionTypeNo;
                self.autocapitalizationType = UITextAutocapitalizationTypeNone;
            }
                break;
            case TextFieldTypeSecure: {
                self.autocorrectionType = UITextAutocorrectionTypeNo;
                self.autocapitalizationType = UITextAutocapitalizationTypeNone;
                self.secureTextEntry = YES;
            }
                break;
            default:
                break;
        }
        
        self.font = [AppTheme mediumLabelFont];
        self.textColor = [AppTheme textDarkColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[AppTheme textMediumColor]}];
        self.backgroundColor = [UIColor whiteColor];
        
        self.placeholder = placeholder;
    }
    
    return self;
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
