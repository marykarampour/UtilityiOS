//
//  MKUSearchResultsViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUSearchResultsViewController.h"
#import "UIViewController+MutableObjectVC.h"
#import "NSObject+Utility.h"
#import "NSArray+Utility.h"

@interface MKUBaseSearchTableViewCell : MKUBaseTableViewCell

@end

@implementation MKUBaseSearchTableViewCell

@end


@interface MKUSearchResultsViewController () <UISearchBarDelegate, MKUItemsListVCUpdateDelegate>

@property (nonatomic, assign) BOOL isSearching;

- (NSString *)textLabelAtIndex:(NSUInteger)index;
- (NSString *)detailTextLabelAtIndex:(NSUInteger)index;
- (void)performDidSelectObject:(NSObject <MKUSearchProtocol> *)object;
- (NSObject <MKUSearchProtocol> *)objectAtIndex:(NSUInteger)index;

@end


@implementation MKUSearchResultsChildViewController

@synthesize headerDelegate;

- (id)targetForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return self.headerDelegate;
}

#pragma mark - Table View

- (CGFloat)heightForNonDateRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject<MKUSearchProtocol> *obj = [self.headerDelegate arrayForSearchState][indexPath.row];
    
    if ([self.headerDelegate isDetailCellAtIndexPath:indexPath])
        return [self.headerDelegate estimatedDetailCellHeightForObject:obj];
    return [self.headerDelegate estimatedCellHeightForObject:obj];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (__kindof MKUBaseTableViewCell *)cellForListItem:(__kindof NSObject<MKUSearchProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    if ([self.headerDelegate isDetailCellAtIndexPath:indexPath]) {
        return [self.headerDelegate tableView:self.tableView detailCellForObject:item];
    }
    else {
        return [super cellForListItem:item atIndexPath:indexPath];
    }
}

- (UITableViewCellAccessoryType)accessoryTypeForSingleDeselectedRowForListOfType:(NSUInteger)type {
    return self.headerDelegate.selectedAction == MKU_LIST_ITEM_SELECTED_ACTION_TRANSITION_TO_DETAIL ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

- (void)setTextForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell {
    cell.textLabel.attributedText = nil;
    cell.textLabel.text = [self textLabelAtIndexPath:indexPath];
    cell.detailTextLabel.attributedText = nil;
    cell.detailTextLabel.text = [self detailTextLabelAtIndexPath:indexPath];
}

- (NSString *)noItemAvailableTitleForListOfType:(NSUInteger)type {
    return nil;
}

@end


@implementation MKUSearchResultsViewController

@dynamic childViewController;
@dynamic headerView;

- (void)initBaseWithObject:(id)object {
    [super initBaseWithObject:object];
    
    self.updateDelegate = self;
    self.searchTransitionDelegate = self;
    [self setupChildVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [self.class selectedColor];
}

- (NSString *)titleForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    switch (type) {
        case MKU_NAV_BAR_BUTTON_TYPE_CLOSE:       return [Constants Close_STR];
        case MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_DONE: return [Constants Done_STR];
        default: return nil;
    }
}

- (BOOL)isEnabledButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return YES;
}

- (void)createChildVC {
    self.childViewController = [[MKUSearchResultsChildViewController alloc] init];
}

- (void)setupChildVC {
    self.childViewController.updateDelegate = self;
    self.childViewController.navbarDelegate = self;
    
    [self setupTableView:self.childViewController.tableView];
    [self addNavBarTarget:self.childViewController];
    [self setNavBarItemsOfTarget:self.childViewController];
}

- (void)setSelectedAction:(MKU_LIST_ITEM_SELECTED_ACTION)selectedAction {
    [super setSelectedAction:selectedAction];
    self.childViewController.selectedAction = selectedAction;
    [self addNavBarTarget:self.childViewController];
    [self setNavBarItemsOfTarget:self.childViewController];
}

- (void)createHeaderView {
    self.headerView = [[MKUSearchHeaderView alloc] init];
}

- (void)setHeaderView:(MKUSearchHeaderView *)headerView {
    [super setHeaderView:headerView];
    headerView.searchBar.delegate = self;
    headerView.searchBar.showsCancelButton = YES;
}

- (CGFloat)headerVerticalMargin {
    return 0.0;
}

