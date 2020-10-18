//
//  MKTableViewController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKTableViewController.h"
#import "UIViewController+Utility.h"
#import "MultiLabelView.h"

static dispatch_queue_t dispatch;

@interface MKTableViewController ()

@end

@implementation MKTableViewController

+ (void)initialize {
    if (!dispatch) {
        dispatch = dispatch_queue_create("DISPATCH_QUEUE", NULL);
    }
}

- (instancetype)initWithType:(NSInteger)type {
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [AppTheme VCBackgroundColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)];
    view.backgroundColor = [AppTheme tableFooterBackgroundColor];
    self.tableView.tableFooterView = view;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [AppTheme seperatorColor];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.tableView.alwaysBounceHorizontal = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;

    self.tableView.estimatedRowHeight = [Constants DefaultRowHeight];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.sectionHeaderData = [MKLabelMetaData dataWithInsets:UIEdgeInsetsZero font:[UIFont KCTableCellTitleFontBold] textColor:[AppTheme sectionHeaderTextColor] backgroundColor:[AppTheme sectionHeaderBackgroundColor]];

    self.sectionFooterData = [MKLabelMetaData dataWithInsets:UIEdgeInsetsZero font:[UIFont KCTableCellTitleFontBold] textColor:[AppTheme sectionFooterTextColor] backgroundColor:[AppTheme sectionFooterBackgroundColor]];
    
    [self adjustScrollViewInsetsForNavigationBarHeight:[self adjustedScrollViewInsetsForNavigationBarHeight]];
    [self addTapToDismissKeyboard];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [Constants TableSectionHeaderHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [Constants TableSectionFooterHeight];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Constants DefaultRowHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKEmbededLabel *view = [self basicLabelForAccessoryOfType:MKTableViewAccessoryViewType_HEADER tableView:tableView inSection:section];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MKEmbededLabel *view = [self basicLabelForAccessoryOfType:MKTableViewAccessoryViewType_FOOTER tableView:tableView inSection:section];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKBaseTableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - reload

- (void)updateTableView {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)reloadDataAnimated:(BOOL)animated {
    dispatch_async(dispatch, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (animated) {
                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView])];
                if ([self.tableView numberOfSections] == sections.count) {
                    [self.tableView beginUpdates];
                    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                }
                else {
                    [self.tableView reloadData];
                }
            }
            else {
                [self.tableView reloadData];
            }
        });
    });
}

- (void)reloadSections:(NSArray<NSNumber *> *)sections completion:(void (^)(void))completion {
    dispatch_async(dispatch, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
            for (NSNumber *sect in sections) {
                if (sect.integerValue && sect.integerValue < [self.tableView numberOfSections]) {
                    [set addIndex:sect.integerValue];
                }
            }
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            if (completion) completion();
        });
    });
}


- (void)reloadSectionsSet:(NSIndexSet *)sections completion:(void (^)(void))completion {
    dispatch_async(dispatch, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            if (completion) completion();
        });
    });
}

- (void)reloadAllSections {
    dispatch_async(dispatch, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.tableView numberOfSections])] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        });
    });
}

- (void)reloadSection:(NSUInteger)section {
    [UIView performWithoutAnimation:^{
        
        CGPoint offset = self.tableView.contentOffset;
        
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        self.tableView.contentOffset = offset;
    }];
}

- (void)reloadSection:(NSUInteger)section completion:(void (^)(void))completion {
    dispatch_async(dispatch, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            if (completion) completion();
        });
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

- (void)reloadIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    dispatch_async(dispatch, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [UIView performWithoutAnimation:^{
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }];
        });
    });
}

- (void)removeRowsAtIndexPaths:(IndexPathArr *)indexPaths {
    dispatch_async(dispatch, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView endUpdates];
        });
    });
}

- (void)insertRowsAtIndexPaths:(IndexPathArr *)indexPaths {
    dispatch_async(dispatch, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        });
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
    } completion:^(BOOL finished) {
    }];
}

- (void)scrollToBottomOfIndexPath:(NSIndexPath *)indexPath withDalay:(CGFloat)delay {
    
    if ([self.tableView numberOfSections] <= indexPath.section) return;
    if ([self.tableView numberOfRowsInSection:indexPath.section] <= indexPath.row) return;
    
    [UIView animateWithDuration:0.2 delay:delay options:0 animations:^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } completion:^(BOOL finished) {
    }];
}

- (void)scrollToBottom {
    //    CGPoint point = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height/2.0);
    //    [self.tableView setContentOffset:point animated:NO];
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        NSUInteger last = [self.tableView numberOfSections] - 1;
        NSUInteger rows = [self.tableView numberOfRowsInSection:last];
        rows = rows > 0 ? rows-1 : NSNotFound;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows inSection:last] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - accessory views

