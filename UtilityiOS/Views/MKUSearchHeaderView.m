//
//  MKUSearchHeaderView.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-26.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUSearchHeaderView.h"
#import "UIView+Utility.h"

@interface MKUSearchHeaderView ()

@property (nonatomic, strong) UIView *backView;

@end

@implementation MKUSearchHeaderView

- (instancetype)init {
    return [self initWithInsets:UIEdgeInsetsZero viewCreationHandler:^UIView *{
        return nil;
    }];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets viewCreationHandler:(VIEW_CREATION_HANDLER)handler {
    if (self = [super init]) {
        self.insets = insets;
        [self initBase];
        [self constraintViews];
        [self setBottomView:handler()];
    }
    return self;
}

- (void)setBottomView:(__kindof UIView *)bottomView {
    _bottomView = bottomView;
    
    [self.backView removeAllSubviews];
    if (!bottomView) return;
    
    [self.backView addSubview:bottomView];
    [self.backView removeConstraintsMask];
    [self.backView constraintSidesForView:bottomView insets:self.insets];
}

+ (CGFloat)defaultHeight {
    return 52.0;
}

- (CGFloat)estimatedHeight {
    return [self.class defaultHeight] + self.insets.top + self.insets.bottom;
}

- (void)constraintViews {
    [self removeConstraintsMask];
    [self constraintVertically:@[self.searchBar, self.backView] interItemMargin:0.0 horizontalMargin:0.0 verticalMargin:0.0];
}

- (void)initBase {
    self.backgroundColor = [AppTheme searchBarTintColor];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.backView = [[UIView alloc] init];
    
    [self addSubview:self.searchBar];
    [self addSubview:self.backView];
}

- (void)reset {
}

@end