- (CGFloat)headerHeight {
    return [self.headerView estimatedHeight];
}

- (void)setDataSource:(NSArray<NSObject<MKUSearchProtocol> *> *)dataSource {
    _dataSource = dataSource;
    [self resetSearch];
}

- (void)itemsListVC:(MKUItemsListViewController *)VC didSetSelected:(BOOL)selected item:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndex:(NSUInteger)index {
    
    if (self.isSearching || !item)
        self.isSearching = NO;
    
    if (item)
        [self searchDidSelectObject:item atIndex:index];
    
    [self.headerView resignFirstResponder];
}

#pragma mark - search

- (NSArray <NSObject<MKUSearchProtocol> *> *)arrayForSearchState {
    return self.isSearching || 0 < self.filterPredicates.count ? self.childViewController.items : self.dataSource;
}

- (void)searchDidSelectObject:(NSObject<MKUSearchProtocol> *)object atIndex:(NSInteger)index {
    
    if (self.selectedAction == MKU_LIST_ITEM_SELECTED_ACTION_TRANSITION_TO_DETAIL && [self.searchTransitionDelegate respondsToSelector:@selector(transitioningViewControllerForObject:atIndex:completion:)]) {
        [self.searchTransitionDelegate transitioningViewControllerForObject:object atIndex:index completion:^(UIViewController *VC) {
            if (VC) {
                [self clearSearch];
                [self resetSearch];
                
                if ([self.updateDelegate respondsToSelector:@selector(handleTransitionToViewController:searchVC:didSelectItem:atIndex:)]) {
                    [self.updateDelegate handleTransitionToViewController:VC searchVC:self didSelectItem:object atIndex:index];
                }
            }
            else {
                [self updateWithSelectObject:object];
            }
        }];
    }
    else if (self.selectedAction == MKU_LIST_ITEM_SELECTED_ACTION_SELECT) {
        [self updateWithSelectObject:object];
        id object = self.childViewController.tableView.allowsMultipleSelection ? [self selectedObjects] : [self selectedObject];
        [self dispathTransitionDelegateToReturnWithObject:object];
    }
    else {
        [self updateWithSelectObject:object];
    }
}

- (void)updateWithSelectObject:(NSObject<MKUSearchProtocol> *)object {
    self.headerView.searchBar.text = [object title];
    [self.childViewController reloadDataAnimated:NO];
}

- (void)clearSearch {
    self.isSearching = NO;
    self.headerView.searchBar.text = nil;
    [self.headerView.searchBar resignFirstResponder];
}

- (void)resetSearch {
    self.searchPredicate = [[MKUSearchPredicate alloc] init];
    self.filterPredicates = @[];
    [self.childViewController setItemsWithArray:self.dataSource];
    
    if ([self.updateDelegate respondsToSelector:@selector(searchVCDidResetSearch:)]) {
        [self.updateDelegate searchVCDidResetSearch:self];
    }
}

- (void)resetSearchFilters {
    self.filterPredicates = @[];
    [self performSearch];
}

- (void)resetSearchTextPredicate {
    self.searchPredicate = [[MKUSearchPredicate alloc] init];
    [self performSearch];
}

- (void)searchEnded:(UISearchBar *)searchBar {
    self.isSearching = NO;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self resetSearchTextPredicate];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self didFinishSearchText:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self searchEnded:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [searchBar becomeFirstResponder];
    [self didFinishSearchText:searchText];
}

- (void)didFinishSearchText:(NSString *)searchText {
    
    self.isSearching = 0 < searchText.length;
    
    if (!self.isSearching) {
        [self resetSearchTextPredicate];
    }
    else {
        [self searchText:searchText withCompletion:^(NSArray<NSObject<MKUSearchProtocol> *> *result) {
            [self.childViewController setItemsWithArray:result];
        }];
    }
}

- (void)searchText:(NSString *)searchText withCompletion:(void (^)(NSArray<NSObject<MKUSearchProtocol> *> *))completion {
    self.searchPredicate = [MKUSearchPredicate objectWithText:searchText condition:YES];
    [self performSearchWithCompletion:completion];
}

