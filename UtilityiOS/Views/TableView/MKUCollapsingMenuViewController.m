//
//  MKUMenuViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-24.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUCollapsingMenuViewController.h"
#import "UIViewController+Utility.h"
#import "UINavigationController+Transition.h"
#import "UIView+Utility.h"
#import "MKUHeaderFooterContainerViewController.h"

@implementation SpinnerItem

@end

@interface MKUMenuObject ()

@property (nonatomic, assign, readwrite) Class trueVCClass;

@end

@implementation MKUMenuObject

- (void)setVCClass:(Class)VCClass {
    _VCClass = VCClass;
    [self setTrueVCClass];
}

- (void)setType:(NSUInteger)type {
    _type = type;
    [self setTrueVCClass];
}

- (void)setTrueVCClass {
    [self viewController];
}

- (UIViewController *)viewController {
    //TODO: do not init if already exists
    UIViewController *nextViewController;
    if ([self.VCClass instancesRespondToSelector:@selector(initWithMKUType:)]) {
        nextViewController = [[self.VCClass alloc] initWithMKUType:self.type];
    }
    else {
        nextViewController = [[self.VCClass alloc] init];
    }
    self.trueVCClass = [nextViewController class];
    return nextViewController;
}

@end

@implementation MKUMenuSection

@dynamic items;

@end


@interface MKUCollapsingMenuTableViewCell ()

@property (nonatomic, strong) MKUBadgeView *badge;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSLayoutConstraint *iconSizeConstraint;
@property (nonatomic, strong, readwrite) UIImageView *iconImage;
@property (nonatomic, strong, readwrite) MKULabel *titleLabel;

@end

@implementation MKUCollapsingMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.badge = [[MKUBadgeView alloc] init];
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.iconImage = [[UIImageView alloc] init];
        self.iconImage.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel = [[MKULabel alloc] init];
        
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.badge];
        
        [self.contentView removeConstraintsMask];
        [self.contentView constraint:NSLayoutAttributeRight view:self.badge margin:-[Constants HorizontalSpacing]];
        [self.contentView constraint:NSLayoutAttributeCenterY view:self.badge];
        [self.contentView constraint:NSLayoutAttributeLeft view:self.iconImage margin:[Constants HorizontalSpacing]];
        [self.contentView constraint:NSLayoutAttributeCenterY view:self.iconImage];
        [self.contentView constraint:NSLayoutAttributeTop view:self.titleLabel];
        [self.contentView constraint:NSLayoutAttributeBottom view:self.titleLabel];
        
        [self.contentView addConstraintWithItem:self.iconImage attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-[Constants HorizontalSpacing]];
        [self.contentView addConstraintWithItem:self.badge attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:[Constants HorizontalSpacing]];
        
        self.iconSizeConstraint = [NSLayoutConstraint constraintWithItem:self.iconImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        [self.contentView addConstraintWithItem:self.iconImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.iconImage attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
        
        [self.contentView addConstraint:self.iconSizeConstraint];
    }
    return self;
}

