//
//  MKUBaseTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUBaseTableViewCell.h"
#import "UIControl+IndexPath.h"

@interface MKUBaseTableViewCell ()

@property (strong, nonatomic) UIButton *accessoryButton;

@end

@implementation MKUSubtitleTableViewCell

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle]) {
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

@end

@implementation MKUBaseTableViewCell

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"k%@Identifier", NSStringFromClass(self)];
}

+ (CGFloat)estimatedHeight {
    return [Constants DefaultRowHeight];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style {
    return [self initWithStyle:style reuseIdentifier:[self.class identifier]];
}

- (instancetype)init {
    return [self initWithStyle:UITableViewCellStyleDefault];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

+ (UIImageView *)disclosureIndicatorAccessoryView {
    CGSize size = [Constants TableCellDisclosureIndicatorSize];
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
    accessoryView.image = [[AppTheme tableCellDisclosureIndicatorImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [accessoryView setTintColor:[AppTheme tableCellAccessoryViewColor]];
    return accessoryView;
}

- (void)setAccessoryView:(UIView *)accessoryView {
    if (!self.useCustomImageAccessoryView) {
        [super setAccessoryView:accessoryView];
        return;
    }
        
    switch (self.accessoryType) {
        case UITableViewCellAccessoryDisclosureIndicator: {
            [super setAccessoryView:[MKUBaseTableViewCell disclosureIndicatorAccessoryView]];
        }
            break;
        default: {
            [super setAccessoryView:accessoryView];
        }
            break;
    }
}

+ (instancetype)blankCell {
    MKUBaseTableViewCell *cell = [[self alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

+ (CGFloat)estimatedHeightForNumberOfLines:(NSInteger)lines {
    if (lines <= 1) {
        return [self estimatedHeight];
    }
    else {
        return lines*[Constants TableCellLineHeight] + 2*[Constants TableCellContentVerticalMargin];
    }
}

#pragma mark - accessory

- (void)addAccessoryButton {
    self.accessoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [Constants TableCellAccessorySize], [Constants TableCellAccessorySize])];
    self.accessoryButton.contentMode = UIViewContentModeScaleAspectFit;
    self.accessoryView = self.accessoryButton;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)setAccessoryButtonTarget:(id)target action:(SEL)action {
    if (!self.accessoryButton) {
        MKURaiseExceptionPropertyIsNil(NSStringFromSelector(@selector(accessoryButton)))
    }
    [self.accessoryButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setAccessoryViewImage:(NSString *)image indexPath:(NSIndexPath *)indexPath {
    if (!self.accessoryButton) {
        MKURaiseExceptionPropertyIsNil(NSStringFromSelector(@selector(accessoryButton)))
    }
    [self.accessoryButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    self.accessoryButton.indexPath = indexPath;
}

- (void)setAccessoryButtonTitle:(NSString *)title {
    if (!self.accessoryButton) {
        MKURaiseExceptionPropertyIsNil(NSStringFromSelector(@selector(accessoryButton)))
    }
    [self.accessoryButton setTitle:title forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (self.checkmarkOnSelection) {
        self.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
}

@end


@implementation MKUTableCellInfo

- (CGFloat)height {
    return self.hidden ? 0.0 : self.estimatedHeight;
}

- (void)setHidden:(BOOL)hidden {
    _hidden = hidden;
    self.cell.contentView.hidden = hidden;
}

@end