- (void)performSearchWithCompletion:(void (^)(NSArray<NSObject<MKUSearchProtocol> *> *))completion {
    
    if (self.dataSource.count == 0) {
        if (completion) completion(nil);
        return;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSPredicate *predicate;
    NSMutableArray *andArr = [[NSMutableArray alloc] init];
    
    for (MKUSearchPredicate *obj in self.filterPredicates) {
        NSPredicate *pre = [self searchPredicateWithText:obj.text condition:obj.condition];
        [arr addObject:pre];
    }
    
    if (0 < arr.count) {
        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:arr];
        [andArr addObject:predicate];
    }
    
    if (0 < self.searchPredicate.text.length) {
        NSPredicate *textPre = [self searchPredicateWithText:self.searchPredicate.text condition:self.searchPredicate.condition];
        [andArr addObject:textPre];
    }
    
    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:andArr];
    
    if (!predicate) {
        if (completion) completion(@[]);
        return;
    }
    
    NSArray<NSObject<MKUSearchProtocol> *> *array = [self.dataSource filteredArrayUsingPredicate:predicate];
    if (completion) completion(array);
}

- (void)performSearch {
    [self performSearchWithCompletion:^(NSArray<NSObject<MKUSearchProtocol> *> *result) {
        [self.childViewController setItemsWithArray:result];
    }];
}

- (NSPredicate *)searchPredicateWithText:(NSString *)searchText condition:(BOOL)condition {
    
    NSPredicate *predicate;
    NSObject<MKUSearchProtocol> *obj = self.dataSource.firstObject;
    
    if ([obj.class respondsToSelector:@selector(searchPredicateKeys)]) {
        
        StringArr *keys = [obj.class searchPredicateKeys];
        
        if (1 == keys.count) {
            predicate = [self predicateWithKey:keys.firstObject searchText:searchText condition:condition];
        }
        else if (0 < keys.count) {
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSString *key in keys) {
                NSPredicate *obj = [self predicateWithKey:key searchText:searchText condition:condition];
                [arr addObject:obj];
            }
            predicate = [NSCompoundPredicate orPredicateWithSubpredicates:arr];
        }
    }
    else if ([obj.class respondsToSelector:@selector(searchPredicateKey)]) {
        
        NSString *key = [obj.class searchPredicateKey];
        predicate = [self predicateWithKey:key searchText:searchText condition:condition];
    }
    
    return predicate;
}

- (NSObject<MKUSearchProtocol> *)selectedObject {
    return [[self selectedObjects] anyObject];
}

- (NSSet<NSObject<MKUSearchProtocol> *> *)selectedObjects {
    return [self.childViewController selectedObjects];
}

- (void)setSelectedObjects:(NSArray<NSObject<MKUSearchProtocol> *> *)objects {
    [self.childViewController setSelectedObjects:[NSMutableSet setWithArray:objects]];
}

- (__kindof MKUBaseTableViewCell *)tableView:(UITableView *)tableView detailCellForObject:(NSObject<MKUSearchProtocol> *)object {
    
    MKUSubtitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MKUSubtitleTableViewCell identifier]];
    if (!cell) {
        cell = [[MKUSubtitleTableViewCell alloc] init];
        cell.accessoryType = self.selectedAction == MKU_LIST_ITEM_SELECTED_ACTION_TRANSITION_TO_DETAIL ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    }
    
    NSString *title = [object respondsToSelector:@selector(title)] ? [object title] : nil;
    NSString *subtitle = [object respondsToSelector:@selector(subtitle)] ? [object subtitle] : nil;
    NSAttributedString *attrTitle = [object respondsToSelector:@selector(attributedTitle)] ? [object attributedTitle] : nil;
    NSAttributedString *attrSubtitle = [object respondsToSelector:@selector(attributedSubtitle)] ? [object attributedSubtitle] : nil;
    
    if (attrTitle) {
        cell.textLabel.text = nil;
        cell.textLabel.attributedText = attrTitle;
    }
    else {
        cell.textLabel.attributedText = nil;
        cell.textLabel.text = title;
    }
    
    if (attrSubtitle) {
        cell.detailTextLabel.text = nil;
        cell.detailTextLabel.attributedText = attrSubtitle;
    }
    else {
        cell.detailTextLabel.attributedText = nil;
        cell.detailTextLabel.text = subtitle;
    }
    return cell;
}

- (CGFloat)estimatedDetailCellHeightForObject:(NSObject<MKUSearchProtocol> *)object {
    return [Constants DefaultRowHeight];
}

