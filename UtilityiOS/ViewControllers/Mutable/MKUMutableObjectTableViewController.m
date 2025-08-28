//
//  MKUMutableObjectTableViewController.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUMutableObjectTableViewController.h"
#import "MKUTableViewController+ItemsListTransition.h"
#import "MKUSearchResultsTransitionViewController.h"
#import "MKUHorizontalLabelFieldTableViewCell.h"
#import "MKUMessageComposerController.h"
#import "NSString+AttributedText.h"
#import "MKUEditingTableViewCell.h"
#import "MKUInputTableViewCell.h"
#import "MKUStepperFieldView.h"
#import "MKUAccessoryLabel.h"
#import "NSString+Utility.h"
#import "NSObject+Utility.h"
#import "NSString+Number.h"
#import "NSArray+Utility.h"
#import "MKUBadgeView.h"

@interface MKUMutableObjectTableViewController ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation MKUMutableObjectTableViewController

- (void)initBase {
    [super initBase];

    self.isEditable = YES;
    self.transitionVCDelegate = self;
    self.updateDelegate = self;
}

- (void)initSelectedActionHandler {
    __weak __typeof(self) weakSelf = self;
    
    self.selectedActionHandler = ^MKU_LIST_ITEM_SELECTED_ACTION(NSUInteger section) {
        MKU_MUTABLE_OBJECT_FIELD_TYPE type = [weakSelf typeForSection:section];
        return type == MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST ? MKU_LIST_ITEM_SELECTED_ACTION_TRANSITION_TO_DETAIL : MKU_LIST_ITEM_SELECTED_ACTION_NONE;
    };
}

- (SEL)actionForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return type == MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE ? @selector(handleSavePressed) : @selector(reset);
}

- (BOOL)isEnabledButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return YES;
}

- (NSString *)titleForButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return type == MKU_NAV_BAR_BUTTON_TYPE_SYSTEM_SAVE ? [Constants Save_STR] : [Constants Reset_STR];
}

- (BOOL)hasButtonOfType:(MKU_NAV_BAR_BUTTON_TYPE)type {
    return self.isEditable;
}

- (BOOL)hasMutableNavbar {
    return YES;
}

- (void)setIsEditable:(BOOL)isEditable {
    _isEditable = isEditable;
    
    if (isEditable && [self canEditListsByDefault]) self.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [self updateDatesWithUpdateObject:self.object.UpdatedObject];
    if ([self hasMutableNavbar]) [self setAsNavBarTarget];
    [self reloadDataAnimated:NO];
}

- (void)setNavBarItems {
    [self setMutableNavBarItems];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSUInteger)numberOfRowsInNonDateSection:(NSUInteger)section {
    
    if (![self hasValueForSection:section] || [self hideSection:section])
        return 0;
    
    MKU_MUTABLE_OBJECT_FIELD_TYPE type = [self typeForSection:section];
    
    if ((type == MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION || type == MKU_MUTABLE_OBJECT_FIELD_TYPE_LABEL) && [self shouldHideSelectionSection:section])
        return 0;
    
    if (type == MKU_MUTABLE_OBJECT_FIELD_TYPE_TITLE_FIELD ||
        type == MKU_MUTABLE_OBJECT_FIELD_TYPE_STEPPER_FIELD ||
        type == MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_COMMENT ||
        type == MKU_MUTABLE_OBJECT_FIELD_TYPE_COMMENT) {
        
        if ([self shouldHideCommentSection:section])
            return 0;
        
        BOOL isEditable = [self canEditSection:section];
        return isEditable && type != MKU_MUTABLE_OBJECT_FIELD_TYPE_STEPPER_FIELD ? 2 : 1;
    }
    
    if (type == MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST)
        return [self numberOfRowsInListSection:section];
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:self.tableView numberOfRowsInSection:section] == 0)
        return 0.0;
    if ([self isHeaderSection:section] && ![self hideSection:section])
        return [self hasTitleForHeaderInSection:section] ? [Constants TableSectionHeaderHeight] : [Constants TableSectionHeaderShortHeight];
    return 0.0;
}

