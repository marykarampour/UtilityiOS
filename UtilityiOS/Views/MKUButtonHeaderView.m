//
//  MKUButtonHeaderView.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-12-07.
//

#import "MKUButtonHeaderView.h"

@implementation MKUButtonHeaderView

- (instancetype)initWithAccessoryImageSize:(CGFloat)size {
    return [super initWithViewCreationHandler:^UIView *{
        return [[MKUButtonImageView alloc] initWithBadgeSize:size];
    }];
}

+ (CGFloat)estimatedHeight {
    return [Constants TableSectionHeaderMediumHeight];
}

@end
