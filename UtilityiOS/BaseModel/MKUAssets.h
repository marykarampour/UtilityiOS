//
//  MKUAssets.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-04-10.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKUAssets : NSObject

+ (NSString *)Plus_Circle_Image_Name;
+ (NSString *)Minus_Circle_Image_Name;
+ (NSString *)Lines_Horizontal_Image_Name;
+ (NSString *)Photo_Image_Name;
+ (NSString *)Checkmark_Square_Image_Name;
+ (NSString *)Square_Image_Name;
+ (NSString *)Chevron_Right_Image_Name;
+ (NSString *)Chevron_Left_Image_Name;
+ (NSString *)Chevron_Up_Image_Name;
+ (NSString *)Chevron_Down_Image_Name;
+ (NSString *)Plusminus_square_Name;

+ (UIImage *)systemIconWithName:(NSString *)name color:(UIColor *)color;
+ (UIImage *)systemIconWithName:(NSString *)name size:(CGFloat)size;
+ (UIImage *)systemIconWithName:(NSString *)name color:(UIColor *)color size:(CGFloat)size;

@end
