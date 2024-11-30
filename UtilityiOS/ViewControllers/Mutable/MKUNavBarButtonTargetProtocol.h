//
//  MKUNavBarButtonTargetProtocol.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "UIBarButtonItem+NavBarButtonObject.h"

/** @brief Indicates whether the nav bar has a button.
 @note Put in the inner most view controller. */
@protocol MKUNavBarButtonTargetProtocol <NSObject>

@optional
/** @brief This is called by default when viewControllerContainingNavigationBar is set in UIViewController + MKUViewControllerNavigationBar.
 If other navbar setting functions need to be called, either call them explicitly, or implement this method and call them inside this.
 @code
 - (void)setNavBarItems {
 [self setMutableNavBarItems];
 }
 @endcode */
- (void)setNavBarItems;

/** @brief Indicates whether the nav bar has a button.
 @note Put in the inner most view controller. */
- (BOOL)hasButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type;

/** @brief If not implemented, the button will be positioned at right. */
- (MKU_NAV_BAR_BUTTON_POSITION)positionForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type;

/** @brief title of the  button if type is not MKU_NAV_BAR_BUTTON_TYPE_IMAGE, otherwise it is the name of the image resource.
 @note Put in the inner most view controller. */
- (NSString *)titleForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type;

- (UIImage *)imageForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type;

/** Passed to saveAction when savePressed. */
- (id)saveObject;

- (BOOL)isEnabledButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type;

/** @brief Handles action performed when pressing the save button. Default is handleSavePressed in MKUMutableObjectTableViewController.
 @note Setting this property will make actionHandler nil. */
- (SEL)actionForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type;

/** @brief Handles action performed when pressing the button. Default is handleSavePressed in MKUMutableObjectTableViewController.
 @note Setting this property will make action nil. */
- (void (^)(id))actionHandlerForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type;

/** @brief This must implement actionForButtonOfType and actionHandlerForButtonOfType otherwise self will be used. */
- (id)targetForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type;

@end
