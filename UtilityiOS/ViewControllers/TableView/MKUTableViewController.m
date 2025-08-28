//
//  MKUTableViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUTableViewController.h"
#import "UIViewController+Navigation.h"
#import "UIViewController+Utility.h"
#import "NSString+AttributedText.h"
#import "MKUDateTableViewCell.h"
#import "MKUMultiLabelViewController.h"
#import "MKUTextField.h"
#import "MKUTextView.h"

typedef NS_ENUM(NSUInteger, MKU_DATE_PICKER_ROW) {
    MKU_DATE_PICKER_ROW_LABEL,
    MKU_DATE_PICKER_ROW_PICKER,
    MKU_DATE_PICKER_ROW_COUNT
};

@interface MKUTableViewController ()

@end

@implementation MKUTableViewController

- (void)initBase {
    self.sectionHeaderStyle = [MKULabelStyleObject styleWithInsets:UIEdgeInsetsZero font:[AppTheme sectionHeaderFont] textColor:[AppTheme sectionHeaderTextColor] backgroundColor:[AppTheme sectionHeaderBackgroundColor]];
    self.sectionFooterStyle = [MKULabelStyleObject styleWithInsets:UIEdgeInsetsZero font:[AppTheme sectionFooterFont] textColor:[AppTheme sectionFooterTextColor] backgroundColor:[AppTheme sectionFooterBackgroundColor]];
    
    [self initSelectedActionHandler];
}

- (void)initSelectedActionHandler {
    self.selectedActionHandler = ^MKU_LIST_ITEM_SELECTED_ACTION(NSUInteger section) {
        return MKU_LIST_ITEM_SELECTED_ACTION_NONE;
    };
}

- (instancetype)initWithMKUType:(NSInteger)type {
    self.MKUType = type;
    return [super init];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        [self initBase];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initBase];
    }
    return self;
}

- (void)refreshWithControl:(UIRefreshControl *)sender {
    [(UIRefreshControl *)sender endRefreshing];
    
    if ([self hasRefreshControl]) {
        [self.refreshDelegate performRefreshWithControl:sender];
    }
}

- (void)setRefreshDelegate:(id<MKURefreshViewControllerDelegate>)refreshDelegate {
    _refreshDelegate = refreshDelegate;
    [self setRefreshControlHidden:![self hasRefreshControl]];
}

- (void)setRefreshControlHidden:(BOOL)hidden {
    if (hidden) {
        self.refreshControl = nil;
    }
    else {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self action:@selector(refreshWithControl:) forControlEvents:UIControlEventValueChanged];
    }
}

- (BOOL)hasRefreshControl {
    return [self.refreshDelegate respondsToSelector:@selector(performRefreshWithControl:)];
}

- (void)refreshViews {
    [self reloadDataAnimated:NO];
}

- (void)setUseDarkTheme:(BOOL)useDarkTheme {
    _useDarkTheme = useDarkTheme;
    
    self.sectionHeaderStyle.backgroundColor = useDarkTheme ? [AppTheme sectionHeaderDarkBackgroundColor] : [AppTheme sectionHeaderLightBackgroundColor];
    self.sectionHeaderStyle.textColor = useDarkTheme ? [AppTheme sectionHeaderDarkTextColor] : [AppTheme sectionHeaderLightTextColor];
    
    self.sectionFooterStyle.backgroundColor = useDarkTheme ? [AppTheme sectionFooterDarkBackgroundColor] : [AppTheme sectionFooterLightBackgroundColor];
    self.sectionFooterStyle.textColor = useDarkTheme ? [AppTheme sectionFooterDarkTextColor] : [AppTheme sectionFooterLightTextColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [AppTheme VCForgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [AppTheme seperatorColor];
    
    if (self.tabBarController)
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, [Constants TabBarHeight], 0.0);
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.tableView.alwaysBounceHorizontal = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.estimatedRowHeight = [Constants DefaultRowHeight];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.accessoryViewInsets = UIEdgeInsetsMake([Constants TextPadding], [Constants TextPadding], [Constants TextPadding], [Constants TextPadding]);
    
    [self adjustScrollViewInsetsForNavigationBarHeight:[self adjustedScrollViewInsetsForNavigationBarHeight]];
    [self addTapToDismissKeyboard];
    [self setRefreshControlHidden:![self hasRefreshControl]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [Constants TableSectionFooterHeight];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Constants DefaultRowHeight];
}

#pragma mark - reload

- (void)updateTableView {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)reloadDataAnimated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (animated)
            [UIView animateWithDuration:1.0 animations:^{
                [self.tableView reloadData];
            }];
        else
            [self.tableView reloadData];
    });
}

