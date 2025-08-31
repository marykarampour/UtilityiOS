//
//  MKUFieldModel.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-22.
//  Copyright © 2024 Maryam Karampour. All rights reserved.
//

#import "MKUFieldModel.h"
#import "MKUStepperFieldView.h"
#import "NSString+Utility.h"
#import "NSNumber+Utility.h"
#import "NSObject+Utility.h"
#import "NSNumber+Utility.h"
#import "NSString+Number.h"
#import "NSArray+Utility.h"
#import "NSDate+Utility.h"
#import "MKUTextField.h"
#import "MKUTextView.h"
#import <objc/runtime.h>

const void *PROPERTY_ENUM_KEY;
const void *SECTION_ENUM_KEY;
const void *TITLE_ENUM_KEY;
static char UPDATE_DELEGATE_KEY;

@interface MKUFieldModel ()

@property (nonatomic, strong, class, readonly) NSDictionary <NSNumber *, NSString *> *propertyEnumDict;
@property (nonatomic, strong, class, readonly) NSDictionary <NSNumber *, NSNumber *> *sectionEnumDict;
@property (nonatomic, strong, class, readonly) NSDictionary <NSNumber *, NSString *> *titleEnumDict;

@property (nonatomic, strong, readwrite) NSString *GUID;

@end

@implementation MKUFieldModel

