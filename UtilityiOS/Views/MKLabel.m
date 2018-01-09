//
//  MKLabel.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKLabel.h"

@implementation MKLabel

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += [Constants TextPadding]*2;
    size.height += [Constants TextPadding]*2;
    return size;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake([Constants TextPadding], [Constants TextPadding], [Constants TextPadding], [Constants TextPadding]);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