- (void)deselectAllExcept:(NSIndexPath *)indexPath animated:(BOOL)animated {
    for (NSIndexPath *path in [self.tableView indexPathsForSelectedRows]) {
        if (path.section == indexPath.section && path.row != indexPath.row) {
            [self.tableView deselectRowAtIndexPath:path animated:animated];
        }
    }
}

#pragma mark - scrolling

- (void)scrollToBottomWithDalay:(CGFloat)delay {
    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:delay];
}

- (void)scrollToBottomOfSection:(NSUInteger)section withDalay:(CGFloat)delay {
    
    if ([self.tableView numberOfSections] <= section) return;
    
    [UIView animateWithDuration:0.2 delay:delay options:0 animations:^{
        
        NSUInteger rows = [self.tableView numberOfRowsInSection:section];
        rows = rows > 0 ? rows-1 : NSNotFound;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } completion:^(BOOL finished) {}];
}

- (void)scrollToBottomOfIndexPath:(NSIndexPath *)indexPath withDalay:(CGFloat)delay {
    
    if ([self.tableView numberOfSections] <= indexPath.section) return;
    if ([self.tableView numberOfRowsInSection:indexPath.section] <= indexPath.row) return;
    
    [UIView animateWithDuration:0.2 delay:delay options:0 animations:^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } completion:^(BOOL finished) {}];
}

- (void)scrollToBottom {
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        NSUInteger last = [self.tableView numberOfSections] - 1;
        NSUInteger rows = [self.tableView numberOfRowsInSection:last];
        rows = rows > 0 ? rows-1 : NSNotFound;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows inSection:last] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } completion:^(BOOL finished) {}];
}

#pragma mark - accessory views

- (MKUMultiLabelViewController *)createTableAccessoryViewOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type {
    MKUMultiLabelViewController *view = [[MKUMultiLabelViewController alloc] initWithContentView:nil];
    [view constructWithType:MKU_MULTI_LABEL_VIEW_TYPE_LABEL leftView:nil rightView:nil labelsCount:1 insets:UIEdgeInsetsMake([Constants TableHeaderPadding], [Constants TableHeaderPadding], [Constants TableHeaderPadding], [Constants TableHeaderPadding])];
    
    if (type == MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE_HEADER) {
        view.contentView.backgroundColor = [AppTheme tableHeaderBackgroundColor];
        view.labels.firstObject.font = [AppTheme tableHeaderFont];
        view.labels.firstObject.textColor = [AppTheme tableHeaderTextColor];
    }
    else {
        view.contentView.backgroundColor = [AppTheme tableFooterBackgroundColor];
        view.labels.firstObject.font = [AppTheme tableFooterFont];
        view.labels.firstObject.textColor = [AppTheme tableFooterTextColor];
    }
    return view;
}

- (void)createTableAccessoryViewOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type withTitle:(NSString *)title {
    
    if (title.length == 0) {
        [self setView:nil forAccessoryViewOfType:type];
        return;
    }
    
    MKUMultiLabelViewController *view = [self createTableAccessoryViewOfType:type];
    [view setText:title forLabelAtIndex:0];
    view.contentView.frame = CGRectMake(0.0, 0.0, [Constants screenWidth], [view heightForWidth:[Constants screenWidth]]);
    
    [self setView:view.contentView forAccessoryViewOfType:type];
}

- (void)createTableAccessoryViewOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type withAttributedTitle:(NSAttributedString *)title {
    
    if (title.length == 0) {
        [self setView:nil forAccessoryViewOfType:type];
        return;
    }
    
    MKUMultiLabelViewController *view = [self createTableAccessoryViewOfType:type];
    [view setAttributedText:title forLabelAtIndex:0];
    view.contentView.frame = CGRectMake(0.0, 0.0, [Constants screenWidth], [view heightForWidth:[Constants screenWidth]]);
    
    [self setView:view.contentView forAccessoryViewOfType:type];
}

