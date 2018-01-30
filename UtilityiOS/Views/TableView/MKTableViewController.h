//
//  MKTableViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBadgeItem.h"
#import "MKTableViewCell.h"

typedef NS_ENUM(NSUInteger, ViewControllerTransitionResult) {
    ViewControllerTransitionResult_UNKNOWN,
    ViewControllerTransitionResult_OK,
    ViewControllerTransitionResult_CANCEL
};

@protocol ViewControllerTransitionDelegate <NSObject>

@optional
- (void)viewController:(UIViewController *)viewController didReturnWithResultType:(ViewControllerTransitionResult)resultType andObject:(id)object;

@end

@protocol MKTableViewControllerDelegate <NSObject>

@optional
- (void)badgeUpdated:(MKBadgeItem * _Nonnull)badge;
- (void)viewTransition:(UIViewController * _Nullable)viewController withObject:(id _Nullable)object;

@end

@interface MKTableViewController : UITableViewController <MKTableViewControllerDelegate>

@property (nonatomic, weak) _Nullable id<MKTableViewControllerDelegate> delegate;
@property (nonatomic, weak) id<ViewControllerTransitionDelegate> transitionDelegate;

@property (nonatomic, strong, nullable) NSString *footerTitle;

- (instancetype _Nonnull)initWithType:(NSInteger)type;

- (void)reloadDataAnimated:(BOOL)animated;
- (void)reloadAllSections;
- (void)reloadSection:(NSUInteger)section;
- (void)reloadSection:(NSUInteger)section completion:(void (^)())completion;
- (void)reloadSections:(NSArray<NSNumber *> *)sections completion:(void (^)())completion;
- (void)reloadIndexPaths:(IndexPathArr * _Nullable)indexPaths;
- (void)reloadSection:(NSUInteger)section withHeader:(BOOL)header;
- (void)removeRowsAtIndexPaths:(IndexPathArr * _Nullable)indexPaths;
- (void)insertRowsAtIndexPaths:(IndexPathArr * _Nullable)indexPaths;
- (void)deselectAllExcept:(NSIndexPath *)indexPath animated:(BOOL)animated;

- (void)getBadge:(NSString * _Nonnull)badgeName;
- (void)updateBadge:(MKBadgeItem * _Nonnull)badge;

#pragma mark - custom views

- (UIView *)defaultSectionFooter;

#pragma mark - custom cell templates

- (__kindof MKTableViewCell *)cellContainingView:(UIView *)view;

@end
