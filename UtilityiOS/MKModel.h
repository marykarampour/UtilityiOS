//
//  MKModel.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "JSONModel.h"

@interface MKModel : JSONModel <NSCoding, NSCopying>

- (instancetype)initWithStringsDictionary:(NSDictionary *)values;

- (NSString *)convertToJson:(NSString *)property;
- (NSString *)convertToProperty:(NSString *)json;

- (NSString *)titleText;
/** @brief Only copies values which are not nil */
- (void)copyValues:(__kindof MKModel *)object;
/** @brief Set all values of object
 @param ancestors YES will set values for ancestors of object too, NO only sets values of properties of object
 */
- (void)setValuesOfObject:(__kindof MKModel *)object ancestors:(BOOL)ancestors;

@end
