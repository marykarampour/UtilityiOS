//
//  UIButton+Theme.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-21.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomButtonType) {
    CustomButtonTypeDefault,
    CustomButtonTypePlain,
    CustomButtonTypeBold
};

@interface UIButton (Theme)

+ (UIButton *)buttonWithCustomType:(CustomButtonType)type;

@end
