//
//  NSObject+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utility)

/** @brief checks properties of self.class */
- (BOOL)MKIsEqual:(id)object;
/** @brief checks properties given */
- (BOOL)MKIsEqual:(id)object properties:(StringArr *)properties;
- (id)MKCopyWithZone:(NSZone *)zone;
- (id)MKCopyWithZone:(NSZone *)zone baseClass:(Class)baseClass;

- (void)MKInitWithCoder:(NSCoder *)aDecoder;
- (void)MKInitWithCoder:(NSCoder *)aDecoder baseClass:(Class)baseClass;

- (void)MKEncodeWithCoder:(NSCoder *)aCoder;
- (void)MKEncodeWithCoder:(NSCoder *)aCoder baseClass:(Class)baseClass;

- (NSUInteger)MKHash;

/** @brief Returns YES if all properties are null. Same as allIsNullWithBaseClass with baseClass = super  */
- (BOOL)allIsNull;

/** @brief Returns YES if all properties are null */
- (BOOL)allIsNullWithBaseClass:(Class)baseClass;

/** @brief Returns YES if all given properties have null values */
- (BOOL)allIsNullWithProperties:(StringArr *)properties;

+ (StringArr *)propertyNamesOfClass:(Class)objectClass;
+ (NSDictionary *)attributePropertyNamesOfClass:(Class)objectClass;
+ (Class)classOfProperty:(NSString *)name forObjectClass:(Class)objectClass;

+ (void)swizzleSelectorOriginal:(SEL)originalSelector swizzled:(SEL)swizzledSelector isClassMethod:(BOOL)isClassMethod;

/** @brief This method uses swizzleSelectorOriginal:swizzled:isClassMethod to swizzle a method
 @param selector to be swizzled.
 @note The corresponding swizzled method with format swizzled_XXX should be implemeneted in your class for selector named XXX */
+ (void)swizzleSelector:(SEL)selector isClassMethod:(BOOL)isClassMethod;

+ (NSString *)GUID;
+ (NSString *)timestampGUID;

@end
