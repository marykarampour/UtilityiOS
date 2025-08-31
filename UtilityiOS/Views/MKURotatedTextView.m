//
//  MKURotatedTextLabel.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-05-04.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKURotatedTextView.h"
#import "UIView+Utility.h"

@implementation MKURotatedTextLabel

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self rotateAttributedText:self.attributedText angle:self.angle rect:rect alignCenter:NO];
}

@end


@implementation MKURotatedTextButton

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self rotateAttributedText:self.titleLabel.attributedText angle:self.angle rect:rect alignCenter:YES];
}

@end