- (void)setUpdateDelegate:(id<MKUFieldModelDelegate>)updateDelegate {
    objc_setAssociatedObject(self, &UPDATE_DELEGATE_KEY, updateDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<MKUFieldModelDelegate>)updateDelegate {
    return objc_getAssociatedObject(self, &UPDATE_DELEGATE_KEY);
}

- (instancetype)init {
    if (self = [super init]) {
        self.GUID = [Constants GUID];
    }
    return self;
}

- (instancetype)initWithStringsDictionary:(NSDictionary *)map {
    if (self = [super initWithDictionary:map error:nil]) {
        self.GUID = [Constants GUID];
    }
    return self;
}

- (id)copy {
    MKUFieldModel *obj = (MKUFieldModel *)[super copy];
    obj.GUID = [Constants GUID];
    return obj;
}

+ (NSSet<NSString *> *)excludedKeys {
    return [NSSet setWithObjects:NSStringFromSelector(@selector(GUID)), NSStringFromSelector(@selector(updateDelegate)), nil];
}
//Not clear why GUID was created. Its only use case at the moment is to make otherwise equal objects, not equal.
//We are excluding it here to accomodate isModified in MKUUpdateObject. This might have to change if it created unexpected bugs.
+ (NSSet<NSString *> *)excludedProperties {
    return [NSSet setWithObject:NSStringFromSelector(@selector(GUID))];
}

+ (BOOL)usingAncestors {
    return YES;
}

+ (NSDictionary<NSNumber *, NSString *> *)propertyEnumDict {
    NSDictionary<NSNumber *, NSString *> *property = objc_getAssociatedObject(self, &PROPERTY_ENUM_KEY);
    if (!property) {
        property = [self propertyEnumDictionary];
        objc_setAssociatedObject(self, &PROPERTY_ENUM_KEY, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return property;
}

+ (NSDictionary<NSNumber *, NSNumber *> *)sectionEnumDict {
    NSDictionary<NSNumber *, NSNumber *> *section = objc_getAssociatedObject(self, &SECTION_ENUM_KEY);
    if (!section) {
        section = [self sectionEnumDictionary];
        objc_setAssociatedObject(self, &SECTION_ENUM_KEY, section, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return section;
}

+ (NSDictionary<NSNumber *, NSString *> *)titleEnumDict {
    NSDictionary<NSNumber *, NSString *> *title = objc_getAssociatedObject(self, &TITLE_ENUM_KEY);
    if (!title) {
        title = [self titleEnumDictionary];
        objc_setAssociatedObject(self, &TITLE_ENUM_KEY, title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return title;
}

+ (NSDictionary<NSNumber *, NSString *> *)propertyEnumDictionary {
    return @{};
}

+ (NSDictionary<NSNumber *, NSNumber *> *)sectionEnumDictionary {
    return [[NSDictionary alloc] initWithObjects:self.propertyEnumDict.allKeys forKeys:self.propertyEnumDict.allKeys];
}

+ (NSDictionary<NSNumber *, NSString *> *)titleEnumDictionary {
    return self.propertyEnumDict;
}

+ (void)iterateOverTypesForSectionType:(NSInteger)type block:(void(^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block {
    
    NSArray<NSNumber *> *types = [self objectTypesForSectionType:type];
    [types enumerateObjectsUsingBlock:block];
}

- (NSArray<NSObject *> *)valuesForSectionType:(NSInteger)type {
    
    __block NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [self.class iterateOverTypesForSectionType:type block:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        
        //Return YES for any type not defined - handled by other controllers
        if (![self.class.propertyEnumDict.allKeys containsObject:obj]) {
            arr = [@[@(YES)] mutableCopy];
            *stop = YES;
        }
        
        NSObject *value = [self valueForObjectType:obj.integerValue];
        
        if (0 < [value description].length) {
            [arr addObject:value];
        }
    }];
    
    return arr;
}

- (NSArray<NSNumber *> *)updateValidationObjectTypes {
    return @[];
}

- (NSArray<NSNumber *> *)saveValidationObjectTypes {
    return @[];
}

- (BOOL)isValid {
    return YES;
}

- (void)canSaveWithResult:(VALIDATION_BLOCK)result {
    [self processValidationWithObjectTypes:[self saveValidationObjectTypes] action:@selector(canSaveWithResult:) result:result];
}

- (void)canUpdateWithResult:(VALIDATION_BLOCK)result {
    [self processValidationWithObjectTypes:[self updateValidationObjectTypes] action:@selector(canUpdateWithResult:) result:result];
}

- (void)processValidationWithObjectTypes:(NSArray<NSNumber *> *)types action:(SEL)action result:(VALIDATION_BLOCK)result {
    if (types.count == 0) return result(YES, nil);
    
    [types enumerateObjectsUsingBlock:^(NSNumber * _Nonnull type, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSObject *obj = [self valueForObjectType:type.integerValue];
        NSString *name = [self.class titleForObjectType:type.integerValue];
        
        if ([obj description].length == 0) {
            NSString *message = 0 < name.length ? [NSString stringWithFormat:[self.class missingValueErrorMessage], name] : nil;
            result(NO, message);
            *stop = YES;
        }
        else if ([obj conformsToProtocol:@protocol(MKUDataUpdateProtocol)] && [obj respondsToSelector:action]) {
            NSObject <MKUDataUpdateProtocol> *value = (NSObject <MKUDataUpdateProtocol> *)obj;
            VALIDATION_OPERATOR operator = (VALIDATION_OPERATOR)[value methodForSelector:action];
            if (operator) {
                operator(value, action, ^(BOOL success, NSString *error) {
                    if (!success) {
                        NSString *message = 0 < error.length ? error : [NSString stringWithFormat:[self.class missingObjectErrorMessage], name];
                        result(NO, message);
                        *stop = YES;
                    }
                });
            }
        }
        
        if (!(*stop) && idx + 1 == types.count) {
            return result(YES, nil);
        }
    }];
}

- (NSObject *)valueForObjectType:(NSInteger)type {
    
    NSString *key = [self.class.propertyEnumDict objectForKey:@(type)];
    if (!key || ![self respondsToSelector:NSSelectorFromString(key)])
        return nil;
    
    return [self valueForKey:key];
}

- (BOOL)boolValueForObjectType:(NSInteger)type {
    NSObject *value = [self valueForObjectType:type];
    if ([NSNumber isBOOL:value]) {
        return [(NSNumber *)value boolValue];
    }
    return value;
}

- (BOOL)boolValueForSectionType:(NSInteger)type {
    
    __block BOOL value = NO;
    
    [self.class iterateOverTypesForSectionType:type block:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSObject *object = [self valueForObjectType:obj.integerValue];
        if ([NSNumber isBOOL:object]) {
            value = [(NSNumber *)object boolValue];
            *stop = YES;
        }
    }];
    
    return value;
}

- (NSDate *)dateValueForObjectType:(NSInteger)type {
    NSObject *value = [self valueForObjectType:type];
    if ([value isKindOfClass:[NSDate class]]) {
        return (NSDate *)value;
    }
    return nil;
}

- (NSDate *)dateValueForSectionType:(NSInteger)type {
    
    __block NSDate *value;
    
    [self.class iterateOverTypesForSectionType:type block:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        value = [self dateValueForObjectType:obj.integerValue];
        if (value) {
            *stop = YES;
        }
    }];
    
    return value;
}

+ (DATE_FORMAT_STYLE)dateFormatForObjectType:(NSInteger)type {
    return DATE_FORMAT_DAY_TIME_STYLE;
}

+ (DATE_FORMAT_STYLE)dateFormatForSectionType:(NSInteger)type {
    return DATE_FORMAT_DAY_TIME_STYLE;
}

+ (MKU_TEXT_TYPE)textTypeForObjectType:(NSInteger)type {
    return MKU_TEXT_TYPE_STRING;
}

+ (BOOL)shouldValidateWhenEditingObjectType:(NSInteger)type {
    return NO;
}

+ (NSNumberFormatterStyle)numberStyleForObjectType:(NSInteger)type {
    MKU_TEXT_TYPE textType = [self textTypeForObjectType:type];
    switch (textType) {
        case MKU_TEXT_TYPE_FLOAT:
        case MKU_TEXT_TYPE_FLOAT_POSITIVE:
            return NSNumberFormatterDecimalStyle;
        default:
            return NSNumberFormatterNoStyle;
    }
}

- (NSNumber *)numberValueForObjectType:(NSInteger)type {
    NSObject *value = [self valueForObjectType:type];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
    }
    return nil;
}

- (NSNumber *)numberValueForSectionType:(NSInteger)type {
    
    __block NSNumber *value;
    
    [self.class iterateOverTypesForSectionType:type block:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        value = [self numberValueForObjectType:obj.integerValue];
        if (value) {
            *stop = YES;
        }
    }];
    
    return value;
}

- (BOOL)hasValueForObjectType:(NSInteger)type {
    return 0 < [[self valueForObjectType:type] description].length;
}

- (BOOL)hasValueForSectionType:(NSInteger)type {
    
    __block BOOL hasValue = NO;
    
    [self.class iterateOverTypesForSectionType:type block:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self hasValueForObjectType:obj.integerValue]) {
            hasValue = YES;
            *stop = YES;
        }
    }];
    
    return hasValue || [self.class isEditableSectionType:type];
}

+ (NSString *)titleForObjectType:(NSInteger)type {
    NSString *key = [self.propertyEnumDict objectForKey:@(type)];
    return [key splitedStringForUppercaseComponentsAndGroupUppercase:YES];
}

+ (NSString *)titleForSectionType:(NSInteger)type {
    NSString *key = [self.titleEnumDict objectForKey:@(type)];
    return [key splitedStringForUppercaseComponentsAndGroupUppercase:YES];
}

- (void)setValue:(NSObject *)value forObjectType:(NSInteger)type {
    
    NSString *key = [self.class.propertyEnumDict objectForKey:@(type)];
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
        [self setValue:value forKey:key];
    }
}