- (void)setView:(__kindof UIView *)view forAccessoryViewOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type {
    if (type == MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE_HEADER)
        [self setTableHeaderWithView:view];
    else
        [self setTableFooterWithView:view];
}

- (UIView *)defaultSectionFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, [Constants TableSectionFooterHeight])];
    footer.backgroundColor = [AppTheme sectionFooterBackgroundColor];
    return footer;
}

- (MKUAccessoryLabel *)defaultHeader {
    MKUAccessoryLabel *view = [[MKUAccessoryLabel alloc] init];
    view.insets = self.accessoryViewInsets;
    view.backgroundColor = self.sectionHeaderStyle.backgroundColor;
    [view setTextColor:self.sectionHeaderStyle.textColor];
    [view setFont:self.sectionHeaderStyle.font];
    return view;
}

- (MKUSingleViewTableViewHeaderFooterView *)accessoryLabelOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type inSection:(NSInteger)section {
    
    MKUSingleViewTableViewHeaderFooterView *view = [[MKUSingleViewTableViewHeaderFooterView alloc] initWithViewCreationHandler:^UIView *{
        
        MKUAccessoryLabel *label = [[MKUAccessoryLabel alloc] init];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.insets = self.accessoryViewInsets;
        
        if (type == MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE_HEADER)
            [label setText:[self tableView:self.tableView titleForHeaderInSection:section] style:self.sectionHeaderStyle];
        else
            [label setText:[self tableView:self.tableView titleForFooterInSection:section] style:self.sectionFooterStyle];
        
        return label;
    }];
    
    return view;
}

- (void)adjustScrollViewInsetsForNavigationBarHeight:(CGFloat)height {
    if (@available(iOS 9.0, *)) {
        CGFloat topInset = height;
        UIEdgeInsets insets = UIEdgeInsetsMake(topInset, 0, 0, 0);
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
}

- (CGFloat)adjustedScrollViewInsetsForNavigationBarHeight {
    return 0.0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (MKUDateViewInfoObject *info in self.dateCellInfoObjects.allValues) {
        if (info.indexPath.section == section) {
            if (info.hidden) return 0;
            if (info.isEditable && info.showDatePicker && [self isEditableDateSection:section]) return 2;
            return 1;
        }
    }
    return [self numberOfRowsInNonDateSection:section];
}

- (NSUInteger)numberOfRowsInNonDateSection:(NSUInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isDateSection:indexPath.section]) {
        self.dateCellInfoObjects[@(indexPath.section)].indexPath = indexPath;
        switch (indexPath.row) {
            case 1: {
                if (self.dateCellInfoObjects[@(indexPath.section)].showDatePicker) {
                    return [Constants DatePickerCalendarHeight];
                }
                return 0.0;
            }
                break;
            default:
                return [MKUDateTableViewCell estimatedHeight];
                break;
        }
    }
    return [self heightForNonDateRowAtIndexPath:indexPath];
}

- (CGFloat)heightForNonDateRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self hasTitleForHeaderInSection:section] ? [Constants TableSectionHeaderHeight] : 0.0;
}

- (BOOL)hasTitleForHeaderInSection:(NSInteger)section {
    NSString *title = [self tableView:self.tableView titleForHeaderInSection:section];
    NSAttributedString *attr = [self attributedTitleForAccessoryLabelOfType:MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE_HEADER inSection:section];
    return 0 < title.length || 0 < attr.string.length;
}

- (NSAttributedString *)attributedTitleForAccessoryLabelOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type inSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForAccessoryLabelOfType:MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE_HEADER inSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self viewForAccessoryLabelOfType:MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE_FOOTER inSection:section];
}

