//
//  MKUMutableObjectTableViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-23.
//  Copyright © 2024 Maryam Karampour. All rights reserved.
//

#import "MKUTableViewController.h"
#import "MKUGenericTableViewControllerProtocols.h"
#import "UIViewController+MutableObjectVC.h"
#import "MKURadioButtonTableViewCell.h"
#import "MKUCheckboxAccessoryView.h"
#import "MKUStepperFieldView.h"
#import "NSObject+KVO.h"

typedef NS_ENUM(NSInteger, MKU_MUTABLE_OBJECT_FIELD_TYPE) {
    /** @brief Use for date cells */
    MKU_MUTABLE_OBJECT_FIELD_TYPE_BLANK,
    /** @brief Same as SELECTION without the ability to select or indicator */
    MKU_MUTABLE_OBJECT_FIELD_TYPE_LABEL,
    MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION,
    MKU_MUTABLE_OBJECT_FIELD_TYPE_FIELD,
    MKU_MUTABLE_OBJECT_FIELD_TYPE_TITLE_FIELD,
    MKU_MUTABLE_OBJECT_FIELD_TYPE_VERTICAL_FIELD,
    MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX,
    MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_BUTTON,
    MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_COMMENT,
    MKU_MUTABLE_OBJECT_FIELD_TYPE_SINGLE_CELL,
    MKU_MUTABLE_OBJECT_FIELD_TYPE_COMMENT,
    MKU_MUTABLE_OBJECT_FIELD_TYPE_STEPPER_FIELD,
    /** @brief Implement and return the array using listItemsForListOfType:
     or declare the property for the list with protocol MKUArrayPropertyProtocol and include the property name in propertyEnumDictionary
     and retrun the corresponding section in sectionEnumDictionary. */
    MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST
};

@protocol MKUMutableObjectTableVCProtocol <MKUMutableObjectVCProtocol>

@required
- (BOOL)isHeaderSection:(NSUInteger)section;
- (MKUBaseTableViewCell *)singleCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (MKU_MUTABLE_OBJECT_FIELD_TYPE)typeForSection:(NSUInteger)section;

/** @brief Implement in case of MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION.
 If this returns NO, the accessory indicator will not show, it can be used as a simple subtitle cell.
 One of valueForSection: or subvalueForSection: should be non-empty to add as label.
 Return nil for placeholderTitleForSection: in case of label, and not nil in case of types. */
- (BOOL)hasTypesForSection:(NSUInteger)section;
- (BOOL)hasValueForSection:(NSUInteger)section;
/** @brief Return if you want the disclosure indicator be present.
 Default checks if canSelectSection or hasTypesForSection and canTransitionToPresentingSelectionVCInSection
 return YES. */
- (BOOL)hasAccessoryForSection:(NSUInteger)section;
/** @brief Default only handles email and phone calls. */
- (void)didSelectSection:(NSUInteger)section;
- (BOOL)canEditSection:(NSUInteger)section;

/** @brief Return YES if you want to hide this section completely regardlss of other conditions.
 Default hides a section with no value or subvalue when isEditable is NO.
 Used for field and comment sections and headers. */
- (BOOL)hideSection:(NSUInteger)section;
/** @brief Default hides a section with no value or subvalue or attributes or placeholder. */
- (BOOL)shouldHideSelectionSection:(NSUInteger)section;

/** @brief By default it returns YES. Return NO if you want to disable transitions, the accessory indicator wiil not show. The main use case is
 when isEditable is NO and the selection VC is a list. */
- (BOOL)canTransitionToPresentingSelectionVCInSection:(NSUInteger)section;
- (NSString *)titleForSection:(NSUInteger)section;
- (NSString *)subtitleForSection:(NSUInteger)section;

/** @brief Implement in case of MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION */
- (NSString *)placeholderTitleForSection:(NSUInteger)section;
- (NSString *)valueForSection:(NSUInteger)section;

/** @brief If placeholder or title or, subvalue and value are provided, this will be ignored */
- (NSAttributedString *)attributedValueForSection:(NSUInteger)section;

/** @brief If placeholder or subtitle or, subvalue and value are provided, this will be ignored */
- (NSAttributedString *)attributedSubvalueForSection:(NSUInteger)section;

/** @brief Used in MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION and MKU_MUTABLE_OBJECT_FIELD_TYPE_LABEL. Default is kColonEmptyString */
- (NSString *)labelDelimiterForSection:(NSUInteger)section;
- (NSString *)sublabelDelimiterForSection:(NSUInteger)section;

/** @brief Implement in case of MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION */
- (NSString *)subvalueForSection:(NSUInteger)section;
- (BOOL)boolValueForSection:(NSUInteger)section;
- (NSUInteger)rowForFieldAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (BOOL)isHiddenFieldAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (MKUStepperValueObject *)stepperValuesForSection:(NSUInteger)section;

