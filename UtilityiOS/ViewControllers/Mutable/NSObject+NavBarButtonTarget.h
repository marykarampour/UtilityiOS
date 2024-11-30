//
//  NSObject+NavBarButtonTarget.h
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUNavBarButtonTargetProtocol.h"
#import "UIViewController+Utility.h"

/** @brief In MKU app almost all screens have a save and possibly also a reset button.
 Because this feature is very common these buttons are added to UIViewController as category. */
@interface NSObject (NavBarButtonTarget) <MKUNavBarButtonTargetProtocol>

- (UIBarButtonItem *)buttonOfType:(NSUInteger)type position:(MKU_NAV_BAR_BUTTON_POSITION)position;

/** @brief Will return any button of type MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE or MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT or MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE.
 These 3 types are mututally exclusive. */
- (UIBarButtonItem *)doneButton;

/** @brief Adds a button of the given type if it doesn't exist.
 @note MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE or MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT or MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE are mututally exclusive.
 When one is added the others are removed.*/
- (void)addButtonOfType:(NSUInteger)type position:(MKU_NAV_BAR_BUTTON_POSITION)position;

/** @brief Will return YES if type is one of MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE or MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT or MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE.
 These 3 types are mututally exclusive. */
+ (BOOL)isDoneButtonOfType:(NSUInteger)type;

/** @brief Will return YES if type is one of MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE or MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_EDIT or MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE.
 These 3 types are mututally exclusive. */
- (BOOL)isDoneButtonOfType:(NSUInteger)type;

/** @brief Removes all buttons added via addButtonOfType: position: */
- (void)clearBarButtons;

@end


@interface UIViewController (NavBarButtonContainer) //<MKUNavBarButtonContainerProtocol>

- (NSArray<NSObject<MKUNavBarButtonTargetProtocol> *> *)navBarTargets;
/** @brief It sets self as the owner of the navbar. Call this starting from the inner most VC, each time this is called it is reset.
 The desirable effect is to have the ouer most container VC own the navbar. Call in outer most container. */
- (void)addNavBarTarget:(NSObject<MKUNavBarButtonTargetProtocol> *)object;
/** @brief Call in outer most container. It calls setNavBarItems. */
- (void)setNavBarItemsOfTarget:(NSObject<MKUNavBarButtonTargetProtocol> *)object;
/** @brief Call in outer most container. It calls setNavBarItems. */
- (void)setNavBarItemsOfTargetAtIndex:(NSUInteger)index;
/** @brief Call in outer most container. */

/** @brief Calls addNavBarTarget and setNavBarItemsOfTarget on self. Call this to set navbar items. */
- (void)setAsNavBarTarget;

/** @brief Clears the navbar and calls setAsNavBarTarget. */
- (void)resetBarButtons;

/** @brief Clears the navbar and calls setBarButtonsOfTarget. */
- (void)resetBarButtonsOfTarget:(NSObject<MKUNavBarButtonTargetProtocol> *)object;

/** @brief Calls addNavBarTarget and setNavBarItemsOfTarget on object. Call this to set navbar items. */
- (void)setBarButtonsOfTarget:(NSObject<MKUNavBarButtonTargetProtocol> *)object;

/** @brief Clears the navbar and calls setAsNavBarTarget on all targets. */
- (void)resetBarButtonsOfTargets;

/** @brief Clalls setBarButtonsOfTarget on all targets. */
- (void)setBarButtonsOfTargets;

/** @brief Clears the navbar and calls setAsNavBarTarget of viewControllerContainingNavigationBar on self as target. */
- (void)setBarButtonsOfViewControllerContainingNavigationBar;

@end

//1. Implement MKUNavBarButtonTargetProtocol methods in target / child VC
//2. Add target / child VC to container
//3. Set navbar items for target
//  1. Clear self navbar
//  2. Clear target navbar
//  3. Adds all items of a target to self navbar
//

//Nav bar items can be in one of these
//
//  self
//  header container
//  split container
//  page control inside header container
//
//  vc inside header inside container
//
//  a nav bar can have items from several of its vc children
//  several targets for containers that each can have a different function
//
//Can use these to add nav bar items
//
//  setAsNavBarTarget
//  setMutableNavBarItems
//  resetBarButtons
//  resetBarButtonsOfTarget
