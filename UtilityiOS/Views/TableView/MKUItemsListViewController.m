//
//  MKUItemsListViewController.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUItemsListViewController.h"
#import "MKUTableViewController+ItemsListTransition.h"
#import "NSArray+Utility.h"

@interface MKUItemsListViewController ()

@end

@implementation MKUItemsListViewController

@synthesize items = _items;

- (void)setHasCloseButton:(BOOL)hasCloseButton {
    _hasCloseButton = hasCloseButton;
    [self setBarButtonsOfViewControllerContainingNavigationBar];
}

- (void)initBase {
    [super initBase];
    
    self.transitionVCDelegate = self;
    self.navbarDelegate = self;
    [self resetSelectedObjects];
    [self setUseDarkTheme:NO];
}

- (void)setSelectedAction:(MKU_LIST_ITEM_SELECTED_ACTION)selectedAction {
    [super setSelectedAction:selectedAction];
    [self setBarButtonsOfViewControllerContainingNavigationBar];
}

- (void)setNavBarItems {
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_CLOSE position:MKU_NAV_BAR_BUTTON_POSITION_LEFT];
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_ADD position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_REFRESH position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
}

- (BOOL)hasButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    if (self.navbarDelegate != self && [self.navbarDelegate respondsToSelector:@selector(hasButtonOfType:)]) {
        return [self.navbarDelegate hasButtonOfType:type];
    }
    
    switch (type) {
        case MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE:
            return
            self.selectedAction == MKU_LIST_ITEM_SELECTED_ACTION_NONE ||
            self.selectedAction == MKU_LIST_ITEM_SELECTED_ACTION_SHOW_DETAIL;
            
        case MKU_NAV_BAR_BUTTON_TYPE_CLOSE:
            return self.hasCloseButton;
            
        default:
            return NO;
    }
}

- (NSString *)titleForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    if (self.navbarDelegate != self && [self.navbarDelegate respondsToSelector:@selector(titleForButtonOfType:)]) {
        NSString *title = [self.navbarDelegate titleForButtonOfType:type];
        if (title.length) return title;
    }
    
    switch (type) {
        case MKU_NAV_BAR_BUTTON_TYPE_CLOSE: return [Constants Close_STR];
        default: return nil;
    }
}

- (id)targetForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return self;
}

- (SEL)actionForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    id target = [self targetForButtonOfType:type];
    if (target != self && [target respondsToSelector:@selector(actionForButtonOfType:)]) {
        SEL action = [target actionForButtonOfType:type];
        if (action) return action;
    }
    
    switch (type) {
        case MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE:   return @selector(nextPressed:);
        case MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_REFRESH:return @selector(refreshPressed:);
        case MKU_NAV_BAR_BUTTON_TYPE_CLOSE:         return @selector(closePressed:);
        case MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_ADD:    return @selector(addPressed:);
        default: return nil;
    }
}

- (BOOL)isEnabledButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    if (self.navbarDelegate != self && [self.navbarDelegate respondsToSelector:@selector(isEnabledButtonOfType:)]) {
        return [self.navbarDelegate isEnabledButtonOfType:type];
    }
    return YES;
}

- (void)nextPressed:(UIBarButtonItem *)sender {
    if (self.navbarDelegate != self && [self.navbarDelegate respondsToSelector:@selector(nextPressed:)]) {
        [self.navbarDelegate nextPressed:sender];
    }
    else {
        [self dispathTransitionDelegateToReturnWithObject:self.selectedObjects];
    }
}

- (void)refreshPressed:(UIBarButtonItem *)sender {
    if (self.navbarDelegate != self && [self.navbarDelegate respondsToSelector:@selector(refreshPressed:)]) {
        [self.navbarDelegate refreshPressed:sender];
    }
}

- (void)closePressed:(UIBarButtonItem *)sender {
    if (self.navbarDelegate != self && [self.navbarDelegate respondsToSelector:@selector(closePressed:)]) {
        [self.navbarDelegate closePressed:sender];
    }
    else {
        [self dispathTransitionDelegateToReturnWithObject:[NSSet setWithArray:self.items]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSUInteger)numberOfRowsInNonDateSection:(NSUInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNonDateRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    return [self cellForListItem:self.items[indexPath.row] atIndexPath:indexPath];
}

- (void)didSelectNonDateRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject<MKUPlaceholderProtocol> *obj = self.items[indexPath.row];
    BOOL selected = [self isSelectedRowAtIndexPath:indexPath];
    
    if (self.selectedAction != MKU_LIST_ITEM_SELECTED_ACTION_TRANSITION_TO_DETAIL) {
        if (selected) {
            [self setDeselectedObject:obj];
        }
        else {
            [self setSelectedObject:obj];
            [self didSelectListItem:obj atIndexPath:indexPath];
        }
    }
    
    [self dispatchUpdateDelegateToSetSelected:!selected item:obj atIndex:indexPath.row];
}

- (BOOL)isSelectedRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject <MKUPlaceholderProtocol> *object = [self objectAtIndex:indexPath.row];
    return [self.selectedObjects containsObject:object];
}

- (void)setSelectedObject:(__kindof NSObject<MKUPlaceholderProtocol> *)obj {
    if (!obj) return;
    
    if (!self.tableView.allowsMultipleSelection) {
        [self.selectedObjects removeAllObjects];
    }
    [self.selectedObjects addObject:obj];
    [self reloadDataAnimated:NO];
}

