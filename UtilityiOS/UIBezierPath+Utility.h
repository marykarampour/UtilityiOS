//
//  UIBezierPath+Utility.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShapeType) {
    ShapeTypeRect,
    ShapeTypeRectFill,
    ShapeTypeRoundedRect,
    ShapeTypeRoundedRectFill,
    ShapeTypeEllipse,
    ShapeTypeEllipseFill,
    ShapeTypeTriangleRightTop,
    ShapeTypeTriangleLeftTop,
    ShapeTypeTriangleRightBottom,
    ShapeTypeTriangleLeftBottom
};

@interface UIBezierPath (Utility)

+ (UIBezierPath *)bezierPathForPoints:(NSArray<NSValue *> *)points;
+ (UIBezierPath *)starBezierPathForPolygon:(NSUInteger)vertexCount ofSize:(CGFloat)size;

/** @brief draws a bezier path inside th given rect
 @param margin padding for drawing the arrow in view's frame
 */
+ (void)drawArrowBezierPathInRect:(CGRect)rect angle:(CGFloat)angle color:(UIColor *)color margin:(CGFloat)margin depth:(CGFloat)depth;

@end
