//
//  MKUBadgeItem.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2018-01-15.
//  Copyright © 2018 BHS Consultants. All rights reserved.
//

#import "MKUModel.h"

@interface MKUBadgeItem : MKUModel

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSString *name;
/** @brief A badge can have more than one type as bitmask used in combinedBadgeNames */
@property (nonatomic, assign, readonly) NSUInteger type;

/** @brief Call early on to set badge options as a array of
 @code
 [MKUOption optionWithTitle:@"Title" name:@"Name" value:0]
 @codeend
 */
+ (void)setGobalBadgeOptions:(NSArray<MKUOption *> *)options;
+ (instancetype)badgeWithName:(NSString *)name;
- (BOOL)hasValue;
+ (NSArray<MKUOption *> *)typeOptions;

@end

@protocol MKUBadgeItemUpdateDelegate <NSObject>

@optional
- (void)updateBadge:(MKUBadgeItem *)badge;

/** @brief Badge names that with badge counts calculated as the sum of the other badges as long as their type are included as an option in the bitmask. */
- (NSArray *)combinedBadgeNames;

@end

