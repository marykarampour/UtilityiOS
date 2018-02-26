//
//  UIImageView+Utility.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-23.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Utility)

+ (UIImageView *)imageViewWithTemplateImageName:(NSString *)imageName color:(UIColor *)color;
- (void)setImageWithTemplateImageName:(NSString *)imageName color:(UIColor *)color;

@end
