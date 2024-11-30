//
//  MKUTableViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKULabel.h"
#import "MKUBadgeItem.h"
#import "MKUDatePicker.h"
#import "MKUAccessoryLabel.h"
#import "TextViewController.h"
#import "TextFieldController.h"
#import "UIViewController+Utility.h"
#import "MKUHeaderContainerProtocol.h"
#import "UIViewController+IndexPath.h"
#import "MKUSingleViewTableViewCell.h"
#import "MKUViewControllerProtocols.h"
#import "NSObject+NavBarButtonTarget.h"
#import "UIViewController+UpdateBadge.h"
#import "MKUTableViewCellContentProtocols.h"
#import "MKUViewControllerTransitionProtocol.h"
#import "MKUSingleViewTableViewHeaderFooterView.h"
#import "UIViewController+ViewControllerTransition.h"

typedef NS_ENUM(NSUInteger, MKU_TEXTVIEW_CELL_ROW) {
    MKU_TEXTVIEW_CELL_ROW_TITLE,
    MKU_TEXTVIEW_CELL_ROW_TEXT,
    MKU_TEXTVIEW_CELL_ROW_COUNT
};

typedef NSDictionary<NSNumber *, MKUDateViewInfoObject *> DateSectionInfoObjctDict;

@protocol MKUTableViewControllerProtocol <NSObject>

@optional
- (void)didShowDatePickerAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
/** @brief Return NO if yo want this date section not expand to modify the date. Default is YES. */
- (BOOL)isEditableDateSection:(NSUInteger)section;
- (NSAttributedString *)attributedTitleForAccessoryLabelOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type inSection:(NSInteger)section;

@required
- (CGFloat)heightForNonDateRowAtIndexPath:(NSIndexPath * _Nullable)indexPath;
- (UITableViewCell * _Nonnull)tableView:(UITableView * _Nonnull)tableView cellForNonDateRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)didSelectNonDateRowAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (void)didHideDatePickerAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (NSUInteger)numberOfRowsInNonDateSection:(NSUInteger)section;

@end


/** @note Use dequeue if cells are dynamic and numerous and therefore must be simple.
 If cells are few and mostly static and more complex, create them on the fly wthout dequeue.
 There is no need to register cells, just check for cell not being nil and if it is create it right there.
 An Identifier for a cell is auto generated for subclasses of MKUBaseTableViewCell. Use it as: [<Cell class> identifier].*/
@interface MKUTableViewController : UITableViewController <MKUTableViewControllerProtocol, MKUDatePickerDelegate, MKUViewControllerViewProtocol, MKUViewControllerProtocol>

@property (nonatomic, weak) _Nullable id<MKURefreshViewControllerDelegate> refreshDelegate;

//TODO: Dark and light styles
@property (nonatomic, strong) MKULabelStyleObject *sectionHeaderStyle;
@property (nonatomic, strong) MKULabelStyleObject *sectionFooterStyle;

@property (nonatomic, strong, nullable) NSString *footerTitle;
@property (nonatomic, strong, nullable) DateSectionInfoObjctDict *dateCellInfoObjects;
@property (nonatomic, assign) UIEdgeInsets accessoryViewInsets;
@property (nonatomic, assign) NSUInteger MKUType;
/** @brief Dark theme will set section headers dark blue with mist text color. */
@property (nonatomic, assign) BOOL useDarkTheme;

/** @brief Call this if you are creating sub-class clusters */
- (void)initBase;

- (BOOL)hasTitleForHeaderInSection:(NSInteger)section;
- (void)reloadDataAnimated:(BOOL)animated;
- (void)reloadAllSections;
- (void)reloadSection:(NSUInteger)section;
- (void)reloadSection:(NSUInteger)section completion:(void (^)())completion;
- (void)reloadSections:(NSArray<NSNumber *> *)sections completion:(void (^)())completion;
- (void)reloadSectionsInSet:(NSIndexSet *)sections completion:(void (^)())completion;
- (void)reloadIndexPaths:(IndexPathArr * _Nullable)indexPaths;
- (void)reloadSection:(NSUInteger)section withHeader:(BOOL)header;
- (void)removeRowsAtIndexPaths:(IndexPathArr * _Nullable)indexPaths;
- (void)insertRowsAtIndexPaths:(IndexPathArr * _Nullable)indexPaths;
- (void)setBlankFooter;
- (BOOL)isDateSection:(NSUInteger)section;
/** @brief Default is type DATE_INFO_OBJECT_TYPE_DAY */
- (void)addDateSections:(NSArray<NSNumber *> *)sections;
- (void)addDateSections:(NSArray<NSNumber *> *)sections dateType:(DATE_INFO_OBJECT_TYPE)type;
- (void)addDateSections:(NSArray<NSNumber *> *)sections dateType:(DATE_INFO_OBJECT_TYPE)type canChooseFutureDate:(BOOL)canChooseFutureDate;
/** @brief Default is type DATE_INFO_OBJECT_TYPE_DAY */
- (void)addDateSections:(NSArray<NSNumber *> *)sections canChooseFutureDate:(BOOL)canChooseFutureDate;

