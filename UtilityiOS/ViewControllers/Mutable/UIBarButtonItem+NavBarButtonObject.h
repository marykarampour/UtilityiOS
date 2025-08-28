//
//  UIBarButtonItem+NavBarButtonObject.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUModel.h"

typedef NS_ENUM(NSUInteger, MKU_NAV_BAR_BUTTON_POSITION) {
    MKU_NAV_BAR_BUTTON_POSITION_RIGHT,
    MKU_NAV_BAR_BUTTON_POSITION_LEFT
};
/** @note If using your own types, start from MKU_NAV_BAR_BUTTON_TYPE_COUNT, don't reuse these.
 MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SPACER is not unique.
 
 @code
 typedef NS_ENUM(NSUInteger, MKU_MY_NAV_BAR_BUTTON_TYPE) {
 MKU_MY_NAV_BAR_BUTTON_TYPE_DETAILS = MKU_NAV_BAR_BUTTON_TYPE_COUNT,
 MKU_MY_NAV_BAR_BUTTON_TYPE_PHOTOS
 };
 @endcode */
typedef NS_ENUM(NSInteger, MKU_NAV_BAR_BUTTON_TYPE) {
    MKU_NAV_BAR_BUTTON_TYPE_NONE = -1,
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE     = UIBarButtonSystemItemDone, /** Used in MKUItemsListViewController. Mututally exclusive with EDIT and SAVE. */
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT     = UIBarButtonSystemItemEdit, /** Used in MKUEditingListsViewController. Mututally exclusive with DONE and SAVE. */
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE     = UIBarButtonSystemItemSave, /** USed in MKUMutableObjectTableViewController. Mututally exclusive with EDIT and DONE. */
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_ADD      = UIBarButtonSystemItemAdd,
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SEARCH   = UIBarButtonSystemItemSearch,
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_REFRESH  = UIBarButtonSystemItemRefresh,
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SPACER   = UIBarButtonSystemItemFixedSpace,
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_CAMERA   = UIBarButtonSystemItemCamera,
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_CLOSE    = UIBarButtonSystemItemClose,
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_TRASH    = UIBarButtonSystemItemTrash,
    MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_COUNT,//No item, marks the end of system items
    MKU_NAV_BAR_BUTTON_TYPE_RESET,
    MKU_NAV_BAR_BUTTON_TYPE_CLEAR,
    MKU_NAV_BAR_BUTTON_TYPE_CLOSE,
    MKU_NAV_BAR_BUTTON_TYPE_ALL,
    MKU_NAV_BAR_BUTTON_TYPE_EMAIL,
    MKU_NAV_BAR_BUTTON_TYPE_PRINT,
    MKU_NAV_BAR_BUTTON_TYPE_SHARE,
    MKU_NAV_BAR_BUTTON_TYPE_COUNT
};

@interface UIBarButtonItem (NavBarButtonObject)

@property (nonatomic, assign) MKU_NAV_BAR_BUTTON_TYPE type;
@property (nonatomic, assign) MKU_NAV_BAR_BUTTON_POSITION position;

/** @brief Handles action performed when pressing the button. Default is handleSavePressed in MKUMutableObjectTableViewController.
 @note Setting this property will make actionHandler nil. saveObject is passed as parameter. */
@property (nonatomic, assign) SEL objectAction;

/** @brief Handles action performed when pressing the button.
 @note Setting this property will make action nil. */
@property (copy) void(^actionHandler)(id object);

/** @brief Creates a blank object, the buttonItem is not set, it will be set only when added to navbar in UIViewController (BarButtonContainer). */
+ (instancetype)editNavBarButtonObject;
+ (instancetype)editNavBarButtonObjectWithEditButton:(UIBarButtonItem *)edit;
/** @brief Creates a button using initWithTitle it title is given, if title is empty it uses initWithBarButtonSystemItem. */
+ (instancetype)navBarButtonWithTitle:(NSString *)title type:(MKU_NAV_BAR_BUTTON_TYPE)type target:(id)target enabled:(BOOL)enabled;
/** @brief Creates a button using initWithTitle it title is given, if title is empty it uses initWithBarButtonSystemItem. */
+ (instancetype)navBarButtonWithTitle:(NSString *)title type:(MKU_NAV_BAR_BUTTON_TYPE)type target:(id)target action:(SEL)action objectAction:(SEL)objectAction actionHandler:(void(^)(id))actionHandler enabled:(BOOL)enabled;
+ (instancetype)navBarButtonWithImage:(UIImage *)image type:(MKU_NAV_BAR_BUTTON_TYPE)type target:(id)target action:(SEL)action objectAction:(SEL)objectAction actionHandler:(void (^)(id))actionHandler enabled:(BOOL)enabled;
/** @brief Creates a button using initWithTitle it title is given, if title is empty it uses initWithBarButtonSystemItem. */
+ (instancetype)navBarButtonWithTitle:(NSString *)title type:(MKU_NAV_BAR_BUTTON_TYPE)type target:(id)target action:(SEL)action;
+ (instancetype)navBarButtonWithImage:(UIImage *)image type:(MKU_NAV_BAR_BUTTON_TYPE)type target:(id)target action:(SEL)action;
+ (instancetype)spacer;

@end