- (UIView *)viewForAccessoryLabelOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type inSection:(NSInteger)section {
    
    NSString *title = [self tableView:self.tableView titleForHeaderInSection:section];
    NSAttributedString *attr = [self attributedTitleForAccessoryLabelOfType:type inSection:section];
    MKUSingleViewTableViewHeaderFooterView<MKULabel *> *view = [self accessoryLabelOfType:type inSection:section];
    
    if (0 < attr.string.length)
        view.view.attributedText = attr;
    else
        view.view.text = title;
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isDateSection:indexPath.section]) {
        self.dateCellInfoObjects[@(indexPath.section)].indexPath = indexPath;
        return [self tableView:tableView dateCellWithInfo:self.dateCellInfoObjects[@(indexPath.section)]];
    }
    return [self tableView:tableView cellForNonDateRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNonDateRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKUBaseTableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = indexPath.section;
    
    if ([self isDateSection:section] && [self isEditableDateSection:section]) {
        
        MKUDateViewInfoObject *info = self.dateCellInfoObjects[@(section)];
        info.indexPath = indexPath;
        info.showDatePicker = !info.showDatePicker;
        
        [self reloadSection:section];
        if (!info.showDatePicker)
            [self didHideDatePickerAtIndexPath:indexPath];
        else
            [self didShowDatePickerAtIndexPath:indexPath];
    }
    else {
        [self didSelectNonDateRowAtIndexPath:indexPath];
    }
}

- (void)didSelectNonDateRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)didHideDatePickerAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)didShowDatePickerAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)reloadSections:(NSArray<NSNumber *> *)sections {
    NSUInteger count = [self.tableView numberOfSections];
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
    for (NSNumber *sect in sections) {
        if (sect.integerValue && sect.integerValue < count)
            [set addIndex:sect.integerValue];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    });
}

- (void)reloadSectionsInSet:(NSIndexSet *)sections {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    });
}

- (void)reloadAllSections {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.tableView numberOfSections])] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    });
}

- (void)reloadSection:(NSUInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint offset = self.tableView.contentOffset;
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        self.tableView.contentOffset = offset;
    });
}

- (void)reloadSection:(NSUInteger)section withHeader:(BOOL)header {
    if (header) {
        [self reloadSection:section];
    }
    else {
        NSUInteger rows = [self.tableView numberOfRowsInSection:section];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (unsigned int i=0; i<rows; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [self reloadIndexPaths:indexPaths];
    }
}

- (void)reloadIndexPaths:(IndexPathArr *)indexPaths {
    if (indexPaths.count == 0) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    });
}

- (void)removeRowsAtIndexPaths:(IndexPathArr *)indexPaths {
    if (indexPaths.count == 0) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    });
}

- (void)insertRowsAtIndexPaths:(IndexPathArr *)indexPaths {
    if (indexPaths.count == 0) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    });
}

- (void)createTableFooterWithTitle:(NSString *)title {
    UIView *view;
    
    if (title.length > 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([Constants TableCellContentHorizontalMargin], [Constants TableCellContentVerticalMargin], self.view.frame.size.width-2*[Constants TableCellContentHorizontalMargin], [Constants TableFooterHeight])];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = title;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [AppTheme tableFooterTextColor];
        label.font = [AppTheme tableFooterFont];
        view = label;
    }
    else {
        view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)];
        view.backgroundColor = [UIColor whiteColor];
    }
    
    [self setTableFooterWithView:view];
}

- (void)setTableHeaderWithView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.tableHeaderView = view;
    });
}

- (void)setTableFooterWithView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tableView.tableFooterView = view;
    });
}

- (void)createTableHeaderWithAttributedTitle:(NSAttributedString *)attributedString {
    [self createTableHeaderWithAttributedTitle:attributedString backgroundColor:[AppTheme tableHeaderBackgroundColor]];
}

- (void)createTableHeaderWithAttributedTitle:(NSAttributedString *)attributedString backgroundColor:(UIColor *)backgroundColor {
    
    MKUAccessoryLabel *header = [MKUAccessoryLabel headerWithAttributedTitle:attributedString backgroundColor:backgroundColor];
    [self setFrameForView:header contentLength:attributedString.string.length];
    [self setTableHeaderWithView:header];
}

- (void)createTableHeaderWithTitle:(NSString *)title {
    [self createTableHeaderWithTitle:title type:MKU_ACCESSORY_VIEW_TYPE_DEFAULT];
}

