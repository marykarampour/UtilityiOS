//
//  UIBezierPath+Utility.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "UIBezierPath+Utility.h"
#import "MKMath.h"

@implementation UIBezierPath (Utility)

+ (UIBezierPath *)bezierPathForPoints:(NSArray<NSValue *> *)points {
    if (points.count < 2) {
        return nil;
    }
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    for (NSValue *value in points) {
        CGPoint point = [value CGPointValue];
        if ([value isEqualToValue:points.firstObject]) {
            CGPathMoveToPoint(pathRef, NULL, point.x, point.y);
        }
        else {
            CGPathAddLineToPoint(pathRef, NULL, point.x, point.y);
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:pathRef];
    CGPathRelease(pathRef);
    return path;
}

+ (UIBezierPath *)starBezierPathForPolygon:(NSUInteger)vertexCount ofSize:(CGFloat)size {
    ValueArr *vertices = [MKMath verticesForPolygon:vertexCount ofSize:size];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    NSUInteger currentVertexIndex = 0;
    NSUInteger skipIndex = (int)((vertexCount-1)/2);
    CGPoint initialVertex = [vertices[currentVertexIndex] CGPointValue];
    CGPathMoveToPoint(pathRef, NULL, initialVertex.x, initialVertex.y);
    
    do {
        CGPoint vertex = [vertices[currentVertexIndex] CGPointValue];
        CGPathAddLineToPoint(pathRef, NULL, vertex.x, vertex.y);
        currentVertexIndex = (currentVertexIndex + skipIndex)%vertexCount;
    } while (currentVertexIndex > 0);
    
    CGPathAddLineToPoint(pathRef, NULL, initialVertex.x, initialVertex.y);
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:pathRef];
    CGPathRelease(pathRef);
    return path;
}

+ (void)drawArrowBezierPathInRect:(CGRect)rect angle:(CGFloat)angle color:(UIColor *)color margin:(CGFloat)margin depth:(CGFloat)depth {
    CGRect frame = CGRectMake(margin, margin, rect.size.width-2*margin, rect.size.height-2*margin);
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    CGPoint point = CGPointMake(rect.size.width - margin, rect.size.height/2.0);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, frame.origin.x, point.y);
    CGPathAddLineToPoint(pathRef, NULL, point.x, point.y);
    
    CGPathMoveToPoint(pathRef, NULL, point.x-depth, point.y-depth);
    CGPathAddLineToPoint(pathRef, NULL, point.x, point.y);
    CGPathAddLineToPoint(pathRef, NULL, point.x-depth, point.y+depth);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:pathRef];
    CGPathRelease(pathRef);
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(center.x, center.y);
    transform = CGAffineTransformRotate(transform, angle);
    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
    [path applyTransform:transform];
    
    [path setLineWidth:2.0];
    path.lineJoinStyle = kCGLineJoinRound;
    [color setStroke];
    [path stroke];
}

@end
