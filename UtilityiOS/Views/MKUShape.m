//
//  MKUShape.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-03-05.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUShape.h"

@implementation MKUShape

- (instancetype)initWithType:(ShapeType)type color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    if (self = [super init]) {
        self.type = type;
        self.color = color;
        self.cornerRadius = cornerRadius;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (MKUShape *)shapeWithType:(ShapeType)type color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    return [[MKUShape alloc] initWithType:type color:color cornerRadius:cornerRadius];
}

- (void)drawRect:(CGRect)rect {
    [self drawShapeInRect:rect shape:self.type color:self.color cornerRadius:self.cornerRadius];
}

- (void)drawShapeInRect:(CGRect)rect shape:(ShapeType)type color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius{
    switch (type) {
        case ShapeTypeEllipse: {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, [Constants BorderWidth]);
            CGContextSetStrokeColor(context, CGColorGetComponents(color.CGColor));
            CGContextStrokeEllipseInRect(context, rect);
        }
            break;
        case ShapeTypeEllipseFill: {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
            CGContextFillEllipseInRect(context, rect);
        }
            break;
        case ShapeTypeRect: {
            self.layer.borderColor = color.CGColor;
            self.layer.borderWidth = [Constants BorderWidth];
        }
            break;
        case ShapeTypeRoundedRect: {
            self.layer.borderColor = color.CGColor;
            self.layer.borderWidth = [Constants BorderWidth];
            self.layer.cornerRadius = cornerRadius;
        }
            break;
        case ShapeTypeRoundedRectFill: {
            self.backgroundColor = color;
            self.layer.cornerRadius = cornerRadius;
        }
            break;
        case ShapeTypeTriangleRightTop:
        case ShapeTypeTriangleRightBottom:
        case ShapeTypeTriangleLeftTop:
        case ShapeTypeTriangleLeftBottom: {
            CGPoint TL = CGPointMake(rect.origin.x, rect.origin.y);
            CGPoint TR = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
            CGPoint BL = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
            CGPoint BR = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            CGMutablePathRef pathRef = CGPathCreateMutable();
            
            switch (type) {
                case ShapeTypeTriangleRightTop: {
                    CGPathMoveToPoint(pathRef, NULL, TL.x, TL.y);
                    CGPathAddLineToPoint(pathRef, NULL, TR.x, TR.y);
                    CGPathAddLineToPoint(pathRef, NULL, BR.x, BR.y);
                }
                    break;
                case ShapeTypeTriangleRightBottom: {
                    CGPathMoveToPoint(pathRef, NULL, BL.x, BL.y);
                    CGPathAddLineToPoint(pathRef, NULL, TR.x, TR.y);
                    CGPathAddLineToPoint(pathRef, NULL, BR.x, BR.y);
                }
                    break;
                case ShapeTypeTriangleLeftTop: {
                    CGPathMoveToPoint(pathRef, NULL, TL.x, TL.y);
                    CGPathAddLineToPoint(pathRef, NULL, TR.x, TR.y);
                    CGPathAddLineToPoint(pathRef, NULL, BL.x, BL.y);
                }
                    break;
                case ShapeTypeTriangleLeftBottom: {
                    CGPathMoveToPoint(pathRef, NULL, TL.x, TL.y);
                    CGPathAddLineToPoint(pathRef, NULL, BR.x, BR.y);
                    CGPathAddLineToPoint(pathRef, NULL, BL.x, BL.y);
                }
                    break;
                default:
                    break;
            }
            UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:pathRef];
            CGPathRelease(pathRef);
            [color setFill];
            [path fill];
        }
            break;
        case ShapeTypeRectFill:
        default: {
            self.backgroundColor = color;
        }
            break;
    }
}


@end
