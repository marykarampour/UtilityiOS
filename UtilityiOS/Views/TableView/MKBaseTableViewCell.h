//
//  MKTableViewCell.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-23.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKBaseTableViewCell : UITableViewCell

+ (NSString *)identifier;
+ (CGFloat)estimatedHeight;
+ (UIImageView *)imageAccessoryView;

@end


@interface MKTableCellInfo : NSObject

@property (nonatomic, strong) __kindof MKBaseTableViewCell *cell;

/** @brief It can be UITableViewAutomaticDimension or estimated height of cell or custom value */
@property (nonatomic, assign) CGFloat estimatedHeight;

/** @breif It is the current height, can be estimatedHeight, 0.0 or a suitable height set based on conditions */
@property (nonatomic, assign) CGFloat height;

/** @brief If YES height will return 0.0 */
@property (nonatomic, assign) BOOL hidden;

@end