- (CGFloat)heightForNonDateRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = indexPath.section;
    NSString *value = [self valueForSection:section];
    BOOL isEditable = [self canEditSection:section];
    
    switch ([self typeForSection:section]) {
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_VERTICAL_FIELD:
            return 80.0;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_FIELD:
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX:
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_STEPPER_FIELD:
            return [Constants ExtendedRowHeight];
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_BUTTON:
            return [self checkboxButtonRowHeightForSection:section];
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST: {
            if ([self isAddIndexPath:indexPath])
                return [self heightForStandardSelectionCell];
            return [self heightForNonEditingListRowAtIndexPath:indexPath];
        }
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_TITLE_FIELD: {
            if (isEditable)
                return [self heightForTextFieldCellAtIndexPath:indexPath];
            return [self adjustHeight:[self heightForTitle:[self titleForSection:section]] + [self heightForTitle:value]];
        }
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_COMMENT: {
            if (isEditable)
                return [self heightForTextViewCellAtIndexPath:indexPath];
            return [self adjustHeight:[self heightForTitle:[self titleForSection:section]] + [self heightForTitle:value]];
        }
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_COMMENT: {
            CGFloat titleHeight = [self heightForTitle:[self titleForSection:section]] + [Constants TableCellLineHeight];
            if (isEditable)
                return indexPath.row == MKU_TEXTVIEW_CELL_ROW_TITLE ? titleHeight : [Constants TextViewMediumHeight];
            return [self adjustHeight:titleHeight + [self heightForTitle:value]];
        }
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_SINGLE_CELL:
            return [self heightForSingleCellRowAtIndexPath:indexPath];
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_BLANK: {
            if ([self hasNoValueOrAattributedValueInSection:section])
                return 0.0;
        }
            
        default: {
            if ([self hideSection:section] || [self shouldHideSelectionSection:section])
                return 0.0;
            else {
                MKULabelAttributes *attrs = [self labelAttributesForSection:section];
                return [self adjustHeight:[attrs heightForWidth:self.view.frame.size.width]];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (![self hasValueForSection:section]) return 0;
    
    MKU_MUTABLE_OBJECT_FIELD_TYPE type = [self typeForSection:section];
    return (type == MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION || type == MKU_MUTABLE_OBJECT_FIELD_TYPE_LABEL) ? 1.0 : 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNonDateRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    
    NSUInteger section = indexPath.section;
    MKU_MUTABLE_OBJECT_FIELD_TYPE type = [self typeForSection:section];
    BOOL isEditable = [self canEditSection:section];
    //TODO: not editable format for all cells
    
    switch (type) {
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION:
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_LABEL: {
            
            MKUBaseTableViewCell *cell = [[MKUSubtitleTableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = [self hasAccessoryForSection:section] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            
            MKULabelAttributes *attrs = [self labelAttributesForSection:section];
            [attrs setAttributedTitlesForLabel:cell.textLabel sublabel:cell.detailTextLabel];
            
            NSString *badge = [self.object.UpdatedObject badgeValueForSectionType:section];
            
            if (0 < badge.length) {
                MKUBadgeView *view = [[MKUBadgeView alloc] init];
                [view setText:badge];
                cell.accessoryView = view;
            }
            else {
                cell.accessoryView = nil;
            }
            return cell;
        }
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_FIELD: {
            
            if (!isEditable) {
                return [self uneditableFieldCellForSection:section withStyle:UITableViewCellStyleValue1];
            }
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:[self rowForFieldAtIndex:MKU_COLUMN_TYPE_LEFT inSection:section] inSection:section];

            MKUInputTableViewCell *cell = [[MKUInputTableViewCell alloc] initWithTextType:[self textTypeForFieldAtIndexPath:path] buttonImage:[self buttonImageForFieldAtIndexPath:path] fieldWidth:[self textWidthForFieldAtIndexPath:path] horizontalMargin:[Constants TableCellContentHorizontalMargin]];
            
            cell.textField.controller.delegate = self.object.UpdatedObject;
            cell.textField.controller.maxLenght = 64;
            cell.textField.text = [self valueForSection:section];
            cell.label.text = [self titleForSection:section];
            [cell setIndexPath:path];
            [cell setTarget:self action:[self actionForFieldButtonAtIndexPath:path]];
            return cell;
        }
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_VERTICAL_FIELD: {
            
            NSArray *titles = [NSArray arrayWithObjects:[self titleForSection:section], [self subtitleForSection:section], nil];
            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:[self rowForFieldAtIndex:MKU_COLUMN_TYPE_LEFT inSection:section] inSection:section];
            NSIndexPath *lastPath = [NSIndexPath indexPathForRow:[self rowForFieldAtIndex:MKU_COLUMN_TYPE_RIGHT inSection:section] inSection:section];
            
            MKUHorizontalLabelFieldTableViewCell *cell = [[MKUHorizontalLabelFieldTableViewCell alloc] initWithTitles:titles delegate:self.object.UpdatedObject interItemSpacing:[Constants HorizontalSpacing] width:self.view.frame.size.width verticalMargin:0.0];
            
            [cell setText:[self valueForSection:section] forFieldAtIndex:MKU_COLUMN_TYPE_LEFT];
            [cell setText:[self subvalueForSection:section] forFieldAtIndex:MKU_COLUMN_TYPE_RIGHT];
            [cell viewAtIndex:MKU_COLUMN_TYPE_LEFT].textField.controller.type = [self textTypeForFieldAtIndexPath:firstPath];
            [cell viewAtIndex:MKU_COLUMN_TYPE_RIGHT].textField.controller.type = [self textTypeForFieldAtIndexPath:lastPath];
            [cell setIndexPath:firstPath forFieldAtIndex:MKU_COLUMN_TYPE_LEFT];
            [cell setIndexPath:lastPath forFieldAtIndex:MKU_COLUMN_TYPE_RIGHT];
            return cell;
        }
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_STEPPER_FIELD: {
            
            MKUSingleViewTableViewCell <MKUStepperFieldView *> *cell = [[MKUSingleViewTableViewCell alloc] initWithInsets:UIEdgeInsetsZero viewCreationHandler:^UIView *{
                MKUStepperFieldView *view = [[MKUStepperFieldView alloc] initWithValues:[self stepperValuesForSection:section]];
                [view setIndexPath:[NSIndexPath indexPathForRow:[self rowForFieldAtIndex:MKU_COLUMN_TYPE_LEFT inSection:section] inSection:section]];
                [view setDelegate:self.object.UpdatedObject];
                return view;
            }];
            return cell;
        }
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX: {
            return [self radioButtonCellInSection:section enabled:isEditable singleLine:NO];
        }
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_BUTTON: {
            return [self checkboxButtonCellInSection:section enabled:isEditable singleLine:NO];
        }
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_TITLE_FIELD: {
            
            if (!isEditable) {
                return [self uneditableFieldCellForSection:section withStyle:UITableViewCellStyleSubtitle];
            }
            
            return [self textFieldCellForIndexPath:indexPath title:[self titleForSection:section] delegate:self.object.UpdatedObject viewIndexPath:[NSIndexPath indexPathForRow:[self rowForFieldAtIndex:MKU_COLUMN_TYPE_LEFT inSection:section] inSection:section] text:[self valueForSection:section] placeholder:[self placeholderTitleForSection:section]];
        }
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_COMMENT: {
            
            if (indexPath.row == MKU_TEXTVIEW_CELL_ROW_TITLE) {
                return [self radioButtonCellInSection:section enabled:isEditable singleLine:NO];
            }
            else {
                if (!isEditable) {
                    return [self uneditableFieldCellForSection:section withStyle:UITableViewCellStyleSubtitle];
                }
                
                return [self textViewCellForIndexPath:indexPath title:[self titleForSection:section] delegate:self.object.UpdatedObject viewIndexPath:[NSIndexPath indexPathForRow:[self rowForFieldAtIndex:MKU_COLUMN_TYPE_LEFT inSection:section] inSection:section] text:[self valueForSection:section] placeholder:[self placeholderTitleForSection:section] maxChars:[Constants MaxTextViewCharactersLong]];
            }
        }
            
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_COMMENT: {
            
            if (!isEditable) {
                return [self uneditableFieldCellForSection:section withStyle:UITableViewCellStyleSubtitle];
            }
            
            return [self textViewCellForIndexPath:indexPath title:[self titleForSection:section] delegate:self.object.UpdatedObject viewIndexPath:[NSIndexPath indexPathForRow:[self rowForFieldAtIndex:MKU_COLUMN_TYPE_LEFT inSection:section] inSection:section] text:[self valueForSection:section] placeholder:[self placeholderTitleForSection:section] maxChars:[Constants MaxTextViewCharactersLong]];
        }
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST: {
            NSUInteger listType = [self listTypeForListInSection:section];

            if ([self isAddIndexPath:indexPath] && [self canAddItemToListOfType:listType]) {
                MKUEditingTableViewCell *cell = [[MKUEditingTableViewCell alloc] init];
                cell.textLabel.text = [self titleForAddCellInListOfType:listType];
                return cell;
            }
            
            NSObject<MKUPlaceholderProtocol> *item = [self listItemAtIndexPath:indexPath];
            return [self cellForListItem:item atIndexPath:indexPath];
        }
            break;
            
        default: {
            MKUBaseTableViewCell *cell = [self singleCellForRowAtIndexPath:indexPath];
            cell.contentView.userInteractionEnabled = self.isEditable;
            return cell;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MKU_MUTABLE_OBJECT_FIELD_TYPE type = [self typeForSection:indexPath.section];
    NSUInteger section = indexPath.section;
    
    if (![self canSelectSection:section] && ![self isEmailOrPhoneSectionType:section]) return;
    
    switch (type) {
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX:
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_BUTTON:
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_COMMENT: {
            if (![self canEditSection:section]) return;
            [self switchBoolValueAtIndexPath:indexPath];
        }
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_LABEL:
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION:
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_SINGLE_CELL: {
            [self handleSelectionAtIndexPath:indexPath];
        }
            break;
            
        case MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST: {
            self.selectedIndexPath = indexPath;
            NSObject<MKUPlaceholderProtocol> *item = [self listItemAtIndexPath:indexPath];
            [self handleDidSelectListItem:item atIndexPath:indexPath];
        }
            break;
            
        default:
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
    }
}

#pragma mark - editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self typeForSection:indexPath.section] == MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST && [self canEditSection:indexPath.section];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.editing)
        return UITableViewCellEditingStyleNone;
    if ([self isAddIndexPath:indexPath] && [self canAddItemToListOfType:indexPath.section])
        return UITableViewCellEditingStyleInsert;
    else if ([self canDeleteFromListOfType:indexPath.section])
        return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPath = indexPath;
    NSUInteger section = indexPath.section;
    NSUInteger type = [self listTypeForListInSection:section];

    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self willAddItemToListOfType:type withCompletion:^(__kindof NSObject<MKUPlaceholderProtocol> *item) {
            if (!item || ![self shouldAddItem:item toListOfType:type]) {
                [self handleDidSelectListItem:item atIndexPath:indexPath];
            }
            else {
                [self addItem:item toListOfType:type];
                [self didAddItem:item forRowAtIndexPath:indexPath];
            }
            [self didFinishCommitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSObject<MKUPlaceholderProtocol> *item = [self listItemAtIndexPath:indexPath];
        [self willDeleteItem:item forRowAtIndexPath:indexPath withCompletion:^(BOOL success, NSError *error) {
            if (success && !error) {
                [self deleteItem:item fromListOfType:type];
                [self didDeleteItem:item forRowAtIndexPath:indexPath];
            }
            else if (error) {
                [self OKAlertWithTitle:kDeleteFailedTitle message:error.localizedDescription];
            }
            [self didFinishCommitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self typeForSection:indexPath.section] != MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST) return NO;
    if ([self isAddIndexPath:indexPath]) return NO;
    
    NSMutableArray *items = [self listItemsForListInSection:indexPath.section];
    if (items.count <= 1) return NO;
    
    return [self canMoveItemsInListOfType:indexPath.section];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if ([self isAddIndexPath:proposedDestinationIndexPath])
        return sourceIndexPath;
    return proposedDestinationIndexPath;
}

//TODO: Add a method to indicate if move between sections is allowed
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.section != destinationIndexPath.section) return;
    if (sourceIndexPath.row == destinationIndexPath.row) return;
    if ([self isAddIndexPath:sourceIndexPath] || [self isAddIndexPath:destinationIndexPath]) return;
    
    NSMutableArray *items = [self listItemsForListInSection:sourceIndexPath.section];
    if (items.count < destinationIndexPath.row) return;

    NSObject<MKUPlaceholderProtocol> *item = [self listItemAtIndexPath:sourceIndexPath];

    [items removeObjectAtIndex:sourceIndexPath.row];
    [items insertOrAddObject:item atIndex:destinationIndexPath.row];
    
    if ([self respondsToSelector:@selector(item:didMoveFromIndex:toIndex:inListOfType:)]) {
        [self item:item didMoveFromIndex:sourceIndexPath.row toIndex:destinationIndexPath.row inListOfType:sourceIndexPath.section];
    }
}

#pragma mark - transitions

- (void)viewController:(UIViewController *)viewController didReturnWithResultType:(VC_TRANSITION_RESULT_TYPE)resultType object:(id)object {
    if (resultType == VC_TRANSITION_RESULT_TYPE_OK) {
        
        NSUInteger section = self.selectedIndexPath.section;
        NSUInteger type = [self listTypeForListInSection:section];
        Class addClass = [self itemsClassInListOfType:type];
        BOOL canUpdate = [object isKindOfClass:addClass];
        
        if (canUpdate)
            [self addItem:object toListOfType:type];
        
        [self didUpdate:canUpdate item:object atIndexPath:self.selectedIndexPath];
        [self resetSelectedSets];
        [self setSelectedIndexPath:nil];
        [self reloadDataAnimated:NO];
        [self.transitionVCDelegate handleDismissDestinationViewController:viewController];
    }
}

- (void)handleDismissDestinationViewController:(UIViewController *)VC {
    [VC.navigationController popViewControllerAnimated:YES];
}

#pragma mark - list

- (NSUInteger)numberOfRowsInListSection:(NSUInteger)section {
    NSUInteger count = [self listItemsForListInSection:section].count;
    NSUInteger type = [self listTypeForListInSection:section];

    return [self canAddItemToListOfType:type] && self.isEditing ? count + 1 : count;
}

- (CGFloat)heightForNonEditingListRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (__kindof MKUBaseTableViewCell *)cellForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    return [self defaultTitleSubtitleCellForListItem:item atIndexPath:indexPath];
}

- (void)didSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedActionHandler(0) == MKU_LIST_ITEM_SELECTED_ACTION_TRANSITION_TO_DETAIL)
        [self presentTransitioningViewControllerWithItem:item atIndexPath:indexPath];
}

- (void)handleDidSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    BOOL selected = [self isSelectedRowAtIndexPath:indexPath];
    NSUInteger section = indexPath.section;

    if (self.selectedActionHandler(section) == MKU_LIST_ITEM_SELECTED_ACTION_TRANSITION_TO_DETAIL) {
        [self transitioningViewControllerForItem:item atIndexPath:indexPath completion:^(UIViewController *VC) {
            if (VC)
                [self handleTransitionForViewController:VC item:item atIndexPath:indexPath];
            else {
                [self dispatchUpdateDelegateToSetSelected:!selected item:item];
            }
        }];
    }
    else if (self.selectedActionHandler(section) == MKU_LIST_ITEM_SELECTED_ACTION_SELECT ||
             self.selectedActionHandler(section) == MKU_LIST_ITEM_SELECTED_ACTION_SHOW_DETAIL) {
        if (selected) {
            [self setDeselectedObject:item reload:NO];
        }
        else {
            [self setSelectedObject:item reload:NO];
            [self didSelectListItem:item atIndexPath:indexPath];
        }
        
        [self dispatchUpdateDelegateToSetSelected:!selected item:item];
        [self reloadDataAnimated:NO];

        if (self.selectedActionHandler(section) == MKU_LIST_ITEM_SELECTED_ACTION_SELECT &&
            !self.tableView.allowsMultipleSelection)
            [self dispathTransitionDelegateToReturnWithObject:[self returnedInSelectObject]];
    }
    else {
        [self setSelectedObject:item reload:NO];
        [self didSelectListItem:item atIndexPath:indexPath];
        [self dispatchUpdateDelegateToSetSelected:!selected item:item];
        [self reloadDataAnimated:NO];
    }
}

