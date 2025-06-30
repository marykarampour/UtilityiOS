//
//  TextFieldController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "TextFieldController.h"
#import "NSString+Validation.h"
#import "MKUTextField.h"

@interface IntTextFieldController : TextFieldController

@end

@implementation IntTextFieldController

@end

@interface FloatTextFieldController : TextFieldController

@end

@implementation FloatTextFieldController

@end

@interface IntPositiveTextFieldController : TextFieldController

@end

@implementation IntPositiveTextFieldController

@end

@interface FloatPositiveTextFieldController : TextFieldController

@end

@implementation FloatPositiveTextFieldController

@end

@interface StringTextFieldController : TextFieldController

@end

@implementation StringTextFieldController

@end


@interface TextFieldController () <UITextFieldDelegate>

@end

@implementation TextFieldController

- (instancetype)initWithType:(MKU_TEXT_TYPE)type {
    if (self = [super init]) {
        switch (type) {
            case MKU_TEXT_TYPE_INT: {
                self = [[IntTextFieldController alloc] init];
            }
                break;
            case MKU_TEXT_TYPE_FLOAT: {
                self = [[FloatTextFieldController alloc] init];
            }
                break;
            case MKU_TEXT_TYPE_INT_POSITIVE: {
                self = [[IntPositiveTextFieldController alloc] init];
            }
                break;
            case MKU_TEXT_TYPE_FLOAT_POSITIVE: {
                self = [[FloatPositiveTextFieldController alloc] init];
            }
                break;
            case MKU_TEXT_TYPE_STRING: {
                self = [[StringTextFieldController alloc] init];
            }
                break;
            default:
                self = [super init];
                break;
        }
    }
    self.type = type;
    self.maxLenght = 256;
    return self;
}

- (void)setTextField:(MKUTextField *)textField {
    _textField = textField;
    textField.delegate = self;
    [self updateTextFieldWithType:self.type];
}

- (void)setDelegate:(id<TextFieldDelegate>)delegate {
    _delegate = delegate;
    [self setDidChangeAction];
}

- (void)setType:(MKU_TEXT_TYPE)type {
    _type = type;
    [self updateTextFieldWithType:type];
}

- (void)updateTextFieldWithType:(MKU_TEXT_TYPE)type {
    switch (type) {
        case MKU_TEXT_TYPE_INT: {
            self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
            break;
        case MKU_TEXT_TYPE_FLOAT: {
            self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
            break;
        case MKU_TEXT_TYPE_INT_POSITIVE: {
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case MKU_TEXT_TYPE_FLOAT_POSITIVE: {
            self.textField.keyboardType = UIKeyboardTypeDecimalPad;
        }
            break;
        case MKU_TEXT_TYPE_STRING: {
            self.textField.keyboardType = UIKeyboardTypeDefault;
        }
            break;
        default:
            break;
    }
}

- (void)setDidChangeAction {
    if ([self.textField.allTargets containsObject:self.delegate]) return;
    
    SEL action = @selector(handleTextFieldDidChange:newText:);
    if ([self.delegate respondsToSelector:action]) {
        [self.textField addTarget:self.delegate action:action forControlEvents:UIControlEventEditingChanged];
    }
}

#pragma mark - TextField Delegate mathods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self handleTextFieldBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad ||
        textField.keyboardType == UIKeyboardTypeDecimalPad ||
        textField.keyboardType == UIKeyboardTypePhonePad) {
        
        [self handleTextFieldReturn:textField isValid:[self validateText:textField.text inTextField:textField]];
    }
    else {
        [self handleTextFieldEndEditing:textField isValid:[self validateText:textField.text inTextField:textField]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleTextFieldReturn:textField isValid:[self validateText:textField.text inTextField:textField]];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL shouldChange = [self validateText:newString inTextField:textField];
    if (shouldChange) {
        [self handleTextFieldChanges:textField newText:newString];
    }
    return shouldChange;
}

- (BOOL)validateText:(NSString *)text inTextField:(__kindof UITextField *)textField {
    return [text isValidStringOfType:self.type maxLength:self.maxLenght];
}

- (void)handleTextFieldReturn:(__kindof UITextField *)textField isValid:(BOOL)isValid {
    if ([textField isKindOfClass:[MKUTextField class]]) {
        if ([self.delegate respondsToSelector:@selector(handleTextFieldReturn:isValid:)]) {
            [self.delegate handleTextFieldReturn:(MKUTextField *)textField isValid:isValid];
        }
        else if ([self.delegate respondsToSelector:@selector(handleTextFieldReturn:)]) {
            [self.delegate handleTextFieldReturn:(MKUTextField *)textField];
        }
        else {
            [self handleTextFieldChanges:textField];
        }
    }
}

- (void)handleTextFieldEndEditing:(__kindof UITextField *)textField isValid:(BOOL)isValid {
    if ([textField isKindOfClass:[MKUTextField class]]) {
        if ([self.delegate respondsToSelector:@selector(handleTextFieldEndEditing:isValid:)]) {
            [self.delegate handleTextFieldEndEditing:(MKUTextField *)textField isValid:isValid];
        }
        else if ([self.delegate respondsToSelector:@selector(handleTextFieldEndEditing:)]) {
            [self.delegate handleTextFieldEndEditing:(MKUTextField *)textField];
        }
        else {
            [self handleTextFieldChanges:textField];
        }
    }
}

- (void)handleTextFieldChanges:(UITextField *)textField {
    if ([textField isKindOfClass:[MKUTextField class]]) {
        if ([self.delegate respondsToSelector:@selector(handleTextFieldChanges:)]) {
            [self.delegate handleTextFieldChanges:(MKUTextField *)textField];
        }
    }
}

- (void)handleTextFieldChanges:(__kindof UITextField *)textField newText:(NSString *)newText {
    if ([textField isKindOfClass:[MKUTextField class]]) {
        if ([self.delegate respondsToSelector:@selector(handleTextFieldChanges:newText:)]) {
            [self.delegate handleTextFieldChanges:(MKUTextField *)textField newText:newText];
        }
        else if ([self.delegate respondsToSelector:@selector(handleTextFieldChanges:)]) {
            [self.delegate handleTextFieldChanges:(MKUTextField *)textField];
        }
    }
}

- (void)handleTextFieldBeginEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[MKUTextField class]]) {
        if ([self.delegate respondsToSelector:@selector(handleTextFieldBeginEditing:)]) {
            [self.delegate handleTextFieldBeginEditing:(MKUTextField *)textField];
        }
    }
}

@end
