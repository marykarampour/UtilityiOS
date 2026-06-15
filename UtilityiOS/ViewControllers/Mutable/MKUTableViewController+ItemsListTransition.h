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
- (void)defaultSetTextForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell;
- (void)defaultSetStyleForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell;
- (UITableViewCellSelectionStyle)defaultSelectionStyleForListOfType:(NSUInteger)type;
- (UITableViewCellAccessoryType)defaultAccessoryTypeForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;
- (void)handleTransitionForViewController:(UIViewController *)VC item:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;
- (BOOL)dispatchTransitionVCDelegateToTransitionToViewController:(UIViewController *)VC sourceViewController:(UIViewController *)sourceVC didSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;
- (void)dispatchTransitionVCDelegateToDismissDestinationViewController:(UIViewController *)VC;
- (NSAttributedString *)attributedTextLabelForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;
- (NSAttributedString *)attributedDetailTextLabelForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;

@end
