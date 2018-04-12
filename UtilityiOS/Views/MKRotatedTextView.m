//
//  MKRotatedTextLabel.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-03-28.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKRotatedTextView.h"
#import "UIView+Utility.h"

@implementation MKRotatedTextLabel

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self rotateAttributedText:self.attributedText angle:self.angle rect:rect alignCenter:NO];
}

@end


@implementation MKRotatedTextButton

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self rotateAttributedText:self.titleLabel.attributedText angle:self.angle rect:rect alignCenter:YES];
}

@end
