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
            case TextTypeInt: {
                view.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
                break;
            case TextTypeFloat: {
                view.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
                break;
            case TextTypeIntPositive: {
                view.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;
            case TextTypeFloatPositive: {
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

@end
