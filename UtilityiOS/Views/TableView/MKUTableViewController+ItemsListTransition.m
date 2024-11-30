//
//  MKUTableViewController+ItemsListTransition.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUTableViewController+ItemsListTransition.h"
#import "UIViewController+ViewControllerTransition.h"
#import "MKUBaseTableViewCell.h"
#import "NSArray+Utility.h"
#import <objc/runtime.h>

static char UIVIEWCONTROLER_TRANSITION_LIST_KEY;

@implementation MKUTableViewController (ItemsListTransition)

- (void)setTransitionVCDelegate:(id<MKUItemsListVCTransitionDelegate>)transitionVCDelegate {
    objc_setAssociatedObject(self, &UIVIEWCONTROLER_TRANSITION_LIST_KEY, transitionVCDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<MKUItemsListVCTransitionDelegate>)transitionVCDelegate {
    return objc_getAssociatedObject(self, &UIVIEWCONTROLER_TRANSITION_LIST_KEY);
}

- (void)presentTransitioningViewControllerWithItem:(NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    
    if ([self respondsToSelector:@selector(transitioningViewControllerForItem:atIndexPath:completion:)]) {
        [self transitioningViewControllerForItem:item atIndexPath:indexPath completion:^(UIViewController *VC) {
            if (![VC isKindOfClass:[UIViewController class]]) return;
            
            if ([VC conformsToProtocol:@protocol(MKUViewControllerTransitionProtocol)]) VC.transitionDelegate = self;
            
            if ([self.transitionVCDelegate respondsToSelector:@selector(handleTransitionToViewController:sourceViewController:didSelectListItem:atIndexPath:)]) {
                [self.transitionVCDelegate handleTransitionToViewController:VC sourceViewController:self didSelectListItem:item atIndexPath:indexPath];
            }
            else {
                [self.navigationController pushViewController:VC animated:YES];
            }
        }];
    }
}

- (NSString *)textLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (![self respondsToSelector:@selector(listItemAtIndexPath:)]) return nil;
    
    NSObject <MKUPlaceholderProtocol> *object = [self listItemAtIndexPath:indexPath];
    if ([object respondsToSelector:@selector(title)]) {
        return [object title];
    }
    return [object description];
}

- (NSString *)detailTextLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (![self respondsToSelector:@selector(listItemAtIndexPath:)]) return nil;
    
    NSObject <MKUPlaceholderProtocol> *object = [self listItemAtIndexPath:indexPath];
    if ([object respondsToSelector:@selector(subtitle)]) {
        return [object subtitle];
    }
    return nil;
}

- (NSAttributedString *)attributedTextLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (![self respondsToSelector:@selector(listItemAtIndexPath:)]) return nil;
    
    NSObject <MKUPlaceholderProtocol> *object = [self listItemAtIndexPath:indexPath];
    if ([object respondsToSelector:@selector(attributedTitle)]) {
        return [object attributedTitle];
    }
    return nil;
}

- (NSAttributedString *)attributedDetailTextLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (![self respondsToSelector:@selector(listItemAtIndexPath:)]) return nil;
    
    NSObject <MKUPlaceholderProtocol> *object = [self listItemAtIndexPath:indexPath];
    if ([object respondsToSelector:@selector(attributedSubtitle)]) {
        return [object attributedSubtitle];
    }
    return nil;
}

- (NSObject<MKUPlaceholderProtocol> *)listItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![self respondsToSelector:@selector(listItemsForListOfType:)]) return nil;
    
    return [[self listItemsForListOfType:indexPath.section] nullableObjectAtIndex:indexPath.row];
}

- (__kindof MKUBaseTableViewCell *)defaultTitleSubtitleCellForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    
    MKUSubtitleTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MKUSubtitleTableViewCell identifier]];
    if (!cell) {
        cell = [[MKUSubtitleTableViewCell alloc] init];
    }
    
    if ([self respondsToSelector:@selector(setTextForRowAtIndexPath:inCell:)])
        [self setTextForRowAtIndexPath:indexPath inCell:cell];
    
    if ([self respondsToSelector:@selector(setStyleForRowAtIndexPath:inCell:)])
        [self setStyleForRowAtIndexPath:indexPath inCell:cell];
    
    return cell;
}

- (void)defaultSetTextForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell {
    NSAttributedString *attrTitle = [self attributedTextLabelAtIndexPath:indexPath];
    NSAttributedString *attrSubtitle = [self attributedDetailTextLabelAtIndexPath:indexPath];
    
    if (attrTitle) {
        cell.textLabel.text = nil;
        cell.textLabel.attributedText = attrTitle;
    }
    else {
        cell.textLabel.attributedText = nil;
        cell.textLabel.text = [self textLabelAtIndexPath:indexPath];
    }
    
    if (attrSubtitle) {
        cell.detailTextLabel.text = nil;
        cell.detailTextLabel.attributedText = attrSubtitle;
    }
    else {
        cell.detailTextLabel.attributedText = nil;
        cell.detailTextLabel.text = [self detailTextLabelAtIndexPath:indexPath];
    }
}

- (void)defaultSetStyleForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell {
    
    UITableViewCellAccessoryType type = [self respondsToSelector:@selector(accessoryTypeForRowAtIndexPath:)] ? [self accessoryTypeForRowAtIndexPath:indexPath] : UITableViewCellAccessoryNone;
    
    cell.selectionStyle = [self respondsToSelector:@selector(selectionStyleForListOfType:)] ? [self selectionStyleForListOfType:indexPath.section] : UITableViewCellSelectionStyleNone;
    cell.accessoryType = type;
    cell.editingAccessoryType = type;
}

- (UITableViewCellSelectionStyle)defaultSelectionStyleForListOfType:(NSUInteger)type {
    if (IS_IPAD)
        return UITableViewCellSelectionStyleDefault;
    if ([self respondsToSelector:@selector(isSelectedRowAtIndexPath:)])
        if (!self.tableView.allowsMultipleSelection)
            return UITableViewCellSelectionStyleDefault;
    return UITableViewCellSelectionStyleNone;
}

- (UITableViewCellAccessoryType)defaultAccessoryTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(isSelectedRowAtIndexPath:)]) {
        if (!self.tableView.allowsMultipleSelection) {
            if ([self respondsToSelector:@selector(accessoryTypeForSingleDeselectedRowForListOfType:)]) {
                return [self isSelectedRowAtIndexPath:indexPath] ? [self accessoryTypeForSelectedRowForListOfType:indexPath.section] : [self accessoryTypeForSingleDeselectedRowForListOfType:indexPath.section];
            }
        }
        else {
            if ([self respondsToSelector:@selector(accessoryTypeForDeselectedRowForListOfType:)]) {
                return [self isSelectedRowAtIndexPath:indexPath] ? [self accessoryTypeForSelectedRowForListOfType:indexPath.section] : [self accessoryTypeForDeselectedRowForListOfType:indexPath.section];
            }
        }
    }
    return UITableViewCellAccessoryNone;
}

@end
