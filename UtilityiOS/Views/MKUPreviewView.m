//
//  MKUPreviewView.m
//  Serafa
//
//  Created by Maryam Karampour on 2018-04-08.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUPreviewView.h"
#import "UIView+Utility.h"

static CGFloat const PADDING = 8.0;
static CGFloat const BUTTON_HEIGHT = 28.0;

@implementation MKUPreviewView

- (instancetype)init {
    if (self = [super init]) {
        self.leftButton = [[UIButton alloc] init];
        self.leftButton.backgroundColor = [UIColor clearColor];
        [self.leftButton sizeToFit];
        
        self.rightButton = [[UIButton alloc] init];
        self.rightButton.backgroundColor = [UIColor clearColor];
        [self.rightButton sizeToFit];
        
        self.view = [[WKWebView alloc] init];
        self.view.contentMode = UIViewContentModeCenter;
        self.view.backgroundColor = [UIColor clearColor];
        self.view.scrollView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.view];
        
        [self removeConstraintsMask];
        
        [self constraint:NSLayoutAttributeTop view:self.leftButton margin:PADDING];
        [self constraint:NSLayoutAttributeLeft view:self.leftButton margin:PADDING];
        [self constraint:NSLayoutAttributeRight view:self.rightButton margin:-PADDING];
        
        [self constraintHeight:BUTTON_HEIGHT forView:self.leftButton];
        [self constraintSame:NSLayoutAttributeHeight view1:self.leftButton view2:self.rightButton];
        [self constraintSame:NSLayoutAttributeTop view1:self.leftButton view2:self.rightButton];
        
        [self constraint:NSLayoutAttributeLeft view:self.view margin:PADDING];
        [self constraint:NSLayoutAttributeRight view:self.view margin:-PADDING];
        [self constraint:NSLayoutAttributeBottom view:self.view margin:-PADDING];
        
        [self addConstraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.leftButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:PADDING];
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.67];
    }
    return self;
}

@end
