//
//  MKUSingleViewTableViewHeaderFooterView.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUTableViewHeaderFooterView.h"

@interface MKUSingleViewTableViewHeaderFooterView <__covariant ViewType : __kindof UIView *> : MKUTableViewHeaderFooterView

@property (nonatomic, strong) ViewType view;
@property (nonatomic, assign) UIEdgeInsets insets;

- (instancetype)initWithInsets:(UIEdgeInsets)insets;
- (instancetype)initWithViewCreationHandler:(VIEW_CREATION_HANDLER)handler;
- (instancetype)initWithInsets:(UIEdgeInsets)insets viewCreationHandler:(VIEW_CREATION_HANDLER)handler;

- (void)constructView;

@end

