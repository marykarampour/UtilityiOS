//
//  MKDrawingView.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-03-28.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKDrawingView.h"
#import "MKMath.h"

@implementation MKBezierPath

- (instancetype)init {
    if (self = [super init]) {
        self.path = [[UIBezierPath alloc] init];
        [self.path setLineCapStyle:kCGLineCapRound];
    }
    return self;
}

@end

@interface MKDrawingView ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray<MKBezierPath *> *paths;

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation MKDrawingView

- (instancetype)init {
    if (self = [super init]) {
        self.image = [[UIImage alloc] init];
        self.paths = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UIImage *)image {
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    return img;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.currentPoint = [touch locationInView:self];
    self.firstPoint = [touch previousLocationInView:self];
    
    MKBezierPath *path = [[MKBezierPath alloc] init];
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
    
    CGPoint mid2 = [MKMath midPointOfPoint:self.currentPoint andPoint:self.firstPoint];
    
    [self.paths.lastObject.path addQuadCurveToPoint:mid2 controlPoint:self.firstPoint];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
}

- (void)drawRect:(CGRect)rect {
    for (MKBezierPath *path in self.paths) {
        [path.color setStroke];
        [path.path setLineWidth:path.lineWidth];
        [path.path stroke];
    }
}

@end
