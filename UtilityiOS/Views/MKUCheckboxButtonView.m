//
//  MKUCheckboxButtonView.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUCheckboxButtonView.h"
#import "UIButton+MKUTheme.h"
#import "UIView+Utility.h"

@interface MKUCheckboxAccessoryView ()

@property (nonatomic, strong, readwrite) MKURadioButtonView *checkboxView;
@property (nonatomic, strong, readwrite) UIView *accessoryView;

@end

@implementation MKUCheckboxAccessoryView

- (void)initBase {
    self.checkboxView = [MKURadioButtonView enabledRadioButtonWithTitle:nil];
    self.checkboxView.titleLabel.font = [AppTheme mediumBoldLabelFont];
    
    [self addSubview:self.checkboxView];
    [self removeConstraintsMask];
}

- (void)constraintBase {
    [self constraintHorizontally:@[self.checkboxView, self.accessoryView] interItemMargin:2*[Constants HorizontalSpacing] horizontalMargin:0.0 verticalMargin:0.0 equalWidths:YES];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initBase];
        [self constraintBase];
    }
    return self;
}

- (instancetype)initWithPosition:(MKU_VIEW_POSITION)position accessorySize:(CGSize)accessorySize viewCreationHandler:(VIEW_CREATION_HANDLER)handler {
    if (self = [super init]) {
        
        if (handler) self.accessoryView = handler();
        if (!self.accessoryView) return self;
        
        [self addSubview:self.accessoryView];
        [self initBase];
        
        BOOL hasPosition = MKU_VIEW_POSITION_NONE < position;
        BOOL hasSize = 0 < accessorySize.width && 0 < accessorySize.height;
        
        if (hasSize)
            [self constraintSize:accessorySize forView:self.accessoryView];
        else if (0 < accessorySize.width)
            [self constraintWidth:accessorySize.width forView:self.accessoryView];
        else if (0 < accessorySize.height)
            [self constraintHeight:accessorySize.height forView:self.accessoryView];
        
        if (hasPosition) {
            [self constraint:NSLayoutAttributeRight view:self.accessoryView];
            [self constraintSidesExcluding:NSLayoutAttributeRight view:self.checkboxView];
            
            if (position & MKU_VIEW_POSITION_TOP) {
                [self constraint:NSLayoutAttributeTop view:self.accessoryView];
            }
            else if (position & MKU_VIEW_POSITION_BOTTOM) {
                [self constraint:NSLayoutAttributeBottom view:self.accessoryView];
            }
            else if (position & MKU_VIEW_POSITION_CENTER_Y) {
                [self constraint:NSLayoutAttributeCenterY view:self.accessoryView];
            }
        }
        else {
            [self constraintHorizontally:@[self.checkboxView, self.accessoryView] interItemMargin:2*[Constants HorizontalSpacing] horizontalMargin:0.0 verticalMargin:0.0 equalWidths:!hasSize];
        }
    }
    return self;
}

@end

@implementation MKUCheckboxButtonView

- (instancetype)initWithPosition:(MKU_VIEW_POSITION)position buttonSize:(CGSize)buttonSize {
    return [super initWithPosition:position accessorySize:buttonSize viewCreationHandler:^UIView *{
        return [UIButton borderButtonWithTitle:nil];
    }];
}

@end