- (NSMutableArray<NSObject<MKUPlaceholderProtocol> *> *)listItemsForListInSection:(NSUInteger)section {
    return [self listItemsForListOfType:[self listTypeForListInSection:section]];
}

- (NSMutableArray<NSObject<MKUPlaceholderProtocol> *> *)listItemsForListOfType:(NSUInteger)type {
    return [self.object.UpdatedObject arrayForSectionType:type];
}

- (NSUInteger)listTypeForListInSection:(NSUInteger)section {
    return section;
}

- (BOOL)addItem:(NSObject<MKUPlaceholderProtocol> *)item toListOfType:(NSUInteger)type {
    if (!item) return NO;
    return [self addItems:@[item] toListOfType:type].count == 0;
}

- (void)deleteItem:(NSObject<MKUPlaceholderProtocol> *)item fromListOfType:(NSUInteger)type {
    if (!item) return;
    [self deleteItems:@[item] fromListOfType:type];
}

- (NSArray *)addItems:(NSArray<NSObject<MKUPlaceholderProtocol> *> *)items toListOfType:(NSUInteger)type {
    NSArray *existing = [[self listItemsForListOfType:type] addOrReplaceUniqueObjectsFromArray:items];
    
    [self resetSelectedSets];
    MIndexPathArr *addIndexPaths = [[NSMutableArray alloc] init];
    MIndexPathArr *replaceIndexPaths = [[NSMutableArray alloc] init];
    
    for (NSObject<MKUPlaceholderProtocol> *item in items) {
        NSIndexPath *path = [self indexPathForItem:item];
        if (path) {
            if ([existing containsObject:item])
                [replaceIndexPaths addObject:path];
            else
                [addIndexPaths addObject:path];
        }
    }
    
    [self insertRowsAtIndexPaths:addIndexPaths];
    [self reloadIndexPaths:replaceIndexPaths];
    [self didFinishUpdatesInListOfType:type];
    
    return existing;
}

