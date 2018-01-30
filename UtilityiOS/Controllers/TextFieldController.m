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

@property (nonatomic, strong) NSMutableArray<MKTextField *> *views;

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
            default:
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
    [self handleTextFieldChanges:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleTextFieldChanges:textField];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isKindOfClass:[MKTextField class]]) return YES;
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    MKTextField *view = (MKTextField *)textField;
    return [newString isValidStringOfType:view.textObject.type maxLength:view.textObject.maxChars];
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
