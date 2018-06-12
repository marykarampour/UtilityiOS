//
//  TextFieldController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "TextFieldController.h"
#import "NSString+Validation.h"
#import "MKTextField.h"

@interface TextFieldController () <UITextFieldDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray<MKTextField *> *views;

@end

@implementation TextFieldController

- (instancetype)init {
    if (self = [super init]) {
        self.views = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addTextField:(MKTextField *)view {
    if (![self.views containsObject:view]) {
        switch (view.textObject.type) {
            case TextType_Int: {
                view.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
                break;
            case TextType_Float: {
                view.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
                break;
            case TextType_IntPositive: {
                view.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;
            case TextType_FloatPositive: {
                view.keyboardType = UIKeyboardTypeDecimalPad;
            }
                break;
            case TextType_Alphabet:
            case TextType_Gender: {
                view.keyboardType = UIKeyboardTypeAlphabet;
                }
                break;
            case TextType_AlphaNumeric: {
                view.keyboardType = UIKeyboardTypeNamePhonePad;
            }
                break;
            case TextType_Email: {
                view.keyboardType = UIKeyboardTypeEmailAddress;
            }
                break;
            case TextType_Phone: {
                view.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;
            
            case TextType_AlphaSpaceDot:
            case TextType_Address:
            case TextType_Date:
            default: {
                view.keyboardType = UIKeyboardTypeDefault;
            }
                break;
        }
        view.delegate = self;
        [self.views addObject:view];
    }
}

#pragma mark - TextField Delegate mathods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self handleTextFieldBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self handleTextFieldReturn:textField isValid:[self validateText:textField.text inTextField:textField isEditing:NO]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleTextFieldReturn:textField isValid:[self validateText:textField.text inTextField:textField isEditing:NO]];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![textField isKindOfClass:[MKTextField class]]) return NO;
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL shouldChange = [self validateText:newString inTextField:textField isEditing:YES];
    if (shouldChange) {
        [self handleTextFieldChanges:textField];
    }
    return shouldChange;
}

- (BOOL)validateText:(NSString *)text inTextField:(__kindof UITextField *)textField isEditing:(BOOL)isEditing {
    BOOL isValid = NO;
    if ([textField isKindOfClass:[MKTextField class]]) {
        MKTextField *view = (MKTextField *)textField;
        isValid = [text isValidStringOfType:view.textObject.type maxLength:view.textObject.maxChars isEditing:isEditing];
    }
    return isValid;
}

- (void)handleTextFieldReturn:(__kindof UITextField *)textField isValid:(BOOL)isValid {
    if ([textField isKindOfClass:[MKTextField class]]) {
        if ([self.delegate respondsToSelector:@selector(handleTextFieldReturn:isValid:)]) {
            [self.delegate handleTextFieldReturn:(MKTextField *)textField isValid:isValid];
        }
    }
}

- (void)handleTextFieldChanges:(UITextField *)textField {
    if ([textField isKindOfClass:[MKTextField class]]) {
        if ([self.delegate respondsToSelector:@selector(handleTextFieldChanges:)]) {
            [self.delegate handleTextFieldChanges:(MKTextField *)textField];
        }
    }
}

- (void)handleTextFieldBeginEditing:(__kindof UITextField *)textField {
    if ([textField isKindOfClass:[MKTextField class]]) {
        if ([self.delegate respondsToSelector:@selector(handleTextFieldBeginEditing:)]) {
            [self.delegate handleTextFieldBeginEditing:(MKTextField *)textField];
        }
    }
}

@end
