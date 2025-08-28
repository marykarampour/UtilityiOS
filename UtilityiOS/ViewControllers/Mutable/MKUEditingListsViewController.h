//
//  MKUEditingListsViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUMutableObjectTableViewController.h"

@interface MKUEditingListsViewController
<__covariant ObjectTypeA : __kindof NSObject<MKUPlaceholderProtocol> *,
 __covariant ObjectTypeB : __kindof NSObject<MKUPlaceholderProtocol> *,
 __covariant ObjectTypeC : __kindof NSObject<MKUPlaceholderProtocol> *,
 __covariant ObjectTypeD : __kindof NSObject<MKUPlaceholderProtocol> *> : MKUMutableObjectTableViewController <MKUFieldListModel <ObjectTypeA, ObjectTypeB, ObjectTypeC, ObjectTypeD> *, MKUFieldListModel <ObjectTypeA, ObjectTypeB, ObjectTypeC, ObjectTypeD> *> <MKUItemsListVCNavBarDelegate>

- (__kindof MKUUpdateListObject<ObjectTypeA, ObjectTypeB, ObjectTypeC, ObjectTypeD> *)object;
- (void)setObject:(__kindof MKUUpdateListObject<ObjectTypeA, ObjectTypeB, ObjectTypeC, ObjectTypeD> *)object;

@property (nonatomic, weak) id<MKUItemsListVCNavBarDelegate> navbarDelegate;
@property (nonatomic, assign) BOOL hasCloseButton;

- (instancetype)initWithListTypes:(MKU_FIELD_LIST_TYPE)types;
- (void)initBaseWithListTypes:(MKU_FIELD_LIST_TYPE)types;

- (void)setItemsWithArray:(NSArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)items forListOfType:(MKU_FIELD_LIST_TYPE)type;

/** @brief A subclass of MKUFieldListModel used to initialize object. Default is MKUFieldListModel. */
+ (Class)classForListObject;

- (void)updateHeader;
- (void)setEditButtonHidden:(BOOL)hidden;

@end

@interface MKUEditingListViewController <__covariant ObjectType : __kindof NSObject<MKUPlaceholderProtocol> *> : MKUEditingListsViewController <ObjectType, NSObject<MKUPlaceholderProtocol> *, NSObject<MKUPlaceholderProtocol> *, NSObject<MKUPlaceholderProtocol> *>

@property (nonatomic, strong) MKUUpdateSingleListObject <ObjectType> *object;

/** @brief For NSObject, override description and return the title to be presented in UI.
 If conforming to MKUPlaceholderProtocol title  will be used.
 @note If there is no items, it sets the footer to noItemAvailableTitleForListOfType: */
- (NSMutableArray<ObjectType> *)items;
/** @brief Default list is section 0. */
- (void)setItems:(NSMutableArray<ObjectType> *)items;
- (void)setItemsWithArray:(NSArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)items;

/** @brief Default list is section 0. */
- (BOOL)addItem:(ObjectType)item;
/** @brief Default list is section 0. */
- (void)deleteItem:(ObjectType)item;
/** @brief Default list is section 0. */
- (NSArray *)addItems:(NSArray<ObjectType> *)items;
/** @brief Default list is section 0. */
- (void)deleteItems:(NSArray<ObjectType> *)items;
/** @brief Default list is section 0. */
- (void)setSelectedObjectsWithSet:(NSSet *)selectedObjects;
/** @brief Default list is section 0. */
- (NSMutableSet *)selectedObjects;

/** @brief Called in viewController:didReturnWithResultType:object: if it is updating existing object. It calls
 itemsListVC:didUpdateItem: and reloadDataAnimated: by default. Call super. */
- (void)didUpdateItem:(__kindof ObjectType)item atIndex:(NSUInteger)index;

/** @brief Called when setItems: addItems: and deleteItems: are done. Default calles updateDelegate
 itemsListVC:didUpdateItems:inSection: call super. */
- (void)didFinishUpdates;
- (ObjectType)listItemAtIndexPath:(NSIndexPath *)indexPath;

@end

