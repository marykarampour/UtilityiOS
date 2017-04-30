//
//  UIButton+Theme.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "UIButton+Theme.h"

@implementation UIButton (Theme)

+ (UIButton *)buttonWithCustomType:(CustomButtonType)type {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = ButtonCornerRadious;
    button.layer.masksToBounds = YES;
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = CGSizeMake(0.0, -0.5);
    
    switch (type) {
        case CustomButtonTypePlain:
        case CustomButtonTypeDefault:
            button.titleLabel.font = [AppTheme mediumLabelFont];
            break;
        case CustomButtonTypeBold:
            button.titleLabel.font = [AppTheme largeBoldLabelFont];
            break;
        default:
            break;
    }
    
    return button;
}

@end
