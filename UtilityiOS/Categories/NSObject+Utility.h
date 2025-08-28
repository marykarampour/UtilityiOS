//
//  NSObject+Utility.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, MKU_COPY_OPTION) {
    MKU_COPY_OPTION_PROPERTIES = 1 << 0,
    MKU_COPY_OPTION_IVARS      = 1 << 1
};

@interface NSObject (Utility)

- (instancetype)initWithObject:(NSObject *)object ancestors:(BOOL)ancestors baseClass:(Class)baseClass;
- (instancetype)initWithObject:(NSObject *)object properties:(NSSet<NSString *> *)properties;
+ (instancetype)objectWithObject:(NSObject *)object ancestors:(BOOL)ancestors baseClass:(Class)baseClass;

- (void)resetIsDefaults:(BOOL)isDefaults;
- (void)resetIsDefaults:(BOOL)isDefaults excludeProperties:(NSSet<NSString *> *)excluding;
/** @brief Set all values of object
 @param ancestors YES will set values for ancestors of object too, NO only sets values of properties of object
 */
- (void)setValuesOfObject:(NSObject *)object ancestors:(BOOL)ancestors baseClass:(Class)baseClass;
- (void)setValuesOfObject:(NSObject *)object properties:(NSSet<NSString *> *)properties;
- (void)setValuesOfObject:(NSObject *)object properties:(StringSet *)properties excludeProperties:(StringSet *)excluding;

/** @brief checks properties of self.class */
- (BOOL)MKUIsEqual:(id)object;
/** @brief Returns YES if all properties are null. Same as allIsNullWithBaseClass with baseClass = super  */
- (BOOL)MKUIsEqual:(id)object properties:(NSSet<NSString *> *)properties;

- (id)MKUCopyWithZone:(NSZone *)zone;
- (id)MKUCopyWithZone:(NSZone *)zone properties:(NSSet<NSString *> *)properties;
- (id)MKUCopyWithZone:(NSZone *)zone excludeProperties:(NSSet<NSString *> *)excluding;
- (id)MKUCopyWithZone:(NSZone *)zone baseClass:(Class)baseClass option:(MKU_COPY_OPTION)option;
- (id)MKUCopyWithZone:(NSZone *)zone baseClass:(Class)baseClass option:(MKU_COPY_OPTION)option excludeProperties:(NSSet<NSString *> *)excluding;

- (void)MKUInitWithCoder:(NSCoder *)aDecoder;
- (void)MKUInitWithCoder:(NSCoder *)aDecoder baseClass:(Class)baseClass;
- (void)MKUInitWithCoder:(NSCoder *)aDecoder properties:(NSSet<NSString *> *)properties;

- (void)MKUEncodeWithCoder:(NSCoder *)aCoder;
- (void)MKUEncodeWithCoder:(NSCoder *)aCoder baseClass:(Class)baseClass;
- (void)MKUEncodeWithCoder:(NSCoder *)aCoder properties:(NSSet<NSString *> *)properties;

- (NSUInteger)MKUHash;
- (NSUInteger)MKUHashWithProperties:(NSSet<NSString *> *)properties;

/** @brief Includes dynamiclly added properties as in protocols */
+ (NSSet<NSString *> *)propertyNamesOfClass:(Class)objectClass;

/** @brief Includes dynamiclly added properties as in protocols */
+ (NSDictionary *)propertyAttributesOfClass:(Class)objectClass;

/** @brief Excludes dynamiclly added properties as in protocols */
+ (NSSet<NSString *> *)ivarNamesOfClass:(Class)objectClass;

/** @brief Excludes dynamiclly added properties as in protocols */
+ (NSDictionary *)ivarAttributesOfClass:(Class)objectClass;

/** @brief Returns YES if all properties are null */
- (BOOL)allIsNull;

/** @brief Returns YES if all properties are null */
- (BOOL)allIsNullWithBaseClass:(Class)baseClass;

/** @brief Returns YES if all given properties have null values */
- (BOOL)allIsNullWithProperties:(NSSet<NSString *> *)properties;

+ (BOOL)haveSameNullity:(NSObject *)obj1 asObject:(NSObject *)obj2;

+ (NSDictionary *)attributePropertyNamesOfClass:(Class)objectClass;
+ (Class)classOfProperty:(NSString *)name forObjectClass:(Class)objectClass;

+ (void)swizzleSelectorOriginal:(SEL)originalSelector swizzled:(SEL)swizzledSelector isClassMethod:(BOOL)isClassMethod;

/** @brief This method uses swizzleSelectorOriginal:swizzled:isClassMethod to swizzle a method
 @param selector to be swizzled.
 @note The corresponding swizzled method with format swizzled_XXX should be implemeneted in your class for selector named XXX */
+ (void)swizzleSelector:(SEL)selector isClassMethod:(BOOL)isClassMethod;

+ (NSString *)GUID;
+ (NSString *)timestampGUID;


- (void)processText:(NSString *)text condition:(BOOL)condition object:(NSString *)object action:(SEL)action;

/** @brief A mechanism for retrieving and processing a number in a textfield
 
 @param textField textField with numeric text
 
 @param condition condition to check before action can be executed
 
 @param action to be executed, variadic args are passed as parameters of this action
 
 @param object object that is compared with the number retrieved earlier
 
 
 @code
 
 [self processNumberInTextField:textField condition:([self.currentCheckList typeForPropertyAtIndex:indexPath.row] == PropertyTypeTemp) action:@selector(setTempValue:indexPath:) object:temp, indexPath];
 
 @endcode
 
 @note variadic arguments are optional
 **/
- (void)processNumberInTextField:(__kindof UITextField *)textField action:(SEL)action object:(__kindof NSObject *)object, ... ;

//TODO: Use MKUFieldModel for object types to handle field updates where this is used
- (NSNumber *)processNumberInTextField:(__kindof UITextField *)textField number:(__kindof NSNumber *)number;

+ (NSArray <NSString *> *)deserializeStringResult:(id)result;
+ (NSArray <NSString *> *)deserializeSingleKeyResult:(id)result objectClass:(Class)objectClass;
/** @brief Assumes single key, i.e., an array of numbers of the same type. */
+ (NSArray <NSString *> *)deserializeNumberResult:(id)result;
/** @param key If is nil, it will be processed as single key. */
+ (NSArray <NSString *> *)deserializeObjectResult:(id)result objectClass:(Class)objectClass key:(NSString *)key;

- (MKU_TENARY_TYPE)stateForSelector:(SEL)action;
- (MKU_TENARY_TYPE)stateForSelector:(SEL)action object:(id)object;

#pragma mark - Predicate

/** @param key Property name which is equal to value. */
- (NSPredicate *)predicateWithKey:(NSString *)key value:(NSObject *)value;
- (NSPredicate *)predicateWithKey:(NSString *)key searchText:(NSString *)searchText condition:(BOOL)condition;

#pragma mark - Math

+ (UIEdgeInsets)insets:(CGFloat)value;
+ (CGRect)boundingRectWithTopLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight;
+ (CGRect)rectForNormalizedRect:(CGRect)normalizedRect withWidth:(CGFloat)width height:(CGFloat)height;

/** @brief Returns N the power of 2 resulting from bit shifting as 1 << N
 @note If bits = 0, it returns -1.  */
+ (NSInteger)indexOfBitmask:(NSUInteger)bits;

@end


@interface NSIndexPath (Utility)

/** @brief The same value of index will be used for both row and section. */
+ (instancetype)indexPathWithSameIndex:(NSUInteger)index;

@end

