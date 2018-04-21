//
//  MKMenuViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-24.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKCollapsableSectionsTableViewController.h"
#import "BadgeView.h"

@interface SpinnerItem : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL inProgress;

@end

@interface MKMenuTableViewCell : MKTableViewCell

@end


@protocol MenuViewControllerProtocol <NSObject>

@required
- (void)createMenuObjects;
- (void)transitionToView:(NSIndexPath *)indexPath;

/** @brief Subclass must subclass MKTableViewCell and return this as base cell for menu items
 @code
 - (MKTableViewCell *)baseCellForRowAtIndexPath:(NSIndexPath *)indexPath {
     MKTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MKTableViewCell identifier]];
     if (!cell) {
        cell = [[MKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MKTableViewCell identifier]];
     }
     return cell;
 }
 @ebdcode
 */
- (__kindof MKTableViewCell *)baseCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (__kindof MKMenuTableViewCell *)baseMenuCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)numberOfRowsInNonMenuSectionWhenExpanded:(NSUInteger)section;
- (NSString *)titleForHeaderInNonMenuSection:(NSInteger)section;

@end

static NSString * const titleKey = @"title";
static NSString * const classKey = @"class";
static NSString * const typeKey  = @"type";


@interface MKMenuObject : NSObject

@property (nonatomic, assign) Class VCClass;
@property (nonatomic, strong) NSString *title;

/** @brief type is used if the VC being pushed uses initWithType */
@property (nonatomic, assign) NSUInteger type;

/** @brief if this action is provided, instead of transitioning to VC the action will be performed */
@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) BOOL hasSpinner;
@property (nonatomic, assign) BOOL hasBadge;
/** @brief only used if hasSpinner is YES */
@property (nonatomic, strong) SpinnerItem *spinner;
/** @brief only used if hasBadge is YES */
@property (nonatomic, strong) MKBadgeItem *badge;

@end

@interface MKMenuSection : MKTableViewSection

@property (nonatomic, strong) NSArray<MKMenuObject *> *menuItems;
@property (nonatomic, strong) NSString *title;

@end


@interface MKMenuViewController : MKCollapsableSectionsTableViewController <MenuViewControllerProtocol>

@property (nonatomic, strong) NSIndexPath *selectedOption;

- (void)reloadSectionKeepSelection:(NSUInteger)section;
- (void)reloadRowsKeepSelection:(NSArray *)indexPaths;
- (SpinnerItem *)spinnerItemForIndexPath:(NSIndexPath *)indexPath;
- (void)reloadBadgeSections;

- (MKMenuObject *)menuItemForIndexPath:(NSIndexPath *)indexPath;
- (MKMenuSection *)menuSectionForSection:(NSUInteger)section;
- (MKMenuSection *)menuSectionForItem:(MKMenuObject *)item;

//Abstracts
- (void)updateBadges;
- (void)updateBadge:(MKBadgeItem *)badge;
- (void)badgeUpdated:(MKBadgeItem *)badge;


@end
