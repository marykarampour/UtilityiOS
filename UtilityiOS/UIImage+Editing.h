//
//  UIImage+Editing.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Editing)

- (NSData *)shrink;
- (NSData *)resize:(CGSize)size;
- (UIImage *)rotate:(float)radian;
- (BOOL)hasNonWhitePixelsForMinimumPercent:(float)minimumPercent;
- (UIImage *)resizeToWidth:(float)width;
- (UIImage *)roundedImage:(CGRect)frame WithRadious:(float)radious;

@end
