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
- (NSData *)shrinkToSize:(long)maxVal;
/** @brief By default shrink to max size 200000 bytes */
+ (void)shrinkImage:(UIImage *)image completion:(void (^)(NSData *data))completion;
/** @brief By default shrink to max size 200000 bytes */
+ (void)shrinkImage:(UIImage *)image toSize:(long)maxVal completion:(void (^)(NSData *data))completion;
+ (void)shrinkImageData:(NSData *)data toSize:(long)maxVal completion:(void (^)(NSData *data))completion;
/** @brief It exactly resizes the image by stretching it. */
- (UIImage *)resizeImage:(CGSize)size;
- (NSData *)resize:(CGSize)size withCompression:(CGFloat)compression;
/** @brief It resizes the image by fitting it preservng its aspect ratio. */
- (NSData *)aspectFitResize:(CGSize)size;
- (UIImage *)rotate:(float)radian;
- (BOOL)hasNonWhitePixelsForMinimumPercent:(float)minimumPercent;
+ (UIImage *)thumbnailImageFromData:(NSData *)data width:(int)width;
- (UIImage *)croppedToFitRect:(CGRect)rect;
+ (CGImagePropertyOrientation)CGorientationWithOrientation:(UIImageOrientation)orientation;
- (CGImagePropertyOrientation)CGOrientation;
- (UIImage *)templateImage;

#pragma mark - stacked images

/** @brief It will create an stack with the width and height of max combined images
 @param images the array of images being stacked, The order will be preserved in the final image
 @param vertical YES for vertical stack, NO for horizontal stack */
+ (UIImage *)stackedImageFromImages:(NSArray<UIImage *> *)images vertical:(BOOL)vertical;

/** @brief It will create a vertical stack with the width and height of max combined images
 @param images the array of images being stacked, The order will be preserved in the final image */
+ (UIImage *)verticallyStackedImageFromImages:(NSArray<UIImage *> *)images;

/** @brief It will create a horizontal stack with the width and height of max combined images
 @param images the array of images being stacked, The order will be preserved in the final image */
+ (UIImage *)horizontallyStackedImageFromImages:(NSArray<UIImage *> *)images;

/** @brief It will create an stack with the width and height of max combined images
 @param images the array of images being stacked, The order will be preserved in the final image
 @param vertical YES for vertical stack, NO for horizontal stack */
+ (UIImage *)stackedImageFromImageData:(NSArray<NSData *> *)images vertical:(BOOL)vertical;

/** @brief It will create a vertical stack with the width and height of max combined images
 @param images the array of images being stacked, The order will be preserved in the final image */
+ (UIImage *)verticallyStackedImageFromImageData:(NSArray<NSData *> *)images;

/** @brief It will create an stack with the width and height of max combined images
 @param images the array of images being stacked, The order will be preserved in the final image
 @param vertical YES for vertical stack, NO for horizontal stack */
+ (NSData *)stackedPdfFromImageData:(NSArray<NSData *> *)images vertical:(BOOL)vertical;

/** @brief It will create a vertical stack with the width and height of max combined images
 @param images the array of images being stacked, The order will be preserved in the final image */
+ (NSData *)verticallyStackedPdfFromImageData:(NSArray<NSData *> *)images;

/** @brief It will create a horizontal stack with the width and height of max combined images
 @param images the array of images being stacked, The order will be preserved in the final image */
+ (UIImage *)horizontallyStackedImageFromImageData:(NSArray<NSData *> *)images;

/** @param isPDF If YES, even a single image is converted to pdf, otherwise, the image is returned. */
+ (NSData *)stackedImageIsAlwaysPDF:(BOOL)isPDF images:(NSArray<NSData *> *)images;


- (NSData *)resize:(CGSize)size;
- (UIImage *)resizeToWidth:(float)width;
- (UIImage *)roundedImage:(CGRect)frame WithRadious:(float)radious;

@end
