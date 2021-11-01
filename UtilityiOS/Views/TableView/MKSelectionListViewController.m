//
//  MKSelectionListViewController.m
//  KaChing
//
//  Created by Maryam Karampour on 2021-10-31.
//  Copyright © 2021 Prometheus Software. All rights reserved.
//

#import "MKSelectionListViewController.h"

@interface MKSelectionListViewController ()

@property (nonatomic, assign) NSInteger selectedTextIndex;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@end

@implementation MKSelectionListViewController

- (instancetype)init {
    return [self initWithTitle:@""];
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        self.title = title;
        self.selectedTextIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedTextIndex = -1;
    
    if (self.selectionTextLabels) {
        self.doneButton = [[UIBarButtonItem alloc] initWithTitle:[Constants Done_STR] style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
    }
}

#pragma mark - Table View Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.selectionTextLabels) {
        if ([self hasSubCategoryForSelectedCategory]) {
            return [Constants TableSectionHeaderHeight];
        }
        return section == 0 ? [Constants TableSectionHeaderHeight] : 0.0;
    }
    return 0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.selectionTextLabels) {
        if (0 <= self.selectedTextIndex) {
            return section == 0 ? self.categoryTitle : self.subcategoryTitle;
        }
        return self.categoryTitle;
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.selectionTextLabels) {
        if (0 <= self.selectedTextIndex) {
            return 2;
        }
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectionTextLabels) {
        if (section == 0) {
            return 1;
        }
        else if (0 <= self.selectedTextIndex) {
            
            NSObject<NSCopying> *key = [self selectedKey];
            return self.selectionTextLabels[key].count;
        }
        return 0;
    }
    return [self listCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MKBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MKBaseTableViewCell identifier]];
    if (!cell) {
        cell = [[MKBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MKBaseTableViewCell identifier]];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    if (self.selectionTextLabels) {
        
        BOOL isFirstSection = indexPath.section == 0;
        if (0 <= self.selectedTextIndex) {
            NSObject<NSCopying> *key = [self selectedKey];
            NSArray *value = self.selectionTextLabels[key];
            cell.textLabel.text = [(isFirstSection ? key : value[indexPath.row]) description];
        }
        else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [Constants Select_STR], self.categoryTitle];
        }
        cell.accessoryType = isFirstSection ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    }
    else {
        cell.textLabel.text = [self textLabelForRow:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectionTextLabels) {
        if (indexPath.section == 0) {
            MKSelectionListViewController *vc = [[MKSelectionListViewController alloc] initWithTitle:self.subcategoryTitle];
            vc.textLabels = self.selectionTextLabels.allKeys;
            vc.transitionDelegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            [self performDoneWithCategoryAtIndexPath:indexPath];
        }
    }
    else {
        [self dispatchDelegateWithObject:indexPath];
    }
}

- (void)performDoneWithCategoryAtIndexPath:(NSIndexPath *)indexPath {
    if (0 <= self.selectedTextIndex) {
        NSObject<NSCopying> *key = [self selectedKey];
        NSArray *value = self.selectionTextLabels[key];
        NSObject *obj = indexPath ? value[indexPath.row] : @"";
        NSDictionary *dict = [NSDictionary dictionaryWithObject:obj forKey:key];
        [self dispatchDelegateWithObject:dict];
    }
}

- (void)dispatchDelegateWithObject:(NSObject *)object {
    if ([self.delegate conformsToProtocol:@protocol(MKTableViewControllerDelegate)] &&
        [self.delegate respondsToSelector:@selector(viewTransition:withObject:)]) {
        [self.delegate viewTransition:self withObject:object];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self.transitionDelegate respondsToSelector:@selector(viewController:didReturnWithResultType:andObject:)]) {
        [self.transitionDelegate viewController:self didReturnWithResultType:ViewControllerTransitionResult_OK andObject:object];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewController:(UIViewController *)viewController didReturnWithResultType:(ViewControllerTransitionResult)resultType andObject:(id)object {
    if (self.selectionTextLabels &&
        [object isKindOfClass:[NSIndexPath class]] &&
        resultType == ViewControllerTransitionResult_OK &&
        [viewController isKindOfClass:[MKSelectionListViewController class]]) {
        
        NSIndexPath *indexPath = (NSIndexPath *)object;
        self.selectedTextIndex = indexPath.row;
        [self reloadDataAnimated:NO];
    }
}

- (NSInteger)listCount {
    return self.textLabels.count;
}

- (NSString *)textLabelForRow:(NSInteger)row {
    return [self.textLabels[row] description];
}

#pragma mark - helpers

- (NSObject<NSCopying> *)selectedKey {
    if (0 <= self.selectedTextIndex && self.selectedTextIndex < self.selectionTextLabels.allKeys.count)
        return self.selectionTextLabels.allKeys[self.selectedTextIndex];
    return nil;
}

- (NSArray *)subCategoryForSelectedCategory {
    return [self subCategoryForCategoryAtIndex:self.selectedTextIndex];
}

- (BOOL)hasSubCategoryForSelectedCategory {
    return [self hasSubCategoryForCategoryAtIndex:self.selectedTextIndex];
}

- (NSArray *)subCategoryForCategoryAtIndex:(NSUInteger)index {
    if (0 <= index && index < self.selectionTextLabels.allKeys.count) {
        NSObject<NSCopying> *key = [self selectedKey];
        return self.selectionTextLabels[key];
    }
    return @[];
}

- (BOOL)hasSubCategoryForCategoryAtIndex:(NSUInteger)index {
    return 0 < [self subCategoryForCategoryAtIndex:index].count;
}

- (void)donePressed:(UIBarButtonItem *)sender {
    [self performDoneWithCategoryAtIndexPath:nil];
}

- (void)setSelectedTextIndex:(NSInteger)selectedTextIndex {
    _selectedTextIndex = selectedTextIndex;
    self.navigationItem.rightBarButtonItem = [self hasSubCategoryForSelectedCategory] ? nil : self.doneButton;
}
@end
