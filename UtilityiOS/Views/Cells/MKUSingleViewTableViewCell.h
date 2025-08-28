//
//  MKUSingleViewTableViewCell.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-25.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUBaseTableViewCell.h"

@interface MKUSingleViewTableViewCell <__covariant ViewType : __kindof UIView *> : MKUBaseTableViewCell

@property (nonatomic, strong) ViewType view;
@property (nonatomic, assign) UIEdgeInsets insets;

- (instancetype)initWithInsets:(UIEdgeInsets)insets;
- (instancetype)initWithViewCreationHandler:(VIEW_CREATION_HANDLER)handler;
- (instancetype)initWithInsets:(UIEdgeInsets)insets viewCreationHandler:(VIEW_CREATION_HANDLER)handler;
- (instancetype)initWithStyle:(UITableViewCellStyle)style insets:(UIEdgeInsets)insets viewCreationHandler:(VIEW_CREATION_HANDLER)handler;

- (void)constructView;

@end
