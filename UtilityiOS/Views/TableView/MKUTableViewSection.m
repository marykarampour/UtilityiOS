//
//  MKUTableViewSection.m
//  KaChing
//
//  Created by Maryam Karampour on 2020-10-17.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKUTableViewSection.h"

@implementation MKUTableViewObject

@end


@implementation MKUTableViewSection

- (instancetype)init {
    if (self = [super init]) {
        self.isEnabled = YES;
        self.expandedHeight = [Constants TableSectionHeaderHeight];
    }
    return self;
}

+ (MKUTableViewSection *)sectionCollapsable:(BOOL)isCollapsable expanded:(BOOL)isExpanded {
    MKUTableViewSection *section = [[MKUTableViewSection alloc] init];
    section.isCollapsable = isCollapsable;
    section.isExpanded = isExpanded;
    return section;
}

- (void)setIsCollapsable:(BOOL)isCollapsable {
    _isCollapsable = isCollapsable;
}

- (CGFloat)estimatedHeight {
    if (self.isCollapsable) return self.expandedHeight;
    return self.collapsedHeight;
}

@end
