//
//  MKUEditingListsViewController.m
//  MKU HAWB Reader
//
//  Created by Maryam Karampour on 2025-07-28.
//  Copyright © 2025 Commodity Forwarders Inc. All rights reserved.
//

#import "MKUEditingListsViewController.h"
#import "MKUTableViewController+ItemsListTransition.h"
#import "NSArray+Utility.h"
#import "NSObject+KVO.h"

static NSString * const MULTI_SELECT_KEY = @"allowsMultipleSelection";

@interface MKUEditingListsViewController ()

@property (nonatomic, assign) BOOL editButtonHidden;

@end

@implementation MKUEditingListsViewController

- (instancetype)init {
    return [self initWithListTypes:MKU_FIELD_LIST_TYPE_A];
}

- (instancetype)initWithMKUType:(NSInteger)type {
    if (self = [super initWithMKUType:type]) {
        [self initBaseWithListTypes:MKU_FIELD_LIST_TYPE_A];
    }
    return self;
}

- (instancetype)initWithListTypes:(MKU_FIELD_LIST_TYPE)types {
    if (self = [super init]) {
        [self initBaseWithListTypes:types];
    }
    return self;
}

- (void)initBaseWithListTypes:(MKU_FIELD_LIST_TYPE)types {
    MKUFieldListModel *obj = [[[self.class classForListObject] alloc] init];
    obj.activeListTypes = types;
    
    [self setUpdatedObject:obj];
    [self resetSelectedSets];
}

- (void)initBase {
    [self registerKVO];
    [super initBase];
    self.navbarDelegate = self;
    self.editButtonHidden = YES;
}

- (void)dealloc {
    [self unregisterKVO];
}

+ (NSSet<NSString *> *)KVOKeys {
    return [NSSet setWithObject:MULTI_SELECT_KEY];
}

- (NSObject *)KVOObject {
    return self.tableView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[UITableView class]] && [keyPath isEqual:MULTI_SELECT_KEY]) {
        [self resetBarButtonsOfViewControllerContainingNavigationBar];
    }
}

+ (Class)classForListObject {
    return [MKUFieldListModel class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self canEditListsByDefault])
        self.editing = YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self reloadDataAnimated:NO];
}

//TODO: This is calling reset too many times. Create self.isViewAppeared set in viewWillAppear, in setIsViewAppeared set bar items, and when called reset do only if self.isViewAppeared is YES
- (void)setEditButtonHidden:(BOOL)hidden {
    _editButtonHidden = hidden;
    [self setBarButtonsOfViewControllerContainingNavigationBar];
}

- (void)setHasCloseButton:(BOOL)hasCloseButton {
    _hasCloseButton = hasCloseButton;
    [self setBarButtonsOfViewControllerContainingNavigationBar];
}

- (void)didSetSelectedActionHandler:(LIST_ITEM_SELECTED_ACTION_HANDLER)selectedActionHandler {
    [self setBarButtonsOfViewControllerContainingNavigationBar];
}

- (void)setNavBarItems {
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_CLOSE position:MKU_NAV_BAR_BUTTON_POSITION_LEFT];
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_ADD position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_REFRESH position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
    [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_CLEAR position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
    
    if (!self.editButtonHidden)
        [self addButtonOfType:MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT position:MKU_NAV_BAR_BUTTON_POSITION_RIGHT];
}

- (BOOL)hasButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    if (self.navbarDelegate != self && [self.navbarDelegate respondsToSelector:@selector(hasButtonOfType:)]) {
        return [self.navbarDelegate hasButtonOfType:type];
    }
    
    switch (type) {
        case MKU_NAV_BAR_BUTTON_TYPE_CLOSE:
            return self.hasCloseButton;
            
        case MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT:
            return ![self canEditListsByDefault] && !self.editButtonHidden;
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
        case MKU_NAV_BAR_BUTTON_TYPE_CLEAR: return [Constants Clear_STR];
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
        case MKU_NAV_BAR_BUTTON_TYPE_CLEAR:         return @selector(clearPressed:);
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
        [self dispathTransitionDelegateToReturnWithObject:[self returnedInSelectObject]];
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
        [self dispathTransitionDelegateToReturnWithObject:[self returnedInCloseObject]];
    }
}

- (void)addPressed:(UIBarButtonItem *)sender {
    if (self.navbarDelegate != self && [self.navbarDelegate respondsToSelector:@selector(addPressed:)]) {
        [self.navbarDelegate addPressed:sender];
    }
}

- (void)clearPressed:(UIBarButtonItem *)sender {
    [self.object reset];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.object.UpdatedObject activeListsCount];
}

- (CGFloat)heightForNonDateRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self isAddIndexPath:indexPath] ? [self heightForEditingRowAtIndexPath:indexPath] : [self heightForNonEditingListRowAtIndexPath:indexPath];
}

#pragma mark - list

- (MKU_MUTABLE_OBJECT_FIELD_TYPE)typeForSection:(NSUInteger)section {
    return [self isDateSection:section] ? MKU_MUTABLE_OBJECT_FIELD_TYPE_BLANK : MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST;
}

- (NSUInteger)listTypeForListInSection:(NSUInteger)section {
    return 1 << section;
}

- (void)setItemsWithArray:(NSArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)items forListOfType:(MKU_FIELD_LIST_TYPE)type {
    [self setItems:[NSMutableArray mutableArrayWithNullableArray:items] forListOfType:type];
}

- (NSArray *)addItems:(NSArray<NSObject<MKUPlaceholderProtocol> *> *)items toListSection:(NSUInteger)section {
    NSArray *existing = [super addItems:items toListOfType:section];
    [self updateHeader];
    return existing;
}

