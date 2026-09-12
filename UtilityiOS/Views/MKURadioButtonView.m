//
//  MKURadioButtonView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKURadioButtonView.h"
#import "MKURadioButtonView.h"
#import "UIView+IndexPath.h"
#import "NSObject+Utility.h"
#import "UIView+Utility.h"
#import "MKUAssets.h"

@interface MKURadioButtonView ()

@end

@implementation MKURadioButtonView

- (instancetype)init {
    return [self initWithAlignment:MKU_RADIO_BUTTON_ALIGNMENT_LEFT];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets {
    return [self initWithInsets:insets labelsCount:1];
}

- (instancetype)initWithInset:(CGFloat)inset {
    return [self initWithInsets:[NSObject insets:inset]];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets labelsCount:(NSUInteger)labelsCount {
    return [self initWithAlignment:MKU_RADIO_BUTTON_ALIGNMENT_LEFT labelsCount:labelsCount insets:insets];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment {
    return [self initWithAlignment:alignment labelsCount:1];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment labelsCount:(NSUInteger)labelsCount {
    return [self initWithAlignment:alignment labelsCount:labelsCount verticalAlignment:MULTILABEL_VERTICAL_ALIGNMENT_CENTER_Y];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment insets:(UIEdgeInsets)insets {
    return [self initWithAlignment:alignment labelsCount:1 insets:insets];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets {
    return [self initWithAlignment:alignment labelsCount:labelsCount verticalAlignment:MULTILABEL_VERTICAL_ALIGNMENT_CENTER_Y insets:insets];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment verticalAlignment:(MULTILABEL_VERTICAL_ALIGNMENT)verticalAlignment {
    return [self initWithAlignment:alignment labelsCount:1 verticalAlignment:verticalAlignment];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment labelsCount:(NSUInteger)labelsCount verticalAlignment:(MULTILABEL_VERTICAL_ALIGNMENT)verticalAlignment {
    return [self initWithAlignment:alignment labelsCount:labelsCount verticalAlignment:verticalAlignment insets:UIEdgeInsetsZero];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment verticalAlignment:(MULTILABEL_VERTICAL_ALIGNMENT)verticalAlignment insets:(UIEdgeInsets)insets {
    return [self initWithAlignment:alignment labelsCount:1 verticalAlignment:verticalAlignment insets:insets];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment labelsCount:(NSUInteger)labelsCount verticalAlignment:(MULTILABEL_VERTICAL_ALIGNMENT)verticalAlignment insets:(UIEdgeInsets)insets {
    if (self = [super init]) {
        self.selectedImage = [MKUAssets systemIconWithName:[MKUAssets Checkmark_Square_Image_Name] color:[AppTheme checkboxTintColor] size:[Constants CheckBoxSize]];
        self.deselectedImage = [MKUAssets systemIconWithName:[MKUAssets Square_Image_Name] color:[AppTheme checkboxTintColor] size:[Constants CheckBoxSize]];
        self.disabledSelectedImage = [MKUAssets systemIconWithName:[MKUAssets Checkmark_Square_Image_Name] color:[AppTheme checkboxDisabledColor] size:[Constants CheckBoxSize]];
        self.disabledDeselectedImage = [MKUAssets systemIconWithName:[MKUAssets Square_Image_Name] color:[AppTheme checkboxDisabledColor] size:[Constants CheckBoxSize]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, verticalAlignment, [Constants CheckBoxSize], [Constants CheckBoxSize])];
        imageView.contentMode = UIViewContentModeCenter;
        
        MKU_MULTI_LABEL_VIEW_TYPE type = alignment == MKU_RADIO_BUTTON_ALIGNMENT_LEFT ? MKU_MULTI_LABEL_VIEW_TYPE_LEFT : MKU_MULTI_LABEL_VIEW_TYPE_RIGHT;
        type = type | MKU_MULTI_LABEL_VIEW_TYPE_LABEL;
        UIImageView *left = alignment == MKU_RADIO_BUTTON_ALIGNMENT_LEFT ? imageView : nil;
        UIImageView *right = alignment == MKU_RADIO_BUTTON_ALIGNMENT_RIGHT ? imageView : nil;
        
        [self constructWithType:type leftView:left rightView:right labelsCount:labelsCount insets:insets];
        [self addBackView:[[UIButton alloc] init]];
        [self addTarget:self action:@selector(switchOn)];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    [self updateViews];
}

- (void)setOn:(BOOL)on {
    _on = on;
    [self updateViews];
}

- (void)switchOn {
    if (!self.enabled) return;
    
    self.on = !self.on;
    if ([self.delegate respondsToSelector:@selector(radioButton:didSetOn:)]) {
        [self.delegate radioButton:self didSetOn:self.on];
    }
}

- (void)updateViews {
    [self checkView].image = self.enabled ? (self.on ? self.selectedImage : self.deselectedImage) : (self.on ? self.disabledSelectedImage : self.disabledDeselectedImage);
}

- (void)setDelegate:(id<MKURadioButtonViewProtocol>)delegate {
    _delegate = delegate;
    self.backView.userInteractionEnabled = delegate;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    self.backView.indexPath = indexPath;
}

- (NSIndexPath *)indexPath {
    return self.backView.indexPath;
}

- (UIImageView *)checkView {
    return (self.leftView ? self.leftView : self.rightView).view;
}

+ (MKURadioButtonView *)enabledRadioButtonWithTitle:(NSString *)title {
    MKURadioButtonView *view = [[MKURadioButtonView alloc] init];
    view.enabled = YES;
    [view labelAtIndex:0].text = title;
    [view labelAtIndex:0].adjustsFontSizeToFitWidth = YES;
    [view labelAtIndex:0].minimumScaleFactor = 0.8;
    return view;
}

@end