- (void)deleteItems:(NSArray<NSObject<MKUPlaceholderProtocol> *> *)items fromListOfType:(NSUInteger)type {
    MIndexPathArr *indexPaths = [[NSMutableArray alloc] init];
    
    for (NSObject<MKUPlaceholderProtocol> *item in items) {
        NSIndexPath *path = [self indexPathForItem:item];
        if (path)
            [indexPaths addObject:path];
    }
    
    [[self listItemsForListOfType:type] removeObjectsInArray:items];
    [self resetSelectedSets];
    [self removeRowsAtIndexPaths:indexPaths];
    [self didFinishUpdatesInListOfType:type];
}

- (void)deleteAllItemsFromListOfType:(NSUInteger)type {
    [[self listItemsForListOfType:type] removeAllObjects];
    [self reloadDataAnimated:NO];
    [self didFinishUpdatesInListOfType:type];
}

- (void)setItems:(NSArray<NSObject<MKUPlaceholderProtocol> *> *)items forListOfType:(NSUInteger)type {
    [[self listItemsForListOfType:type] removeAllObjects];
    [[self listItemsForListOfType:type] addUniqueObjectsFromArray:items];
    
    NSCache *selectedSets = self.selectedSets;
    [self resetSelectedSets];
    [self setSelectedSets:selectedSets];
    [self reloadDataAnimated:NO];
    [self didFinishUpdatesInListOfType:type];
}

- (void)didFinishUpdatesInListOfType:(NSUInteger)section {
    if ([self.updateDelegate respondsToSelector:@selector(itemsListVC:didUpdateItems:inSection:)]) {
        [self.updateDelegate itemsListVC:self didUpdateItems:[self listItemsForListInSection:section] inSection:section];
    }
}

- (void)dispatchUpdateDelegateToRefreshItem:(__kindof NSObject<NSCopying> *)item {
    if ([self.updateDelegate respondsToSelector:@selector(itemsListVC:didUpdateItem:atIndexPath:)]) {
        [self.updateDelegate itemsListVC:self didUpdateItem:item atIndexPath:[self indexPathForItem:item]];
    }
}

- (void)dispatchUpdateDelegateToSetSelected:(BOOL)selected item:(__kindof NSObject<NSCopying> *)item {
    if ([self.updateDelegate respondsToSelector:@selector(itemsListVC:didSetSelected:item:atIndexPath:)]) {
        [self.updateDelegate itemsListVC:self didSetSelected:selected item:item atIndexPath:[self indexPathForItem:item]];
    }
}

- (BOOL)isAddIndexPath:(NSIndexPath *)indexPath {
    if ([self typeForSection:indexPath.section] != MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST)
        return NO;
    
    NSUInteger count = [self listItemsForListInSection:indexPath.section].count;
    return count <= indexPath.row;
}

