//
//  MKUCheckboxButtonView.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKURadioButtonView.h"

/** @brief Default init constraints horizontally to sides. */
@interface MKUCheckboxAccessoryView <__covariant ViewType : __kindof UIView *> : UIView

@property (nonatomic, strong, readonly) MKURadioButtonView *checkboxView;
@property (nonatomic, strong, readonly) ViewType accessoryView;

/**
 @param position is used for the button Y position. The checkbox is constrained sides. Button is on right side.
 @param accessorySize is used only if position is not MKU_VIEW_POSITION_NONE. */
- (instancetype)initWithPosition:(MKU_VIEW_POSITION)position accessorySize:(CGSize)accessorySize viewCreationHandler:(VIEW_CREATION_HANDLER)handler;

@end


@interface MKUCheckboxButtonView : MKUCheckboxAccessoryView <UIButton *>

- (instancetype)initWithPosition:(MKU_VIEW_POSITION)position buttonSize:(CGSize)buttonSize;

@end