- (void)setValue:(NSObject *)value forSectionType:(NSInteger)type {
    
    [self.class iterateOverTypesForSectionType:type block:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *key = [self.class.propertyEnumDict objectForKey:@(obj.integerValue)];
        Class cls = [NSObject classOfProperty:key forObjectClass:self.class];
        if ([[value class] isSubclassOfClass:cls]) {
            [self setValue:value forObjectType:obj.integerValue];
            *stop = YES;
        }
    }];
}

+ (NSArray<NSNumber *> *)typesForSection:(NSInteger)section {
    return [self.sectionEnumDict allKeysForObject:@(section)];
}

- (NSString *)stringValueForObjectType:(NSInteger)type {
    NSObject *object = [self valueForObjectType:type];
    
    if (!object)
        return nil;
    
    if ([object isKindOfClass:[NSString class]])
        return (NSString *)object;
    
    if ([object isKindOfClass:[NSDate class]])
        return [self.class localDateStringWithDate:(NSDate *)object forObjectType:type];
    
    if ([object isKindOfClass:[NSNumber class]])
        return [(NSNumber *)object stringValueWithStyle:[self.class numberStyleForObjectType:type] digits:[self floatingDigits]];
    
    return [object description];
}

- (NSString *)stringValueForSectionType:(NSInteger)type {
    
    __block NSString *value;
    
    [self.class iterateOverTypesForSectionType:type block:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger type = obj.integerValue;
        value = [self stringValueForObjectType:type];
        
        if (0 < value.length) {
            *stop = YES;
        }
    }];
    
    return 0 < value.length ? value : [[self valuesForSectionType:type].firstObject description];
}