- (NSIndexPath *)indexPathForItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item {
    for (NSUInteger i=0; i<[self numberOfSectionsInTableView:self.tableView]; i++) {
        NSUInteger type = [self typeForSection:i];
        if (type != MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST) continue;
        
        NSArray *arr = [self listItemsForListInSection:i];
        if ([arr containsObject:item]) {
            return [NSIndexPath indexPathForRow:[arr indexOfObject:item] inSection:i];
        }
    }
    return nil;
}

- (BOOL)canAddItemToListOfType:(NSUInteger)type {
    return NO;
}

- (BOOL)canDeleteFromListOfType:(NSUInteger)type {
    return NO;
}

- (BOOL)canEditListsByDefault {
    return NO;
}

- (BOOL)canMoveItemsInListOfType:(NSUInteger)type {
    return NO;
}

- (void)item:(__kindof NSObject<MKUPlaceholderProtocol> *)item1 didMoveFromIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2 inListOfType:(NSUInteger)type {
}

- (NSString *)titleForAddCellInListOfType:(NSUInteger)type {
    return [Constants Add_New_Item_STR];
}

- (void)willDeleteItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item forRowAtIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(BOOL, NSError *))completion {
    if (completion) completion(YES, nil);
}

- (void)didAddItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)didDeleteItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)didFinishCommitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)willAddItemToListOfType:(NSUInteger)type withCompletion:(void (^)(__kindof NSObject<MKUPlaceholderProtocol> *))completion {
    
    NSObject<MKUPlaceholderProtocol> *item = [self newItemInListOfType:type];
    if (!item) {
        completion(nil);
        return;
    }
    completion(item);
}

- (BOOL)shouldAddItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item toListOfType:(NSUInteger)type{
    return NO;
}

- (__kindof NSObject<MKUPlaceholderProtocol> *)newItemInListOfType:(NSUInteger)type {
    return [[[self itemsClassInListOfType:type] alloc] init];
}

- (Class)itemsClassInListOfType:(NSUInteger)type {
    return nil;
}

- (void)transitioningViewControllerForItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath completion:(void (^)(UIViewController *))completion {
    [self createPresentingSelectionVCForItem:item atIndexPath:indexPath completion:completion];
}

- (NSString *)noItemAvailableTitleForListOfType:(NSUInteger)type {
    return nil;
}

- (BOOL)canSelectItemsInListOfType:(NSUInteger)type {
    return NO;
}

- (NSSet *)selectedSetsInListOfType:(NSUInteger)type {
    return [self.selectedSets objectForKey:@(type)];
}

- (BOOL)isSelectedRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger type = [self listTypeForListInSection:indexPath.section];
    if (![self canSelectItemsInListOfType:type]) return NO;
    NSObject <MKUPlaceholderProtocol> *object = [self listItemAtIndexPath:indexPath];
    NSSet *set = [self selectedSetsInListOfType:type];
    return [set containsObject:object];
}

- (void)setSelectedObject:(__kindof NSObject<MKUPlaceholderProtocol> *)obj {
    [self setSelectedObject:obj reload:YES];
}

- (void)setSelectedObject:(__kindof NSObject<MKUPlaceholderProtocol> *)obj reload:(BOOL)reload {
    if (!obj) return;
    
    NSIndexPath *indexPath = [self indexPathForItem:obj];
    NSUInteger type = [self listTypeForListInSection:indexPath.section];
    
    if (![self canSelectItemsInListOfType:type]) return;
    
    NSSet *set = [self selectedSetsInListOfType:type];
    NSMutableSet *selectedObjects = [[NSMutableSet alloc] initWithSet:set];
    
    if (!selectedObjects)
        selectedObjects = [[NSMutableSet alloc] init];
    if (!self.tableView.allowsMultipleSelection)
        [selectedObjects removeAllObjects];
    
    [selectedObjects addObject:obj];
    [self setSelectedObjectsWithSet:selectedObjects inListOfType:type reload:reload];
}

- (void)setDeselectedObject:(__kindof NSObject<MKUPlaceholderProtocol> *)obj {
    [self setDeselectedObject:obj reload:YES];
}

- (void)setDeselectedObject:(__kindof NSObject<MKUPlaceholderProtocol> *)obj reload:(BOOL)reload {
    if (!obj) return;
    
    NSIndexPath *indexPath = [self indexPathForItem:obj];
    NSUInteger type = [self listTypeForListInSection:indexPath.section];
    NSSet *set = [self selectedSetsInListOfType:type];
    NSMutableSet *selectedObjects = [[NSMutableSet alloc] initWithSet:set];

    [selectedObjects removeObject:obj];
    [self setSelectedObjectsWithSet:selectedObjects inListOfType:type reload:reload];
}

- (void)resetSelectedSets {
    self.selectedSets = [[NSCache alloc] init];
}

- (void)resetSelectedSetsInListOfType:(NSUInteger)type {
    [self.selectedSets setObject:[[NSSet alloc] init] forKey:@(type)];
}

- (void)setSelectedObjectsWithSet:(NSSet *)selectedObjects inListOfType:(NSUInteger)type {
    [self setSelectedObjectsWithSet:selectedObjects inListOfType:type reload:YES];
}

- (void)setSelectedObjectsWithSet:(NSSet *)selectedObjects inListOfType:(NSUInteger)type reload:(BOOL)reload {
    if (![self canSelectItemsInListOfType:type]) return;

    if (!selectedObjects)
        [self.selectedSets removeObjectForKey:@(type)];
    else
        [self.selectedSets setObject:selectedObjects forKey:@(type)];
    if (reload) [self reloadDataAnimated:NO];
}

- (void)didUpdate:(BOOL)update item:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
}

- (void)handleTransitionToViewController:(UIViewController *)VC sourceViewController:(UIViewController *)sourceVC didSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)itemsListVC:(MKUItemsListViewController *)VC didUpdateItems:(NSArray <__kindof NSObject<MKUPlaceholderProtocol> *> *)items inSection:(NSUInteger)section {
}

- (void)itemsListVC:(MKUItemsListViewController *)VC didUpdateItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
}

- (void)itemsListVC:(MKUItemsListViewController *)VC didSetSelected:(BOOL)selected item:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - dates

- (void)didHideDatePickerAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = indexPath.section;
    NSDate *date = self.dateCellInfoObjects[@(section)].date;
    [self.object.UpdatedObject setValue:date forSectionType:section];
    [self reloadSection:section];
}

- (BOOL)isEditableDateSection:(NSUInteger)section {
    return self.isEditable;
}

