//
//  LoginView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKBasicFormView : UIView

- (instancetype)initWithTextFieldPlaceholders:(StringArr *)texts buttonTitle:(NSString *)buttonTitle;
- (void)setTarget:(id)object selector:(SEL)action;
- (NSString *)textAtIndex:(NSUInteger)index;
- (BOOL)performAtTextFieldReturn:(UITextField *)textField;
- (CGFloat)height;

@end