+ (NSArray<NSNumber *> *)objectTypesForSectionType:(NSInteger)type {
    return [self.sectionEnumDict allKeysForObject:@(type)];
}

- (NSString *)badgeValueForSectionType:(NSInteger)type {
    return nil;
}

- (NSUInteger)floatingDigits {
    return 2;
}

+ (NSString *)localDateStringWithDate:(NSDate *)date forObjectType:(NSInteger)type {
    return [date localDateStringWithFormat:[self dateFormatForObjectType:type]];
}

+ (NSString *)localDateStringWithDate:(NSDate *)date {
    return [date localDateStringWithFormat:DATE_FORMAT_DAY_TIME_STYLE];
}

- (NSString *)localDateStringForObjectType:(NSInteger)type {
    NSObject *object = [self valueForObjectType:type];
    if (![object isKindOfClass:[NSDate class]]) return nil;
    return [self.class localDateStringWithDate:(NSDate *)object forObjectType:type];
}

- (void)switchBoolValueForObjectType:(NSInteger)type {
    
    NSString *key = [self.class.propertyEnumDict objectForKey:@(type)];
    NSObject *value = [self valueForKey:key];
    Class cls = [self.class classOfProperty:key forObjectClass:self.class];
    
    if ([cls isSubclassOfClass:[NSNumber class]] && [NSNumber isBOOL:value]) {
        BOOL boolVal = [(NSNumber *)value boolValue];
        [self setValue:@(!boolVal) forKey:key];
    }
}

- (void)switchBoolValueForSectionType:(NSInteger)type {
    [self.class iterateOverTypesForSectionType:type block:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self switchBoolValueForObjectType:obj.integerValue];
    }];
}

- (BOOL)isLongValueForObjectType:(NSInteger)type {
    return [Constants MaxValue1CellCharacterCount] <= [self stringValueForObjectType:type].length;
}

- (BOOL)isLongValueForSectionType:(NSInteger)type {
    
    __block BOOL isLong = NO;
    
    [self.class iterateOverTypesForSectionType:type block:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isLongValueForObjectType:obj.integerValue]) {
            isLong = YES;
            *stop = YES;
        }
    }];
    
    return isLong;
}

+ (BOOL)isEditableSectionType:(NSInteger)type {
    return YES;
}

+ (BOOL)isCommentSectionType:(NSInteger)type {
    return NO;
}

+ (BOOL)isUppercaseStringObjectType:(NSInteger)type {
    return NO;
}

+ (BOOL)isEmailSectionType:(NSInteger)type {
    return NO;
}

+ (BOOL)isPhoneSectionType:(NSInteger)type {
    return NO;
}

- (void)handleTextFieldDidChange:(__kindof UITextField *)textField newText:(NSString *)newText {
    [self handleTextFieldUpdates:textField newText:newText setTextField:YES endEditing:NO];
}

- (void)handleTextFieldEndEditing:(__kindof UITextField *)textField {
    [self handleTextFieldUpdates:textField newText:nil setTextField:YES endEditing:YES];
}