#pragma mark - protocols and actions

- (BOOL)isHeaderSection:(NSUInteger)section {
    return [self hasTitleForHeaderInSection:section];
}

- (MKUBaseTableViewCell *)singleCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MKUBaseTableViewCell blankCell];
}

- (CGFloat)heightForSingleCellRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

- (MKU_MUTABLE_OBJECT_FIELD_TYPE)typeForSection:(NSUInteger)section {
    return MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION;
}

- (BOOL)hasTypesForSection:(NSUInteger)section {
    return NO;
}

- (BOOL)hasValueForSection:(NSUInteger)section {
    return YES;
}

- (BOOL)canTransitionToPresentingSelectionVCInSection:(NSUInteger)section {
    return YES;
}

- (NSString *)titleForSection:(NSUInteger)section {
    return [self.object.UpdatedObject.class titleForSectionType:section];
}

- (NSString *)subtitleForSection:(NSUInteger)section {
    return nil;
}

- (NSString *)valueForSection:(NSUInteger)section {
    return [self.object.UpdatedObject stringValueForSectionType:section];
}

- (NSString *)subvalueForSection:(NSUInteger)section {
    return nil;
}

- (NSAttributedString *)attributedValueForSection:(NSUInteger)section {
    return nil;
}

- (NSAttributedString *)attributedSubvalueForSection:(NSUInteger)section {
    return nil;
}

- (NSString *)labelDelimiterForSection:(NSUInteger)section {
    return kColonEmptyString;
}

- (NSString *)sublabelDelimiterForSection:(NSUInteger)section {
    return kColonEmptyString;
}

- (BOOL)boolValueForSection:(NSUInteger)section {
    return [self.object.UpdatedObject boolValueForSectionType:section];
}

- (NSUInteger)rowForFieldAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    NSArray<NSNumber *> *nums = [[self.object.UpdatedObject class] objectTypesForSectionType:section];
    return [nums nullableObjectAtIndex:index].integerValue;
}

- (BOOL)isHiddenFieldAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    return NO;
}

- (MKUStepperValueObject *)stepperValuesForSection:(NSUInteger)section {
    return [MKUStepperValueObject objectWithTitle:[self titleForSection:section] value:0 start:0 end:MAX_QUANTITY];
}

- (void)switchBoolValueAtIndexPath:(NSIndexPath *)indexPath {
    [self.object.UpdatedObject switchBoolValueForSectionType:indexPath.section];
    [self didSwitchBoolValueAtIndexPath:indexPath];
}

- (void)didSwitchBoolValueAtIndexPath:(NSIndexPath *)indexPath {
    [self reloadIndexPaths:@[indexPath]];
}

- (void)handleSelectionAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    
    if ([self canTransitionToPresentingSelectionVCInSection:section] && [self hasTypesForSection:section]) {
        [self createPresentingSelectionVCAtIndexPath:indexPath completion:^(UIViewController *VC) {
            if (VC)
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentSelectionVC:VC atIndexPath:indexPath];
                });
        }];
    }
    else {
        [self didSelectSection:section];
    }
}

- (id)returnedInSelectObject {
    return [self selectedSets];
}

- (id)returnedInCloseObject {
    return self.object.UpdatedObject;
}

- (void)createPresentingSelectionVCAtIndexPath:(NSIndexPath *)indexPath completion:(void (^)(UIViewController *))completion {
    if (completion) completion(nil);
}

- (void)createPresentingSelectionVCForItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath completion:(void (^)(UIViewController *))completion {
    if (completion) completion(nil);
}

- (void)presentSelectionVC:(UIViewController *)VC atIndexPath:(NSIndexPath *)indexPath {
    if ([self.transitionMutableVCDelegate respondsToSelector:@selector(shouldHandlePresentSelectionVC:atIndexPath:)]) {
        if ([self.transitionMutableVCDelegate shouldHandlePresentSelectionVC:VC atIndexPath:indexPath] &&
            [self.transitionMutableVCDelegate respondsToSelector:@selector(presentSelectionVC:atIndexPath:)]) {
            [self.transitionMutableVCDelegate presentSelectionVC:VC atIndexPath:indexPath];
        }
        else {
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    else {
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (NSString *)placeholderTitleForSection:(NSUInteger)section {
    return @"";
}

#pragma mark - save data

- (void)saveObjectWithCompletion:(void (^)(NSNumber *, NSError *))completion {
    completion(nil, nil);
}

- (void)updateObjectWithCompletion:(void (^)(BOOL, NSError *))completion {
    completion(NO, nil);
}

- (BOOL)canPerformSaveObject {
    return ![self.object.OriginalObject isEqual:self.object.UpdatedObject];
}

- (void)handleAbortSaveObject {
}

- (void)dispatchDelegateForSaveDone {
    [self defaultDispatchDelegateForSaveDone];
}

- (BOOL)performDefaultSavePressedAction {
    return NO;
}

- (void)prepareDataForUpdate {
    [self.dateCellInfoObjects enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, MKUDateViewInfoObject * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.object.UpdatedObject setValue:obj.date forSectionType:key.integerValue];
    }];
}

- (void)didResetUpdateObject:(__kindof MKUFieldModel *)object {
    [self updateDatesWithUpdateObject:object];
    [self registerKVO];
    [self reloadDataAnimated:NO];
}

- (void)didSetObject:(__kindof MKUUpdateObject *)object {
    [self resetSelectedSets];
}

- (void)updateDatesWithUpdateObject:(__kindof MKUFieldModel *)object {
    if (![object isKindOfClass:[MKUFieldModel class]]) return;
    
    [self.dateCellInfoObjects enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, MKUDateViewInfoObject * _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSUInteger section = key.integerValue;
        NSDate *date = [object dateValueForSectionType:section];
        
        if (date) obj.date = date;
        else [obj reset];
        
        if (![self canEditSection:section]) obj.isEditable = NO;
        else if (self.isEditable) obj.isEditable = YES;
    }];
}

- (void)setDateCellInfoObjects:(DateSectionInfoObjctDict *)dateCellInfoObjects {
    [super setDateCellInfoObjects:dateCellInfoObjects];
    [self updateDatesWithUpdateObject:self.object.UpdatedObject];
}

- (void)loadSelectionVCWithTitle:(NSString *)title allowsMultipleSelection:(BOOL)allowsMultipleSelection items:(NSArray *)items selectedObjectHandler:(EvaluateSelectedObjectHandler)selectedObjectHandler completion:(void (^)(UIViewController *))completion {
    
    Class cls = allowsMultipleSelection ? [MKUSearchResultsViewController class] : [MKUSearchResultsTransitionViewController class];
    [cls loadSelectionVCWithTitle:title allowsMultipleSelection:allowsMultipleSelection items:items transitionDelegate:self selectedObjectHandler:selectedObjectHandler completion:completion];
}

- (BOOL)canUpdate {
    return NO;
}

- (void)didFinishUpdateWithResultID:(NSNumber *)ID {
}

+ (Class)classForObject {
    return [MKUUpdateObject class];
}

- (CGFloat)heightForStandardSelectionCell {
    return [Constants ExtendedRowHeight];
}

- (MKU_TEXT_TYPE)textTypeForFieldAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.object.UpdatedObject class] textTypeForObjectType:indexPath.row];
}