/** @brief If the section contains a button such as in MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_BUTTON the action will be performed. */
- (SEL)actionForSection:(NSUInteger)section;
/** @brief Used in MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_BUTTON. Default is  MKU_VIEW_POSITION_NONE constrained to sides. */
- (MKU_VIEW_POSITION)checkboxButtonPositionForSection:(NSUInteger)section;
/** @brief Used in MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_BUTTON. Default is  48.0. */
- (CGFloat)checkboxButtonHeightForSection:(NSUInteger)section;
/** @brief Used in MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_BUTTON. Default is  [self checkboxButtonHeightForSection:section] + 2*VerticalMargin. */
- (CGFloat)checkboxButtonRowHeightForSection:(NSUInteger)section;
/** @brief Used in MKU_MUTABLE_OBJECT_FIELD_TYPE_CHECKBOX_BUTTON. Default is  (self.view.frame.size.width - 3*HorizontalMargin) / 2.0. */
- (CGFloat)checkboxButtonWidthForSection:(NSUInteger)section;
- (void)switchBoolValueAtIndexPath:(NSIndexPath *)indexPath;
/** @brief Default is isEditableSectionType of the object. */
- (BOOL)isEditableSectionType:(NSInteger)type;
/** @brief By default reloads the corresonding section only. */
- (void)didSwitchBoolValueAtIndexPath:(NSIndexPath *)indexPath;
/** @brief It is called in tableView:didSelectRowAtIndexPath: when type is MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION.
 By default calls createPresentingSelectionVCAtIndexPath:completion: */
- (void)handleSelectionAtIndexPath:(NSIndexPath *)indexPath;
/** @brief It is called in tableView:didSelectRowAtIndexPath: via handleSelectionAtIndexPath when type is MKU_MUTABLE_OBJECT_FIELD_TYPE_SELECTION.
 By default calls presentSelectionVC:atIndexPath: */
- (void)createPresentingSelectionVCAtIndexPath:(NSIndexPath *)indexPath completion:(void(^)(UIViewController *VC))completion;
/** @brief It is called in tableView:didSelectRowAtIndexPath: via didSelectListItem:atIndexPath when type is MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST.
 By default calls presentTransitioningViewControllerWithItem:atIndexPath: */
- (void)createPresentingSelectionVCForItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath completion:(void(^)(UIViewController *VC))completion;
/** @brief By default does [self.navigationController pushViewController:VC animated:YES]. In case of a container or popover
 for example you can override to provide other actions.*/
- (void)presentSelectionVC:(UIViewController *)VC atIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)heightForStandardSelectionCell;
- (CGFloat)heightForSingleCellRowAtIndexPath:(NSIndexPath *)indexPath;

- (UIImage *)buttonImageForFieldAtIndexPath:(NSIndexPath *)indexPath;
- (SEL)actionForFieldButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol MKUMutableObjectTransitionDelegate <NSObject>

@optional
/** @brief Handles transitions, called in presentSelectionVC:atIndexPath.
 
 @note If transitionVCDelegate = nil, or if shouldHandlePresentSelectionVC:atIndexPath returns NO, it
 performa default transition:
 @code
 [self.navigationController pushViewController:VC animated:YES];
 @endcode
 */
- (void)presentSelectionVC:(UIViewController *)VC atIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldHandlePresentSelectionVC:(UIViewController *)VC atIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - VC

/** @brief This is a utility class to facilitate simple screen with low vertically stacked UI elements. Although it is a
 tableview it does not do any dequeing, all cells are static and recreated on reload by default, unless subclass return a
 predefined cells for any type in particular for MKU_MUTABLE_OBJECT_FIELD_TYPE_SINGLE_CELL. */
@interface MKUMutableObjectTableViewController <__covariant ObjectType : __kindof NSObject<MKUFieldModelProtocol> *, __covariant UpdateObjectType : __kindof NSObject<MKUFieldModelProtocol> *> : MKUTableViewController <MKUMutableObjectTableVCProtocol, MKUViewControllerTransitionProtocol, MKUItemsListVCProtocol, MKUEditingListVCProtocol, MKUItemsListVCTransitionDelegate, MKUItemsListVCUpdateDelegate, MKUKVOProtocol>


- (__kindof MKUUpdateObject<ObjectType, UpdateObjectType> *)object;
- (void)setObject:(__kindof MKUUpdateObject<ObjectType, UpdateObjectType> *)object;

/** @brief Keys are list sections. It is empty set if nothing is selected, rows in list section if an item is selected.
 NSCache is used instead of NSDictionary primarily for thread safety. */
@property (nonatomic, strong) NSCache<NSNumber *, NSSet *> *selectedSets;

/** @brief The indexpath of the row that was selected or edited. */
@property (nonatomic, strong, readonly) NSIndexPath *selectedIndexPath;

/** @brief By default is is self. If this view is within a container, it can be assigned the container to handle
 transitions when an item is selected. */