- (void)handleTextFieldUpdates:(__kindof UITextField *)textField newText:(NSString *)newText setTextField:(BOOL)setTextField endEditing:(BOOL)endEditing {
    if ([textField isKindOfClass:[MKUTextField class]]) {
        
        NSIndexPath *indexPath = textField.indexPath;
        NSString *text = newText.length ? newText : textField.text;
        text = [self text:text forObjectType:indexPath.row];
        NSUInteger type = indexPath.row;
        NSObject *value = text;
        NSString *name = [[self.class propertyEnumDict] objectForKey:@(type)];
        Class cls = [NSObject classOfProperty:name forObjectClass:self.class];
        
        if ([cls isSubclassOfClass:[NSNumber class]])
            value = [text stringToNullableNumberWithStyle:[self.class numberStyleForObjectType:type]];
        
        [self setValue:value forObjectType:type];
        
        if (setTextField)
            textField.text = (endEditing || [self.class shouldValidateWhenEditingObjectType:type]) ? [self stringValueForObjectType:type] : text;
        
        [self dispatchUpdateDelegateWithObjectType:type textField:textField endEditing:endEditing atIndexPath:indexPath];
    }
}

- (void)handleTextViewEndEditing:(__kindof MKUTextView *)textView {
    if ([textView isKindOfClass:[MKUTextView class]]) {
        NSIndexPath *indexPath = textView.indexPath;
        textView.text = [self text:textView.text forObjectType:indexPath.row];
        [self setValue:textView.text forObjectType:indexPath.row];
    }
}

- (void)stepper:(UIStepper *)stepper didChangeValue:(NSInteger)value {
    NSIndexPath *indexPath = stepper.indexPath;
    [self setValue:@(value) forObjectType:indexPath.row];
}

- (void)dispatchUpdateDelegateWithObjectType:(NSInteger)type {
    if (![self respondsToSelector:@selector(updateDelegate)]) return;
    
    if ([self.updateDelegate respondsToSelector:@selector(object:didUpdateObjectType:)]) {
        [self.updateDelegate object:self didUpdateObjectType:type];
    }
}

- (void)dispatchUpdateDelegateWithObjectType:(NSInteger)type textField:(UITextField *)textField endEditing:(BOOL)endEditing atIndexPath:(NSIndexPath *)indexPath {
    if (![self respondsToSelector:@selector(updateDelegate)]) return;
    
    if ([self.updateDelegate respondsToSelector:@selector(object:didUpdateObjectType:textField:endEditing:atIndexPath:)]) {
        [self.updateDelegate object:self didUpdateObjectType:type textField:textField endEditing:endEditing atIndexPath:indexPath];
    }
}

- (NSString *)text:(NSString *)text forObjectType:(NSInteger)type {
    return [self.class isUppercaseStringObjectType:type] ? [text uppercaseString] : text;
}

- (NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)arrayForObjectType:(NSUInteger)type {
    NSObject *obj = [self valueForObjectType:type];
    
    if ([obj respondsToSelector:@selector(array)])
        return [(id<MKUArrayPropertyProtocol>)obj array];
    return nil;
}

- (NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)arrayForSectionType:(NSUInteger)type {
    
    __block NSArray *value;
    
    [self.class iterateOverTypesForSectionType:type block:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        value = [self arrayForObjectType:obj.integerValue];
        if (value) {
            *stop = YES;
        }
    }];
    
    if ([value respondsToSelector:@selector(array)])
        return [(id<MKUArrayPropertyProtocol>)value array];
    return nil;
}

+ (NSString *)missingValueErrorMessage {
    return [Constants Missing_Value_Error_Message_STR];
}

+ (NSString *)missingObjectErrorMessage {
    return [Constants Missing_Object_Error_Message_STR];
}

@end


@interface MKUMutableObject ()

@property (nonatomic, assign, readwrite) Class classForOriginalObject;
@property (nonatomic, assign, readwrite) Class classForUpdatedObject;

@end

@implementation MKUMutableObject

- (instancetype)init {
    return [self initWithObject:nil];
}

- (instancetype)initWithObject:(__kindof NSObject<NSCopying> *)object {
    if (self = [super init]) {
        [self setupWithObject:object];
    }
    return self;
}

- (void)setupWithObject:(__kindof NSObject<NSCopying> *)object {
    
    NSObject<NSCopying> *obj = [object MKUCopyWithZone:nil baseClass:[NSObject class] option:MKU_COPY_OPTION_IVARS];
    
    if (!obj) {
        Class cls = self.classForOriginalObject;
        if (![cls conformsToProtocol:@protocol(NSCopying)])
            cls = [NSObject classOfProperty:NSStringFromSelector(@selector(OriginalObject)) forObjectClass:self.class];
        obj = [[cls alloc] init];
    }
    
    self.OriginalObject = obj;
}

