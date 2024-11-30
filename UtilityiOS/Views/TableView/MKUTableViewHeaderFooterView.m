//
//  MKUTableViewHeaderFooterView.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUTableViewHeaderFooterView.h"

@implementation MKUTableViewHeaderFooterView

- (instancetype)init {
    return [super initWithReuseIdentifier:[self.class identifier]];
}

+ (NSString *)identifier {
    return [NSString stringWithFormat:@"k%@Identifier", NSStringFromClass(self)];
}

+ (CGFloat)estimatedHeight {
    return [Constants DefaultRowHeight];
}

+ (CGFloat)estimatedHeightForType:(NSUInteger)type {
    return type == MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE_HEADER ? [Constants TableSectionHeaderHeight] : [Constants TableSectionFooterHeight];
}

@end
