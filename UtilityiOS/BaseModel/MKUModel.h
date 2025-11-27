//
//  MKUModel.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "JSONModel.h"
#import "MKUViewContentStyleProtocols.h"
#import "NSString+Utility.h"
#import "NSObject+Utility.h"

@protocol MKUModelCustomKeysProtocol <NSObject>

@optional
/** @brief Override in subclass if you want properties of ancestors be added to serialization keys, default NO
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

/** @brief Return how you want BOOL be serialized, e.g., YES / NO, or true / false.  DEfault is true / false */
+ (NSString *)stringValueForBOOL:(BOOL)value;
+ (BOOL)boolValueForObject:(NSObject *)value;

/** @brief Override in subclass if you want keys be excluded in JSON keys
 @code
 + (StringSet *)excludedKeys {
 return [NSSet setWithObjects:NSStringFromSelector(@selector(maxDate)),
 NSStringFromSelector(@selector(fromDate)),
 NSStringFromSelector(@selector(toDate)), nil];
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
+ (NSSet<NSString *> *)excludedProperties;

/** @brief Override in subclass if you want properties have different format than other JSON keys
 @note Use with + (MKU_STRING_FORMAT)customFormat
 @code
 + (NSSet<NSString *> *)customKeys {
 return [NSSet setWithObjects:
 NSStringFromSelector(@selector(fromDate)),
 NSStringFromSelector(@selector(toDate)), nil];
 }
 @endcode
 */
+ (NSSet<NSString *> *)customKeys;

/** @brief Override in subclass if you want properties have different format than other JSON keys
  @note Use with + (NSSet<NSString *> *)customKeys
 @code
 + (MKU_STRING_FORMAT)customFormat {
    return MKU_STRING_FORMAT_NONE;
 }
 @endcode
 */
+ (MKU_STRING_FORMAT)customFormat;

/** @brief Override in subclass if you want properties have custom keys in JSON
 @code
 + (DictStringString *)customKeyValueDict {
    return @{NSStringFromSelector(@selector(fromDate)):@"from",
             NSStringFromSelector(@selector(toDate)):@"to"};
 }
 @endcode
 */
+ (DictStringString *)customKeyValueDict;

- (Class)classForProperty:(NSString *)property;

/** @brief Used to serialize dates. Default is DATE_FORMAT_FULL_STYLE. */
- (DATE_FORMAT_STYLE)dateFormatForProperty:(NSString *)propertyName;

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
 @note default is MKU_STRING_FORMATNONE, override + (MKU_STRING_FORMAT)classMapperFormat in subclass to customize */
@property (class, nonatomic, assign, readonly) MKU_STRING_FORMAT mapperFormat;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
/** @param Default is NO. If NO, JSONModel methods will be used, otherwise XMLSerialize will be done. */
- (instancetype)initWithDictionary:(NSDictionary *)dict useXML:(BOOL)XML;
/** @param Default is NO. If NO, JSONModel methods will be used, otherwise XMLSerialize will be done. */
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err useXML:(BOOL)XML;

+ (NSArray *)toDictionaryWithArray:(NSArray<MKUModel *> *)items useXML:(BOOL)XML;
+ (NSArray *)toDictionaryWithArray:(NSArray<MKUModel *> *)items withTags:(BOOL)tags useXML:(BOOL)XML;

/** @brief Override in subclass to set the mapper format for object to JSON. */
+ (MKU_STRING_FORMAT)classMapperFormat;

/** @brief override in subclass to set custom date formatter */
+ (NSDateFormatter *)dateFormatter;

+ (NSString *)convertToJson:(NSString *)property;
+ (NSString *)convertToProperty:(NSString *)json;

- (NSString *)titleText;

/** @brief Only copies values which are not nil */
- (void)copyValues:(__kindof MKUModel *)object;

/** @brief An extension to - (NSDictionary *)toDictionary excluding given keys
 @note Use with + (NSSet<NSString *> *)excludedKeys 
 */
- (NSDictionary *)toDictionaryWithExcludedKeys:(StringSet *)keys;

#pragma mark - search predicate

/** @brief key value pair for search predicates containg the class and property name
 @note subclass must implement searchPredicateKeys */
+ (DictStringString *)searchPredicateKeyValues;

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
/** @brief A JSON representation of the serialized object. */
- (NSData *)dataValue;
/** @brief A representation of the serialized object in XML or JSON format. */
- (NSData *)dataValueUseXML:(BOOL)XML;
/** @brief A representation of the serialized object in XML or JSON format. */
- (NSDictionary *)toDictionaryWithXML:(BOOL)XML;
/** @brief A JSON representation of the serialized object is converted to dictionary and used to create the object using initWithDictionary:. */
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
/** @param values can be a bitmask or other int, either case bitwise & will be used to evalaute if the option matches.*/
+ (NSArray<MKUOption *> *)optionsForOptions:(NSArray<MKUOption *> *)options values:(NSArray<NSNumber *> *)values;
+ (NSArray<MKUOption *> *)optionsForOptions:(NSArray<MKUOption *> *)options value:(NSInteger)value;
+ (NSArray<MKUOption *> *)optionsForOptions:(NSArray<MKUOption *> *)options name:(NSString *)name;
+ (NSArray<MKUOption *> *)optionsForOptions:(NSArray<MKUOption *> *)options title:(NSString *)title;
+ (instancetype)optionForNameOrTitle:(NSString *)text options:(NSArray<MKUOption *> *)options;
+ (instancetype)optionForName:(NSString *)name options:(NSArray<MKUOption *> *)options;
+ (instancetype)optionForTitle:(NSString *)title options:(NSArray<MKUOption *> *)options;
+ (instancetype)optionForType:(NSInteger)type options:(NSArray<MKUOption *> *)options;

- (NSComparisonResult)compare:(MKUOption *)option;

@end

/** @brief description retruns true or false based on false and true states. If they are equal, it will be nil. */
@interface MKUBool : MKUModel

@property (nonatomic, assign) BOOL falseState;
@property (nonatomic, assign) BOOL trueState;

/** @brief Sets falseState to true and trueState to false. */
- (void)setFalse;
/** @brief Sets trueState to true and falseState to false. */
- (void)setTrue;
/** @brief If state is YES, does setTrue, if state is NO, does setFalse. */
- (void)setState:(BOOL)state;

@end


@interface JSONValueTransformer (MKUModel)

- (id)NSDataFromNSString:(NSString *)string;
- (NSString *)JSONObjectFromNSData:(NSData *)data;

@end
