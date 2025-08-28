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

/** @brief Call early such as in initialize.
 
 @param options Badge options as an array
 
 @code
 @[[MKUOption optionWithTitle:@"Title" name:@"Name" value:0]]
 @endcode
 */
+ (void)setGlobalBadgeOptions:(NSArray<MKUOption *> *)options;
+ (instancetype)badgeWithName:(NSString *)name;
- (BOOL)hasValue;
+ (NSArray<MKUOption *> *)typeOptions;
+ (instancetype)badgeWithName:(NSString *)name inBadges:(NSArray<MKUBadgeItem *> *)badges;

@end

@protocol MKUBadgeItemUpdateDelegate <NSObject>

@optional
- (void)updateBadge:(__kindof MKUBadgeItem *)badge;

/** @brief Badge names that with badge counts calculated as the sum of the other badges as long as their type are included as an option in the bitmask. */
- (NSArray *)combinedBadgeNames;

@end

