//
//  UIColor+Utility.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-02.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation MKUColorComponents

- (instancetype)init {
    if (self = [super init]) {
        self.alpha = 1.0;
    }
    return self;
}

+ (instancetype)colorComponentsWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    MKUColorComponents *color = [[MKUColorComponents alloc] init];
    color.red = red;
    color.green = green;
    color.blue = blue;
    color.alpha = alpha;
    return color;
}

+ (instancetype)colorComponentsWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [self colorComponentsWithRed:red green:green blue:blue alpha:1.0];
}

+ (instancetype)colorComponentsWithRGBHEX:(UInt32)value alpha:(CGFloat)alpha {
    return [self colorComponentsWithRed:((float)((value & 0xff0000) >> 16)) / 255.0
                                  green:((float)((value & 0x00ff00) >>  8)) / 255.0
                                   blue:((float)((value & 0x0000ff) >>  0)) / 255.0
                                  alpha:alpha];
}

- (BOOL)isValid {
    return 0 <= self.red && 0 <= self.green && 0 <= self.blue && 0 < self.alpha;
}

@end

@implementation UIColor (Utility)

+ (UIColor *)colorWithRGB:(UInt32)hexValue {
    return [UIColor colorWithRGB:hexValue alpha:1.0];
}

+ (UIColor *)colorWithRGB:(UInt32)hexValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hexValue & 0xff0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0x00ff00) >>  8)) / 255.0
                            blue:((float)((hexValue & 0x0000ff) >>  0)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithRGBString:(NSString *)hexString {
    return [self colorWithRGBString:hexString alpha:1.0];
}

+ (UIColor *)colorWithRGBString:(NSString *)hexString alpha:(CGFloat)alpha {
    UInt32 value = [self intFromHexString:hexString];
    return [self colorWithRGB:value alpha:alpha];
}

+ (UInt32)intFromHexString:(NSString *)hexString {
    
    UInt32 hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexInt];
    return hexInt;
}

+ (UIColor *)randomColor {
    
    CGFloat red = arc4random_uniform(255)/255.0;
    CGFloat green = arc4random_uniform(255)/255.0;
    CGFloat blue = arc4random_uniform(255)/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

#pragma mark - images

- (UIImage *)pixelImage {
    return [self rectImageWithSize:CGSizeMake(1.0, 1.0)];
}

- (UIImage *)rectImageWithSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)circleImageWithRadius:(CGFloat)radius {
    return [self circleImageWithRadius:radius borderColor:nil];
}

- (UIImage *)circleImageWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor {
    return [self circleImageWithRadius:radius borderColor:borderColor borderWidth:1.0];
}

- (UIImage *)circleImageWithRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    CGRect rect = CGRectMake(0.0, 0.0, 2*radius, 2*radius);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (borderColor) {
        if (borderWidth > 4.0) {
            
            UIBezierPath *borderPath = [UIBezierPath bezierPathWithOvalInRect:rect];
            CGContextSetFillColorWithColor(context, borderColor.CGColor);
            [borderPath fill];
            
            CGFloat borderRadius = radius - borderWidth;
            CGRect borderRect = CGRectMake(borderWidth, borderWidth, 2*borderRadius, 2*borderRadius);
            
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:borderRect];
            CGContextSetFillColorWithColor(context, self.CGColor);
            [path fill];
        }
        else {
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
            CGContextSetFillColorWithColor(context, self.CGColor);
            [path fill];
            
            CGContextSetLineWidth(context, borderWidth);
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            [path stroke];
        }
    }
    else {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        CGContextSetFillColorWithColor(context, self.CGColor);
        [path fill];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)ringImageWithInnerRadius:(CGFloat)innerRadius outerRadius:(CGFloat)outerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    
    CGFloat ringSize = outerRadius - innerRadius;
    CGFloat ringRadius = outerRadius - ringSize/2.0;
    CGFloat borderRadius = outerRadius - borderWidth/2.0;
    CGRect outerRect = CGRectMake(0.0, 0.0, 2*outerRadius, 2*outerRadius);
    CGRect borderRect = CGRectMake(borderWidth/2.0, borderWidth/2.0, 2*borderRadius, 2*borderRadius);
    CGRect innerRect = CGRectMake(ringSize/2.0, ringSize/2.0, 2*ringRadius, 2*ringRadius);
    
    UIGraphicsBeginImageContext(outerRect.size);
    
    if (borderColor) {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:innerRect];
        [self setStroke];
        path.lineWidth = ringSize;
        path.lineCapStyle = kCGLineCapRound;
        [path stroke];
        
        UIBezierPath *outerPath = [UIBezierPath bezierPathWithOvalInRect:borderRect];
        [borderColor setStroke];
        outerPath.lineWidth = 2.0;
        outerPath.lineCapStyle = kCGLineCapRound;
        [outerPath stroke];
    }
    else {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:innerRect];
        [self setStroke];
        path.lineWidth = ringSize;
        path.lineCapStyle = kCGLineCapRound;
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (MKUColorComponents *)colorComponents {
    
    MKUColorComponents *comps = [[MKUColorComponents alloc] init];
    
    const CGFloat *colors = CGColorGetComponents(self.CGColor);
    size_t count = CGColorGetNumberOfComponents(self.CGColor);
    
    if (0 < count) {
        comps.red = colors[0];
        if (1 < count) {
            comps.green = colors[1];
            if (2 < count) {
                comps.blue = colors[2];
                if (3 < count) {
                    comps.alpha = colors[3];
                }
            }
        }
    }
    
    return comps;
}

+ (UIColor *)inkBlueColor {
    return [self colorWithRGB:kInkBlueHEXValue];
}

@end
