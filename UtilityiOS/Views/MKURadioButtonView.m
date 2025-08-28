//
//  MKURadioButtonView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKURadioButtonView.h"
#import "MKURadioButtonView.h"
#import "UIControl+IndexPath.h"
#import "UIView+Utility.h"
#import "MKUAssets.h"

static CGFloat const CHECK_SIZE = 40.0;

@interface MKURadioButtonView ()

@property (nonatomic, assign, readwrite) MKU_RADIO_BUTTON_ALIGNMENT alignment;
@property (nonatomic, assign, readwrite) MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT verticalAlignment;
@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong, readwrite) MKULabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation MKURadioButtonView

- (instancetype)init {
    return [self initWithAlignment:MKU_RADIO_BUTTON_ALIGNMENT_LEFT];
}

- (instancetype)initWithCheckboxInset:(CGFloat)inset {
    return [self initWithAlignment:MKU_RADIO_BUTTON_ALIGNMENT_LEFT checkboxInset:inset];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment {
    return [self initWithAlignment:alignment verticalAlignment:MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT_CENTER_Y];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment checkboxInset:(CGFloat)inset {
    return [self initWithAlignment:alignment verticalAlignment:MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT_CENTER_Y checkboxInset:inset];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment verticalAlignment:(MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT)verticalAlignment {
    return [self initWithAlignment:alignment verticalAlignment:verticalAlignment checkboxInset:[Constants HorizontalSpacing]];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment verticalAlignment:(MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT)verticalAlignment checkboxInset:(CGFloat)inset {
    if (self = [super init]) {
        
        self.alignment = alignment;
        self.verticalAlignment = verticalAlignment;
                
        self.selectedImage = [MKUAssets systemIconWithName:[MKUAssets Checkmark_Square_Image_Name] color:[AppTheme checkboxTintColor] size:[Constants CheckBoxSize]];
        self.deselectedImage = [MKUAssets systemIconWithName:[MKUAssets Square_Image_Name] color:[AppTheme checkboxTintColor] size:[Constants CheckBoxSize]];
        self.disabledSelectedImage = [MKUAssets systemIconWithName:[MKUAssets Checkmark_Square_Image_Name] color:[AppTheme checkboxDisabledColor] size:[Constants CheckBoxSize]];
        self.disabledDeselectedImage = [MKUAssets systemIconWithName:[MKUAssets Square_Image_Name] color:[AppTheme checkboxDisabledColor] size:[Constants CheckBoxSize]];
        
        self.titleLabel = [[MKULabel alloc] init];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.minimumScaleFactor = 0.5;
        self.titleLabel.numberOfLines = 0;
        
        self.checkImageView = [[UIImageView alloc] init];
        self.checkImageView.contentMode = UIViewContentModeCenter;
        
        self.backButton = [[UIButton alloc] init];
        self.backButton.userInteractionEnabled = NO;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.checkImageView];
        [self addSubview:self.backButton];
        [self sendSubviewToBack:self.backButton];
        
        [self constraintLayoutWithCheckboxInset:inset];
        [self addSwitchTarget:self];
    }
    return self;
}

- (void)constraintLayoutWithCheckboxInset:(CGFloat)inset {
    
    [self removeConstraintsMask];
    [self constraintSidesForView:self.backButton];
    [self constraintSize:CGSizeMake(CHECK_SIZE, CHECK_SIZE) forView:self.checkImageView];
    
    if (self.verticalAlignment == MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT_CENTER_Y) {
        
        NSArray *views = self.alignment == MKU_RADIO_BUTTON_ALIGNMENT_LEFT ? @[self.checkImageView, self.titleLabel] : @[self.titleLabel, self.checkImageView];
        
        [self constraint:NSLayoutAttributeCenterY view:self.checkImageView];
        [self constraint:NSLayoutAttributeTop view:self.titleLabel margin:[Constants VerticalSpacing]];
        [self constraint:NSLayoutAttributeBottom view:self.titleLabel margin:-[Constants VerticalSpacing]];
        [self constraintHorizontally:views interItemMargin:inset horizontalMargin:inset verticalMargin:CONSTRAINT_NO_PADDING equalWidths:NO];
    }
    else {
        if (self.alignment == MKU_RADIO_BUTTON_ALIGNMENT_LEFT) {
            [self constraint:NSLayoutAttributeLeft view:self.checkImageView margin:inset];
            [self constraint:NSLayoutAttributeRight view:self.titleLabel margin:-inset];
            [self addConstraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.checkImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:inset];
        }
        else {
            [self constraint:NSLayoutAttributeRight view:self.checkImageView margin:-inset];
            [self constraint:NSLayoutAttributeLeft view:self.titleLabel margin:inset];
            [self addConstraintWithItem:self.checkImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:inset];
        }
        
        if (self.verticalAlignment == MKU_RADIO_BUTTON_VERTICAL_ALIGNMENT_TOP)
            [self constraint:NSLayoutAttributeTop view:self.checkImageView margin:inset];
        else
            [self constraint:NSLayoutAttributeBottom view:self.checkImageView margin:inset];
        
        [self constraint:NSLayoutAttributeBottom view:self.titleLabel];
        [self constraint:NSLayoutAttributeTop view:self.titleLabel];
    }
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
    self.checkImageView.image = self.enabled ? (self.on ? self.selectedImage : self.deselectedImage) : (self.on ? self.disabledSelectedImage : self.disabledDeselectedImage);
}

- (void)setDelegate:(id<MKURadioButtonViewProtocol>)delegate {
    _delegate = delegate;
    [self addSwitchTarget:delegate];
}

- (void)addSwitchTarget:(id)target {
    if (target) {
        [self.backButton addTarget:self action:@selector(switchOn) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self.backButton removeTarget:self action:@selector(switchOn) forControlEvents:UIControlEventTouchUpInside];
    }
    self.backButton.userInteractionEnabled = target;
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.backButton.userInteractionEnabled = target;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    self.backButton.indexPath = indexPath;
}

- (NSIndexPath *)indexPath {
    return self.backButton.indexPath;
}

- (void)setMultiline {
    self.titleLabel.adjustsFontSizeToFitWidth = NO;
    self.titleLabel.minimumScaleFactor = 1.0;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

+ (MKURadioButtonView *)enabledRadioButtonWithTitle:(NSString *)title {
    MKURadioButtonView *view = [[MKURadioButtonView alloc] init];
    view.enabled = YES;
    view.titleLabel.text = title;
    view.titleLabel.adjustsFontSizeToFitWidth = YES;
    view.titleLabel.minimumScaleFactor = 0.8;
    return view;
}

@end
