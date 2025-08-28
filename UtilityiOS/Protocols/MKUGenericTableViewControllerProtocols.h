//
//  MKUGenericTableViewControllerProtocols.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUViewControllerTransitionProtocol.h"
#import "MKUViewContentStyleProtocols.h"
#import "NSObject+NavBarButtonTarget.h"

@protocol MKUGenericTableViewControllerProtocols <NSObject>

@end

@class MKUBaseTableViewCell;

@protocol MKUItemsListVCTransitionDelegate <NSObject>

@optional
- (void)handleTransitionToViewController:(UIViewController *)VC sourceViewController:(UIViewController *)sourceVC didSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;
- (void)handleDismissDestinationViewController:(UIViewController *)VC;

@end


@protocol MKUItemsListVCProtocol <NSObject>

@optional
/** @brief Default uses textLabelAtIndexPath and detailTextLabelAtIndexPath and  attributedTextLabelAtIndexPath and attributedDetailTextLabelAtIndexPath. */
- (void)setTextForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell;
/** @brief Default sets accessoryType and selectionStyle. */
- (void)setStyleForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell;
- (UITableViewCellAccessoryType)accessoryTypeForRowAtIndexPath:(NSIndexPath *)indexPath;
/** @brief Default is UITableViewCellAccessoryCheckmark. */
- (UITableViewCellAccessoryType)accessoryTypeForSelectedRowForListOfType:(NSUInteger)type;
/** @brief Default is UITableViewCellAccessoryNone. */
- (UITableViewCellAccessoryType)accessoryTypeForDeselectedRowForListOfType:(NSUInteger)type;
/** @brief Default is UITableViewCellAccessoryDisclosureIndicator. */
- (UITableViewCellAccessoryType)accessoryTypeForSingleDeselectedRowForListOfType:(NSUInteger)type;
/** @brief If allowsMultipleSelection it is defaulted to UITableViewCellSelectionStyleNone else UITableViewCellSelectionStyleDefault. */
- (UITableViewCellSelectionStyle)selectionStyleForListOfType:(NSUInteger)type;

/** @brief Default returns YES. */
- (BOOL)canSelectSection:(NSUInteger)section;
- (NSString *)noItemAvailableTitleForListOfType:(NSUInteger)type;
- (NSString *)textLabelAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)detailTextLabelAtIndexPath:(NSIndexPath *)indexPath;
- (NSAttributedString *)attributedTextLabelAtIndexPath:(NSIndexPath *)indexPath;
- (NSAttributedString *)attributedDetailTextLabelAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)isSelectedRowAtIndexPath:(NSIndexPath *)indexPath;
- (__kindof MKUBaseTableViewCell *)cellForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;
/** @brief Called in tableView: didSelectRowAtIndexPath: or methods called by it when a section is of type list or
 tableView: commitEditingStyle: forRowAtIndexPath for UITableViewCellEditingStyleInsert.
 Corresponds to selectedActionHandler of type MKU_LIST_ITEM_SELECTED_ACTION_SELECT and MKU_LIST_ITEM_SELECTED_ACTION_SHOW_DETAIL */
- (void)didSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;
- (NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)listItemsForListOfType:(NSUInteger)type;
- (NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)listItemsForListInSection:(NSUInteger)section;
- (BOOL)canSelectItemsInListOfType:(NSUInteger)type;
- (NSUInteger)listTypeForListInSection:(NSUInteger)section;
- (NSObject<MKUPlaceholderProtocol> *)listItemAtIndexPath:(NSIndexPath *)indexPath;

/** @brief Retun view controller to be pushed when an item is selected. It will be called in
 willAddItemToListOfType:(NSUInteger)type withCompletion as well. Return nil to do custom actions. */
- (void)transitioningViewControllerForItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath completion:(void(^)(UIViewController *VC))completion;

/** @brief Pushes the view controller returned by transitioningViewControllerForItem:atIndexPath when an item is selected. It will be called in willAddItemToListOfType:(NSUInteger)type withCompletion as well. Return nil in transitioningViewControllerForItem to do custom actions, or override this. */
- (void)presentTransitioningViewControllerWithItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;

