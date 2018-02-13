//
//  MKArrowView.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-13.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKArrowView.h"

@implementation MKArrowView

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGRect frame = CGRectMake(self.margin, self.margin, rect.size.width-2*self.margin, rect.size.height-2*self.margin);
    CGPoint center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
    CGPoint point = CGPointMake(frame.size.width, frame.size.height/2.0);
    CGFloat arrowDepth = 6.0;
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, center.x, center.y);
    CGPathAddLineToPoint(pathRef, NULL, point.x, point.y);
    
    CGPathMoveToPoint(pathRef, NULL, point.x-arrowDepth, point.y-arrowDepth);
    CGPathAddLineToPoint(pathRef, NULL, point.x, point.y);
    CGPathAddLineToPoint(pathRef, NULL, point.x-arrowDepth, point.y+arrowDepth);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:pathRef];
    CGPathRelease(pathRef);
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-center.x, -center.y);
    [path applyTransform:transform];
    transform = CGAffineTransformMakeRotation(self.angle);
    [path applyTransform:transform];
    transform = CGAffineTransformMakeTranslation(center.x, center.y);
    [path applyTransform:transform];
    
    [self.color setStroke];
    [path setLineWidth:2.0];
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
}

@end
