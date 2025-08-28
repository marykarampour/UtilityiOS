//
//  MKUHeaderLabel.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKULabel.h"

typedef NS_ENUM(NSUInteger, MKU_ACCESSORY_VIEW_TYPE) {
    MKU_ACCESSORY_VIEW_TYPE_DEFAULT,
    MKU_ACCESSORY_VIEW_TYPE_BOLD
};

@interface MKUAccessoryLabel : MKULabel

/** @brief A header with attributed title based on type or nil if title is empty. */
+ (instancetype)headerWithTitle:(NSString *)title type:(MKU_ACCESSORY_VIEW_TYPE)type;
/** @brief A header with attributed title based on type or nil if title is empty. */
+ (instancetype)headerWithAttributedTitle:(NSAttributedString *)attributedString;
/** @brief A header with attributed title based on type or nil if title is empty. */
+ (instancetype)headerWithAttributedTitle:(NSAttributedString *)attributedString backgroundColor:(UIColor *)backgroundColor;
- (void)setTitle:(NSString *)title type:(MKU_ACCESSORY_VIEW_TYPE)type;
- (void)setAttributedTitle:(NSAttributedString *)attributedString backgroundColor:(UIColor *)backgroundColor;

@end

@interface MKUPaddingLabel <__covariant ViewType : MKULabel *> : UIView

@property (nonatomic, strong, readonly) ViewType titleLabel;

- (instancetype)initWithInsets:(UIEdgeInsets)insets;
- (instancetype)initWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets;

@end