- (void)resetOriginalObject {
    _OriginalObject = nil;
}

- (void)setOriginalObject:(__kindof NSString<NSCopying> *)OriginalObject {
    _OriginalObject = OriginalObject;
    if (OriginalObject && [[OriginalObject class] isSubclassOfClass:[MKUModel class]])
        self.classForOriginalObject = [OriginalObject class];
    [self reset];
}

- (void)setUpdatedObject:(__kindof NSObject *)UpdatedObject {
    if (UpdatedObject) {
        _UpdatedObject = UpdatedObject;
        if ([[UpdatedObject class] isSubclassOfClass:[MKUModel class]])
            self.classForUpdatedObject = [UpdatedObject class];
    }
    else {
        [self reset];
    }
}

- (void)reset {
    if ([self.OriginalObject isKindOfClass:self.classForUpdatedObject]) {
        if ([[self.OriginalObject class] isSubclassOfClass:[MKUModel class]])
            self.UpdatedObject = [self.OriginalObject MKUCopyWithZone:nil baseClass:[MKUModel class] option:MKU_COPY_OPTION_IVARS];
        else
            self.UpdatedObject = [self.OriginalObject copy];
    }
    else {
        self.UpdatedObject = [[self.classForUpdatedObject alloc] init];
    }
}

- (instancetype)duplicateUpdateObject {
    MKUUpdateObject *obj = [[self.class alloc] init];
    obj.UpdatedObject = [self.UpdatedObject copy];
    [obj resetOriginalObject];
    return obj;
}

- (BOOL)isModified {
    return ![self.OriginalObject isEqual:self.UpdatedObject];
}

- (Class)classForOriginalObject {
    if (!_classForOriginalObject) {
        _classForOriginalObject = [self.class defaultClassForOriginalObject];
    }
    return _classForOriginalObject;
}

- (Class)classForUpdatedObject {
    if (!_classForUpdatedObject) {
        _classForUpdatedObject = [self.class defaultClassForUpdatedObject];
    }
    return _classForUpdatedObject;
}

+ (NSMutableArray *)updateObjectsWithObjects:(NSArray *)objects {
    
    NSMutableArray <MKUMutableObject *> *arr = [[NSMutableArray alloc] init];
    
    for (NSObject<NSCopying> *obj in objects) {
        MKUMutableObject *update = [[self alloc] initWithObject:obj];
        [arr addObject:update];
    }
    return arr;
}

+ (NSSet<NSString *> *)excludedKeys {
    return [NSSet setWithObjects:NSStringFromSelector(@selector(classForOriginalObject)), NSStringFromSelector(@selector(classForUpdatedObject)), nil];
}

+ (Class)defaultClassForUpdatedObject {
    return [NSObject class];
}

+ (Class)defaultClassForOriginalObject {
    return [self defaultClassForUpdatedObject];
}

- (NSString *)nameForProperty:(NSString *)property {
    NSDictionary *map = @{NSStringFromSelector(@selector(OriginalObject)) : [self.class nameForOriginalObject],
                          NSStringFromSelector(@selector(UpdatedObject)) : [self.class nameForUpdatedObject]};
    NSString *name = [map objectForKey:property];
    return name.length > 0 ? name : [super nameForProperty:property];
}

+ (DictStringString *)customKeyValueDict {
    return @{NSStringFromSelector(@selector(OriginalObject)) : [self.class nameForOriginalObject],
             NSStringFromSelector(@selector(UpdatedObject))  : [self.class nameForUpdatedObject]};
}

+ (NSString *)nameForOriginalObject {
    return NSStringFromSelector(@selector(OriginalObject));
}

+ (NSString *)nameForUpdatedObject {
    return NSStringFromSelector(@selector(UpdatedObject));
}

+ (BOOL)usingDynamicProperties {
    return YES;
}

+ (BOOL)usingAncestors {
    return YES;
}

@end


@implementation MKUUpdateObject

@dynamic OriginalObject;
@dynamic UpdatedObject;

- (instancetype)duplicateUpdateObject {
    MKUUpdateObject *obj = [super duplicateUpdateObject];
    obj.UserID = self.UserID;
    return obj;
}