/** @brief Default is type DATE_INFO_OBJECT_TYPE_DAY */
- (void)addDateSections:(NSArray<NSNumber *> *)sections datePickerMode:(UIDatePickerMode)mode;
- (void)addDateSections:(NSArray<NSNumber *> *)sections datePickerMode:(UIDatePickerMode)mode dateType:(DATE_INFO_OBJECT_TYPE)type;
- (void)setDateSectionsHidden:(BOOL)hidden;
- (void)setDateSections:(NSArray<NSNumber *> *)sections hidden:(BOOL)hidden;

- (void)clearSelections;
- (void)clearSelectionsInSection:(NSUInteger)section;
- (void)selectAllInSection:(NSUInteger)section;
- (NSArray<NSIndexPath *> *)selectedIndexPaths;
- (NSArray<NSIndexPath *> *)selectedIndexPathsInSection:(NSUInteger)section;
- (void)setExtendedLineSeparator;


#pragma mark - custom cell templates

- (MKUBaseTableViewCell *)emptyCell;
- (MKUBaseTableViewCell * _Nullable)tableView:(UITableView * _Nonnull)tableView dateCellWithInfo:(MKUDateViewInfoObject * _Nullable)info;
- (MKUBaseTableViewCell *)cellContainingView:(UIView *)view;
- (MKUBaseTableViewCell *)textViewCellForIndexPath:(NSIndexPath * _Nonnull)indexPath title:(NSString *)title delegate:(id<TextViewDelegate>)delegate viewIndexPath:(NSIndexPath *)viewIndexPath text:(NSString *)text;
- (MKUBaseTableViewCell *)textViewCellForIndexPath:(NSIndexPath * _Nonnull)indexPath title:(NSString *)title delegate:(id<TextViewDelegate>)delegate viewIndexPath:(NSIndexPath *)viewIndexPath text:(NSString *)text placeholder:(NSString *)placeholder;
- (MKUBaseTableViewCell *)textViewCellForIndexPath:(NSIndexPath * _Nonnull)indexPath title:(NSString *)title delegate:(id<TextViewDelegate>)delegate viewIndexPath:(NSIndexPath *)viewIndexPath text:(NSString *)text placeholder:(NSString *)placeholder maxChars:(NSUInteger)maxChars;
- (MKUBaseTableViewCell *)textViewCellForRow:(NSUInteger)row withView:(MKUTextView *)view title:(NSString *)title insets:(UIEdgeInsets)insets;
- (MKUBaseTableViewCell *)textFieldCellForIndexPath:(NSIndexPath * _Nonnull)indexPath title:(NSString *)title delegate:(id<TextFieldDelegate>)delegate viewIndexPath:(NSIndexPath *)viewIndexPath text:(NSString *)text placeholder:(NSString *)placeholder;
- (MKUBaseTableViewCell *)textFieldCellForIndexPath:(NSIndexPath * _Nonnull)indexPath title:(NSString *)title delegate:(id<TextFieldDelegate>)delegate viewIndexPath:(NSIndexPath *)viewIndexPath text:(NSString *)text;

- (CGFloat)heightForTextFieldCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForTextViewCellAtIndexPath:(NSIndexPath * _Nonnull)indexPath;

- (void)updateTableView;
- (void)reloadSectionsSet:(NSIndexSet *)sections completion:(void (^)(void))completion;

- (void)getBadge:(NSString * _Nonnull)badgeName;
- (void)updateBadge:(MKUBadgeItem * _Nonnull)badge;

//Abstract
/** @brief subclass must return updated badges to be used on badge rows **/
- (NSArray<MKUBadgeItem *> *)updatedBadges;


/** @brief Used to adjust the content insets of the table view based on the navigation bar. Default is 0.
 It can be greater than zero in case of a custom navigation bar */
- (CGFloat)adjustedScrollViewInsetsForNavigationBarHeight;

#pragma mark - custom views

- (UIView *)defaultSectionFooter;
/** @brief It uses MKU_ACCESSORY_VIEW_TYPE_DEFAULT */
- (void)createTableHeaderWithTitle:(NSString *)title;
- (void)createTableHeaderWithTitle:(NSString *)title type:(MKU_ACCESSORY_VIEW_TYPE)type;
/** @brief It uses  backgroundColor MKUMistBlue */
- (void)createTableHeaderWithAttributedTitle:(NSAttributedString *)attributedString;
- (void)createTableHeaderWithAttributedTitle:(NSAttributedString *)attributedString backgroundColor:(UIColor *)backgroundColor;
- (void)setTableHeaderWithView:(UIView *)view;
- (void)setTableFooterWithView:(UIView *)view;
- (void)createTableAccessoryViewOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type withTitle:(NSString *)title;
- (void)createTableAccessoryViewOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type withAttributedTitle:(NSAttributedString *)title;
- (void)setView:(__kindof UIView *)view forAccessoryViewOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type;
- (MKUSingleViewTableViewHeaderFooterView<MKULabel *> *)accessoryLabelOfType:(MKU_TABLEVIEW_ACCESSORY_VIEW_TYPE)type inSection:(NSInteger)section;

- (void)scrollToBottomWithDalay:(CGFloat)delay;
- (void)scrollToBottomOfSection:(NSUInteger)section withDalay:(CGFloat)delay;
- (void)scrollToBottomOfIndexPath:(NSIndexPath *)indexPath withDalay:(CGFloat)delay;
- (void)scrollToBottom;

@end