- (void)setDeselectedObject:(__kindof NSObject<MKUPlaceholderProtocol> *)obj {
    if (!obj) return;
    [self.selectedObjects removeObject:obj];
    [self reloadDataAnimated:NO];
}

#pragma mark - items

- (NSObject <MKUPlaceholderProtocol> *)objectAtIndex:(NSUInteger)index {
    if (index == NSNotFound || index < 0 || self.items.count <= index) return nil;
    return self.items[index];
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (void)setItems:(NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)items {
    _items = [items mutableCopy];
    
    NSSet *selectedObjects = [self selectedObjects];
    [self resetSelectedObjects];
    [self setSelectedObjectsWithSet:selectedObjects];
    [self updateHeader];
    [self didFinishUpdates];
}

- (void)setItemsWithArray:(NSArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)items {
    [self setItems:[NSMutableArray mutableArrayWithNullableArray:items]];
}

- (NSIndexPath *)indexPathForItem:(__kindof NSObject<NSCopying> *)item {
    if (![self.items containsObject:item]) return nil;
    return [NSIndexPath indexPathForRow:[self.items indexOfObject:item] inSection:MKU_EDIT_LIST_SECTION_TYPE_LIST];
}

- (__kindof MKUBaseTableViewCell *)cellForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    return [self defaultTitleSubtitleCellForListItem:item atIndexPath:indexPath];
}

- (void)didSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    [self presentTransitioningViewControllerWithItem:item atIndexPath:indexPath];
}

- (void)transitioningViewControllerForItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath completion:(void (^)(UIViewController *))completion {
    completion(nil);
}

- (void)handleTransitionToViewController:(UIViewController *)VC sourceViewController:(UIViewController *)sourceVC didSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:VC animated:YES];
}

- (NSMutableSet *)selectedObjects {
    if (!_selectedObjects)
        _selectedObjects = [[NSMutableSet alloc] init];
    return _selectedObjects;
}

- (void)resetSelectedObjects {
    self.selectedObjects = [[NSMutableSet alloc] init];
}

- (void)setSelectedObjectsWithSet:(NSSet *)selectedObjects {
    self.selectedObjects = [selectedObjects mutableCopy];
    [self reloadDataAnimated:NO];
}

- (void)didFinishUpdates {
    [self dispatchUpdateDelegateToRefresh];
}

- (void)dispatchUpdateDelegateToRefresh {
    if ([self.updateDelegate respondsToSelector:@selector(itemsListVC:didUpdateItems:)]) {
        [self.updateDelegate itemsListVC:self didUpdateItems:self.items];
    }
}

- (void)didUpdateItem:(__kindof NSObject<NSCopying> *)item atIndex:(NSUInteger)index {
    [self dispatchUpdateDelegateToRefreshItem:item atIndex:index];
    [self reloadDataAnimated:NO];
}

- (void)dispatchUpdateDelegateToRefreshItem:(__kindof NSObject<NSCopying> *)item atIndex:(NSUInteger)index {
    if ([self.updateDelegate respondsToSelector:@selector(itemsListVC:didUpdateItem:atIndex:)]) {
        [self.updateDelegate itemsListVC:self didUpdateItem:item atIndex:index];
    }
}

- (void)dispatchUpdateDelegateToSetSelected:(BOOL)selected item:(__kindof NSObject<NSCopying> *)item atIndex:(NSUInteger)index {
    if ([self.updateDelegate respondsToSelector:@selector(itemsListVC:didSetSelected:item:atIndex:)]) {
        [self.updateDelegate itemsListVC:self didSetSelected:selected item:item atIndex:index];
    }
}

- (BOOL)canSelectSection:(NSUInteger)section {
    return YES;
}

- (NSString *)noItemAvailableTitleForListOfType:(NSUInteger)type {
    return [Constants No_Items_Available_STR];
}

- (NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)listItemsForListOfType:(NSUInteger)type {
    return self.items;
}

- (void)updateHeader {
    [self createTableHeaderWithTitle:self.items.count == 0 ? [self noItemAvailableTitleForListOfType:0] : nil];
}

- (void)setTextForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell {
    [self defaultSetTextForRowAtIndexPath:indexPath inCell:cell];
}

- (void)setStyleForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell {
    [self defaultSetStyleForRowAtIndexPath:indexPath inCell:cell];
}

- (UITableViewCellAccessoryType)accessoryTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self defaultAccessoryTypeForRowAtIndexPath:indexPath];
}

- (UITableViewCellAccessoryType)accessoryTypeForSelectedRowForListOfType:(NSUInteger)type {
    return UITableViewCellAccessoryCheckmark;
}

- (UITableViewCellAccessoryType)accessoryTypeForDeselectedRowForListOfType:(NSUInteger)type {
    return UITableViewCellAccessoryNone;
}

- (UITableViewCellAccessoryType)accessoryTypeForSingleDeselectedRowForListOfType:(NSUInteger)type {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (UITableViewCellSelectionStyle)selectionStyleForListOfType:(NSUInteger)type {
    return [self defaultSelectionStyleForListOfType:type];
}

- (NSObject<MKUPlaceholderProtocol> *)listItemAtIndexPath:(NSIndexPath *)indexPath {
    return [super listItemAtIndexPath:indexPath];
}

@end
