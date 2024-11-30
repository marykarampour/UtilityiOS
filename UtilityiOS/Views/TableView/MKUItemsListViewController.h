//
//  MKUItemsListViewController.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUTableViewController.h"
#import "NSObject+NavBarButtonTarget.h"
#import "MKUGenericTableViewControllerProtocols.h"
#import "UIViewController+Utility.h"

typedef NS_ENUM(NSUInteger, MKU_EDIT_LIST_SECTION_TYPE) {
    MKU_EDIT_LIST_SECTION_TYPE_ADD,
    MKU_EDIT_LIST_SECTION_TYPE_LIST,
    MKU_EDIT_LIST_SECTION_TYPE_COUNT
};

@class MKUItemsListViewController;

@protocol MKUItemsListVCUpdateDelegate <NSObject>

@optional
- (void)itemsListVC:(MKUItemsListViewController *)VC didUpdateItems:(NSArray <__kindof NSObject<MKUPlaceholderProtocol> *> *)items;
- (void)itemsListVC:(MKUItemsListViewController *)VC didUpdateItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndex:(NSUInteger)index;
- (void)itemsListVC:(MKUItemsListViewController *)VC didSetSelected:(BOOL)selected item:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndex:(NSUInteger)index;

@end

@protocol MKUItemsListVCNavBarDelegate <MKUNavBarButtonTargetProtocol>

@optional
- (void)addPressed:(UIBarButtonItem *)sender;
- (void)nextPressed:(UIBarButtonItem *)sender;
- (void)refreshPressed:(UIBarButtonItem *)sender;
- (void)closePressed:(UIBarButtonItem *)sender;

@end

/** @brief A list of items of the same object type.
 By default has navbar buttons of types MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE, MKU_NAV_BAR_BUTTON_TYPE_RESET, MKU_NAV_BAR_BUTTON_TYPE_CLOSE. */
@interface MKUItemsListViewController <__covariant ObjectType : NSObject<MKUPlaceholderProtocol> *> : MKUTableViewController <MKUItemsListVCTransitionDelegate, MKUItemsListVCProtocol, MKUItemsListVCUpdateDelegate, MKUNavBarButtonTargetProtocol, MKUViewControllerTransitionProtocol, MKUItemsListVCNavBarDelegate>

/** @brief For NSObject, override description and return the title to be presented in UI.
 If conforming to MKUPlaceholderProtocol title  will be used.
 @note If there is no items, it sets the footer to noItemAvailableTitleForListOfType: */
@property (nonatomic, strong) NSMutableArray <ObjectType> *items;

/** @brief It is nil if nothing is selected, rows in items section if an item is selected, otherwise it is the add section. */
@property (nonatomic, strong) NSMutableSet *selectedObjects;

/** @brief By default is is self. If this view is within a container, it can be assigned the container to handle
 transitions when an item is selected. */
@property (nonatomic, weak) id<MKUItemsListVCUpdateDelegate> updateDelegate;

@property (nonatomic, weak) id<MKUItemsListVCNavBarDelegate> navbarDelegate;

@property (nonatomic, assign) BOOL hasCloseButton;

- (void)setItemsWithArray:(NSArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)items;
- (void)resetSelectedObjects;

- (NSObject <MKUPlaceholderProtocol> *)objectAtIndex:(NSUInteger)index;
- (void)setSelectedObject:(__kindof NSObject<MKUPlaceholderProtocol> *)obj;
- (void)setDeselectedObject:(__kindof NSObject<MKUPlaceholderProtocol> *)obj;
- (void)setSelectedObjectsWithSet:(NSSet *)selectedObjects;

/** @brief Called in viewController:didReturnWithResultType:andObject: if it is updating existing object. It calls
 itemsListVC:didUpdateItem: and reloadDataAnimated: by default. Call super. */
- (void)didUpdateItem:(__kindof ObjectType)item atIndex:(NSUInteger)index;

/** @brief Called when setItems: addItems: and deleteItems: are done. Default calles updateDelegate
 itemsListVC:didUpdateItems: call super. */
- (void)didFinishUpdates;

/** @brief Implemented from MKUViewControllerNavigationBarProtocol. Override to not add any navbar buttons. */
//- (void)setNavBarItems;

- (NSIndexPath *)indexPathForItem:(__kindof ObjectType)item;
- (void)updateHeader;

- (ObjectType)listItemAtIndexPath:(NSIndexPath *)indexPath;

@end

