//
//  MKURadioButtonTableViewCell.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-27.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUSingleViewTableViewCell.h"
#import "MKURadioButtonView.h"

@interface MKURadioButtonTableViewCell : MKUSingleViewTableViewCell <MKURadioButtonView *>

- (instancetype)initWithAlignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment;
- (instancetype)initWithStyle:(UITableViewCellStyle)style alignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment;
- (instancetype)initWithInsets:(UIEdgeInsets)insets alignment:(MKU_RADIO_BUTTON_ALIGNMENT)alignment;

@end

