//
//  UIColor+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-02.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)

+ (UIColor *)colorWithRGB:(UInt32)hexValue;
+ (UIColor *)colorWithRGB:(UInt32)hexValue alpha:(CGFloat)alpha;

@end
