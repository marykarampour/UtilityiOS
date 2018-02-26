//
//  UIImageView+Utility.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-23.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "UIImageView+Utility.h"

@implementation UIImageView (Utility)

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

@end
