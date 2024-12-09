//
//  MKUMenuObjects.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-25.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUModel.h"
#import "ActionObject.h"
#import "MKUMenuProtocols.h"

@interface MKUMenuObjects : MKUModel

@end

@interface MKUSectionObject : MKUModel

@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, assign) BOOL isCollapsable;

+ (instancetype)objectIsCollapsable:(BOOL)collapsable expanded:(BOOL)expanded;
+ (instancetype)objectIsCollapsable:(BOOL)collapsable;
+ (instancetype)blankObject;

@end

@interface MKUMenuItemObject : MKUModel

/** @brief Standard key, title of the veiw controller. Pass empty string if you want this item be hidden */
@property (nonatomic, strong) NSString *title;

/** @brief Standard key, subtitle of the menu item cell */
@property (nonatomic, strong) NSString *subtitle;

/** @brief Standard key, class of the veiw controller */
@property (nonatomic, assign) Class VCClass;

/** @brief Standard key, type of the veiw controller if it has initWithMKUType */
@property (nonatomic, assign) NSInteger type;

/** @brief Standard key, object of the veiw controller, a property to be set with the object passed as value of this key */
@property (nonatomic, strong) id object;

/** @brief Standard key, if YES then it checks if object responds to selector copyWithZone:
 if it does, setObject: or action will be performed on [object copy], otherwise, on object. */
@property (nonatomic, assign) BOOL shouldCopy;

/** @brief Standard key, action to be performed when the item is selected.
 If no target and the title is given, title will be used to create the target by performing its selector on the VC being pushed. */
@property (nonatomic, strong) ActionObject *action;

@property (nonatomic, assign) MKU_MENU_ACCESSORY_TYPE accessoryType;
@property (nonatomic, assign) MKU_MENU_SPINNER_STATE spinnerState;
@property (nonatomic, strong) MKUBadgeItem *badge;
@property (nonatomic, strong) UIImage *selectedIcon;
@property (nonatomic, strong) UIImage *deselectedIcon;

+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass;
+ (instancetype)objectWithTitle:(NSString *)title type:(NSInteger)type;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass object:(id)object;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass object:(id)object icon:(UIImage *)icon;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass action:(ActionObject *)action;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type object:(id)object;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type object:(id)object icon:(UIImage *)icon;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type action:(ActionObject *)action;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type action:(ActionObject *)action icon:(UIImage *)icon;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass icon:(UIImage *)icon;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type icon:(UIImage *)icon;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type icon:(UIImage *)icon badge:(MKUBadgeItem *)badge;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass icon:(UIImage *)icon badge:(MKUBadgeItem *)badge;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass selectedIcon:(UIImage *)selectedIcon deselectedIcon:(UIImage *)deselectedIcon badge:(MKUBadgeItem *)badge;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass accessoryType:(MKU_MENU_ACCESSORY_TYPE)accessoryType badge:(MKUBadgeItem *)badge;
+ (instancetype)objectWithTitle:(NSString *)title VCClass:(Class)VCClass type:(NSInteger)type accessoryType:(MKU_MENU_ACCESSORY_TYPE)accessoryType badge:(MKUBadgeItem *)badge;
+ (instancetype)objectWithTitle:(NSString *)title subtitle:(NSString *)subtitle VCClass:(Class)VCClass type:(NSInteger)type icon:(UIImage *)icon;
+ (instancetype)objectWithTitle:(NSString *)title subtitle:(NSString *)subtitle VCClass:(Class)VCClass type:(NSInteger)type object:(id)object shouldCopy:(BOOL)shouldCopy;
+ (instancetype)objectWithTitle:(NSString *)title subtitle:(NSString *)subtitle VCClass:(Class)VCClass type:(NSInteger)type object:(id)object shouldCopy:(BOOL)shouldCopy accessoryType:(MKU_MENU_ACCESSORY_TYPE)accessoryType badge:(MKUBadgeItem *)badge;

@end

@interface MKUMenuSectionObject : MKUSectionObject

/** @brief Standard keys are first used, and key not among standard keys will be considered a selector with object passed as value of this key.
 If key is not any of the standard keys but its value is of type ActionObject the action will be performed, its target is ignored, the key is used to create
 the target as its getter, e.g., self.controller is a property, controller is a key, target will be controller, otherwise, the VC performs the action if possible  */
@property (nonatomic, strong) NSArray<MKUMenuItemObject *> *menuItemObjects;
@property (nonatomic, strong) NSString *title;

+ (instancetype)sectionWithTitle:(NSString *)title objects:(NSArray<MKUMenuItemObject *> *)objects;
+ (instancetype)sectionWithObjects:(NSArray<MKUMenuItemObject *> *)objects;

@end
