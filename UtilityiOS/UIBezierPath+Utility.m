//
//  UIBezierPath+Utility.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "UIBezierPath+Utility.h"

@implementation UIBezierPath (Utility)

+ (UIBezierPath *)bezierPathForPoints:(NSArray<NSValue *> *)points {
    if (points.count < 3) {
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

@end
