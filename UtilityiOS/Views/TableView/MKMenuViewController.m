//
//  MKMenuViewController.m
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-24.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKMenuViewController.h"
#import "UIView+Utility.h"

@implementation SpinnerItem

@end

@implementation MKMenuObject

@end

@implementation MKMenuSection

@end


@interface MKMenuTableViewCell ()

@property (nonatomic, strong) BadgeView *badge;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation MKMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.badge = [[BadgeView alloc] init];
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [self.contentView addSubview:self.badge];
        [self.contentView removeConstraintsMask];
        [self.contentView constraint:NSLayoutAttributeRight view:self.badge];
        [self.contentView constraint:NSLayoutAttributeCenterY view:self.badge];
    }
    return self;
}

- (void)updateWithObject:(MKMenuObject *)obj {
    if (obj.hasSpinner) {
        if (obj.spinner.inProgress) {
            [self animateSpinner];
        }
        else {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.accessoryView = nil;
        }
    }
    else {
        if (obj.hasBadge) {
            NSString *badgeStr = obj.badge.description;
            if (badgeStr.length > 0) {
                [self setBadgeText:badgeStr];
            }
            self.badge.hidden = badgeStr.length > 0;
        }
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.accessoryView = nil;
    }
}

- (void)setBadgeText:(NSString *)text {
    self.badge.text = text;
}

- (void)animateSpinner {
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = self.spinner;
    [self.spinner startAnimating];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

@interface MKMenuViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MKMenuViewController

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        [self createMenuObjects];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:BADGE_POOLING_TIMER target:self selector:@selector(updateBadges) userInfo:nil repeats:YES];
    [self updateBadges];
}

- (void)transitionToView:(NSIndexPath *)indexPath {
    MKMenuObject *obj = [self menuItemForIndexPath:indexPath];
    UIViewController *nextViewController;
    
    if ([obj.VCClass instancesRespondToSelector:@selector(initWithType:)]) {
        nextViewController = [[obj.VCClass alloc] initWithType:obj.type];
    }
    else {
        nextViewController = [[obj.VCClass alloc] init];
    }
    [self.navigationController pushViewController:nextViewController animated:YES];
}

#pragma mark - Table view data source

- (NSUInteger)numberOfRowsInSectionWhenExpanded:(NSUInteger)section {
    MKMenuSection *sect = [self menuSectionForSection:section];
    if (sect) {
        return sect.menuItems.count;
    }
    return [self numberOfRowsInNonMenuSectionWhenExpanded:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MKMenuSection *sect = [self menuSectionForSection:section];
    if (sect) {
        return sect.title;
    }
    return [self titleForHeaderInNonMenuSection:section];
}

- (MKTableViewCell *)baseCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MKTableViewCell identifier]];
    if (cell == nil) {
        cell = [[MKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MKTableViewCell identifier]];
    }
    return cell;
}

- (MKMenuTableViewCell *)baseMenuCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKMenuTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MKMenuTableViewCell identifier]];
    if (cell == nil) {
        cell = [[MKMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MKMenuTableViewCell identifier]];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKMenuObject *obj = [self menuItemForIndexPath:indexPath];
    if (obj) {
        __kindof MKMenuTableViewCell *cell = [self baseMenuCellForRowAtIndexPath:indexPath];
        [cell updateWithObject:obj];
        cell.textLabel.text = [self titleForItem:indexPath];
        return cell;
    }
    return [self baseCellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKMenuObject *obj = [self menuItemForIndexPath:indexPath];
    if (obj) {
        if (obj.hasSpinner && obj.spinner.inProgress) {
            return;
        }
        if (obj.action && [self respondsToSelector:obj.action]) {
            [self performSelector:obj.action];
        }
        else {
            [self transitionToView:indexPath];
        }
    }
    self.selectedOption = indexPath;
}

- (NSString *)titleForItem:(NSIndexPath *)indexPath {
    MKMenuObject *obj = [self menuItemForIndexPath:indexPath];
    return obj ? obj.title: nil;
}

- (MKMenuObject *)menuItemForTitle:(NSString *)title {
    for (MKMenuSection *sect in self.sections) {
        for (MKMenuObject *obj in sect.menuItems) {
            if ([obj.title isEqualToString:title]) {
                return obj;
            }
        }
    }
    return nil;
}

- (MKMenuObject *)menuItemForIndexPath:(NSIndexPath *)indexPath {
    MKMenuSection *sect = [self menuSectionForSection:indexPath.section];
    return sect.menuItems[indexPath.row];
}

- (MKMenuSection *)menuSectionForSection:(NSUInteger)section {
    MKTableViewSection *sect = [self sectionObjectForIndex:section];
    if ([sect isKindOfClass:[MKMenuSection class]]) {
        return (MKMenuSection *)sect;
    }
    return nil;
}

- (MKMenuSection *)menuSectionForItem:(MKMenuObject *)item {
    for (MKTableViewSection *sect in self.sections) {
        if ([sect isKindOfClass:[MKMenuSection class]]) {
            MKMenuSection * menu = (MKMenuSection *)sect;
            if ([menu.menuItems containsObject:item]) {
                return menu;
            }
        }
    }
    return nil;
}

#pragma mark - abstracts

- (NSUInteger)numberOfRowsInNonMenuSectionWhenExpanded:(NSUInteger)section {
    RaiseExceptionMissingMethodInClass
    return 0;
}

- (NSString *)titleForHeaderInNonMenuSection:(NSInteger)section {
    return nil;
}

- (void)createMenuObjects {
    RaiseExceptionMissingMethodInClass
}

- (void)updateBadges {
}

- (void)updateBadge:(MKBadgeItem *)badge {
    MKMenuObject *obj = [self menuItemForTitle:[badge keyForBadge]];
    obj.badge = badge;
}

- (void)badgeUpdated:(MKBadgeItem *)badge {
    MKMenuObject *obj = [self menuItemForTitle:[badge keyForBadge]];
    obj.badge = badge;
    MKMenuSection *sect = [self menuSectionForItem:obj];
    if (sect) {
        NSUInteger index = [self.sections indexOfObject:sect];
        [self reloadSectionKeepSelection:index];
    }
}

#pragma mark - helpers

- (SpinnerItem *)spinnerItemForIndexPath:(NSIndexPath *)indexPath {
    MKMenuObject *obj = [self menuItemForIndexPath:indexPath];
    return obj.spinner;
}

- (void)reloadSectionKeepSelection:(NSUInteger)section {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView selectRowAtIndexPath:self.selectedOption animated:NO scrollPosition:UITableViewScrollPositionNone];
    });
}

- (void)reloadRowsKeepSelection:(NSArray *)indexPaths {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView selectRowAtIndexPath:self.selectedOption animated:NO scrollPosition:UITableViewScrollPositionNone];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
