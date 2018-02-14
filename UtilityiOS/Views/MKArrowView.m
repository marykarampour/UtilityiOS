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
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    CGPoint point = CGPointMake(rect.size.width - self.margin, rect.size.height/2.0);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, frame.origin.x, point.y);
    CGPathAddLineToPoint(pathRef, NULL, point.x, point.y);
    
    CGPathMoveToPoint(pathRef, NULL, point.x-self.depth, point.y-self.depth);
    CGPathAddLineToPoint(pathRef, NULL, point.x, point.y);
    CGPathAddLineToPoint(pathRef, NULL, point.x-self.depth, point.y+self.depth);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:pathRef];
    CGPathRelease(pathRef);
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(center.x, center.y);
    transform = CGAffineTransformRotate(transform, self.angle);
    transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
    [path applyTransform:transform];
    
    [self.color setStroke];
    [path setLineWidth:2.0];
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
}

@end
