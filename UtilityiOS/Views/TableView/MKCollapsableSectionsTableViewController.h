//
//  MKCollapsableSectionsTableViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKTableViewController.h"
#import "MKTableViewSection.h"
#import "MKButtonView.h"
#import "MKPair.h"

#define STATE_EXPANDED  YES
#define STATE_COLLAPSED  NO

@protocol MKCollapsableSectionsProtocol <NSObject>

@required
/** @brief subclass must implement to customize create sections
 @code
 - (void)createSections {
 self.sectionsController = [MKSectionController sectionControllerWithType:0];
 
 for (unsigned int i=0; i<self.sectionsController.sections.count; i++) {
 MKTableViewSection *section = [[MKTableViewSection alloc] init];
 section.isExpanded = NO;
 section.isCollapsable = YES;
 [self.sections addObject:section];
 }
 }
 @endcode
 */
- (void)createSections;

- (NSUInteger)numberOfRowsInSectionWhenExpanded:(NSUInteger)section;
/** @brief return nil if no header is needed or if the default for collapsable setions should be used */
- (__kindof MKButtonView *)viewObjectForHeaderInSection:(NSInteger)section;
- (__kindof MKButtonView *)viewObjectForHeaderInCollapsableSection:(NSInteger)section;
/** @brief return nil if no header is needed or if the default for collapsable setions should be used */
- (UIView *)viewForHeaderInSection:(NSInteger)section;
- (UIView *)viewForHeaderInCollapsableSection:(NSInteger)section;
/** @brief Call super first
 @note Never call - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section in subclass */
- (void)customizeViewForHeader:(__kindof MKButtonView *)header inSection:(__kindof MKTableViewSection *)sect section:(NSInteger)section;

@end

@interface MKCollapsableSectionsTableViewController : MKTableViewController <MKCollapsableSectionsProtocol, MKButtonProtocol>

/** @brief Key is the indexpath of section, value is a bool indicating if the section is collapsable
 @code
 [self.sectionStates setObject:@(YES) forKey:[NSIndexPath indexPathWithIndex:0]];
 @endcode
 */
@property (nonatomic, strong) NSArray<__kindof MKTableViewSection *> *sections;

/** @brief Default is YES, if NO only one section can be expanded at a time
 @note You are responsible for updating/tapping etc. of the header, this does not
 result in header button press programmatically, only reloads the rows in sections */
@property (nonatomic, assign) BOOL multiExpandedSectionEnabled;

/** @brief Default is YES */
@property (nonatomic, assign) BOOL reloadSectionsAnimated;

/** @brief Default is NO, if YES, it uses the following logic:
 @code
 if (selected && !sect.isExpanded) {
 sect.isExpanded = YES;
 }
 else if (!selected && sect.isExpanded) {
 sect.isExpanded = NO;
 }
 @endcode
 */
@property (nonatomic, assign) BOOL exclusiveExpandForSelected;
/** @brief Implement this to update the specific header after headerPressed called
 on a different section, e.g. headerPressed called for section 0, if multiExpandedSectionEnabled = NO,
 then updateHeaderForSection is called for section 1 to give it the chance to update itself */
- (void)updateHeaderForSection:(NSUInteger)section;

- (MKTableViewSection *)sectionObjectForIndex:(NSUInteger)section;

/** @brief Returns the header stored in headers or creates new if doesn't exist */
- (__kindof MKButtonView *)headerViewForSection:(NSUInteger)section;

/** @brief Returns the header stored in headers or creates new if doesn't exist */
- (__kindof MKButtonView *)headerViewForSectionObject:(__kindof MKTableViewSection *)sect;

/** @brief This method triggers a collapsing of the section programmatically */
- (void)performUpdateHeaderForSection:(MKTableViewSection *)sect section:(NSUInteger)section;

@end
