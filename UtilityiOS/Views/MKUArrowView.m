//
//  MKUArrowView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-02-13.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUArrowView.h"
#import "UIBezierPath+Utility.h"

@implementation MKUArrowView

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [UIBezierPath drawArrowBezierPathInRect:rect angle:self.angle color:self.color margin:self.margin depth:self.depth];
}

@end