@property (nonatomic, weak) id<MKUItemsListVCUpdateDelegate> updateDelegate;

/** @brief It makes the view completely uneditable. It has more precedence than isEditableSectionType of both this class and the object
 if NO, that is, if it is NO, nothing will be editable. But if it is YES, then isEditableSectionType will be used. Default is YES.
 @note Call this in initBase or viewWillAppear: or later. Calling it in viewDidLoad is too early and might result in it getting reset to YES. */
@property (nonatomic, assign) BOOL isEditable;

/** @brief Default is YES. If YES it calls setAsNavBarTarget in initBase. */
- (BOOL)hasMutableNavbar;

@property (nonatomic, weak) id<MKUMutableObjectTransitionDelegate> transitionMutableVCDelegate;

/** @brief selectedObjectHandler The handler to evalaute and set the selected item in the array of items. */
- (void)loadSelectionVCWithTitle:(NSString *)title allowsMultipleSelection:(BOOL)allowsMultipleSelection items:(NSArray *)items selectedObjectHandler:(EvaluateSelectedObjectHandler)selectedObjectHandler completion:(void(^)(UIViewController *VC))completion;

- (void)updateDatesWithUpdateObject:(UpdateObjectType)object;
- (MKUSingleViewTableViewCell <MKUCheckboxButtonView *> *)checkboxButtonCellInSection:(NSUInteger)section enabled:(BOOL)enabled singleLine:(BOOL)singleLine;
- (MKURadioButtonTableViewCell *)radioButtonCellForRowAtIndexPath:(NSIndexPath *)indexPath title:(NSString *)title enabled:(BOOL)enabled on:(BOOL)on singleLine:(BOOL)singleLine;

- (BOOL)isAddIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item;

- (void)resetSelectedSets;
- (void)resetSelectedSetsInListOfType:(NSUInteger)type;
- (void)setSelectedObjectsWithSet:(NSSet *)selectedObjects inListOfType:(NSUInteger)type;
- (NSSet *)selectedSetsInListOfType:(NSUInteger)type;
- (void)setSelectedObject:(__kindof NSObject<MKUPlaceholderProtocol> *)obj;
- (void)setDeselectedObject:(__kindof NSObject<MKUPlaceholderProtocol> *)obj;

/** @brief Adds the item to the list only if it doesn't already contain it, i.e., isEqual returns NO.
 @return A BOOL indicating if the object was added to the array.  */
- (BOOL)addItem:(NSObject<MKUPlaceholderProtocol> *)item toListOfType:(NSUInteger)type;
- (void)deleteItem:(NSObject<MKUPlaceholderProtocol> *)item fromListOfType:(NSUInteger)type;
- (NSArray *)addItems:(NSArray<NSObject<MKUPlaceholderProtocol> *> *)items toListOfType:(NSUInteger)type;
- (void)deleteItems:(NSArray<NSObject<MKUPlaceholderProtocol> *> *)items fromListOfType:(NSUInteger)type;
- (void)deleteAllItemsFromListOfType:(NSUInteger)type;
- (void)setItems:(NSArray<NSObject<MKUPlaceholderProtocol> *> *)items forListOfType:(NSUInteger)type;
/** @brief Called when setItems: addItems: and deleteItems: are done. Default calles updateDelegate
 itemsListVC:didUpdateItems:inSection: call super. */
- (void)didFinishUpdatesInListOfType:(NSUInteger)section;
- (void)dispatchUpdateDelegateToRefreshItem:(__kindof NSObject<NSCopying> *)item;
- (void)dispatchUpdateDelegateToSetSelected:(BOOL)selected item:(__kindof NSObject<NSCopying> *)item;
/** @brief It uses the section itself contrary to listItemsForListOfType which uses a type which might not match the section, e.g., bitmask. */
- (NSMutableArray<NSObject<MKUPlaceholderProtocol> *> *)listItemsForListInSection:(NSUInteger)section;
/** @brief Called in tableView: didSelectRowAtIndexPath: when a section is of type MKU_MUTABLE_OBJECT_FIELD_TYPE_LIST.
 Handles different actions corresponding to selectedActionHandler */
- (void)handleDidSelectListItem:(__kindof NSObject<MKUPlaceholderProtocol> *)item atIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - single type

@interface MKUMutableObjectTableViewControllerSingle <__covariant ObjectType : __kindof NSObject<MKUFieldModelProtocol> *, __covariant UpdateObjectType : __kindof NSObject<MKUFieldModelProtocol> *> : MKUMutableObjectTableViewController <ObjectType, UpdateObjectType>

@property (nonatomic, assign) MKU_MUTABLE_OBJECT_FIELD_TYPE type;

/** @brief Creates an instance with a single section of the given type. */
- (instancetype)initWithType:(MKU_MUTABLE_OBJECT_FIELD_TYPE)type;

@end

