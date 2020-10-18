//
//  MKTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKBaseTableViewCell.h"

@implementation MKTableCellInfo

- (CGFloat)height {
    return self.hidden ? 0.0 : self.estimatedHeight;
}

- (void)setHidden:(BOOL)hidden {
    _hidden = hidden;
    self.cell.contentView.hidden = hidden;
}

@end

@implementation MKBaseTableViewCell

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"k%@Identifier", NSStringFromClass(self)];
}

+ (CGFloat)estimatedHeight {
    return [Constants DefaultRowHeight];
}

- (instancetype)init {
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self.class identifier]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
            [super setAccessoryView:[MKBaseTableViewCell imageAccessoryView]];
        }
            break;
        default: {
            [super setAccessoryView:accessoryView];
        }
            break;
    }
}



@end
