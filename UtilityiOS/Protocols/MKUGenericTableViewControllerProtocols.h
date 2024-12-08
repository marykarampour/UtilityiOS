//
//  MKUGenericTableViewControllerProtocols.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-24.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUViewControllerTransitionProtocol.h"
#import "MKUViewContentStyleProtocols.h"

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
- (void)didSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;
- (NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)listItemsForListOfType:(NSUInteger)type;
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


@protocol MKUEditingListVCProtocol <MKUViewControllerTransitionDelegate>

@required
- (BOOL)canAddItemToListOfType:(NSUInteger)type;
- (BOOL)canDeleteFromListOfType:(NSUInteger)type;
/** @brief Return YES if self.editing should be always YES. The navbar will not have the edit button in this case. Default is NO. */
- (BOOL)canEditListsByDefault;
- (NSString *)titleForAddCellInListOfType:(NSUInteger)type;
- (CGFloat)heightForNonEditingListRowAtIndexPath:(NSIndexPath *)indexPath;

/** @brief Peform any actions required to delete this item. In the completion, this ittem will be removed from the list. */
- (void)willDeleteItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item forRowAtIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(BOOL success, NSError *error))completion;

/** @brief Peform any actions required after deleting this item such as updating navbar.. */
- (void)didDeleteItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item forRowAtIndexPath:(NSIndexPath *)indexPath;

/** @brief Peform any actions required to construct this item. In the completion, this ittem will be add to the list. */
- (void)willAddItemToListOfType:(NSUInteger)type withCompletion:(void (^)(__kindof NSObject<MKUPlaceholderProtocol> *item))completion;

/** @brief If YES, the item is added on spot, if NO, presentTransitioningViewControllerWithItem is called to handle adding the new item.
 Default returns NO. */
- (BOOL)shouldAddItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item toListOfType:(NSUInteger)type;

/** @brief Called after insert or delete actions are performed. Use to update other elements such as navbar. */
- (void)didFinishCommitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

/** By default when viewController: didReturnWithResultType: andObject: is triggered, the object is either added if selected index was add, or otherwise, the items replace the  item at selected index
 with the object, unless the object is of a different type than that of items, in which case this method is called to handle the update. */
- (void)updateItemsWithUnmatchedTypeItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndex:(NSUInteger)index;

/** @brief Return a new item to be used in willAddItemToListOfType:(NSUInteger)type withCompletion. Default uses  itemsClass to initialize it. */
- (__kindof NSObject<MKUPlaceholderProtocol> *)newItemInListOfType:(NSUInteger)type;

- (Class)itemsClassInListOfType:(NSUInteger)type;

@optional
- (void)item:(__kindof NSObject<MKUPlaceholderProtocol> *)item1 didMoveFromIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2 inListOfType:(NSUInteger)type;

@end

