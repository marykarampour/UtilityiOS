//
//  UIBezierPath+Utility.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-02-07.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Utility)

+ (UIBezierPath *)bezierPathForPoints:(NSArray<NSValue *> *)points;
+ (UIBezierPath *)starBezierPathForPolygon:(NSUInteger)vertexCount ofSize:(CGFloat)size;

@end