- (BOOL)isLongValueForSectionType:(NSInteger)type {
    return [self.UpdatedObject isLongValueForSectionType:type];
}

- (BOOL)isEditableSectionType:(NSInteger)type {
    return [self.classForOriginalObject isEditableSectionType:type];
}

- (BOOL)hasValueForSectionType:(NSInteger)type {
    return [self.UpdatedObject hasValueForSectionType:type];
}

- (BOOL)isCommentSectionType:(NSInteger)type {
    return [[self classForUpdatedObject] isCommentSectionType:type];
}

+ (BOOL)usingDynamicProperties {
    return NO;
}

@end


@interface MKUUpdateIDObject ()

@end

@implementation MKUUpdateIDObject

@dynamic OriginalObject;
@dynamic UpdatedObject;

+ (Class)defaultClassForUpdatedObject {
    return [MKUModelID class];
}

- (BOOL)isUpdate {
    return [self.OriginalObject hasID];
}

@end


@implementation MKUModelID

+ (instancetype)objectWithID:(NSNumber *)ID {
    MKUModelID *obj = [[self alloc] init];
    obj.ID = ID;
    return obj;
}

- (void)canUpdateWithResult:(VALIDATION_BLOCK)result {
    if (!self.ID)
        result(NO, nil);
    else
        [super canUpdateWithResult:result];
}

- (BOOL)hasID {
    return 0 < self.ID.integerValue;
}

+ (BOOL)usingAncestors {
    return YES;
}

@end


@implementation MKUFieldListModel

+ (NSDictionary<NSNumber *,NSString *> *)propertyEnumDictionary {
    return @{@(MKU_FIELD_LIST_TYPE_A) : NSStringFromSelector(@selector(itemsA)),
             @(MKU_FIELD_LIST_TYPE_B) : NSStringFromSelector(@selector(itemsB)),
             @(MKU_FIELD_LIST_TYPE_C) : NSStringFromSelector(@selector(itemsC)),
             @(MKU_FIELD_LIST_TYPE_D) : NSStringFromSelector(@selector(itemsD))};
}

- (NSMutableArray *)arrayA {
    return [self.itemsA array];
}

- (NSMutableArray *)arrayB {
    return [self.itemsB array];
}

- (NSMutableArray *)arrayC {
    return [self.itemsC array];
}

- (NSMutableArray *)arrayD {
    return [self.itemsD array];
}

- (NSUInteger)activeListsCount {
    NSUInteger count = 0;
    NSUInteger value = 0;
    for (NSUInteger i=MKU_FIELD_LIST_TYPE_NONE; value<MKU_FIELD_LIST_TYPE_COUNT; i++) {
        value = 1 << i;
        if (value & self.activeListTypes) count++;
    }
    return count;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"itemsA: %@\nitemsB: %@\nitemsC: %@\nitemsD: %@", _itemsA, _itemsB, _itemsC, _itemsD];
}

@end

@implementation MKUUpdateListObject

@dynamic OriginalObject;
@dynamic UpdatedObject;

@end

@implementation MKUFieldSingleListModel

@dynamic itemsA;

- (instancetype)init {
    if (self = [super init]) {
        self.itemsA = [[NSMutableArray alloc] init];
    }
    return self;
}

@end


@implementation MKUCommentModel

+ (NSDictionary<NSNumber *,NSString *> *)propertyEnumDict {
    return @{@0:NSStringFromSelector(@selector(Notes))};
}

@end

@implementation MKUCommentUpdateObject

@dynamic OriginalObject;
@dynamic UpdatedObject;

@end

#pragma mark - categories

@implementation NSString (MKUFieldModel)

+ (NSDictionary<NSNumber *,NSString *> *)propertyEnumDictionary {
    return @{};
}

+ (NSDictionary<NSNumber *,NSNumber *> *)sectionEnumDictionary {
    return @{};
}

+ (NSDictionary<NSNumber *,NSString *> *)titleEnumDictionary {
    return @{};
}

- (BOOL)boolValueForObjectType:(NSInteger)type {
    return 0 < self.length;
}

