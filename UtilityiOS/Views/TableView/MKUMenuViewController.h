//
//  MKUMenuViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-24.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUCollapsableSectionsTableViewController.h"
#import "ActionObject.h"
#import "MKUBadgeView.h"

@class MKUMenuObject;

@interface SpinnerItem : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL inProgress;

@end

@interface MKUMenuTableViewCell : MKUBaseTableViewCell

@property (nonatomic, strong, readonly) UIImageView *iconImage;
@property (nonatomic, strong, readonly) MKULabel *titleLabel;

@end


@protocol MenuViewControllerProtocol <NSObject>

@required
- (void)createMenuObjects;
- (void)transitionToView:(NSIndexPath *)indexPath animated:(BOOL)animated;

/** @brief Subclass must subclass MKUBaseTableViewCell and return this as base cell for menu items
 @code
 - (MKUBaseTableViewCell *)baseCellForRowAtIndexPath:(NSIndexPath *)indexPath {
 MKUBaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MKUBaseTableViewCell identifier]];
 if (!cell) {
 cell = [[MKUBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MKUBaseTableViewCell identifier]];
 }
 return cell;
 }
 @ebdcode
 */
- (__kindof MKUBaseTableViewCell *)baseCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (__kindof MKUMenuTableViewCell *)baseMenuCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)customizeBaseMenuCell:(__kindof MKUMenuTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)numberOfRowsInNonMenuSectionWhenExpanded:(NSUInteger)section;
- (NSString *)titleForHeaderInNonMenuSection:(NSInteger)section;
- (CGFloat)heightForVisibleRowAtIndexPath:(NSIndexPath *)indexPath;
/** @brief Override to set selected color, font etc. to be updated at reload */
- (void)setStyleForItem:(MKUMenuObject *)item atIndexPath:(NSIndexPath *)indexPath;

@end

static NSString * const titleKey = @"title";
static NSString * const classKey = @"class";
static NSString * const typeKey  = @"type";


@interface MKUMenuObject : NSObject

@property (nonatomic, assign) Class VCClass;

/** @brief In case of class clusters of VCs, this returns the subclasses class */
@property (nonatomic, assign, readonly) Class trueVCClass;

@property (nonatomic, strong) NSString *title;

/** @brief type is used if the VC being pushed uses initWithType */
@property (nonatomic, assign) NSUInteger type;

/** @brief The hidden item can be used for navigation controller VCs which are skiped by the menu*/
@property (nonatomic, assign) BOOL hidden;

/** @brief if this action is provided, instead of transitioning to VC the action will be performed */
@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) BOOL hasSpinner;
@property (nonatomic, assign) BOOL hasBadge;
/** @brief only used if hasSpinner is YES */
@property (nonatomic, strong) SpinnerItem *spinner;
/** @brief only used if hasBadge is YES */
@property (nonatomic, strong) MKUBadgeItem *badge;

/** @brief Use this method to set properties for the VC being presented */
@property (nonatomic, strong) ActionObject *actionObject;

@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, strong) UIView *accessoryView;

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat iconSize;

/** @brief Call this after VCClass and type are set */
- (void)setTrueVCClass;
- (UIViewController *)viewController;

@end

@interface MKUMenuSection : MKUTableViewSection

@property (nonatomic, strong) NSArray<MKUMenuObject *> *items;

@end


@interface MKUMenuViewController : MKUCollapsableSectionsTableViewController <MenuViewControllerProtocol>

/** @brief The container view controller if the menu is added to one,
 if not null it is used for navigation, otherwise menu is used */
@property (nonatomic, weak) __kindof UIViewController *containerVC;
@property (nonatomic, strong) NSIndexPath *selectedOption;
@property (nonatomic, strong) NSMutableArray<__kindof MKUMenuSection *> *sections;

+ (UIViewController *)viewControllerForObject:(MKUMenuObject *)obj;
/** @breif call this method to programmatically trnsition to a view in the menu */
- (void)transitionToView:(NSIndexPath *)indexPath animated:(BOOL)animated;
/** @breif call this method to programmatically trnsition to the next view in the menu
 @note the view which push self is of type menu */
+ (void)transitionToNextItemFromView:(__kindof UIViewController *)VC;

- (void)reloadSectionKeepSelection:(NSUInteger)section;
- (void)reloadRowsKeepSelection:(NSArray *)indexPaths;
- (SpinnerItem *)spinnerItemForIndexPath:(NSIndexPath *)indexPath;
- (void)reloadBadgeSections;
- (void)setItemsStyle;
- (void)reloadMenu;

- (MKUMenuObject *)menuItemForIndexPath:(NSIndexPath *)indexPath;
- (MKUMenuSection *)menuSectionForSection:(NSUInteger)section;
- (MKUMenuSection *)menuSectionForItem:(MKUMenuObject *)item;

//Abstracts
- (void)updateBadges;
- (void)updateBadge:(MKUBadgeItem *)badge;
- (void)badgeUpdated:(MKUBadgeItem *)badge;
- (UITableViewCellAccessoryType)accessoryTypeForIndexPath:(NSIndexPath *)indexPath;
- (UIView *)accessoryViewForIndexPath:(NSIndexPath *)indexPath;

@end