- (void)updateWithObject:(MKUMenuObject *)obj {
    if (obj.hasSpinner) {
        if (obj.spinner.inProgress) {
            [self animateSpinner];
        }
        else {
            if (obj.accessoryView) {
                self.accessoryView = obj.accessoryView;
            }
            else {
                self.accessoryType = obj.accessoryType;
            }
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
        if (obj.accessoryView) {
            self.accessoryView = obj.accessoryView;
        }
        else {
            self.accessoryType = obj.accessoryType;
        }
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

- (void)setIconSize:(CGFloat)size {
    self.iconSizeConstraint.constant = size;
    [self setNeedsLayout];
}

@end

@interface MKUCollapsingMenuViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MKUCollapsingMenuViewController

@dynamic sections;

- (instancetype)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        [self reloadMenu];
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
    [self setItemsStyle];
    [self reloadDataAnimated:NO];
}

+ (UIViewController *)viewControllerForObject:(MKUMenuObject *)obj {
    return [obj viewController];
}

- (void)transitionToView:(NSIndexPath *)indexPath animated:(BOOL)animated {
    
    MKUMenuObject *obj = [self menuItemForIndexPath:indexPath];
    
    UIViewController *nextViewController = [self.class viewControllerForObject:obj];
    if (obj.actionObject) {
        if ([obj.actionObject.target respondsToSelector:obj.actionObject.action]) {
            [obj.actionObject.target performSelector:obj.actionObject.action withObject:obj.actionObject.object];
        }
        else if ([nextViewController respondsToSelector:obj.actionObject.action]) {
            [nextViewController performSelector:obj.actionObject.action withObject:obj.actionObject.object];
        }
    }
    
    UIViewController *navigationVC = self.containerVC ? self.containerVC : self;
    
    if (navigationVC.navigationController) {
        [navigationVC.navigationController pushViewController:nextViewController animated:animated];
    }
    else {
        UIViewController *presentingVC = navigationVC.presentingViewController;
        UINavigationController *presentingNav;
        if ([presentingVC isKindOfClass:[UINavigationController class]]) {
            presentingNav = (UINavigationController *)presentingVC;
        }
        else if (presentingVC.navigationController) {
            presentingNav = presentingVC.navigationController;
        }
        
        //dismiss the menu
        if (self.containerVC) {
            [self.containerVC dismissViewControllerAnimated:animated completion:nil];
        }
        else {
            [self dismissViewControllerAnimated:animated completion:nil];
        }
        
        for (UIViewController *childMenu in presentingVC.childViewControllers) {
            if ([childMenu isKindOfClass:[MKUCollapsingMenuViewController class]]) {
                [((MKUCollapsingMenuViewController *)childMenu) transitionToView:indexPath animated:animated];
                return;
            }
        }
        
        //push next VC
        if (presentingNav) {
            //Assuming presentingNav's VCs correspond to menu items
            MKUMenuSection *section = self.sections.firstObject;
            UIViewController *currentVC = presentingNav.topViewController;
            NSMutableArray<UIViewController *> *VCs = [presentingNav.viewControllers mutableCopy];
            NSUInteger navigationIndex = [section.items indexOfObject:obj];
            NSUInteger currentIndex = [VCs indexOfObject:currentVC];
            
            if (currentIndex < navigationIndex) {
                for (NSUInteger i=currentIndex+1; i<=navigationIndex; i++) {
                    
                    if (section.items.count <= i) break;
                    
                    MKUMenuObject *obj = section.items[i];
                    UIViewController *nextVC = [self.class viewControllerForObject:obj];
                    [VCs insertObject:nextVC atIndex:i];
                }
                [presentingNav setViewControllers:VCs animated:animated];
            }
            else if (navigationIndex < currentIndex) {
                [presentingNav popToViewControllerAtIndex:navigationIndex animated:animated];
            }
        }
        else {
            [presentingVC presentViewController:nextViewController animationType:animated ? kCATransitionFromRight : nil timingFunction:kCAAnimationLinear completion:nil];
        }
    }
}

+ (void)transitionToNextItemFromView:(__kindof UIViewController *)VC {
    
    UIViewController *pvc = [VC previousViewController];
    MKUCollapsingMenuViewController *mvc;
    
    if ([pvc isKindOfClass:[MKUCollapsingMenuViewController class]]) {
        mvc = (MKUCollapsingMenuViewController *)pvc;
    }
    else if ([pvc isKindOfClass:[MKUHeaderFooterContainerViewController class]]) {
        
        MKUHeaderFooterContainerViewController *hvc = (MKUHeaderFooterContainerViewController *)pvc;
        mvc = (MKUCollapsingMenuViewController *)hvc.childViewController;
    }
    //TODO: this should loop through all sections
    if ([mvc isKindOfClass:[MKUCollapsingMenuViewController class]]) {
        MKUMenuSection *section = (MKUMenuSection *)mvc.sections.firstObject;
        
        if ([section isKindOfClass:[MKUMenuSection class]]) {
            
            __block NSInteger index = -1;
            
            [section.items enumerateObjectsUsingBlock:^(MKUMenuObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.VCClass == VC.class || [VC isKindOfClass:obj.VCClass]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            
            if (index >= 0 && index+1 < section.items.count) {
                
                MKUMenuObject *item = section.items[index+1];
                [VC.navigationController popViewControllerAnimated:NO];
                
                if (item.action && [mvc respondsToSelector:item.action]) {
                    [mvc performSelector:item.action];
                }
                else {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
                    [mvc transitionToView:indexPath animated:NO];
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSUInteger)numberOfRowsInSectionWhenExpanded:(NSUInteger)section {
    MKUMenuSection *sect = [self menuSectionForSection:section];
    if (sect) {
        return sect.items.count;
    }
    return [self numberOfRowsInNonMenuSectionWhenExpanded:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MKUMenuSection *sect = [self menuSectionForSection:section];
    if (sect) {
        return sect.title;
    }
    return [self titleForHeaderInNonMenuSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKUMenuObject *obj = [self menuItemForIndexPath:indexPath];
    return obj.hidden ? 0.0 : [self heightForVisibleRowAtIndexPath:indexPath];
}

- (CGFloat)heightForVisibleRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0;
}

- (MKUBaseTableViewCell *)baseCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKUBaseTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MKUBaseTableViewCell identifier]];
    if (cell == nil) {
        cell = [[MKUBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MKUBaseTableViewCell identifier]];
    }
    return cell;
}

- (MKUCollapsingMenuTableViewCell *)baseMenuCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKUCollapsingMenuTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MKUCollapsingMenuTableViewCell identifier]];
    
    if (cell == nil) {
        cell = [[MKUCollapsingMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MKUCollapsingMenuTableViewCell identifier]];
    }
    return cell;
}

- (void)customizeBaseMenuCell:(__kindof MKUCollapsingMenuTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MKUMenuObject *obj = [self menuItemForIndexPath:indexPath];
    
    cell.accessoryType = obj.accessoryType;
    cell.iconImage.image = obj.iconImage;
    cell.iconImage.tintColor = obj.tintColor;
    cell.titleLabel.textColor = obj.textColor;
    cell.titleLabel.font = obj.font;
    
    if (obj.selectedColor) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = obj.selectedColor;
        cell.selectedBackgroundView = view;
    }
    if (obj.backgroundColor) {
        cell.backgroundColor = obj.backgroundColor;
        cell.contentView.backgroundColor = obj.backgroundColor;
    }
    
    [cell setIconSize:obj.iconSize];
    cell.titleLabel.text = [self titleForItem:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKUMenuObject *obj = [self menuItemForIndexPath:indexPath];
    if (obj) {
        __kindof MKUCollapsingMenuTableViewCell *cell = [self baseMenuCellForRowAtIndexPath:indexPath];
        [self customizeBaseMenuCell:cell forRowAtIndexPath:indexPath];
        [cell updateWithObject:obj];
        return cell;
    }
    return [self baseCellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKUMenuObject *obj = [self menuItemForIndexPath:indexPath];
    if (obj) {
        if (obj.hasSpinner && obj.spinner.inProgress) {
            return;
        }
        if (obj.action && [self respondsToSelector:obj.action]) {
            [self performSelector:obj.action];
        }
        else {
            [self transitionToView:indexPath animated:YES];
        }
    }
    self.selectedOption = indexPath;
    [self reloadDataAnimated:NO];
}

- (NSString *)titleForItem:(NSIndexPath *)indexPath {
    MKUMenuObject *obj = [self menuItemForIndexPath:indexPath];
    return obj ? obj.title: nil;
}

- (MKUMenuObject *)menuItemForTitle:(NSString *)title {
    for (MKUMenuSection *sect in self.sections) {
        for (MKUMenuObject *obj in sect.items) {
            if ([obj.title isEqualToString:title]) {
                return obj;
            }
        }
    }
    return nil;
}

- (MKUMenuObject *)menuItemForIndexPath:(NSIndexPath *)indexPath {
    MKUMenuSection *sect = [self menuSectionForSection:indexPath.section];
    return sect.items[indexPath.row];
}

- (MKUMenuSection *)menuSectionForSection:(NSUInteger)section {
    MKUTableViewSection *sect = [self sectionObjectForIndex:section];
    if ([sect isKindOfClass:[MKUMenuSection class]]) {
        return (MKUMenuSection *)sect;
    }
    return nil;
}

- (MKUMenuSection *)menuSectionForItem:(MKUMenuObject *)item {
    for (MKUTableViewSection *sect in self.sections) {
        if ([sect isKindOfClass:[MKUMenuSection class]]) {
            MKUMenuSection * menu = (MKUMenuSection *)sect;
            if ([menu.items containsObject:item]) {
                return menu;
            }
        }
    }
    return nil;
}

- (void)setItemsStyle {
    [self.sections enumerateObjectsUsingBlock:^(__kindof MKUMenuSection * _Nonnull sec, NSUInteger idxs, BOOL * _Nonnull stops) {
        [sec.items enumerateObjectsUsingBlock:^(MKUMenuObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:idx inSection:idxs];
            [self setStyleForItem:obj atIndexPath:path];
        }];
    }];
}

- (void)setStyleForItem:(MKUMenuObject *)item atIndexPath:(NSIndexPath *)indexPath {
    item.accessoryType = [self accessoryTypeForIndexPath:indexPath];
    item.accessoryView = [self accessoryViewForIndexPath:indexPath];
}

- (UITableViewCellAccessoryType)accessoryTypeForIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryNone;
}

- (UIView *)accessoryViewForIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - abstracts

- (NSUInteger)numberOfRowsInNonMenuSectionWhenExpanded:(NSUInteger)section {
    MKURaiseExceptionMissingMethodInClass
    return 0;
}

- (NSString *)titleForHeaderInNonMenuSection:(NSInteger)section {
    return nil;
}

- (void)createMenuObjects {
    MKURaiseExceptionMissingMethodInClass
}

- (void)reloadMenu {
    [self.sections removeAllObjects];
    [self createMenuObjects];
    [self updateBadges];
    [self setItemsStyle];
    [self reloadDataAnimated:NO];
}

- (void)updateBadges {
}

- (void)updateBadge:(MKUBadgeItem *)badge {
    MKUMenuObject *obj = [self menuItemForTitle:badge.name];
    obj.badge = badge;
}

- (void)badgeUpdated:(MKUBadgeItem *)badge {
    MKUMenuObject *obj = [self menuItemForTitle:badge.name];
    obj.badge = badge;
    MKUMenuSection *sect = [self menuSectionForItem:obj];
    if (sect) {
        NSUInteger index = [self.sections indexOfObject:sect];
        [self reloadSectionKeepSelection:index];
    }
}

#pragma mark - helpers

- (SpinnerItem *)spinnerItemForIndexPath:(NSIndexPath *)indexPath {
    MKUMenuObject *obj = [self menuItemForIndexPath:indexPath];
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

@end
