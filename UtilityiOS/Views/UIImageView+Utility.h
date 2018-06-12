//
//  UIImageView+Utility.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-23.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IconType) {
    IconType_Small,
    IconType_Medium,
    IconType_Large
};

@interface UIImageView (Utility)

+ (UIImageView *)imageViewWithImageName:(NSString *)imageName iconType:(IconType)iconType color:(UIColor *)color;
+ (UIImageView *)imageViewWithTemplateImageName:(NSString *)imageName color:(UIColor *)color;
- (void)setImageWithTemplateImageName:(NSString *)imageName color:(UIColor *)color;
- (void)setImageWithURLString:(NSString *)url;
+ (UIImageView *)roundedImageViewWithSize:(CGFloat)size;
+ (UIImageView *)roundedImageViewWithSize:(CGFloat)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
