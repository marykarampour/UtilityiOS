//
//  MKUMenuViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-12-07.
//

#import "MKUMenuViewController.h"
#import "NSString+Validation.h"
#import "MKUNotificationCenter.h"
#import "UIViewController+Menu.h"

@interface MKUMenuTableViewCell : MKUBaseTableViewCell

@end

@implementation MKUMenuTableViewCell

- (instancetype)initWithStyleObject:(id<MKUCellStyleProtocol>)obj {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle]) {
        self.textLabel.font = [obj.class cellTitleFont];
        self.textLabel.textColor = [obj.class cellTitleColor];
        self.detailTextLabel.font = [obj.class cellSubtitleFont];
        self.detailTextLabel.textColor = [obj.class cellSubtitleColor];
        self.textLabel.numberOfLines = 2;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return self;
}

@end

@interface MKUMenuViewController ()

@end

@implementation MKUMenuViewController

- (instancetype)init {
    return [super initWithStyle:UITableViewStylePlain];
}

- (void)initBase {
    [super initBase];
    [self registerForBadgeUpdates];
    
    self.canExpandMultipleSections = YES;
}

- (void)didSetMenuObjects:(NSArray<MKUMenuSectionObject *> *)menuObjects {
    self.sectionObjects = [self.menuObjects mutableCopy];
}

- (void)setCanLoadMenuObjects:(BOOL)canLoadMenuObjects {
    _canLoadMenuObjects = canLoadMenuObjects;
    if (canLoadMenuObjects) [self createMenuObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadDataAnimated:NO];
}

#pragma mark - Table view data source

- (NSUInteger)numberOfRowsInNonDateSectionWhenExpanded:(NSUInteger)section {
    return self.menuObjects[section].menuItemObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self titleForItem:indexPath];
    if (0 == title.length)
        return 0.0;
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = [self anyTitleForSection:section];
    if (title.length == 0)
        return nil;
    return self.menuObjects[section].title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = [self titleForItem:indexPath];
    if (0 == title.length)
        return [[MKUMenuTableViewCell alloc] initWithStyleObject:self];
    
    MKUMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MKUMenuTableViewCell identifier]];
    
    if (!cell) {
        cell = [[MKUMenuTableViewCell alloc] initWithStyleObject:self];
    }
    
    NSString *subtitle = [self subtitleForItem:indexPath];
    MKUMenuItemObject *obj = [self menuObjectAtIndexPath:indexPath];
    BOOL hasBadge = [obj.badge hasValue];
    BOOL hasSpinner = obj.spinnerState == MKU_MENU_SPINNER_STATE_ACTIVE;
    
    if (hasBadge && hasSpinner) {
        MKUBadgeSpinnerView *badge = [[MKUBadgeSpinnerView alloc] init];
        [badge setText:obj.badge.description];
        [badge.spinnerView startAnimating];
        cell.accessoryView = badge;
    }
    else if (hasBadge) {
        MKUBadgeView *badge = [[MKUBadgeView alloc] init];
        [badge setText:obj.badge.description];
        cell.accessoryView = badge;
    }
    else if (hasSpinner) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        [spinner startAnimating];
        cell.accessoryView = spinner;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = nil;
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}

+ (UIFont *)cellTitleFont {
    return [AppTheme mediumLabelFont];
}

+ (UIColor *)cellTitleColor {
    return [AppTheme nightBlueColorWithAlpha:1.0];
}

+ (UIFont *)cellSubtitleFont {
    return [AppTheme smallLabelFont];
}

+ (UIColor *)cellSubtitleColor {
    return [UIColor grayColor];
}

- (void)didSelectNonDateRowAtIndexPath:(NSIndexPath *)indexPath {
    MKUMenuItemObject *obj = [self menuObjectAtIndexPath:indexPath];
    if (obj.spinnerState == MKU_MENU_SPINNER_STATE_ACTIVE) {
        [self handleDidSelectSpinnerRowAtIndexPath:indexPath];
        return;
    }
    [self didSelectNoneSpinnerRowAtIndexPath:indexPath];
}

- (void)handleDidSelectSpinnerRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)didSelectNoneSpinnerRowAtIndexPath:(NSIndexPath *)indexPath {
    [super didSelectNonDateRowAtIndexPath:indexPath];
    [self handleTransitionToViewAtIndexPath:indexPath];
}

- (void)handleTransitionToViewAtIndexPath:(NSIndexPath *)indexPath {
    [self transitionToViewAtIndexPath:indexPath];
}

- (void)reload {
    [self reloadDataAnimated:NO];
}

- (void)updateBadge:(MKUBadgeItem *)badge {
    [self updateMenuBadge:badge];
}

- (void)createMenuObjects {
    MKURaiseExceptionMissingMethodInClass
}

- (void)willTransitionToView:(UIViewController *)VC atIndexPath:(NSIndexPath *)indexPath {
}

- (void)viewController:(UIViewController *)viewController didReturnWithResultType:(VC_TRANSITION_RESULT_TYPE)resultType object:(id)object {
    if (resultType == VC_TRANSITION_RESULT_TYPE_OK) {
        if ([self respondsToSelector:@selector(handleViewController:didReturnWithObject:)])
            [self handleViewController:viewController didReturnWithObject:object];
    }
}

@end