/** @brief By default is is self. If this view is within a container, it can be assigned the container to handle
 transitions when an item is selected. */
@property (nonatomic, weak) id<MKUItemsListVCTransitionDelegate> transitionVCDelegate;

@end

@protocol MKUItemsListVCNavBarDelegate <MKUNavBarButtonTargetProtocol>

@optional
- (void)addPressed:(UIBarButtonItem *)sender;
- (void)nextPressed:(UIBarButtonItem *)sender;
- (void)refreshPressed:(UIBarButtonItem *)sender;
- (void)closePressed:(UIBarButtonItem *)sender;
- (void)clearPressed:(UIBarButtonItem *)sender;

@end


@protocol MKUEditingListVCProtocol <MKUViewControllerTransitionDelegate>

@required
- (BOOL)canAddItemToListOfType:(NSUInteger)type;
- (BOOL)canDeleteFromListOfType:(NSUInteger)type;
- (BOOL)canMoveItemsInListOfType:(NSUInteger)type;
/** @brief Return YES if self.editing should be always YES. The navbar will not have the edit button in this case. Default is NO. */
- (BOOL)canEditListsByDefault;
- (NSString *)titleForAddCellInListOfType:(NSUInteger)type;
- (CGFloat)heightForNonEditingListRowAtIndexPath:(NSIndexPath *)indexPath;

/** @brief Peform any actions required to delete this item. In the completion, this ittem will be removed from the list. */
- (void)willDeleteItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item forRowAtIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(BOOL success, NSError *error))completion;

/** @brief Peform any actions required after deleting this item such as updating navbar. */
- (void)didDeleteItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item forRowAtIndexPath:(NSIndexPath *)indexPath;

/** @brief Peform any actions required to construct this item. In the completion, this ittem will be add to the list. */
- (void)willAddItemToListOfType:(NSUInteger)type withCompletion:(void (^)(__kindof NSObject<MKUPlaceholderProtocol> *item))completion;

/** @brief Peform any actions required after adding this item such as updating navbar. */
- (void)didAddItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item forRowAtIndexPath:(NSIndexPath *)indexPath;

/** @brief If YES, the item is added on spot, if NO, presentTransitioningViewControllerWithItem is called to handle adding the new item.
 Default returns NO. */
- (BOOL)shouldAddItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item toListOfType:(NSUInteger)type;

/** @brief Called after insert or delete actions are performed. Use to update other elements such as navbar. */
- (void)didFinishCommitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

/** By default when viewController: didReturnWithResultType: object: is triggered, the object is either added or replaced if existing, or
 the object is of a different type than that of items which results in failure, in any case this method is called to handle the update's result.
 @param update YES if update succeeds and NO if it fails. */
- (void)didUpdate:(BOOL)update item:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;

/** @brief Return a new item to be used in willAddItemToListOfType:(NSUInteger)type withCompletion. Default uses  itemsClass to initialize it. */
- (__kindof NSObject<MKUPlaceholderProtocol> *)newItemInListOfType:(NSUInteger)type;

- (Class)itemsClassInListOfType:(NSUInteger)type;

/** @brief The object which will be retunred to transitionDelegate when Done / Next button ia pressed, e.g., selected items. */
- (id)returnedInSelectObject;
/** @brief The object which will be retunred to transitionDelegate when Close button is pressed, e.g., items. */
- (id)returnedInCloseObject;

@optional
- (void)item:(__kindof NSObject<MKUPlaceholderProtocol> *)item1 didMoveFromIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2 inListOfType:(NSUInteger)type;

@end

@protocol MKUItemsListVCUpdateDelegate <NSObject>

@optional
- (void)itemsListVC:(UIViewController<MKUEditingListVCProtocol, MKUItemsListVCProtocol> *)VC didUpdateItems:(NSArray <__kindof NSObject<MKUPlaceholderProtocol> *> *)items inSection:(NSUInteger)section;
- (void)itemsListVC:(UIViewController<MKUEditingListVCProtocol, MKUItemsListVCProtocol> *)VC didUpdateItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;
- (void)itemsListVC:(UIViewController<MKUEditingListVCProtocol, MKUItemsListVCProtocol> *)VC didSetSelected:(BOOL)selected item:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;

@end