- (void)createTableHeaderWithTitle:(NSString *)title type:(MKU_ACCESSORY_VIEW_TYPE)type {
    
    MKUAccessoryLabel *header = [MKUAccessoryLabel headerWithTitle:title type:type];
    [self setFrameForView:header contentLength:title.length];
    [self setTableHeaderWithView:header];
}

- (void)setFrameForView:(MKUAccessoryLabel *)view contentLength:(NSUInteger)contentLength {
    if (0 < contentLength) {
        CGFloat height = [view textHeightForWidth:self.view.frame.size.width];
        view.frame = CGRectMake(0.0, [Constants TableCellContentVerticalMargin], self.view.frame.size.width, height);
    }
}

- (void)setFooterTitle:(NSString *)footerTitle {
    _footerTitle = footerTitle;
    [self createTableFooterWithTitle:footerTitle];
}

- (void)setBlankFooter {
    [self setFooterTitle:@"  "];
}

#pragma mark - utility

- (BOOL)isEditableDateSection:(NSUInteger)section {
    return YES;
}

- (BOOL)isDateSection:(NSUInteger)section {
    for (NSNumber *sect in self.dateCellInfoObjects.allKeys) {
        if ([sect integerValue] == section) {
            return YES;
        }
    }
    return NO;
}

- (void)addDateSections:(NSArray<NSNumber *> *)sections dateType:(DATE_INFO_OBJECT_TYPE)type canChooseFutureDate:(BOOL)canChooseFutureDate {
    [self addDateSections:sections dateType:type canChooseFutureDate:canChooseFutureDate datePickerMode:UIDatePickerModeDate];
}

- (void)addDateSections:(NSArray<NSNumber *> *)sections dateType:(DATE_INFO_OBJECT_TYPE)type canChooseFutureDate:(BOOL)canChooseFutureDate datePickerMode:(UIDatePickerMode)mode {
    
    NSMutableDictionary <NSNumber *, MKUDateViewInfoObject *> *dates = [NSMutableDictionary dictionaryWithDictionary:self.dateCellInfoObjects ? self.dateCellInfoObjects : @{}];
    
    for (NSNumber *num in sections) {
        MKUDateViewInfoObject *date = [[MKUDateViewInfoObject alloc] initWithType:type section:num.integerValue];
        date.canChooseFutureDate = canChooseFutureDate;
        date.mode = mode;
        [date reset];
        [dates setObject:date forKey:num];
    }
    
    self.dateCellInfoObjects = dates;
}

- (void)addDateSections:(NSArray<NSNumber *> *)sections canChooseFutureDate:(BOOL)canChooseFutureDate {
    [self addDateSections:sections dateType:DATE_INFO_OBJECT_TYPE_DAY canChooseFutureDate:canChooseFutureDate];
}

- (void)addDateSections:(NSArray<NSNumber *> *)sections dateType:(DATE_INFO_OBJECT_TYPE)type {
    [self addDateSections:sections dateType:type canChooseFutureDate:YES];
}

- (void)addDateSections:(NSArray<NSNumber *> *)sections {
    [self addDateSections:sections dateType:DATE_INFO_OBJECT_TYPE_DAY];
}

- (void)addDateSections:(NSArray<NSNumber *> *)sections datePickerMode:(UIDatePickerMode)mode {
    [self addDateSections:sections datePickerMode:mode dateType:DATE_INFO_OBJECT_TYPE_DAY];
}

- (void)addDateSections:(NSArray<NSNumber *> *)sections datePickerMode:(UIDatePickerMode)mode dateType:(DATE_INFO_OBJECT_TYPE)type {
    [self addDateSections:sections dateType:type canChooseFutureDate:YES datePickerMode:mode];
}

- (void)setDateSectionsHidden:(BOOL)hidden {
    [self setDateSections:self.dateCellInfoObjects.allKeys hidden:hidden];
}

- (void)setDateSections:(NSArray<NSNumber *> *)sections hidden:(BOOL)hidden {
    [self.dateCellInfoObjects enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, MKUDateViewInfoObject * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([sections containsObject:key]) {
            obj.hidden = hidden;
        }
    }];
}

- (void)clearSelections {
    NSArray <NSIndexPath *> *paths = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *path in paths) {
        [self.tableView deselectRowAtIndexPath:path animated:NO];
    }
}

