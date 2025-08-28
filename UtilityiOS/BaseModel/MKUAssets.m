//
//  MKUAssets.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-04-10.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUAssets.h"
#import "UIImageView+Utility.h"

@implementation MKUAssets

+ (NSString *)Plus_Circle_Image_Name {
    return @"plus.circle";
}

+ (NSString *)Minus_Circle_Image_Name {
    return @"minus.circle";
}

+ (NSString *)Lines_Horizontal_Image_Name {
    return @"line.3.horizontal";
}

+ (NSString *)Photo_Image_Name {
    return @"photo";
}

+ (NSString *)Checkmark_Square_Image_Name {
    return @"checkmark.square";
}

+ (NSString *)Square_Image_Name {
    return @"square";
}

+ (NSString *)Chevron_Right_Image_Name {
    return @"chevron.right";
}

+ (NSString *)Chevron_Left_Image_Name {
    return @"chevron.left";
}

+ (NSString *)Chevron_Up_Image_Name {
    return @"chevron.up";
}

+ (NSString *)Chevron_Down_Image_Name {
    return @"chevron.down";
}

+ (NSString *)Plusminus_square_Name {
    return @"plusminus.square";
}

+ (UIImage *)systemIconWithName:(NSString *)name color:(UIColor *)color {
    if (!color) return nil;
    
    if (@available(iOS 15.0, *)) {
        UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPaletteColors:@[color]];
        UIImage *image = [UIImage systemImageNamed:name withConfiguration:configuration];
        return image;
    }
    return nil;
}

+ (UIImage *)systemIconWithName:(NSString *)name size:(CGFloat)size {
    if (size <= 0.0) return nil;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithPointSize:size];
    UIImage *image = [UIImage systemImageNamed:name withConfiguration:configuration];
    return image;
}

+ (UIImage *)systemIconWithName:(NSString *)name color:(UIColor *)color size:(CGFloat)size {
    
    if (!color && size <= 0.0) return [UIImage systemImageNamed:name];
    
    UIImage *image = [UIImage systemImageNamed:name];
    UIImageSymbolConfiguration *colorConfig;
    UIImageSymbolConfiguration *sizeConfig;
    
    if (color) {
        if (@available(iOS 15.0, *)) {
            colorConfig = [UIImageSymbolConfiguration configurationWithPaletteColors:@[color]];
            image = [image imageByApplyingSymbolConfiguration:colorConfig];
        }
    }

    if (0.0 <= size) {
        sizeConfig = [UIImageSymbolConfiguration configurationWithPointSize:size];
        image = [image imageByApplyingSymbolConfiguration:sizeConfig];
    }
    
    return image;
}

@end
