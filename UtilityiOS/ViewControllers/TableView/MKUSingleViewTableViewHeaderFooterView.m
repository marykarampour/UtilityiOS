//
//  MKUSingleViewTableViewHeaderFooterView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUSingleViewTableViewHeaderFooterView.h"
#import "UIView+Utility.h"

@implementation MKUSingleViewTableViewHeaderFooterView

- (instancetype)initWithInsets:(UIEdgeInsets)insets {
    if (self = [super init]) {
        self.insets = insets;
        [self initBase];
        [self constructView];
    }
    return self;
}

- (instancetype)initWithViewCreationHandler:(VIEW_CREATION_HANDLER)handler {
    return [self initWithInsets:UIEdgeInsetsZero viewCreationHandler:handler];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets viewCreationHandler:(VIEW_CREATION_HANDLER)handler {
    if (self = [super init]) {
        self.insets = insets;
        [self initBase];
        [self setView:handler()];
    }
    return self;
}

- (void)setView:(__kindof UIView *)view {
    [UIView setContentView:view forSuperview:self.contentView insets:self.insets setterHandler:^{
        [self.view removeFromSuperview];
        _view = view;
    }];
}

- (void)initBase {
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
}

- (void)constructView {
    self.view = [[UIView alloc] init];
}


@end
