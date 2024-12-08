//
//  MKUCollapsableSectionsViewController.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-12-07.
//

#import "MKUTableViewController.h"
#import "MKUButtonHeaderView.h"
#import "MKUMenuObjects.h"

@protocol MKUCollapsableSectionsProtocol <NSObject>

@required
- (NSUInteger)numberOfRowsInNonDateSectionWhenExpanded:(NSUInteger)section;
/** @brief Default is nil. */
- (UIView *)viewForNonCollapsableHeaderInSection:(NSInteger)section;
- (CGFloat)heightForCollapsableHeaderInSection:(NSInteger)section;
- (CGFloat)heightForNoneCollapsableHeaderInSection:(NSInteger)section;
/** @brief Default is chevron down. */
- (UIImage *)expandedImageInSection:(NSInteger)section;
/** @brief Default is chevron right. */
- (UIImage *)collapsedImageInSection:(NSInteger)section;

@end

@interface MKUCollapsableSectionsViewController : MKUTableViewController <MKUCollapsableSectionsProtocol>
/** @brief It has as many sections as the tableview, sections which are not collapsable have negative index */
@property (nonatomic, strong) NSMutableArray<MKUSectionObject *> *sectionObjects;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) BOOL canExpandMultipleSections;
/** @brief Default os MKU_THEME_STYLE_DARK. It affects the colors of the section headers. */
@property (nonatomic, assign) MKU_THEME_STYLE sectionHeaderTheme;

- (void)reloadSectionKeepSelection:(NSUInteger)section;
- (void)reloadRowsKeepSelection:(NSArray *)indexPaths;
- (MKUButtonHeaderView *)defaultHeaderViewInSection:(NSInteger)section;

@end