- (CGFloat)estimatedCellHeightForObject:(NSObject<MKUSearchProtocol> *)object {
    return 52.0;
}

- (void)performReset {
    [self clearSearch];
    [self resetSearch];
}

+ (UIColor *)selectedColor {
    return [AppTheme sectionHeaderBackgroundColor];
}

+ (void)loadSelectionVCWithTitle:(NSString *)title allowsMultipleSelection:(BOOL)allowsMultipleSelection items:(NSArray *)items transitionDelegate:(id<MKUViewControllerTransitionDelegate>)transitionDelegate selectedObjectHandler:(EvaluateObjectHandler)selectedObjectHandler completion:(void (^)(UIViewController *))completion {
    
    MKUSearchResultsViewController *vc = [[[self class] alloc] init];
    vc.childViewController.tableView.allowsMultipleSelection = allowsMultipleSelection;
    vc.title = title;
    [vc setDataSource:items];
    vc.transitionDelegate = transitionDelegate;
    
    if (selectedObjectHandler) {
        NSArray *selectedItems = [items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return selectedObjectHandler(evaluatedObject);
        }]];
        
        [vc setSelectedObjects:selectedItems];
    }
    
    if (completion) completion(vc);
}

- (BOOL)showSelectedObject {
    return self.selectedAction == MKU_LIST_ITEM_SELECTED_ACTION_SHOW_DETAIL && 0 < [self selectedObjects].count;
}

- (BOOL)isDetailCellAtIndexPath:(NSIndexPath *)indexPath {
    return
    [self.childViewController isSelectedRowAtIndexPath:indexPath] &&
    [self showSelectedObject];
}

- (void)setupTableView:(UITableView *)tableView {
}

- (void)handleTransitionToViewController:(UIViewController *)VC searchVC:(MKUSearchResultsViewController *)searchVC didSelectItem:(NSObject<MKUSearchProtocol> *)item atIndex:(NSUInteger)index {
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)searchVCDidResetSearch:(MKUSearchResultsViewController *)searchVC {
}

- (void)nextPressed:(UIBarButtonItem *)sender {
    if (self.childViewController.tableView.allowsMultipleSelection)
        [self dispathTransitionDelegateToReturnWithObject:[self selectedObjects]];
    else
        [super nextPressed:sender];
}

@end

#pragma mark - Date search

@interface MKUSearchResultsDateChildViewController ()

@property (nonatomic, strong) MKUSearchResultsDateViewController *headerDelegate;

@end

@interface MKUSearchResultsDateViewController ()

@property (nonatomic, strong) MKUSearchResultsDateChildViewController *childViewController;

@end

@implementation MKUSearchResultsDateViewController

@dynamic childViewController;

- (NSDate *)selectedDate {
    return self.childViewController.dateCellInfoObjects[@(MKU_SEARCH_DATE_SECTION_DATE)].date;
}

- (void)createChildVC {
    self.childViewController = [[MKUSearchResultsDateChildViewController alloc] init];
}

- (void)refreshPressed:(UIBarButtonItem *)sender {
    if ([self respondsToSelector:@selector(refreshDataWithDate:)])
        [self refreshDataWithDate:[self selectedDate]];
}

- (BOOL)hasButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_REFRESH;
}

@end

@implementation MKUSearchResultsDateChildViewController

@dynamic headerDelegate;

- (instancetype)init {
    if (self = [super init]) {
        [self addDateSections:@[@(MKU_SEARCH_DATE_SECTION_DATE)]];
        self.dateCellInfoObjects[@(MKU_SEARCH_DATE_SECTION_DATE)].date = [NSDate date];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MKU_SEARCH_DATE_SECTION_COUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return
    section == MKU_SEARCH_DATE_SECTION_DATE &&
    [self.headerDelegate respondsToSelector:@selector(dateSectionHeaderTitle)]
    ? [Constants TableSectionHeaderHeight] : 0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (![self.headerDelegate respondsToSelector:@selector(dateSectionHeaderTitle)]) return nil;
    return section == MKU_SEARCH_DATE_SECTION_DATE ? [self.headerDelegate dateSectionHeaderTitle] : nil;
}

- (void)datePicker:(MKUDatePicker *)datePicker didChangeDate:(NSDate *)date {
    [self.headerDelegate setDataSource:nil];
}

@end

