//
//  MKURadioButtonView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKURadioButtonViewProtocol.h"
#import "MKUMultiLabelViewController.h"

@class MKURadioButtonView;

typedef NS_ENUM(NSUInteger, MKU_RADIO_BUTTON_ALIGNMENT) {
    MKU_RADIO_BUTTON_ALIGNMENT_LEFT,
    MKU_RADIO_BUTTON_ALIGNMENT_RIGHT
};

@interface MKURadioButtonView : MKUMultiLabelViewController <UIImageView *, UIImageView *> <MKUControlProtocol>

@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *deselectedImage;
@property (nonatomic, strong) UIImage *disabledSelectedImage;
@property (nonatomic, strong) UIImage *disabledDeselectedImage;
/** @brief If nil, userInteractionEnabled will be disabled. */
@property (nonatomic, weak) id<MKURadioButtonViewProtocol> delegate;

/** @brief Uses insets for the checkbox. labelsCount = 1. */
- (instancetype)initWithInsets:(UIEdgeInsets)insets;
/** @brief Uses inset for the checkbox. labelsCount = 1. */
- (instancetype)initWithInset:(CGFloat)inset;
/** @brief Uses insets for the checkbox. labelsCount = 1. */
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment insets:(UIEdgeInsets)insets;
/** @brief Uses insets for the checkbox. labelsCount = 1. */
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment verticalAlignment:(MULTILABEL_VERTICAL_ALIGNMENT)verticalAlignment insets:(UIEdgeInsets)insets;
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment;
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment verticalAlignment:(MULTILABEL_VERTICAL_ALIGNMENT)verticalAlignment;

/** @brief Uses insets for the checkbox. */
- (instancetype)initWithInsets:(UIEdgeInsets)insets labelsCount:(NSUInteger)labelsCount;
/** @brief Uses insets for the checkbox. */
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets;
/** @brief Uses insets for the checkbox. */
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment labelsCount:(NSUInteger)labelsCount verticalAlignment:(MULTILABEL_VERTICAL_ALIGNMENT)verticalAlignment insets:(UIEdgeInsets)insets;
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment labelsCount:(NSUInteger)labelsCount;
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment labelsCount:(NSUInteger)labelsCount verticalAlignment:(MULTILABEL_VERTICAL_ALIGNMENT)verticalAlignment;

- (void)setIndexPath:(NSIndexPath *)indexPath;
- (void)setMultiline;
- (NSIndexPath *)indexPath;

+ (MKURadioButtonView *)enabledRadioButtonWithTitle:(NSString *)title;

@end


