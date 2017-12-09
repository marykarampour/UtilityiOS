//
//  UIColor+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-02.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)

+ (UIColor *)colorWithRGB:(UInt32)hexValue {
    
    return [UIColor colorWithRed:((float)((hexValue & 0xff0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0x00ff00) >>  8)) / 255.0
                            blue:((float)((hexValue & 0x0000ff) >>  0)) / 255.0
                           alpha:1.0];
}

@end