- (void)createTableFooterWithTitle:(NSString *)title {
    if (title.length > 0) {
        UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake([Constants HorizontalSpacing], [Constants VerticalSpacing], self.view.frame.size.width-[Constants HorizontalSpacing]*2, [Constants TableFooterHeight])];
        view.backgroundColor = [UIColor whiteColor];
        view.textAlignment = NSTextAlignmentLeft;
        view.text = title;
        view.numberOfLines = 0;
        view.lineBreakMode = NSLineBreakByTruncatingTail;
        view.adjustsFontSizeToFitWidth = YES;
        view.textColor = [AppTheme sectionFooterTextColor];
        view.font = [AppTheme tableFooterFont];
        self.tableView.tableFooterView = view;
    }
    else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)];
        view.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = view;
    }
}

- (MultiLabelView *)createTableAccessoryViewOfType:(MKTableViewAccessoryViewType)type {
    MultiLabelView *view = [[MultiLabelView alloc] initWithContentView:nil];
    [view constructWithType:MultiLabelViewType_Labels leftView:nil rightView:nil labelsCount:1 insets:UIEdgeInsetsMake([Constants TableHeaderPadding], [Constants TableHeaderPadding], [Constants TableHeaderPadding], [Constants TableHeaderPadding])];
    
    if (type == MKTableViewAccessoryViewType_HEADER) {
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

- (void)createTableAccessoryViewOfType:(MKTableViewAccessoryViewType)type withTitle:(NSString *)title {
    
    if (title.length == 0) {
        [self setView:nil forAccessoryViewOfType:type];
        return;
    }
    
    MultiLabelView *view = [self createTableAccessoryViewOfType:type];
    [view setText:title forLabelAtIndex:0];
    view.contentView.frame = CGRectMake(0.0, 0.0, [Constants screenWidth], [view heightForWidth:[Constants screenWidth]]);
    
    [self setView:view.contentView forAccessoryViewOfType:type];
}

- (void)createTableAccessoryViewOfType:(MKTableViewAccessoryViewType)type withAttributedTitle:(NSAttributedString *)title {
    
    if (title.length == 0) {
        [self setView:nil forAccessoryViewOfType:type];
        return;
    }
    
    MultiLabelView *view = [self createTableAccessoryViewOfType:type];
    [view setAttributedText:title forLabelAtIndex:0];
    view.contentView.frame = CGRectMake(0.0, 0.0, [Constants screenWidth], [view heightForWidth:[Constants screenWidth]]);
    
    [self setView:view.contentView forAccessoryViewOfType:type];
}

- (void)setView:(__kindof UIView *)view forAccessoryViewOfType:(MKTableViewAccessoryViewType)type {
    if (type == MKTableViewAccessoryViewType_HEADER) {
        self.tableView.tableHeaderView = view;
    }
    else {
        self.tableView.tableFooterView = view;
    }
}

- (UIView *)defaultSectionFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, [Constants TableFooterHeight])];
    footer.backgroundColor = [AppTheme sectionFooterBackgroundColor];
    return footer;
}

#pragma mark - helpers

- (MKEmbededLabel *)basicLabelForAccessoryOfType:(MKTableViewAccessoryViewType)type tableView:(UITableView *)tableView inSection:(NSInteger)section {
    
    BOOL isHeader = type == MKTableViewAccessoryViewType_HEADER;
    MKEmbededLabel *view = [[MKEmbededLabel alloc] init];
    if (isHeader) {
        [view setMetaData:self.sectionHeaderData];
        view.label.text = [self tableView:tableView titleForHeaderInSection:section];
    }
    else {
        [view setMetaData:self.sectionFooterData];
        view.label.text = [self tableView:tableView titleForFooterInSection:section];
    }
    return view;
}

- (void)setFooterTitle:(NSString *)footerTitle {
    _footerTitle = footerTitle;
    [self createTableFooterWithTitle:footerTitle];
}

- (void)getBadge:(NSString *)badgeName {
    for (MKBadgeItem *badge in [self updatedBadges]) {
        if ([badge.name caseInsensitiveCompare:badgeName] == NSOrderedSame) {
            [self updateBadge:badge];
            break;
        }
    }
}

- (NSArray<MKBadgeItem *> *)updatedBadges {
    return @[];
}

- (void)updateBadge:(MKBadgeItem *)badge {
    if ([self.delegate respondsToSelector:@selector(badgeUpdated:)]) {
        [self.delegate badgeUpdated:badge];
    }
    else if (self.tabBarController) {
        self.navigationController.tabBarItem.badgeValue = badge.description;
    }
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

#pragma mark - custom cell templates

- (MKBaseTableViewCell *)cellContainingView:(UIView *)view {
    CGPoint point = [view convertPoint:view.bounds.origin toView:self.tableView];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:point];
    return [self.tableView cellForRowAtIndexPath:path];
}

- (MKBaseTableViewCell *)emptyCell {
    return [[MKBaseTableViewCell alloc] init];
}

@end
