//
//  LoginView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKTextField.h"

@interface MKBasicFormView : UIView

- (instancetype)initWithTextFieldPlaceholders:(StringArr *)texts buttonTitle:(NSString *)buttonTitle;
- (void)setPlaceholderText:(NSString *)text forTextFieldAtIndex:(NSUInteger)index;
- (void)setTarget:(id)object selector:(SEL)action;
- (void)setDelegate:(id)object;
- (NSString *)textAtIndex:(NSUInteger)index;
- (void)setText:(NSString *)text atIndex:(NSUInteger)index;
- (void)setTextFieldAtIndex:(NSUInteger)index secure:(BOOL)isSecure;
- (BOOL)performAtTextFieldReturn:(UITextField *)textField;
- (CGFloat)height;

//negative if it doesn't exist
- (NSInteger)indexOfTextField:(MKTextField *)textField;

/** @brief addes a view to the bottom of the button */

- (void)addBottomSubview:(UIView *)view;

@end
