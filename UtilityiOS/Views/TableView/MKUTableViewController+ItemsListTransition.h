//
//  MKUTableViewController+ItemsListTransition.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUGenericTableViewControllerProtocols.h"
#import "MKUTableViewController.h"

@interface MKUTableViewController (ItemsListTransition) <MKUItemsListVCProtocol, MKUViewControllerTransitionDelegate>

- (__kindof MKUBaseTableViewCell *)defaultTitleSubtitleCellForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;
- (void)defaultSetTextForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell;
- (void)defaultSetStyleForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell;
- (UITableViewCellSelectionStyle)defaultSelectionStyleForListOfType:(NSUInteger)type;
- (UITableViewCellAccessoryType)defaultAccessoryTypeForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
