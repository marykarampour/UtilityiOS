//
//  MKTableViewController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKTableViewController.h"
#import "ServerController.h"

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.tableView.alwaysBounceHorizontal = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.estimatedRowHeight = [Constants DefaultRowHeight];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    if ([header respondsToSelector:NSSelectorFromString(@"textLabel")]) {
        [header.textLabel setTextColor:[AppTheme sectionHeaderTextColor]];
    }
    if ([header respondsToSelector:NSSelectorFromString(@"backgroundView")]) {
        header.backgroundView.backgroundColor = [AppTheme sectionHeaderBackgroundColor];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    if ([footer respondsToSelector:NSSelectorFromString(@"backgroundView")]) {
        footer.backgroundView.backgroundColor = [AppTheme sectionFooterBackgroundColor];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[MKTableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)reloadSections:(NSArray<NSNumber *> *)sections completion:(void (^)())completion {
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
    dispatch_async(dispatch, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        });
    });
}

- (void)reloadSection:(NSUInteger)section completion:(void (^)())completion {
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
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
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

- (void)createTableFooterWithTitle:(NSString *)title {
    if (title.length > 0) {
        UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake([Constants HorizontalSpacing], [Constants VerticalSpacing], self.view.frame.size.width-[Constants HorizontalSpacing]*2, [Constants TableFooterHeight])];
        view.backgroundColor = [UIColor whiteColor];
        view.textAlignment = NSTextAlignmentLeft;
        view.text = title;
        view.numberOfLines = 0;
        view.lineBreakMode = NSLineBreakByTruncatingTail;
        view.adjustsFontSizeToFitWidth = YES;
        view.textColor = [UIColor redColor];
        view.font = [AppTheme tableFooterFont];
        self.tableView.tableFooterView = view;
    }
    else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 1.0)];
        view.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = view;
    }
}

- (UIView *)defaultSectionFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, [Constants TableFooterHeight])];
    footer.backgroundColor = [AppTheme sectionFooterBackgroundColor];
    return footer;
}

#pragma mark - helpers

- (void)setFooterTitle:(NSString *)footerTitle {
    _footerTitle = footerTitle;
    [self createTableFooterWithTitle:footerTitle];
}

- (void)getBadge:(NSString *)badgeName {
    [ServerController getBadgeCountWithCompletion:^(id result, NSError *error) {
        if (!error && result) {
            for (MKBadgeItem *badge in result) {
                if ([badge.name caseInsensitiveCompare:badgeName] == NSOrderedSame) {
                    [self updateBadge:badge];
                    break;
                }
            }
        }
    }];
}

- (void)updateBadge:(MKBadgeItem *)badge {
    if ([self.delegate respondsToSelector:@selector(badgeUpdated:)]) {
        [self.delegate badgeUpdated:badge];
    }
    else if (self.tabBarController) {
        self.navigationController.tabBarItem.badgeValue = badge.description;
    }
}

#pragma mark - custom cell templates

- (MKTableViewCell *)cellContainingView:(UIView *)view {
    CGPoint point = [view convertPoint:view.bounds.origin toView:self.tableView];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:point];
    return [self.tableView cellForRowAtIndexPath:path];
}

@end
