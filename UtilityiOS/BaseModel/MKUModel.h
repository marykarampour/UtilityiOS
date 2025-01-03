//
//  MKUModel.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "JSONModel.h"
#import "NSString+Utility.h"

@protocol MKUModelCustomKeysProtocol <NSObject>

@optional
/** @brief Override in subclass if you want properties of ancestors be added to JSON keys, default NO
 @code
 + (BOOL)usingAncestors {
    return YES;
 }
 @endcode
 */
+ (BOOL)usingAncestors;

/** @brief Override in subclass if you want dynamic properties including from protocols be added to  property names, default NO
 @code
 + (BOOL)usingDynamicProperties {
 return YES;
 }
 @endcode
 */
+ (BOOL)usingDynamicProperties;

/** @brief Override in subclass if you want keys be excluded in JSON keys
 @code
 + (NSSet<NSString *> *)excludedKeys {
    return @[NSStringFromSelector(@selector(maxDate)),
             NSStringFromSelector(@selector(fromDate)),
             NSStringFromSelector(@selector(toDate))];
 }
 @endcode
 */
+ (NSSet<NSString *> *)excludedKeys;

/** @brief Override in subclass if you want keys be excluded in property names when used in isEqual (not used in copy)
 @code
 + (StringSet *)excludedProperties {
 return [NSSet setWithObjects:NSStringFromSelector(@selector(maxDate)),
 NSStringFromSelector(@selector(fromDate)),
 NSStringFromSelector(@selector(toDate)), nil];
 }
 @endcode
 */
+ (StringSet *)excludedProperties;

/** @brief Override in subclass if you want properties have different format than other JSON keys
 @note Use with + (StringFormat)customFormat
 @code
 + (NSSet<NSString *> *)customKeys {
    return @[NSStringFromSelector(@selector(fromDate)),
             NSStringFromSelector(@selector(toDate))];
 }
 @endcode
 */
+ (NSSet<NSString *> *)customKeys;

/** @brief Override in subclass if you want properties have different format than other JSON keys
  @note Use with + (NSSet<NSString *> *)customKeys
 @code
 + (StringFormat)customFormat {
    return StringFormatNone;
 }
 @endcode
 */
+ (StringFormat)customFormat;

/** @brief Override in subclass if you want properties have custom keys in JSON
 @code
 + (DictStringString *)customKeyValueDict {
    return @{NSStringFromSelector(@selector(fromDate)):@"from",
             NSStringFromSelector(@selector(toDate)):@"to"};
 }
 @endcode
 */
+ (DictStringString *)customKeyValueDict;

@end

//TODO: JSONModel does not support all types, e.g., Class. Made it not throw exception, have to decide
@interface MKUModel : JSONModel <NSCoding, NSCopying, MKUModelCustomKeysProtocol>

@property (class, nonatomic, strong, readonly) NSSet<NSString *> *propertyNames;
/** @brief Key is property name and value is Attribute name */
@property (class, nonatomic, strong, readonly) DictStringString *propertyAttributeNames;
/** @brief Key is property name and value is class name */
@property (class, nonatomic, strong, readonly) DictStringString *propertyClassNames;
@property (class, nonatomic, strong, readonly) NSSet<NSString *> *dateProperties;

/** @brief Used to set the mapper format for object to JSON.
 @note default is StringFormatNONE, override + (StringFormat)classMapperFormat in subclass to customize */
@property (class, nonatomic, assign, readonly) StringFormat mapperFormat;


- (instancetype)initWithStringsDictionary:(NSDictionary *)values;

/** @brief Override in subclass to set the mapper format for object to JSON. */
+ (StringFormat)classMapperFormat;

/** @brief override in subclass to set custom date formatter */
+ (NSDateFormatter *)dateFormatter;

+ (NSString *)convertToJson:(NSString *)property;
+ (NSString *)convertToProperty:(NSString *)json;

- (NSString *)titleText;

/** @brief Only copies values which are not nil */
- (void)copyValues:(__kindof MKUModel *)object;

/** @brief Set all values of object
 @param ancestors YES will set values for ancestors of object too, NO only sets values of properties of object
 */
- (void)setValuesOfObject:(__kindof MKUModel *)object ancestors:(BOOL)ancestors;

/** @brief An extension to - (NSDictionary *)toDictionary excluding given keys
 @note Use with + (NSSet<NSString *> *)excludedKeys 
 */
- (NSDictionary *)toDictionaryWithExcludedKeys:(StringSet *)keys;

#pragma mark - search predicate

/** @brief key value pair for search predicates containg the class and property name
 @note subclass must implement searchPredicateKeys */
+ (DictStringString *)searchPredicateKeyValues;

/** @brief keys for search predicates containg property names
 @note subclass must implement */
+ (NSSet<NSString *> *)searchPredicateKeys;

/** @brief search property name, return nil if search self */
+ (NSSet<NSString *> *)searchPredicatePropertyNames;

/** @brief Returns class of a property with given name */
+ (Class)classForPropertyName:(NSString *)name;

#pragma mark - utility

- (NSString *)stringJSON;
/** @brief Sets values from object */
- (void)setWithObject:(__kindof MKUModel *)object;
+ (BOOL)propertyIsBool:(NSString *)name;
+ (BOOL)propertyIsEnum:(NSString *)name;

- (NSString *)nameForProperty:(NSString *)property;
+ (NSString *)tagName;
/** @brief A JSON representation of the serialized object. */
- (NSString *)stringValue;
/** @brief A JSON representation of the serialized object is converted to dictionary and used to create the object using initWithMap:. */
+ (instancetype)objectWithJSON:(NSString *)string;
- (BOOL)propertyIsBool:(NSString *)propertyName;
/** @brief Default is NO. If No is assuems local time for formatting. */
- (BOOL)datePropertyIsUTC:(NSString *)propertyName;
- (NSDictionary *)varNamesWithSingleLenght:(NSUInteger)lenght;

@end



@interface MKUOption : MKUModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger value;

- (instancetype)initWithTitle:(NSString *)title name:(NSString *)name value:(NSInteger)value;
+ (instancetype)optionWithTitle:(NSString *)title name:(NSString *)name value:(NSInteger)value;
+ (instancetype)optionWithTitle:(NSString *)title value:(NSInteger)value;

+ (NSArray *)namesForOptions:(NSArray<MKUOption *> *)options;
+ (NSArray *)titlesForOptions:(NSArray<MKUOption *> *)options;
+ (NSArray *)namesForOptions:(NSArray<MKUOption *> *)options range:(NSRange)range;
+ (NSArray *)titlesForOptions:(NSArray<MKUOption *> *)options range:(NSRange)range;
+ (NSArray<MKUOption *> *)optionsForOptions:(NSArray<MKUOption *> *)options range:(NSRange)range;
+ (instancetype)optionForNameOrTitle:(NSString *)text options:(NSArray<MKUOption *> *)options;
+ (instancetype)optionForName:(NSString *)name options:(NSArray<MKUOption *> *)options;
+ (instancetype)optionForTitle:(NSString *)title options:(NSArray<MKUOption *> *)options;
+ (instancetype)optionForType:(NSInteger)type options:(NSArray<MKUOption *> *)options;

@end

