//
//  UIImage+Editing.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "UIImage+Editing.h"

#define kLandscapePagerSizeA4            CGSizeMake(841.8, 595.2)
#define kPortraitPagerSizeA4             CGSizeMake(595.2, 841.8)

static NSUInteger const MAX_IMAGE_SIZE = 500000;
static CGFloat const MAX_IMAGE_QUALITY = 1.0;
static CGFloat const MAX_IMAGE_COMPRESSION = 0.5;
static CGFloat const MAX_IMAGE_COMPRESSION_TRIES = 12;
static CGFloat const IMAGE_SHRINK_CONSTANT = 0.5;

@implementation UIImage (Editing)

+ (void)shrinkImage:(UIImage *)image completion:(void (^)(NSData *))completion {
    [self shrinkImage:image toSize:MAX_IMAGE_SIZE completion:completion];
}

+ (void)shrinkImageData:(NSData *)data toSize:(long)maxVal completion:(void (^)(NSData *))completion {
    UIImage *image = [UIImage imageWithData:data];
    [self shrinkImage:image toSize:maxVal completion:completion];
}

+ (void)shrinkImage:(UIImage *)image toSize:(long)maxVal completion:(void (^)(NSData *))completion {
    if (!image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(nil);
        });
        return;
    }
    
    __block CGFloat compression = 1.0;
    __block NSUInteger count = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imageData = UIImageJPEGRepresentation(image, compression);
        DEBUGLOG(@"Size of Image before resize: %ld", (unsigned long)imageData.length);
        
        while (count < MAX_IMAGE_COMPRESSION_TRIES && maxVal < imageData.length) {
            count ++;
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(image, compression);
        }
        
        DEBUGLOG(@"Size of Image after resize: %ld", (unsigned long)imageData.length);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(imageData);
        });
    });
}

- (NSData *)shrink {
    return [self shrinkToSize:MAX_IMAGE_SIZE];
}

- (NSData *)shrinkToSize:(long)maxVal {
    
    CGFloat compression = 1.0;
    NSUInteger count = 0;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    DEBUGLOG(@"Size of Image before resize: %ld", (unsigned long)imageData.length);
    
    while (count < MAX_IMAGE_COMPRESSION_TRIES && maxVal < imageData.length) {
        count ++;
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);
    }
    
    DEBUGLOG(@"Size of Image after resize: %ld", (unsigned long)imageData.length);
    return imageData;
}

- (NSData *)resize:(CGSize)size withCompression:(CGFloat)compression {
    
    UIImage *image = [self resizeImage:size];
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    UIGraphicsEndImageContext();
    
    DEBUGLOG(@"Size of Image after resize: %ld", (unsigned long)imageData.length);
    return imageData;
}

- (UIImage *)resizeImage:(CGSize)size {
    if ([self size].width == size.width && [self size].height == size.height) return self;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//https://stackoverflow.com/a/6565988
- (UIImage *)aspectFitImageResize:(CGSize)size {
    if (size.height == 0) return nil;
    
    UIImage *image = self;
    CGFloat aspectI = self.size.width / self.size.height;
    CGFloat aspectS = size.width / size.height;
    CGFloat width = aspectS > aspectI ? self.size.width * size.height / self.size.height : size.width;
    CGFloat height = aspectS > aspectI ? size.height : self.size.height * size.width / self.size.width;
    CGSize imSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContextWithOptions(imSize, NO, self.scale);
    [image drawInRect:CGRectMake(size.width / 2.0 - imSize.width / 2.0, 0.0, imSize.width, imSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (NSData *)aspectFitResize:(CGSize)size {
    UIImage *image = [self aspectFitImageResize:size];
    NSData *imageData = [image shrink];
    return imageData;
}

+ (NSData *)aspectFitImageData:(NSData *)data resize:(CGSize)size {
    UIImage *image = [UIImage imageWithData:data];
    return [image aspectFitResize:size];
}

+ (NSData *)aspectFitShrinkImageData:(NSData *)data {
    return [self aspectFitImageData:data resize:[Constants ImageShrinkMaxSize]];
}

- (UIImage *)rotate:(float)radian {
    
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform tr = CGAffineTransformMakeRotation(radian);
    rotatedViewBox.transform = tr;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(context, radian);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(-self.size.width/2, -self.size.height/2, self.size.width, self.size.height), [self CGImage]);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)hasNonWhitePixelsForMinimumPercent:(float)minimumPercent {
    
    unsigned int nonWhiteCount = 0;
    unsigned int whiteCount = 0;
    
    NSData *pixelData = (NSData *)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage)));
    unsigned char *allBytes = (unsigned char *)pixelData.bytes;
    
    for (unsigned int i=0; i<pixelData.length; i+=4) {
        if ((CGFloat)allBytes[i+3] < 1.0) {
            whiteCount ++;
        }
        else {
            nonWhiteCount ++;
        }
    }
    
    if (whiteCount > 0) {
        if (nonWhiteCount > 0) {
            if ((float)nonWhiteCount/whiteCount >= minimumPercent) {
                return YES;
            }
            return NO;
        }
        return NO;
    }
    return NO;
}

