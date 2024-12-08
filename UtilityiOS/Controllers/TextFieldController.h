//
//  TextFieldController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKUTextField;

@protocol TextFieldDelegate <NSObject>

@optional
- (void)handleTextFieldReturn:(__kindof UITextField *)textField isValid:(BOOL)isValid;
- (void)handleTextFieldEndEditing:(__kindof UITextField *)textField isValid:(BOOL)isValid;
- (void)handleTextFieldReturn:(__kindof UITextField *)textField;
- (void)handleTextFieldEndEditing:(__kindof UITextField *)textField;
- (void)handleTextFieldChanges:(__kindof UITextField *)textField;
- (void)handleTextFieldChanges:(__kindof UITextField *)textField newText:(NSString *)newText;
- (void)handleTextFieldDidChange:(__kindof UITextField *)textField newText:(NSString *)newText;
- (void)handleTextFieldBeginEditing:(__kindof UITextField *)textField;

@end

@interface TextFieldController : NSObject

@property (nonatomic, weak) id<TextFieldDelegate> delegate;
@property (nonatomic, weak) MKUTextField *textField;
@property (nonatomic, assign) NSUInteger maxLenght;
@property (nonatomic, assign) MKU_TEXT_TYPE type;

- (instancetype)initWithType:(MKU_TEXT_TYPE)type;

@end