- (void)clearSelectionsInSection:(NSUInteger)section {
    for (NSUInteger i=0; i<[self.tableView numberOfRowsInSection:section]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:section];
        [self.tableView deselectRowAtIndexPath:path animated:NO];
    }
}

- (void)selectAllInSection:(NSUInteger)section {
    for (NSUInteger i=0; i<[self.tableView numberOfRowsInSection:section]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:section];
        [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (NSArray<NSIndexPath *> *)selectedIndexPaths {
    return [self.tableView indexPathsForSelectedRows];
}

- (NSArray<NSIndexPath *> *)selectedIndexPathsInSection:(NSUInteger)section {
    
    NSArray<NSIndexPath *> *paths = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *selectedItems = [[NSMutableArray alloc] init];
    for (NSIndexPath *path in paths) {
        if (path.section == section)
            [selectedItems addObject:path];
    }
    return selectedItems;
}

- (void)setExtendedLineSeparator {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [AppTheme seperatorColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

#pragma mark - custom cell templates

- (MKUBaseTableViewCell *)tableView:(UITableView *)tableView dateCellWithInfo:(MKUDateViewInfoObject *)info {
    
    if (info.showDatePicker) {
        switch (info.indexPath.row) {
            case MKU_DATE_PICKER_ROW_LABEL: {
                MKUDateTableViewCell *cell = (MKUDateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[MKUDateTableViewCell identifier]];
                if (!cell) {
                    cell = [[MKUDateTableViewCell alloc] init];
                }
                [cell setDateText:[info title]];
                [cell setDoneHidden:!info.isEditable];
                return cell;
            }
                break;
            case MKU_DATE_PICKER_ROW_PICKER: {
                MKUSingleViewTableViewCell *cell = [[MKUSingleViewTableViewCell alloc] initWithInsets:UIEdgeInsetsMake([Constants VerticalSpacing], [Constants TableCellContentHorizontalMargin], [Constants VerticalSpacing], [Constants TableCellContentHorizontalMargin]) viewCreationHandler:^UIView *{
                    MKUDatePicker *view = [[MKUDatePicker alloc] init];
                    view.delegate = self;
                    view.infoObject = info;
                    view.date = [info getAdjustedDate];
                    view.timeZone = [info timeZone];
                    view.datePickerMode = info.mode;
                    return view;
                }];
                return cell;
            }
                break;
            default:
                return [[MKUBaseTableViewCell alloc] init];
                break;
        }
    }
    else {
        MKUDateTableViewCell *cell = (MKUDateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[MKUDateTableViewCell identifier]];
        if (!cell) {
            cell = [[MKUDateTableViewCell alloc] init];
        }
        [cell setDateText:[info title]];
        [cell setDoneHidden:YES];
        return cell;
    }
}

- (void)datePicker:(MKUDatePicker *)datePicker didChangeDate:(NSDate *)date {
    [self reloadIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:datePicker.infoObject.indexPath.section]]];
}

- (MKUBaseTableViewCell *)emptyCell {
    return [MKUBaseTableViewCell blankCell];
}

- (MKUBaseTableViewCell *)cellContainingView:(UIView *)view {
    CGPoint point = [view convertPoint:view.bounds.origin toView:self.tableView];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:point];
    return [self.tableView cellForRowAtIndexPath:path];
}

- (MKUBaseTableViewCell *)textViewCellForIndexPath:(NSIndexPath *)indexPath title:(NSString *)title delegate:(id<TextViewDelegate>)delegate viewIndexPath:(NSIndexPath *)viewIndexPath text:(NSString *)text {
    return [self textViewCellForIndexPath:indexPath title:title delegate:delegate viewIndexPath:viewIndexPath text:text placeholder:@""];
}

- (MKUBaseTableViewCell *)textViewCellForIndexPath:(NSIndexPath *)indexPath title:(NSString *)title delegate:(id<TextViewDelegate>)delegate viewIndexPath:(NSIndexPath *)viewIndexPath text:(NSString *)text placeholder:(NSString *)placeholder {
    return [self textViewCellForIndexPath:indexPath title:title delegate:delegate viewIndexPath:viewIndexPath text:text placeholder:placeholder maxChars:0];
}

- (MKUBaseTableViewCell *)textViewCellForIndexPath:(NSIndexPath *)indexPath title:(NSString *)title delegate:(id<TextViewDelegate>)delegate viewIndexPath:(NSIndexPath *)viewIndexPath text:(NSString *)text placeholder:(NSString *)placeholder maxChars:(NSUInteger)maxChars {
    
    if (indexPath.row == MKU_TEXTVIEW_CELL_ROW_TITLE) {
        
        MKUBaseTableViewCell *cell = [[MKUBaseTableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = title;
        cell.textLabel.font = [AppTheme smallBoldLabelFont];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        return cell;
    }
    else {
        MKUSingleViewTableViewCell *cell = [[MKUSingleViewTableViewCell alloc] initWithInsets:UIEdgeInsetsMake([Constants VerticalSpacing], [Constants TableCellContentHorizontalMargin], [Constants VerticalSpacing], [Constants TableCellContentHorizontalMargin]) viewCreationHandler:^UIView *{
            MKUTextView *view = [[MKUTextView alloc] init];
            view.text = text;
            view.scrollEnabled = YES;
            view.indexPath = viewIndexPath;
            view.controller.maxLenght = maxChars;
            [view setControllerDelegate:delegate];
            [view setPlaceholderText:placeholder];
            return view;
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
}

- (MKUBaseTableViewCell *)textViewCellForRow:(NSUInteger)row withView:(MKUTextView *)view title:(NSString *)title insets:(UIEdgeInsets)insets {
    
    if (row == MKU_TEXTVIEW_CELL_ROW_TITLE) {
        
        MKUBaseTableViewCell *cell = [[MKUBaseTableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = title;
        cell.textLabel.font = [AppTheme smallBoldLabelFont];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        return cell;
    }
    else {
        MKUSingleViewTableViewCell *cell = [[MKUSingleViewTableViewCell alloc] init];
        cell.insets = insets;
        cell.view = view;
        return cell;
    }
}

- (CGFloat)heightForTextViewCellAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == MKU_TEXTVIEW_CELL_ROW_TITLE ? [Constants TextViewTitleHeight] : [Constants TextViewMediumHeight];
}

- (MKUBaseTableViewCell *)textFieldCellForIndexPath:(NSIndexPath *)indexPath title:(NSString *)title delegate:(id<TextFieldDelegate>)delegate viewIndexPath:(NSIndexPath *)viewIndexPath text:(NSString *)text {
    return [self textFieldCellForIndexPath:indexPath title:title delegate:delegate viewIndexPath:viewIndexPath text:text placeholder:@""];
}

- (MKUBaseTableViewCell *)textFieldCellForIndexPath:(NSIndexPath *)indexPath title:(NSString *)title delegate:(id<TextFieldDelegate>)delegate viewIndexPath:(NSIndexPath *)viewIndexPath text:(NSString *)text placeholder:(NSString *)placeholder {
    
    if (indexPath.row == MKU_TEXTVIEW_CELL_ROW_TITLE) {
        
        MKUBaseTableViewCell *cell = [[MKUBaseTableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = title;
        cell.textLabel.font = [AppTheme smallBoldLabelFont];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        return cell;
    }
    else {
        MKUSingleViewTableViewCell *cell = [[MKUSingleViewTableViewCell alloc] initWithInsets:UIEdgeInsetsMake([Constants VerticalSpacing], [Constants TableCellContentHorizontalMargin], [Constants VerticalSpacing], [Constants TableCellContentHorizontalMargin]) viewCreationHandler:^UIView *{
            MKUTextField *view = [[MKUTextField alloc] init];
            view.textAlignment = NSTextAlignmentLeft;
            view.keyboardType = UIKeyboardTypeDefault;
            view.placeholder = placeholder;
            view.text = text;
            view.indexPath = viewIndexPath;
            view.controller.delegate = delegate;
            return view;
        }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
}

- (CGFloat)heightForTextFieldCellAtIndexPath:(NSIndexPath *)indexPath {
    return [Constants TextFieldHeight] + 2*[Constants VerticalSpacing];
}

@end

