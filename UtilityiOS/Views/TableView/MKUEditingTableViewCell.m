//
//  MKUEditingTableViewCell.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-28.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUEditingTableViewCell.h"

@implementation MKUEditingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style {
    if (self = [super initWithStyle:style]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.editingAccessoryType = UITableViewCellAccessoryNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.textLabel.font = [AppTheme mediumBoldLabelFont];
    }
    return self;
}

@end
