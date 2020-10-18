//
//  MKTableViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKLabel.h"
#import "MKBadgeItem.h"
#import "MKBaseTableViewCell.h"
#import "ViewControllerTransitionDelegate.h"

typedef NS_ENUM(NSUInteger, MKTableViewAccessoryViewType) {
    MKTableViewAccessoryViewType_HEADER,
    MKTableViewAccessoryViewType_FOOTER
};

@protocol MKTableViewControllerDelegate <NSObject>

@optional
- (void)badgeUpdated:(MKBadgeItem * _Nonnull)badge;
- (void)viewTransition:(UIViewController * _Nullable)viewController withObject:(id _Nullable)object;

@end

@interface MKTableViewController : UITableViewController <MKTableViewControllerDelegate>

@property (nonatomic, weak) _Nullable id<MKTableViewControllerDelegate> delegate;
@property (nonatomic, weak) id<ViewControllerTransitionDelegate> transitionDelegate;

@property (nonatomic, strong, nullable) NSString *footerTitle;

@property (nonatomic, strong) MKLabelMetaData *sectionHeaderData;
@property (nonatomic, strong) MKLabelMetaData *sectionFooterData;

- (instancetype _Nonnull)initWithType:(NSInteger)type;

- (void)updateTableView;
- (void)reloadDataAnimated:(BOOL)animated;
- (void)reloadAllSections;
- (void)reloadSection:(NSUInteger)section;
- (void)reloadSection:(NSUInteger)section completion:(void (^)(void))completion;
- (void)reloadSections:(NSArray<NSNumber *> *)sections completion:(void (^)(void))completion;
- (void)reloadSectionsSet:(NSIndexSet *)sections completion:(void (^)(void))completion;
- (void)reloadIndexPaths:(IndexPathArr * _Nullable)indexPaths;
- (void)reloadSection:(NSUInteger)section withHeader:(BOOL)header;
- (void)removeRowsAtIndexPaths:(IndexPathArr * _Nullable)indexPaths;
- (void)insertRowsAtIndexPaths:(IndexPathArr * _Nullable)indexPaths;
- (void)deselectAllExcept:(NSIndexPath *)indexPath animated:(BOOL)animated;

- (void)getBadge:(NSString * _Nonnull)badgeName;
- (void)updateBadge:(MKBadgeItem * _Nonnull)badge;

//Abstract
/** @brief subclass must return updated badges to be used on badge rows **/
- (NSArray<MKBadgeItem *> *)updatedBadges;

#pragma mark - custom views

- (UIView *)defaultSectionFooter;

- (void)createTableAccessoryViewOfType:(MKTableViewAccessoryViewType)type withTitle:(NSString *)title;
- (void)createTableAccessoryViewOfType:(MKTableViewAccessoryViewType)type withAttributedTitle:(NSAttributedString *)title;
- (void)setView:(__kindof UIView *)view forAccessoryViewOfType:(MKTableViewAccessoryViewType)type;

- (void)scrollToBottomWithDalay:(CGFloat)delay;
- (void)scrollToBottomOfSection:(NSUInteger)section withDalay:(CGFloat)delay;
- (void)scrollToBottomOfIndexPath:(NSIndexPath *)indexPath withDalay:(CGFloat)delay;
- (void)scrollToBottom;

#pragma mark - custom cell templates

- (__kindof MKBaseTableViewCell *)cellContainingView:(UIView *)view;
- (MKBaseTableViewCell *)emptyCell;

@end
