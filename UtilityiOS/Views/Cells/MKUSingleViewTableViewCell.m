//
//  MKUSingleViewTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-25.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUSingleViewTableViewCell.h"
#import "UIView+Utility.h"

@implementation MKUSingleViewTableViewCell

+ (NSString *)identifierForViewClass:(Class)cls {
    return [NSString stringWithFormat:@"k%@-%@Identifier", NSStringFromClass(self), NSStringFromClass(cls)];
}

- (instancetype)init {
    return [self initWithInsets:UIEdgeInsetsZero];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets {
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.insets = insets;
        [self constructView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self constructView];
    }
    return self;
}

- (instancetype)initWithViewCreationHandler:(VIEW_CREATION_HANDLER)handler {
    return [self initWithInsets:UIEdgeInsetsZero viewCreationHandler:handler];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets viewCreationHandler:(VIEW_CREATION_HANDLER)handler {
    return [self initWithStyle:UITableViewCellStyleDefault insets:insets viewCreationHandler:handler];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style insets:(UIEdgeInsets)insets viewCreationHandler:(VIEW_CREATION_HANDLER)handler {
    
    UIView *view = handler();
    
    if (self = [super initWithStyle:style reuseIdentifier:[self.class identifierForViewClass:[view class]]]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.insets = insets;
        [self setView:view];
    }
    return self;
}

- (void)setView:(__kindof UIView *)view {
    [UIView setContentView:view forSuperview:self.contentView insets:self.insets setterHandler:^{
        [self.view removeFromSuperview];
        _view = view;
    }];
}

- (void)constructView {
    self.view = [[UIView alloc] init];
}

@end

