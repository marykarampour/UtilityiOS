//
//  MKUDateTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUDateTableViewCell.h"
#import "UIView+Utility.h"
#import "MKULabel.h"

@interface MKUDateTableViewCell ()

@property (nonatomic, strong) MKULabel *doneLabel;
@property (nonatomic, strong) MKULabel *dateLabel;

@end

@implementation MKUDateTableViewCell

+ (CGFloat)estimatedHeight {
    return 32.0;
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.contentView.backgroundColor = [AppTheme mistBlueColorWithAlpha:1.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.dateLabel = [[MKULabel alloc] init];
        self.dateLabel.font = [AppTheme mediumLabelFont];
        self.dateLabel.textColor = [AppTheme buttonTextColor];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        
        self.doneLabel = [[MKULabel alloc] init];
        self.doneLabel.font = [UIFont systemFontOfSize:17.0];
        self.doneLabel.textColor = [AppTheme buttonTextColor];
        self.doneLabel.text = [Constants Done_STR];
        self.doneLabel.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:self.doneLabel];
        [self.contentView addSubview:self.dateLabel];
        
        [self.contentView removeConstraintsMask];
        [self.contentView constraintSidesForView:self.dateLabel insets:UIEdgeInsetsMake(0.0, [Constants TableCellContentHorizontalMargin], 0.0, [Constants TableCellContentHorizontalMargin])];
        [self.contentView constraintSameView1:self.doneLabel view2:self.dateLabel];
    }
    return self;
}

- (void)setDateText:(NSString *)dateString {
    self.dateLabel.text = dateString;
}

- (void)setDoneHidden:(BOOL)isHidden {
    [self.doneLabel setHidden:isHidden];
}

@end
