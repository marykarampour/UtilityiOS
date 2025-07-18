//
//  MKUTableViewSection.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2020-10-17.
//  Copyright © 2020 Prometheus Software. All rights reserved.
//

#import "MKUModel.h"

@interface MKUTableViewSection : MKUModel

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) BOOL isCollapsable;
/** @brief only used if isCollapsable is YES */
@property (nonatomic, assign) BOOL isExpanded;
/** @brief if NO user interaction will be disabled on the section header, default is YES */
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL hasCustomHeader;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) CGFloat collapsedHeight;
/** @brief Default is [Constants TableSectionHeaderHeight] */
@property (nonatomic, assign) CGFloat expandedHeight;

@property (nonatomic, strong) NSArray<__kindof NSObject *> *items;

+ (MKUTableViewSection *)sectionCollapsable:(BOOL)isCollapsable expanded:(BOOL)isExpanded;
/** @brief If isCollapsable = YES returns collapsedHeight otherwise returns expandedHeight */
- (CGFloat)estimatedHeight;

@end


@interface MKUTableViewObject : MKUModel

@property (nonatomic, strong) NSArray<MKUTableViewSection *> *sections;

@end