- (UIImage *)buttonImageForFieldAtIndexPath:(NSIndexPath *)indexPath {
    MKU_TEXT_TYPE type = [self textTypeForFieldAtIndexPath:indexPath];
    switch (type) {
        case MKU_TEXT_TYPE_INT:
        case MKU_TEXT_TYPE_FLOAT:
            return [UIImage systemImageNamed:[MKUAssets Plusminus_square_Name]];
        default:
            return nil;
    }
}

- (SEL)actionForFieldButtonAtIndexPath:(NSIndexPath *)indexPath {
    MKU_TEXT_TYPE type = [self textTypeForFieldAtIndexPath:indexPath];
    switch (type) {
        case MKU_TEXT_TYPE_INT:
        case MKU_TEXT_TYPE_FLOAT:
            return @selector(plusMinusPressed:);
        default:
            return nil;
    }
}

- (void)plusMinusPressed:(UIButton *)sender {
    NSIndexPath *indexPath = sender.indexPath;
    if (!indexPath) return;
    
    NSNumber *numb = [[self valueForSection:indexPath.section] plusMinus];
    if (numb) {
        [self.object.UpdatedObject setValue:numb forObjectType:indexPath.row];
        [self reloadDataAnimated:NO];
    }
}

- (CGFloat)textWidthForFieldAtIndexPath:(NSIndexPath *)indexPath {
    MKU_TEXT_TYPE type = [self textTypeForFieldAtIndexPath:indexPath];
    switch (type) {
        case MKU_TEXT_TYPE_INT:
        case MKU_TEXT_TYPE_FLOAT:
        case MKU_TEXT_TYPE_INT_POSITIVE:
        case MKU_TEXT_TYPE_FLOAT_POSITIVE:
            return [Constants NumericInputTextFieldWidth];
        default:
            return [Constants InputTextFieldWidth];
    }
}

- (BOOL)hasAccessoryForSection:(NSUInteger)section {
    MKU_MUTABLE_OBJECT_FIELD_TYPE type = [self typeForSection:section];
    return
    (type != MKU_MUTABLE_OBJECT_FIELD_TYPE_LABEL) &&
    ([self canSelectSection:section] || [self hasTypesForSection:section]) &&
    [self canTransitionToPresentingSelectionVCInSection:section];
}

- (void)setTextForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell {
    [self defaultSetTextForRowAtIndexPath:indexPath inCell:cell];
}

- (void)setStyleForRowAtIndexPath:(NSIndexPath *)indexPath inCell:(MKUBaseTableViewCell *)cell {
    [self defaultSetStyleForRowAtIndexPath:indexPath inCell:cell];
}

- (UITableViewCellAccessoryType)accessoryTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self defaultAccessoryTypeForRowAtIndexPath:indexPath];
}

- (UITableViewCellAccessoryType)accessoryTypeForSelectedRowForListOfType:(NSUInteger)type {
    return UITableViewCellAccessoryCheckmark;
}

- (UITableViewCellAccessoryType)accessoryTypeForDeselectedRowForListOfType:(NSUInteger)type {
    return UITableViewCellAccessoryNone;
}

