//
//  UIButton+Theme.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "UIButton+MKUTheme.h"
#import "MKUAssets.h"

@implementation UIButton (MKUTheme)

+ (UIButton *)buttonWithTitle:(NSString *)title {
    
    UIButton *view = [[UIButton alloc] init];
    view.titleLabel.font = [AppTheme mediumBoldLabelFont];
    
    [view setTitle:title forState:UIControlStateNormal];
    [view setTitleColor:[AppTheme buttonTextColor] forState:UIControlStateNormal];
    [view setTitleColor:[AppTheme lightBlueColorWithAlpha:1.0] forState:UIControlStateHighlighted];
    return view;
}

+ (UIButton *)cornerButtonWithTitle:(NSString *)title {
    return [self cornerButtonWithTitle:title cornerRadius:[Constants ButtonCornerRadious]];
}

+ (UIButton *)cornerButtonWithTitle:(NSString *)title cornerRadius:(CGFloat)cornerRadius {
    
    UIButton *view = [self buttonWithTitle:title];
    view.layer.cornerRadius = cornerRadius;
    return view;
}

+ (UIButton *)borderButtonWithTitle:(NSString *)title {
    
    UIButton *view = [self cornerButtonWithTitle:title];
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [AppTheme buttonBorderColor].CGColor;
    return view;
}

+ (UIButton *)backButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [AppTheme mediumBoldLabelFont];
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = [AppTheme defaultSectionHeaderColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[AppTheme textDarkColor] forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)addButtonWithTarget:(id)target action:(SEL)action {
    
    UIButton *button = [self addButton];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)addButton {
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    [button setImage:[MKUAssets systemIconWithName:[MKUAssets Plus_Circle_Image_Name] color:[UIColor systemGreenColor]] forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)deleteButtonWithTarget:(id)target action:(SEL)action {
    
    UIButton *button = [self removeButton];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)removeButton {
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    [button setImage:[MKUAssets systemIconWithName:[MKUAssets Minus_Circle_Image_Name] color:[UIColor systemRedColor]] forState:UIControlStateNormal];
    return button;
}

+ (CGFloat)defaultHeight {
    return 38.0;
}

+ (CGSize)editButtonSize {
    return CGSizeMake(52.0, 52.0);
}

@end

