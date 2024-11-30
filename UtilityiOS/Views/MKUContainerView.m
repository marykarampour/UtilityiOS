//
//  MKUContainerView.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUContainerView.h"
#import "UIView+Utility.h"

@interface MKUContainerView ()

@property (nonatomic, assign) UIEdgeInsets insets;

@end

@implementation MKUContainerView

- (instancetype)initWithViewCreationHandler:(VIEW_CREATION_HANDLER)handler {
    return [self initWithInsets:UIEdgeInsetsZero viewCreationHandler:handler];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets viewCreationHandler:(VIEW_CREATION_HANDLER)handler {
    if (self = [super init]) {
        self.insets = insets;
        self.view = handler();
    }
    return self;
}

- (void)setView:(UIView *)view {
    [UIView setContentView:view forSuperview:self insets:self.insets setterHandler:^{
        [self.view removeFromSuperview];
        _view = view;
    }];
}

@end

