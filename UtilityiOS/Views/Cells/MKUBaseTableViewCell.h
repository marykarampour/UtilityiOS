//
//  MKUBaseTableViewCell.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUViewProtocol.h"

@interface MKUBaseTableViewCell : UITableViewCell <MKUViewProtocol>

/** @brief When YES, acesoryType will be UITableViewCellAccessoryCheckmark if it is selected, otherwise UITableViewCellAccessoryNone. */
@property (nonatomic, assign) BOOL checkmarkOnSelection;
/** @brief Implpement [Constants TableCellDisclosureIndicatorSize] and [AppTheme tableCellDisclosureIndicatorImage] and [AppTheme tableCellAccessoryViewColor] if this is set to YES. */
@property (nonatomic, assign) BOOL useCustomImageAccessoryView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style;
+ (instancetype)blankCell;
- (void)addAccessoryButton;
- (void)setAccessoryButtonTarget:(id)target action:(SEL)action;
- (void)setAccessoryButtonTitle:(NSString *)title;
- (void)setAccessoryViewImage:(NSString *)image indexPath:(NSIndexPath *)indexPath;

@end

@interface MKUSubtitleTableViewCell : MKUBaseTableViewCell

@end

__deprecated
@interface MKUTableCellInfo : NSObject

@property (nonatomic, strong) __kindof MKUBaseTableViewCell *cell;

/** @brief It can be UITableViewAutomaticDimension or estimated height of cell or custom value */
@property (nonatomic, assign) CGFloat estimatedHeight;

/** @breif It is the current height, can be estimatedHeight, 0.0 or a suitable height set based on conditions */
@property (nonatomic, assign) CGFloat height;

/** @brief If YES height will return 0.0 */
@property (nonatomic, assign) BOOL hidden;

@end