- (BOOL)boolValueForSectionType:(NSInteger)type {
    return 0 < self.length;
}

- (NSDate *)dateValueForObjectType:(NSInteger)type {
    return nil;
}

- (NSDate *)dateValueForSectionType:(NSInteger)type {
    return nil;
}

+ (DATE_FORMAT_STYLE)dateFormatForObjectType:(NSInteger)type {
    return DATE_FORMAT_FULL_STYLE;
}

+ (DATE_FORMAT_STYLE)dateFormatForSectionType:(NSInteger)type {
    return DATE_FORMAT_FULL_STYLE;
}

+ (MKU_TEXT_TYPE)textTypeForObjectType:(NSInteger)type {
    return MKU_TEXT_TYPE_STRING;
}

+ (BOOL)shouldValidateWhenEditingObjectType:(NSInteger)type {
    return NO;
}

- (BOOL)hasValueForObjectType:(NSInteger)type {
    return 0 < self.length;
}

- (BOOL)hasValueForSectionType:(NSInteger)type {
    return 0 < self.length;
}

+ (BOOL)isCommentSectionType:(NSInteger)type {
    return NO;
}

+ (BOOL)isEditableSectionType:(NSInteger)type {
    return NO;
}

- (BOOL)isLongValueForObjectType:(NSInteger)type {
    return [Constants MaxValue1CellCharacterCount] <= self.length;
}

- (BOOL)isLongValueForSectionType:(NSInteger)type {
    return [self isLongValueForObjectType:type];
}

- (NSNumber *)numberValueForObjectType:(NSInteger)type {
    return @(self.length);
}

- (NSNumber *)numberValueForSectionType:(NSInteger)type {
    return @(self.length);
}

+ (NSArray<NSNumber *> *)objectTypesForSectionType:(NSInteger)type {
    return @[@0];
}

- (void)setValue:(NSObject *)value forObjectType:(NSInteger)type {
}

- (void)setValue:(NSObject *)value forSectionType:(NSInteger)type {
}

- (NSString *)stringValueForObjectType:(NSInteger)type {
    return self;
}

- (NSString *)stringValueForSectionType:(NSInteger)type {
    return self;
}

- (void)switchBoolValueForObjectType:(NSInteger)type {
}

- (void)switchBoolValueForSectionType:(NSInteger)type {
}

+ (NSString *)titleForObjectType:(NSInteger)type {
    return nil;
}

+ (NSString *)titleForSectionType:(NSInteger)type {
    return nil;
}

+ (NSArray<NSNumber *> *)typesForSection:(NSInteger)section {
    return @[@0];
}

- (NSObject *)valueForObjectType:(NSInteger)type {
    return self;
}

- (NSArray<NSObject *> *)valuesForSectionType:(NSInteger)type {
    return [NSArray arrayWithNullableObject:self];
}

+ (BOOL)isUppercaseStringObjectType:(NSInteger)type {
    return NO;
}

- (NSString *)badgeValueForSectionType:(NSInteger)type {
    return nil;
}

+ (BOOL)isEmailSectionType:(NSInteger)type {
    return NO;
}

+ (BOOL)isPhoneSectionType:(NSInteger)type {
    return NO;
}

+ (NSString *)localDateStringWithDate:(NSDate *)date forObjectType:(NSInteger)type {
    return nil;
}

+ (NSString *)localDateStringWithDate:(NSDate *)date {
    return nil;
}

- (NSString *)localDateStringForObjectType:(NSInteger)type {
    return nil;
}

- (BOOL)isValid {
    return YES;
}

- (void)canSaveWithResult:(VALIDATION_BLOCK)result {
}

- (void)canUpdateWithResult:(VALIDATION_BLOCK)result {
}

- (NSString *)title {
    return self;
}

+ (NSString *)missingValueErrorMessage {
    return [Constants Missing_Value_Error_Message_STR];
}

+ (NSString *)missingObjectErrorMessage {
    return [Constants Missing_Object_Error_Message_STR];
}

- (NSUInteger)floatingDigits {
    return 2;
}

@end

@implementation NSArray (Property)

- (NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)array {
    return [self isKindOfClass:[NSMutableArray class]] ? self : [self mutableCopy];
}

@end


