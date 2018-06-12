//
//  MKTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKTableViewCell.h"

@implementation MKTableViewCell

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"k%@Identifier", NSStringFromClass(self)];
}

+ (CGFloat)estimatedHeight {
    return [Constants DefaultRowHeight];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [AppTheme tableCellBackgroundColor];
        self.cellController = [[MKCellContentController alloc] initWithCellType:MKCellTypeTableView];
        [self.cellController setTableViewCell:self];
    }
    return self;
}

+ (UIImageView *)imageAccessoryView {
    CGSize size = [Constants TableCellDisclosureIndicatorSize];
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
    accessoryView.image = [[AppTheme tableCellDisclosureIndicatorImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [accessoryView setTintColor:[AppTheme tableCellAccessoryViewColor]];
    return accessoryView;
}

- (void)setAccessoryView:(UIView *)accessoryView {
    switch (self.accessoryType) {
        case UITableViewCellAccessoryDisclosureIndicator: {
            [super setAccessoryView:[MKTableViewCell imageAccessoryView]];
        }
            break;
        default: {
            [super setAccessoryView:accessoryView];
        }
            break;
    }
}



@end
