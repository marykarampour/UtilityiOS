//
//  UIColor+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-02.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUModel.h"

@interface MKUColorComponents : MKUModel

@property (nonatomic, assign) CGFloat red;
@property (nonatomic, assign) CGFloat green;
@property (nonatomic, assign) CGFloat blue;
@property (nonatomic, assign) CGFloat alpha;

+ (instancetype)colorComponentsWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
/** @brief Default alpha is 1.0. */
+ (instancetype)colorComponentsWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (instancetype)colorComponentsWithRGBHEX:(UInt32)value alpha:(CGFloat)alpha;
- (BOOL)isValid;

@end

@interface UIColor (Utility)

+ (UIColor *)colorWithRGB:(UInt32)hexValue;
+ (UIColor *)colorWithRGB:(UInt32)hexValue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithRGBString:(NSString *)hexString;
+ (UIColor *)colorWithRGBString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)randomColor;

+ (UIColor *)inkBlueColor;

- (UIImage *)pixelImage;
- (UIImage *)rectImageWithSize:(CGSize)size;
- (UIImage *)circleImageWithRadius:(CGFloat)radius;
- (UIImage *)circleImageWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor;
- (UIImage *)circleImageWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
- (UIImage *)ringImageWithInnerRadius:(CGFloat)innerRadius outerRadius:(CGFloat)outerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

- (MKUColorComponents *)colorComponents;

@end

@interface MKUColorComponents (MKUTheme)

+ (MKUColorComponents *)MKUInkBlueComponents;

@end
