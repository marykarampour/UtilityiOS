//
//  MKURadioButtonView.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKULabel.h"
#import "MKUViewProtocol.h"

@class MKURadioButtonView;

typedef NS_ENUM(NSUInteger, MKU_RADIO_BUTTON_ALIGNMENT) {
    MKU_RADIO_BUTTON_ALIGNMENT_LEFT,
    MKU_RADIO_BUTTON_ALIGNMENT_RIGHT
};

typedef NS_ENUM(NSUInteger, MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT) {
    MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT_CENTER_Y,
    MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT_TOP,
    MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT_BOTTOM
};

@protocol MKURadioButtonViewProtocol <NSObject>

@optional
- (void)radioButton:(MKURadioButtonView *)view didSetOn:(BOOL)on;

@end

@interface MKURadioButtonView : UIView <MKUControlProtocol>

@property (nonatomic, assign) BOOL on;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign, readonly) MKU_RADIO_BUTTON_ALIGNMENT alignment;
/** @brief Default is MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT_CENTER_Y */
@property (nonatomic, assign, readonly) MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT verticalAlignment;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *deselectedImage;
@property (nonatomic, strong) UIImage *disabledSelectedImage;
@property (nonatomic, strong) UIImage *disabledDeselectedImage;
@property (nonatomic, strong, readonly) MKULabel *titleLabel;
/** @brief If nil, userInteractionEnabled will be disabled. */
@property (nonatomic, weak) id<MKURadioButtonViewProtocol> delegate;

/** @brief Uses insets for the checkbox. */
- (instancetype)initWithCheckboxInset:(CGFloat)inset;
/** @brief Uses insets for the checkbox. */
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment checkboxInset:(CGFloat)inset;
/** @brief Uses insets for the checkbox. */
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment verticalAlignment:(MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT)verticalAlignment  checkboxInset:(CGFloat)inset;
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment;
- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment verticalAlignment:(MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT)verticalAlignment;
/** @param target If nil, userInteractionEnabled will be disabled. */
- (void)addTarget:(id)target action:(SEL)action;
- (void)setIndexPath:(NSIndexPath *)indexPath;
- (void)setMultiline;
- (NSIndexPath *)indexPath;

+ (MKURadioButtonView *)enabledRadioButtonWithTitle:(NSString *)title;

@end


