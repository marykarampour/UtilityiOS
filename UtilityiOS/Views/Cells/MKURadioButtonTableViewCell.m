//
//  MKURadioButtonTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKURadioButtonTableViewCell.h"

@implementation MKURadioButtonTableViewCell

- (instancetype)init {
    return [self initWithAlignment:MKU_RADIO_BUTTON_ALIGNMENT_LEFT];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets {
    return [self initWithInsets:insets alignment:MKU_RADIO_BUTTON_ALIGNMENT_LEFT];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style alignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment {
    return [self initWithStyle:style insets:UIEdgeInsetsZero viewCreationHandler:^UIView *{
        UIEdgeInsets margins = UIEdgeInsetsMake(0.0, [Constants HorizontalSpacing], 0.0, [Constants HorizontalSpacing]);
        return [[MKURadioButtonView alloc] initWithAlignment:alignment checkboxInset:alignment == MKU_RADIO_BUTTON_ALIGNMENT_LEFT ? margins.left : margins.right];;
    }];
}

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment {
    return [self initWithStyle:UITableViewCellStyleDefault alignment:alignment];
}

- (instancetype)initWithInsets:(UIEdgeInsets)insets alignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment {
    return [self initWithStyle:UITableViewCellStyleDefault insets:insets viewCreationHandler:^UIView *{
        UIEdgeInsets margins = UIEdgeInsetsMake(0.0, [Constants HorizontalSpacing], 0.0, [Constants HorizontalSpacing]);
        return [[MKURadioButtonView alloc] initWithAlignment:alignment checkboxInset:alignment == MKU_RADIO_BUTTON_ALIGNMENT_LEFT ? margins.left : margins.right];;
    }];
}

@end
