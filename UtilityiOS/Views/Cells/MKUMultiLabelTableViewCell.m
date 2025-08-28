//
//  MKUMultiLabelTableViewCell.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUMultiLabelTableViewCell.h"

@interface MKUMultiLabelTableViewCell ()

@property (nonatomic, strong, readwrite) MKUMultiLabelViewController *viewController;

@end

@implementation MKUMultiLabelTableViewCell

- (instancetype)initWithType:(MKU_MULTI_LABEL_VIEW_TYPE)type leftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets {
    if (self = [super init]) {
        [self constructControllerWithType:type leftView:leftView rightView:rightView labelsCount:labelsCount insets:insets];
    }
    return self;
}

- (void)constructControllerWithType:(MKU_MULTI_LABEL_VIEW_TYPE)type leftView:(__kindof UIView *)leftView rightView:(__kindof UIView *)rightView labelsCount:(NSUInteger)labelsCount insets:(UIEdgeInsets)insets {    
    self.viewController = [[MKUMultiLabelViewController alloc] initWithContentView:self.contentView];
    [self.viewController constructWithType:type leftView:leftView rightView:rightView labelsCount:labelsCount insets:insets];
}

@end