+ (UIImage *)thumbnailImageFromData:(NSData *)data width:(int)width {
    if (!data) return nil;
    
    UIImage *image;
    CFDictionaryRef options = (__bridge CFDictionaryRef)@{
        (id)kCGImageSourceCreateThumbnailWithTransform:@(YES),
        (id)kCGImageSourceCreateThumbnailFromImageAlways:@(YES),
        (id)kCGImageSourceThumbnailMaxPixelSize:@(width)};
    
    CGImageSourceRef isrc = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    CGImageRef ref = CGImageSourceCreateThumbnailAtIndex(isrc, 0, options);
    image = [UIImage imageWithCGImage:ref];
    
    CGImageRelease(ref);
    CFRelease(isrc);
    return image;
}

- (UIImage *)croppedToFitRect:(CGRect)rect {
    
    CGRect selfRect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef selfRef = [context createCGImage:self.CIImage fromRect:selfRect];
    CGImageRef imageRef = CGImageCreateWithImageInRect(selfRef, rect);
    UIImage *im = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGImageRelease(selfRef);
    return im;
}

+ (CGImagePropertyOrientation)CGorientationWithOrientation:(UIImageOrientation)orientation {
    switch (orientation) {
        case UIImageOrientationLeft:
            return kCGImagePropertyOrientationLeft;
        case UIImageOrientationRight:
            return kCGImagePropertyOrientationRight;
        case UIImageOrientationDown:
            return kCGImagePropertyOrientationDown;
        default:
            return kCGImagePropertyOrientationUp;
    }
}

- (CGImagePropertyOrientation)CGOrientation {
    return [UIImage CGorientationWithOrientation:self.imageOrientation];
}

- (UIImage *)templateImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - stacked images

+  (UIImage *)verticallyStackedImageFromImages:(NSArray<UIImage *> *)images {
    return [self stackedImageFromImages:images vertical:YES];
}

+  (UIImage *)horizontallyStackedImageFromImages:(NSArray<UIImage *> *)images {
    return [self stackedImageFromImages:images vertical:NO];
}

+ (UIImage *)verticallyStackedImageFromImageData:(NSArray<NSData *> *)images {
    return [self stackedImageFromImageData:images vertical:YES];
}

+ (UIImage *)horizontallyStackedImageFromImageData:(NSArray<NSData *> *)images {
    return [self stackedImageFromImageData:images vertical:NO];
}

+ (UIImage *)stackedImageFromImageData:(NSArray<NSData *> *)images vertical:(BOOL)vertical {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSData *data in images) {
        UIImage *im = [UIImage imageWithData:data];
        if (im) [arr addObject:im];
    }
    return [self stackedImageFromImages:arr vertical:vertical];
}

+ (NSData *)verticallyStackedPdfFromImageData:(NSArray<NSData *> *)images {
    return [self stackedPdfFromImageData:images vertical:YES];
}

+ (NSData *)stackedImageIsAlwaysPDF:(BOOL)isPDF images:(NSArray<NSData *> *)images {
    if (images.count <= 1 && !isPDF)
        return images.firstObject;
    if (isPDF)
        return [UIImage verticallyStackedPdfFromImageData:images];
    else
        return [[[UIImage verticallyStackedImageFromImageData:images] aspectFitImageResize:[Constants ImageShrinkMaxSize]] shrink];
}

+  (UIImage *)stackedImageFromImages:(NSArray<UIImage *> *)images vertical:(BOOL)vertical {
    
    CGFloat maxWidth = 0.0;
    CGFloat maxHeight = 0.0;
    
    for (UIImage *im in images) {
        
        if (vertical) {
            if (maxWidth < im.size.width) {
                maxWidth = im.size.width;
            }
            maxHeight += im.size.height;
        }
        else {
            if (maxHeight < im.size.height) {
                maxHeight = im.size.height;
            }
            maxWidth += im.size.width;
        }
    }
    
    CGPoint nextImageOrigin = CGPointZero;
    CGFloat totalHeight = vertical ? 0.0 : maxHeight;
    CGFloat totalWidth = vertical ? maxWidth : 0.0;
    
    for (UIImage *im in images) {
        
        CGFloat aspect = 1.0;
        
        if (vertical) {
            aspect = maxWidth / im.size.width;
            totalHeight += (im.size.height * aspect);
        }
        else {
            aspect = maxHeight / im.size.height;
            totalWidth += (im.size.width * aspect);
        }
    }
    
    CGRect finalRect = CGRectMake(0.0, 0.0, totalWidth, totalHeight);
    UIGraphicsBeginImageContextWithOptions(finalRect.size, NO, 0.0);
    
    for (UIImage *im in images) {
        
        CGFloat aspect = 1.0;
        CGFloat height = 0.0;
        CGFloat width = 0.0;
        
        if (vertical) {
            aspect = maxWidth / im.size.width;
            height = im.size.height * aspect;
            width = maxWidth;
        }
        else {
            aspect = maxHeight / im.size.height;
            width = im.size.width * aspect;
            height = maxHeight;
        }
        
        CGRect rect = CGRectMake(nextImageOrigin.x, nextImageOrigin.y, width, height);
        [im drawInRect:rect];
        
        if (vertical) {
            nextImageOrigin = CGPointMake(nextImageOrigin.x, nextImageOrigin.y + height);
        }
        else {
            nextImageOrigin = CGPointMake(nextImageOrigin.x + width, nextImageOrigin.y);
        }
    }
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}