- (void)deleteItems:(NSArray<NSObject<MKUPlaceholderProtocol> *> *)items fromListSection:(NSUInteger)section {
    [super deleteItems:items fromListOfType:section];
    [self updateHeader];
}

- (BOOL)addItem:(NSObject<MKUPlaceholderProtocol> *)item toListOfType:(NSUInteger)type {
    BOOL existing = [super addItem:item toListOfType:type];
    [self updateHeader];
    return existing;
}

- (void)deleteItem:(NSObject<MKUPlaceholderProtocol> *)item fromListOfType:(NSUInteger)type {
    [super deleteItem:item fromListOfType:type];
    [self updateHeader];
}

#pragma mark -

- (CGFloat)heightForEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0;
}

- (CGFloat)heightForNonEditingListRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)updateItemsWithUnmatchedTypeItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndex:(NSUInteger)index {
}

- (BOOL)canAddItemToListOfType:(NSUInteger)type {
    return self.isEditing;
}

- (BOOL)canDeleteFromListOfType:(NSUInteger)type {
    return self.isEditing;
}

#pragma mark -

- (void)updateHeader {
    for (NSUInteger i=0; i<[self numberOfSectionsInTableView:self.tableView]; i++) {
        
        NSUInteger value = (1 << i);
        BOOL hasItems = value & self.object.UpdatedObject.activeListTypes;
        if (!hasItems) continue;
        
        NSArray *arr = [self listItemsForListOfType:value];
        if (arr.count == 0) {
            [self createTableHeaderWithTitle:[self noItemAvailableTitleForListOfType:value]];
            return;
        }
    }
    [self createTableHeaderWithTitle:nil];
}

@end

@implementation MKUEditingListViewController

@dynamic object;

- (instancetype)init {
    return [self initWithListTypes:MKU_FIELD_LIST_TYPE_A];
}

+ (Class)classForListObject {
    return [MKUFieldSingleListModel class];
}

- (BOOL)hasButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    if (self.navbarDelegate != self && [self.navbarDelegate respondsToSelector:@selector(hasButtonOfType:)]) {
        return [self.navbarDelegate hasButtonOfType:type];
    }
    
    switch (type) {
        case MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE:
            return
            self.selectedActionHandler(0) == MKU_LIST_ITEM_SELECTED_ACTION_NONE ||
            self.selectedActionHandler(0) == MKU_LIST_ITEM_SELECTED_ACTION_SHOW_DETAIL ||
            self.tableView.allowsMultipleSelection;
            
        default:
            return [super hasButtonOfType:type];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - items

- (NSObject <MKUPlaceholderProtocol> *)objectAtIndex:(NSUInteger)index {
    if (index == NSNotFound || index < 0 || [self items].count <= index) return nil;
    return [self items][index];
}

- (NSMutableArray *)items {
    return [self listItemsForListOfType:MKU_FIELD_LIST_TYPE_A];
}

- (void)setItems:(NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)items {
    self.object.UpdatedObject.itemsA = [items mutableCopy];
    
    NSSet *selectedObjects = [self selectedObjects];
    [self resetSelectedSets];
    [self setSelectedObjectsWithSet:selectedObjects];
    [self updateHeader];
    [self reloadDataAnimated:NO];
    [self didFinishUpdates];
}

- (void)setItemsWithArray:(NSArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)items {
    [self setItems:[NSMutableArray mutableArrayWithNullableArray:items]];
}

- (BOOL)canSelectSection:(NSUInteger)section {
    return YES;
}

- (NSString *)noItemAvailableTitleForListOfType:(NSUInteger)type {
    return [Constants No_Items_Available_STR];
}

- (void)didFinishUpdates {
    [self dispatchUpdateDelegateToRefresh];
}

- (void)dispatchUpdateDelegateToRefresh {
    if ([self.updateDelegate respondsToSelector:@selector(itemsListVC:didUpdateItems:inSection:)]) {
        [self.updateDelegate itemsListVC:self didUpdateItems:[self items] inSection:MKU_FIELD_LIST_TYPE_A];
    }
}

- (void)didUpdateItem:(__kindof NSObject<NSCopying> *)item atIndex:(NSUInteger)index {
    [self dispatchUpdateDelegateToRefreshItem:item];
    [self reloadDataAnimated:NO];
}

- (BOOL)addItem:(NSObject<MKUPlaceholderProtocol> *)item {
    return [self addItem:item toListOfType:MKU_FIELD_LIST_TYPE_A];
}

- (void)deleteItem:(NSObject<MKUPlaceholderProtocol> *)item {
    [self deleteItem:item fromListOfType:MKU_FIELD_LIST_TYPE_A];
}

- (NSArray *)addItems:(NSArray<NSObject<MKUPlaceholderProtocol> *> *)items {
    return [self addItems:items toListOfType:MKU_FIELD_LIST_TYPE_A];
}

- (void)deleteItems:(NSArray<NSObject<MKUPlaceholderProtocol> *> *)items {
    [self deleteItems:items fromListSection:MKU_FIELD_LIST_TYPE_A];
}

- (void)setSelectedObjectsWithSet:(NSSet *)selectedObjects {
    [self setSelectedObjectsWithSet:selectedObjects inListOfType:MKU_FIELD_LIST_TYPE_A];
}

- (NSSet *)selectedObjects {
    return [self selectedSetsInListOfType:MKU_FIELD_LIST_TYPE_A];
}

- (id)returnedInSelectObject {
    NSSet *set = [self selectedObjects];
    return self.tableView.allowsMultipleSelection ? set : set.anyObject;
}

- (id)returnedInCloseObject {
    return self.object.UpdatedObject.itemsA;
}

@end
