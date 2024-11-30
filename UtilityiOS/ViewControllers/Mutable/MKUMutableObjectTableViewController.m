//
//  MKUMutableObjectTableViewController.m
//  KaChing
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Prometheus Software. All rights reserved.
//

#import "MKUMutableObjectTableViewController.h"
#import "MKUTableViewController+ItemsListTransition.h"
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

@end

@implementation MKUMutableObjectTableViewController

- (void)initBase {
    self.isEditable = YES;
    
    [super initBase];
    [self setUseDarkTheme:NO];
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
            return [Constants DefaultRowHeight];
            
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
            
            MKUInputTableViewCell *cell = [[MKUInputTableViewCell alloc] initWithTextType:[self textTypeForFieldAtIndexPath:indexPath] buttonImage:[self buttonImageForFieldAtIndexPath:indexPath] fieldWidth:[self textWidthForFieldAtIndexPath:indexPath] horizontalMargin:[Constants TableCellContentHorizontalMargin]];
            
            cell.textField.controller.delegate = self.object.UpdatedObject;
            cell.textField.controller.maxLenght = 64;
            cell.textField.text = [self valueForSection:section];
            cell.label.text = [self titleForSection:section];
            [cell setIndexPath:[NSIndexPath indexPathForRow:[self rowForFieldAtIndex:MKU_COLUMN_TYPE_LEFT inSection:section] inSection:section]];
            [cell setTarget:self action:[self actionForFieldButtonAtIndexPath:indexPath]];
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
            if ([self isAddIndexPath:indexPath] && [self canAddItemToListOfType:section]) {
                MKUEditingTableViewCell *cell = [[MKUEditingTableViewCell alloc] init];
                cell.textLabel.text = [self titleForAddCellInListOfType:section];
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
            NSObject<MKUPlaceholderProtocol> *item = [self listItemAtIndexPath:indexPath];
            [self didSelectListItem:item atIndexPath:indexPath];
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
    return [self isAddIndexPath:indexPath] && [self canAddItemToListOfType:indexPath.section] ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = indexPath.section;
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self willAddItemToListOfType:section withCompletion:^(__kindof NSObject<MKUPlaceholderProtocol> *item) {
            if (!item || ![self shouldAddItem:item toListOfType:section]) {
                [self didSelectListItem:item atIndexPath:indexPath];
            }
            else {
                [self addItem:item toListSection:section];
            }
            [self didFinishCommitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSObject<MKUPlaceholderProtocol> *item = [self listItemAtIndexPath:indexPath];
        [self willDeleteItem:item forRowAtIndexPath:indexPath withCompletion:^(BOOL success, NSError *error) {
            if (success && !error) {
                [self deleteItem:item fromListSection:section];
            }
            [self didFinishCommitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }];
    }
}

#pragma mark - list

- (NSUInteger)numberOfRowsInListSection:(NSUInteger)section {
    NSUInteger count = [self listItemsForListOfType:section].count;
    return [self canAddItemToListOfType:section] ? count + 1 : count;
}

- (CGFloat)heightForNonEditingListRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (__kindof MKUBaseTableViewCell *)cellForListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    return [self defaultTitleSubtitleCellForListItem:item atIndexPath:indexPath];
}

- (void)didSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath {
    [self presentTransitioningViewControllerWithItem:item atIndexPath:indexPath];
}

- (NSMutableArray<NSObject<MKUPlaceholderProtocol> *> *)listItemsForListOfType:(NSUInteger)type {
    return [self.object.UpdatedObject arrayForSectionType:type];
}

- (void)addItem:(NSObject<MKUPlaceholderProtocol> *)item toListSection:(NSUInteger)section {
    [[self listItemsForListOfType:section] addObject:item];
    [self reloadSection:section];
}

- (void)deleteItem:(NSObject<MKUPlaceholderProtocol> *)item fromListSection:(NSUInteger)section {
    [[self listItemsForListOfType:section] removeObject:item];
    [self reloadSection:section];
}

- (BOOL)isAddIndexPath:(NSIndexPath *)indexPath {
    if ([self typeForSection:indexPath.section] != MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST)
        return NO;
    
    NSUInteger count = [self listItemsForListOfType:indexPath.section].count;
    return count <= indexPath.row;
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

- (NSString *)titleForAddCellInListOfType:(NSUInteger)type {
    return [Constants Add_New_Item_STR];
}

- (void)willDeleteItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item forRowAtIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(BOOL, NSError *))completion {
    if (completion) completion(YES, nil);
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

- (void)item:(__kindof NSObject<MKUPlaceholderProtocol> *)item1 didMoveFromIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2 inListOfType:(NSUInteger)type {
}

- (void)transitioningViewControllerForItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath completion:(void (^)(UIViewController *))completion {
    [self createPresentingSelectionVCForItem:item atIndexPath:indexPath completion:completion];
}

- (NSString *)noItemAvailableTitleForListOfType:(NSUInteger)type {
    return nil;
}

- (BOOL)isSelectedRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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
    return [[self.object.UpdatedObject class] objectTypesForSectionType:section].firstObject.integerValue;
}

- (BOOL)isHiddenFieldAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    return NO;
}

- (MKUStepperValueObject *)stepperValuesForSection:(NSUInteger)section {
    return nil;
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

- (void)loadSelectionVCWithTitle:(NSString *)title allowsMultipleSelection:(BOOL)allowsMultipleSelection items:(NSArray *)items selectedObjectHandler:(EvaluateObjectHandler)selectedObjectHandler completion:(void (^)(UIViewController *))completion {
    
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
    return MKU_TEXT_TYPE_STRING;
}

- (UIImage *)buttonImageForFieldAtIndexPath:(NSIndexPath *)indexPath {
    MKU_TEXT_TYPE type = [self textTypeForFieldAtIndexPath:indexPath];
    switch (type) {
        case MKU_TEXT_TYPE_INT:
        case MKU_TEXT_TYPE_FLOAT:
            return [UIImage systemImageNamed:@"plusminus"];
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
    if ([self isDateSection:section] || [self canEditSection:section]) return NO;
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

- (instancetype)initWithType:(MKU_MUTABLE_OBJECT_FIELD_TYPE)type {
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