+ (NSData *)stackedPdfFromImageData:(NSArray<NSData *> *)images vertical:(BOOL)vertical {
    if (images.count == 0) return nil;
    
    CGFloat maxWidth = 0.0;
    CGFloat maxHeight = 0.0;
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    NSMutableArray<NSData *> *imageData = [[NSMutableArray alloc] init];
    CGFloat resizeRatio = 1 / (float)images.count;
    CGFloat maxSizePerImage = MAX_IMAGE_SIZE * resizeRatio;
    
    for (NSData *image in images) {
        
        NSData *fit = [UIImage aspectFitShrinkImageData:image];
        UIImage *im = [UIImage imageWithData:fit];
        if (!im) continue;
        
        CGSize size = im.size;
        NSData *data = [im shrinkToSize:maxSizePerImage];
        if (!data) continue;
        
        [imageData addObject:data];
        
        if (vertical) {
            if (maxWidth < size.width) {
                maxWidth = size.width;
            }
            maxHeight += size.height;
        }
        else {
            if (maxHeight < size.height) {
                maxHeight = size.height;
            }
            maxWidth += size.width;
        }
    }
    
    CGFloat totalHeight = vertical ? maxHeight * images.count : maxHeight;
    CGFloat totalWidth = vertical ? maxWidth : maxWidth * images.count;
    
    CGRect finalRect = CGRectMake(0.0, 0.0, totalWidth, totalHeight);
    UIGraphicsBeginPDFContextToData(pdfData, finalRect, nil);
    
    for (NSData *image in imageData) {
        
        CGFloat aspect = 1.0;
        CGFloat height = 0.0;
        CGFloat width = 0.0;
        UIImage *im = [UIImage imageWithData:image];
        
        if (vertical) {
            aspect = maxWidth / im.size.width;
            height = im.size.height * aspect;
            width = maxWidth;
        }
        else {
            aspect = maxHeight / im.size.height;
            width = im.size.width * aspect;
            height = maxHeight;
        }
        
        CGRect rect = CGRectMake(0.0, 0.0, width, height);
        UIGraphicsBeginPDFPageWithInfo(rect, nil);
        [im drawInRect:rect];
    }
    
    UIGraphicsEndPDFContext();
    return pdfData;
}

+ (CGRect)pdfPageSizeIsLandscape:(BOOL)isLandscape {
    
    CGFloat width;
    CGFloat height;
    
    if (isLandscape) {
        width = kLandscapePagerSizeA4.width;
        height = kLandscapePagerSizeA4.height;
    }
    else {
        width = kPortraitPagerSizeA4.width;
        height = kPortraitPagerSizeA4.height;
    }
    
    CGRect paperRect = CGRectMake(0, 0, width, height);
    return paperRect;
}

+ (void)renderImage:(UIImage *)im inRect:(CGRect)rect toData:(NSMutableData *)data {
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, im.scale);
    UIGraphicsBeginPDFContextToData(data, rect, nil);
    UIGraphicsBeginPDFPageWithInfo(rect, nil);
    [im drawInRect:rect];
    UIGraphicsEndPDFContext();
    UIGraphicsEndImageContext();
}

- (UIImage *)resizeToWidth:(float)width {
    
    UIImage *scaledImage = nil;
    if (self.size.width != width) {
        CGFloat height = floorf(self.size.height * (width / self.size.width));
        CGSize size = CGSizeMake(width, height);
        UIGraphicsBeginImageContext(size);
        [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return scaledImage;
}

- (UIImage *)roundedImage:(CGRect)frame WithRadious:(float)radious {
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radious] addClip];
    [self drawInRect:frame];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSData *)resize:(CGSize)size {
    
    UIImage *compressedImage = self;
    UIImage *image = compressedImage;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(compressedImage, 0.1);
    UIGraphicsEndImageContext();
    
    DEBUGLOG(@"Size of Image after resize: %ld", (unsigned long)imageData.length);
    return imageData;
}

@end
