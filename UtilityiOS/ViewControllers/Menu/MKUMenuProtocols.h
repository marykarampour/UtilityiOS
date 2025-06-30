//
//  MKUMenuProtocols.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-25.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUViewContentStyleProtocols.h"
#import "MKUBadgeItem.h"
#import "MKUBadgeView.h"

@protocol MKUMenuProtocol <NSObject>

@end

@class MKUMenuItemObject;
@class MKUMenuSectionObject;

typedef NS_ENUM(NSUInteger, MKU_MENU_SPINNER_STATE) {
    MKU_MENU_SPINNER_STATE_NONE,
    MKU_MENU_SPINNER_STATE_ACTIVE,
    MKU_MENU_SPINNER_STATE_INACTIVE,
};

typedef NS_OPTIONS(NSUInteger, MKU_MENU_ACCESSORY_TYPE) {
    MKU_MENU_ACCESSORY_TYPE_NONE       = 0,
    MKU_MENU_ACCESSORY_TYPE_BADGE      = 1 << 0,
    MKU_MENU_ACCESSORY_TYPE_SPINNER    = 1 << 1,
    MKU_MENU_ACCESSORY_TYPE_DISCLOSURE = 1 << 2
};

@protocol MKUMenuViewControllerProtocol <MKUCellStyleProtocol, MKUBadgeItemUpdateDelegate>

@required
- (void)transitionToViewAtIndexPath:(NSIndexPath *)indexPath;
- (MKUMenuItemObject *)menuObjectAtIndexPath:(NSIndexPath *)indexPath;
- (UIViewController *)nextViewControllerForIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSArray<MKUMenuSectionObject *> *menuObjects;

@optional
- (void)reload;
- (void)createMenuObjects;
- (void)didSetMenuObjects:(NSArray<MKUMenuSectionObject *> *)menuObjects;

/** @brief Perform any dynamic set up of this view controller if necessary before transition.
 Appropriate for cases were the data might change from one trnsition to another.
 Default does nothing. */
- (void)willTransitionToView:(UIViewController *)VC atIndexPath:(NSIndexPath *)indexPath;

@end


