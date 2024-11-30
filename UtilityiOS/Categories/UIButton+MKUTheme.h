//
//  UIButton+Theme.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MKUTheme)

+ (UIButton *)buttonWithTitle:(NSString *)title;
+ (UIButton *)cornerButtonWithTitle:(NSString *)title;
+ (UIButton *)cornerButtonWithTitle:(NSString *)title cornerRadius:(CGFloat)cornerRadius;
+ (UIButton *)borderButtonWithTitle:(NSString *)title;
+ (UIButton *)backButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIButton *)addButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)deleteButtonWithTarget:(id)target action:(SEL)action;
+ (UIButton *)addButton;
+ (UIButton *)removeButton;

+ (CGFloat)defaultHeight;

/** @brief Used for Add and Delete default buttons. */
+ (CGSize)editButtonSize;

@end
