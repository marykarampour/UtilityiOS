//
//  MKCollapsableSectionsTableViewController.h
//  KaChing-v2
//
//  Created by Maryam Karampour on 2018-01-17.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKTableViewController.h"

#define STATE_EXPANDED  YES
#define STATE_COLLAPSED  NO

@interface MKTableViewSection : NSObject

@property (nonatomic, assign) BOOL isCollapsable;
/** @brief only used if isCollapsable is YES */
@property (nonatomic, assign) BOOL isExpanded;

+ (MKTableViewSection *)sectionCollapsable:(BOOL)isCollapsable expanded:(BOOL)isExpanded;

@end


@protocol MKCollapsableSectionsProtocol <NSObject>

@required
- (NSUInteger)numberOfRowsInSectionWhenExpanded:(NSUInteger)section;
/** @brief return nil if no header is needed or if the default for collapsable setions should be used */
- (UIView *)viewForHeaderInSection:(NSInteger)section;


@end

@interface MKCollapsableSectionsTableViewController : MKTableViewController

/** @brief Key is the indexpath of section, value is a bool indicating if the section is collapsable
 @code
 [self.sectionStates setObject:@(YES) forKey:[NSIndexPath indexPathWithIndex:0]];
 @endcode
 */
@property (nonatomic, strong) NSMutableArray<__kindof MKTableViewSection *> *sections;

- (MKTableViewSection *)sectionObjectForIndex:(NSUInteger)section;

@end