- (UITableViewCellAccessoryType)accessoryTypeForSingleDeselectedRowForListOfType:(NSUInteger)type {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (UITableViewCellSelectionStyle)selectionStyleForListOfType:(NSUInteger)type {
    return [self defaultSelectionStyleForListOfType:type];
}

- (BOOL)isEditableSectionType:(NSInteger)type {
    return [self.object isEditableSectionType:type];
}

- (BOOL)canSelectSection:(NSUInteger)section {
    return YES;
}

- (SEL)actionForSection:(NSUInteger)section {
    return nil;
}

- (MKU_VIEW_POSITION)checkboxButtonPositionForSection:(NSUInteger)section {
    return MKU_VIEW_POSITION_NONE;
}

- (CGFloat)checkboxButtonHeightForSection:(NSUInteger)section {
    return 48.0;
}

- (CGFloat)checkboxButtonRowHeightForSection:(NSUInteger)section {
    return [self checkboxButtonHeightForSection:section] + 2*[Constants VerticalSpacing];
}

- (CGFloat)checkboxButtonWidthForSection:(NSUInteger)section {
    return (self.view.frame.size.width - 3*[Constants HorizontalSpacing]) / 2.0;
}

- (BOOL)isEmailOrPhoneSectionType:(NSUInteger)section {
    return [self.object.UpdatedObject.class isEmailSectionType:section] ||
    [self.object.UpdatedObject.class isPhoneSectionType:section];
}

- (void)didSelectSection:(NSUInteger)section {
    
    NSString *value = [self.object.UpdatedObject stringValueForSectionType:section];
    
    if ([self.object.UpdatedObject.class isEmailSectionType:section]) {
        [MKUMessageComposerController emailToAddress:value];
    }
    else if ([self.object.UpdatedObject.class isPhoneSectionType:section]) {
        [Constants callPhoneNumber:value];
    }
}

- (BOOL)canEditSection:(NSUInteger)section {
    if (!self.isEditable)
        return NO;
    return [self isEditableSectionType:section];
}

- (BOOL)hideSection:(NSUInteger)section {
    if ([self isDateSection:section] || [self canEditSection:section] || [self typeForSection:section] == MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST) return NO;
    return !self.isEditable && [self hasNoValueOrAattributedValueInSection:section] && ![self hasTypesForSection:section];
}

- (CGFloat)heightForTitle:(NSString *)title {
    if (title.length == 0) return 0.0;
    
    CGFloat height = [title rectForWidth:self.view.frame.size.width font:nil].size.height + [Constants TableCellLineHeight];
    return height;
}

- (CGFloat)adjustHeight:(CGFloat)height {
    return MAX(height, [self heightForStandardSelectionCell]);
}

- (BOOL)hasNoValueOrAattributedValueInSection:(NSUInteger)section {
    return [self valueForSection:section].length == 0 && ![self attributedValueForSection:section] &&
           [self subvalueForSection:section].length == 0 && ![self attributedSubvalueForSection:section];
}

- (BOOL)shouldHideSelectionSection:(NSUInteger)section {
    return
    [self hasNoValueOrAattributedValueInSection:section] &&
    ([self placeholderTitleForSection:section].length == 0 ||//Is not SELECTION
     ![self hasTypesForSection:section]);//Is SELECTION but has no types to show
}

- (BOOL)shouldHideCommentSection:(NSUInteger)section {
    return ![self isEditableSectionType:section] && [self valueForSection:section].length == 0;
}

- (void)object:(MKUFieldModel *)obj didUpdateObjectType:(NSInteger)type {
}

- (BOOL)showSaveSuccessAlert {
    return YES;
}

- (MKULabelAttributes *)labelAttributesForSection:(NSInteger)section {
    return [MKULabelAttributes
            attributesWithTitle:[self titleForSection:section]
            subtitle:[self subtitleForSection:section]
            value:[self valueForSection:section]
            subvalue:[self subvalueForSection:section]
            placeholder:[self placeholderTitleForSection:section]
            attrValue:[self attributedValueForSection:section]
            attrSubvalue:[self attributedSubvalueForSection:section]
            labelDelimiter:[self labelDelimiterForSection:section]
            sublabelDelimiter:[self sublabelDelimiterForSection:section]];
}

#pragma mark - default cells

- (MKUBaseTableViewCell *)uneditableFieldCellForSection:(NSUInteger)section withStyle:(UITableViewCellStyle)style {
    
    MKUBaseTableViewCell *cell = [[MKUBaseTableViewCell alloc] initWithStyle:style];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.text = [self titleForSection:section];
    cell.detailTextLabel.text = [self valueForSection:section];
    
    return cell;
}

- (MKURadioButtonTableViewCell *)radioButtonCellInSection:(NSUInteger)section enabled:(BOOL)enabled singleLine:(BOOL)singleLine {
    MKURadioButtonTableViewCell *cell = [[MKURadioButtonTableViewCell alloc] initWithInsets:UIEdgeInsetsMake(0.0, [Constants HorizontalSpacing], 0.0, [Constants HorizontalSpacing])];
    cell.view.titleLabel.font = [AppTheme mediumBoldLabelFont];
    cell.view.titleLabel.text = [self titleForSection:section];
    cell.view.on = [self boolValueForSection:section];
    cell.view.enabled = enabled;
    cell.view.userInteractionEnabled = NO;
    if (!singleLine) [cell.view setMultiline];
    
    return cell;
}

- (MKURadioButtonTableViewCell *)radioButtonCellForRowAtIndexPath:(NSIndexPath *)indexPath title:(NSString *)title enabled:(BOOL)enabled on:(BOOL)on singleLine:(BOOL)singleLine {
    MKURadioButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[MKURadioButtonTableViewCell identifier]];
    if (!cell) {
        cell = [[MKURadioButtonTableViewCell alloc] initWithInsets:UIEdgeInsetsMake(0.0, 2*[Constants HorizontalSpacing], 0.0, 2*[Constants HorizontalSpacing])];
        cell.view.userInteractionEnabled = NO;
        if (!singleLine) [cell.view setMultiline];
    }
    cell.view.titleLabel.text = title;
    cell.view.on = on;
    cell.view.enabled = enabled;
    
    return cell;
}

- (MKUSingleViewTableViewCell<MKUCheckboxButtonView *> *)checkboxButtonCellInSection:(NSUInteger)section enabled:(BOOL)enabled singleLine:(BOOL)singleLine {
    
    MKUSingleViewTableViewCell<MKUCheckboxButtonView *> *cell = [[MKUSingleViewTableViewCell alloc] initWithInsets:[NSObject insets:[Constants HorizontalSpacing]] viewCreationHandler:^UIView *{
        
        CGSize size = CGSizeMake([self checkboxButtonWidthForSection:section], [self checkboxButtonHeightForSection:section]);
        MKUCheckboxButtonView *view = [[MKUCheckboxButtonView alloc] initWithPosition:[self checkboxButtonPositionForSection:section] buttonSize:size];
        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:[self rowForFieldAtIndex:MKU_COLUMN_TYPE_LEFT inSection:section] inSection:section];
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:[self rowForFieldAtIndex:MKU_COLUMN_TYPE_RIGHT inSection:section] inSection:section];
        NSString *value = 0 < [self valueForSection:section].length ? [self valueForSection:section] : [self placeholderTitleForSection:section];
        
        view.checkboxView.titleLabel.text = [self titleForSection:section];
        view.checkboxView.on = [self boolValueForSection:section];
        view.checkboxView.enabled = enabled;
        view.checkboxView.userInteractionEnabled = NO;
        [view.checkboxView setIndexPath:firstPath];
        if (!singleLine) [view.checkboxView setMultiline];
        
        view.accessoryView.hidden = [self isHiddenFieldAtIndex:MKU_COLUMN_TYPE_RIGHT inSection:section];
        [view.accessoryView setIndexPath:lastPath];
        [view.accessoryView setTitle:value forState:UIControlStateNormal];
        [view.accessoryView addTarget:self action:[self actionForSection:section] forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }];
    return cell;
}

#pragma mark KVO

+ (NSSet<NSString *> *)KVOKeys {
    return nil;
}

- (void)updateObject:(__kindof NSObject<MKUFieldModelProtocol> *)object didUpdateKey:(NSString *)key {
}

- (NSObject *)KVOObject {
    return self.object.UpdatedObject;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[self.object.UpdatedObject class]]) {
        [self updateObject:object didUpdateKey:keyPath];
    }
}

- (void)dealloc {
    [self unregisterKVO];
}

@end

#pragma mark single type

@implementation MKUMutableObjectTableViewControllerSingle

- (instancetype)initWithMKUType:(MKU_MUTABLE_OBJECT_FIELD_TYPE)type {
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (MKU_MUTABLE_OBJECT_FIELD_TYPE)typeForSection:(NSUInteger)section {
    return self.type;
}

@end
