//
//  UIImageView+Utility.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-23.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "UIImageView+Utility.h"
#import "UIImageView+AFNetworking.h"
#import "MKUAssets.h"

@implementation UIImageView (Utility)

+ (UIImageView *)imageViewWithImageName:(NSString *)imageName iconType:(IconType)iconType color:(UIColor *)color {
    UIImageView *img = [UIImageView imageViewWithTemplateImageName:imageName color:color];
    CGFloat size = (iconType == IconType_Small) ? [Constants TableIconImageSmallSize] : [Constants TableIconImageLargeSize];
    img.frame = CGRectMake(0.0, 0.0, size, size);
    return img;
}

+ (UIImageView *)imageViewWithTemplateImageName:(NSString *)imageName color:(UIColor *)color {
    UIImage *im = [UIImage imageNamed:imageName];
    UIImageView *view = [[UIImageView alloc] initWithImage:[im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    view.tintColor = color;
    view.contentMode = UIViewContentModeScaleAspectFit;
    return view;
}

- (void)setImageWithTemplateImageName:(NSString *)imageName color:(UIColor *)color {
    UIImage *im = [UIImage imageNamed:imageName];
    self.image = [im imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tintColor = color;
    self.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setImageWithURLString:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    [self setImageWithURLRequest:request placeholderImage:[MKUAssets systemIconWithName:[MKUAssets Photo_Image_Name] color:[UIColor systemGray3Color]] success:nil failure:nil];
}

+ (UIImageView *)roundedImageViewWithSize:(CGFloat)size {
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size, size)];
    img.layer.cornerRadius = size/2.0;
    img.clipsToBounds = YES;
    return img;
}

+ (UIImageView *)roundedImageViewWithSize:(CGFloat)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    UIImageView *img = [self roundedImageViewWithSize:size];
    img.layer.borderWidth = borderWidth;
    img.layer.borderColor = borderColor.CGColor;
    return img;
}

@end
