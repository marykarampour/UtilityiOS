//
//  UIImage+Editing.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "UIImage+Editing.h"

@implementation UIImage (Editing)

- (UIImage *)templateImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
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

- (NSData *)shrink {
    
    long maxVal = 200000;
    
    NSData *imageData = UIImageJPEGRepresentation(self, 0.1);
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    
    DEBUGLOG(@"Size of Image before resize: %ld", (unsigned long)imageData.length);
    if (imageData.length > maxVal) {
        
        UIImage *image = compressedImage;
        CGSize size = CGSizeMake(image.size.width/3.0, image.size.height/3.0);
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        imageData = UIImageJPEGRepresentation(compressedImage, 0.1);
        
    }
    
    DEBUGLOG(@"Size of Image after resize: %ld", (unsigned long)imageData.length);
    return imageData;
    
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
    //    CGContextRelease(context);
    return image;
}

- (BOOL)hasNonWhitePixelsForMinimumPercent:(float)minimumPercent {
    
    unsigned int nonWhiteCount = 0;
    unsigned int whiteCount = 0;
    
    NSData *pixelData = (NSData *)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage)));
    unsigned char *allBytes = (unsigned char *)pixelData.bytes;
    
    for (unsigned int i=0; i<pixelData.length; i+=4) {
        if ((CGFloat)allBytes[i] < 1.0 || (CGFloat)allBytes[i+1] < 1.0 || (CGFloat)allBytes[i+2] < 1.0 || (CGFloat)allBytes[i+3] < 1.0) {
            nonWhiteCount ++;
        }
        else {
            whiteCount ++;
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
    return image;
}

@end
