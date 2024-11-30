//
//  MKUDrawingView.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-03-28.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUDrawingView.h"
#import "MKUMath.h"

@implementation MKUBezierPath

- (instancetype)init {
    if (self = [super init]) {
        self.path = [[UIBezierPath alloc] init];
        [self.path setLineCapStyle:kCGLineCapRound];
    }
    return self;
}

@end

@interface MKUDrawingView ()

@property (nonatomic, strong) NSMutableArray<MKUBezierPath *> *paths;

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation MKUDrawingView

- (instancetype)init {
    if (self = [super init]) {
        self.paths = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UIImage *)image {
    CGColorRef borderColor = self.layer.borderColor;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.layer.borderColor = borderColor;
    return img;
}

- (void)clearView {
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.currentPoint = [touch locationInView:self];
    self.firstPoint = [touch previousLocationInView:self];
    
    MKUBezierPath *path = [[MKUBezierPath alloc] init];
    path.color = [UIColor blackColor];
    path.lineWidth = 2.0;
    [path.path moveToPoint:self.currentPoint];
    [self.paths addObject:path];
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.currentPoint = [touch locationInView:self];
    self.firstPoint = [touch previousLocationInView:self];
    
    CGPoint mid2 = [MKUMath midPointOfPoint:self.currentPoint andPoint:self.firstPoint];
    
    [self.paths.lastObject.path addQuadCurveToPoint:mid2 controlPoint:self.firstPoint];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(touchesEndedWithImage:)]) {
        [self.delegate touchesEndedWithImage:[self image]];
    }
}

- (void)drawRect:(CGRect)rect {
    for (MKUBezierPath *path in self.paths) {
        [path.color setStroke];
        [path.path setLineWidth:path.lineWidth];
        [path.path stroke];
    }
}

@end
