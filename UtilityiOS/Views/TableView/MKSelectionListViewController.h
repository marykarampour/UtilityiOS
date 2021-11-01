//
//  MKSelectionListViewController.h
//  KaChing
//
//  Created by Maryam Karampour on 2021-10-31.
//  Copyright © 2021 Prometheus Software. All rights reserved.
//

#import "MKTableViewController.h"

@protocol MKSelectionListProtocol <NSObject>

@required
- (NSInteger)listCount;
- (NSString *)textLabelForRow:(NSInteger)row;

@end

@interface MKSelectionListViewController : MKTableViewController <MKSelectionListProtocol, ViewControllerTransitionDelegate>

/** @brief Any NSObject works here, for title label, override description and return the title to be presented in UI */
@property (nonatomic, strong) NSArray *textLabels;

/** @brief If this is given, upon te selection of an item, these items will be presented for user to choose, e.g. select category
 and then select sub category. */
@property (nonatomic, strong) NSDictionary<NSObject<NSCopying>*, NSArray *> *selectionTextLabels;

/** @brief Only used if selectionTextLabels is provided */
@property (nonatomic, strong) NSString *categoryTitle;

/** @brief Only used if selectionTextLabels is provided */
@property (nonatomic, strong) NSString *subcategoryTitle;

/** This is CFISelectionListTypeNone */
- (instancetype)initWithTitle:(NSString *)title;

@end

