//
//  MKUSearchResultsViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUHeaderFooterContainerViewController.h"
#import "MKUViewContentStyleProtocols.h"
#import "MKUItemsListViewController.h"
#import "MKUSearchHeaderView.h"
#import "MKUSearch.h"

typedef NS_ENUM(NSUInteger, MKU_SEARCH_DATE_SECTION) {
    MKU_SEARCH_DATE_SECTION_DATE,
    MKU_SEARCH_DATE_SECTION_LIST,
    MKU_SEARCH_DATE_SECTION_COUNT
};

@class MKUSearchResultsChildViewController;
@class MKUSearchResultsViewController;

@protocol MKUSearchHeaderVCParentViewDelegate <MKUViewControllerTransitionDelegate>

@required
/** @brief Calls performSearchWithCompletion and immediately sets the searchArray as result. */
- (void)performSearch;
- (void)performSearchWithCompletion:(void (^)(NSArray<NSObject<MKUSearchProtocol> *> *result))completion;
- (void)searchText:(NSString *)searchText withCompletion:(void (^)(NSArray <NSObject<MKUSearchProtocol> *> *result))completion;
- (void)searchDidSelectObject:(NSObject<MKUSearchProtocol> *)object atIndex:(NSInteger)index;
/** @brief By default only called if selectedObject not nil. */
- (__kindof MKUBaseTableViewCell *)tableView:(UITableView *)tableView detailCellForObject:(NSObject<MKUSearchProtocol> *)object;
- (CGFloat)estimatedDetailCellHeightForObject:(NSObject<MKUSearchProtocol> *)object;
- (CGFloat)estimatedCellHeightForObject:(NSObject<MKUSearchProtocol> *)object;
+ (UIColor *)selectedColor;
- (BOOL)isDetailCellAtIndexPath:(NSIndexPath *)indexPath;

/** @brief Called in viewDidLoad. Use this method to set colors and style of the tableView. */
- (void)setupTableView:(UITableView *)tableView;
/** @brief Called in viewWillAppear and  viewDidDisappear. Default calls clearSearch and resetSearch which resets the datasource and searcharray and reload the tableview.
 Override and call a service to retrieve new data and then call this on super in completion before setting the datasource. */
- (void)performReset;

@end

@protocol MKUSearchResultsTransitionDelegate <NSObject>

@optional
/** @brief Retun view controller to be pushed when an item is selected. It will be called in
 searchDidSelectObject:atIndex:. Return nil to only update the cell and searchbar. */
- (void)transitioningViewControllerForObject:(NSObject<MKUSearchProtocol> *)object atIndex:(NSInteger)index completion:(void(^)(UIViewController *VC))completion;

@end

@protocol MKUSearchResultsUpdateDelegate <NSObject>

@optional
- (void)handleTransitionToViewController:(UIViewController *)VC searchVC:(MKUSearchResultsViewController *)searchVC didSelectItem:(NSObject<MKUSearchProtocol> *)item atIndex:(NSUInteger)index;
- (void)searchVCDidResetSearch:(MKUSearchResultsViewController *)searchVC;

@end


@interface MKUSearchResultsChildViewController <__covariant ObjectType : NSObject<MKUSearchProtocol> *> : MKUItemsListViewController <ObjectType> <HeaderVCChildViewDelegate>

@end

@interface MKUSearchResultsViewController <__covariant ObjectType : NSObject<MKUSearchProtocol> *, __covariant ChildType : __kindof MKUSearchResultsChildViewController *> : MKUHeaderFooterContainerViewController <ChildType> <MKUSearchHeaderVCParentViewDelegate, MKURefreshViewControllerDelegate, MKUSearchResultsUpdateDelegate, MKUSearchResultsTransitionDelegate, MKUViewControllerActionProtocol, MKUItemsListVCNavBarDelegate>

@property (nonatomic, strong) ChildType childViewController;
@property (nonatomic, strong) MKUSearchHeaderView *headerView;
@property (nonatomic, strong) NSArray <ObjectType> *dataSource;

/** @brief Used for search text from textbar only. */
@property (nonatomic, strong) MKUSearchPredicate *searchPredicate;

/** @brief Filters used in combination with the search text.
 Default is constructed from MKUSearchProtocol. You can add more criteria which will be utilized via OR predicate. */
@property (nonatomic, strong) NSArray<MKUSearchPredicate *> *filterPredicates;

/** @brief By default is is self. If this view is within a container, it can be assigned the container to handle
 transitions when an item is selected. */
@property (nonatomic, weak) id<MKUSearchResultsUpdateDelegate> updateDelegate;
@property (nonatomic, weak) id<MKUSearchResultsTransitionDelegate> searchTransitionDelegate;

/** @brief It is called after createChildVC. Implement this in your overridden createChildVC to customize childViewController */
- (void)setupChildVC;

- (void)setSelectedObjects:(NSArray <ObjectType> *)objects;
- (ObjectType)selectedObject;
- (NSSet<ObjectType> *)selectedObjects;
- (NSArray<ObjectType> *)arrayForSearchState;
- (void)clearSearch;
- (void)resetSearch;

/** @brief Manually set isSearching for example in case of a search filter. */
- (void)setIsSearching:(BOOL)isSearching;

/** @brief selectedObjectHandler The handler to evalaute and set the selected item in the array of items. */
+ (void)loadSelectionVCWithTitle:(NSString *)title allowsMultipleSelection:(BOOL)allowsMultipleSelection items:(NSArray *)items transitionDelegate:(id<MKUViewControllerTransitionDelegate>)transitionDelegate selectedObjectHandler:(EvaluateObjectHandler)selectedObjectHandler completion:(void(^)(UIViewController *VC))completion;

@end



#pragma mark - Date search

@protocol MKUSearchResultsDateVCProtocol <NSObject>

@optional
- (NSString *)dateSectionHeaderTitle;
- (void)refreshDataWithDate:(NSDate *)date;

@end

@interface MKUSearchResultsDateChildViewController <__covariant ObjectType : NSObject<MKUSearchProtocol> *> : MKUSearchResultsChildViewController <ObjectType>

@end

@interface MKUSearchResultsDateViewController <__covariant ObjectType : NSObject<MKUSearchProtocol> *> : MKUSearchResultsViewController <ObjectType, MKUSearchResultsDateChildViewController *> <MKUSearchResultsDateVCProtocol>

- (NSDate *)selectedDate;

@end


