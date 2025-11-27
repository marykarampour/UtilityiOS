//
//  MKUFieldModel.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2024-11-22.
//  Copyright © 2024 Maryam Karampour. All rights reserved.
//

#import "MKUModel.h"
#import "TextViewController.h"
#import "TextFieldController.h"
#import "MKUArrayPropertyProtocol.h"
#import "MKUDataIntegrityProtocol.h"
#import "MKUViewContentStyleProtocols.h"

@class MKUFieldModel;
@protocol MKUFieldModelDelegate;
@protocol MKUStepperFieldViewDelegate;

@protocol MKUFieldModelProtocol <NSCopying, TextFieldDelegate, TextViewDelegate, MKUStepperFieldViewDelegate>

@required
/** @brief keys are field types and values are property names */
+ (NSDictionary <NSNumber *, NSString *> *)propertyEnumDictionary;
/** @brief keys are field types and values are section types  */
+ (NSDictionary <NSNumber *, NSNumber *> *)sectionEnumDictionary;
/** @brief keys are section types and values are section titles */
+ (NSDictionary <NSNumber *, NSString *> *)titleEnumDictionary;

- (BOOL)hasValueForObjectType:(NSInteger)type;
- (BOOL)hasValueForSectionType:(NSInteger)section;
- (BOOL)boolValueForObjectType:(NSInteger)type;
- (BOOL)boolValueForSectionType:(NSInteger)section;
- (NSDate *)dateValueForObjectType:(NSInteger)type;
- (NSDate *)dateValueForSectionType:(NSInteger)section;
+ (DATE_FORMAT_STYLE)dateFormatForObjectType:(NSInteger)type;
+ (DATE_FORMAT_STYLE)dateFormatForSectionType:(NSInteger)section;
+ (MKU_TEXT_TYPE)textTypeForObjectType:(NSInteger)type;
+ (BOOL)shouldValidateWhenEditingObjectType:(NSInteger)type;
- (NSNumber *)numberValueForObjectType:(NSInteger)type;
- (NSNumber *)numberValueForSectionType:(NSInteger)section;
- (NSObject *)valueForObjectType:(NSInteger)type;
- (NSArray<NSObject *> *)valuesForSectionType:(NSInteger)section;
+ (NSString *)titleForObjectType:(NSInteger)type;
+ (NSString *)titleForSectionType:(NSInteger)section;
+ (NSArray<NSNumber *> *)typesForSection:(NSInteger)section;
- (NSString *)stringValueForObjectType:(NSInteger)type;
- (NSString *)stringValueForSectionType:(NSInteger)section;
+ (NSArray<NSNumber *> *)objectTypesForSectionType:(NSInteger)section;
- (NSString *)badgeValueForSectionType:(NSInteger)section;
/** @brief Default is 2. */
- (NSUInteger)floatingDigits;

/** @brief Uses the same format as dates being formatted by this class. */
+ (NSString *)localDateStringWithDate:(NSDate *)date;
/** @brief Uses the same format as dates being formatted by this class for object type. */
+ (NSString *)localDateStringWithDate:(NSDate *)date forObjectType:(NSInteger)type;
- (NSString *)localDateStringForObjectType:(NSInteger)type;

- (void)setValue:(NSObject *)value forObjectType:(NSInteger)type;
- (void)setValue:(NSObject *)value forSectionType:(NSInteger)section;
- (void)switchBoolValueForObjectType:(NSInteger)type;
- (void)switchBoolValueForSectionType:(NSInteger)section;
- (BOOL)isLongValueForObjectType:(NSInteger)type;
- (BOOL)isLongValueForSectionType:(NSInteger)section;
+ (BOOL)isEditableSectionType:(NSInteger)section;
+ (BOOL)isCommentSectionType:(NSInteger)section;
+ (BOOL)isUppercaseStringObjectType:(NSInteger)type;
+ (BOOL)isEmailSectionType:(NSInteger)section;
+ (BOOL)isPhoneSectionType:(NSInteger)section;

+ (NSString *)missingValueErrorMessage;
+ (NSString *)missingObjectErrorMessage;

@optional
/** @brief Call this method to send a message to updateDelegate that a value is updated. Useful in cases custom calculations require a view update.
 @param newText It is nil unless this is called as a result of shouldChangeCharactersInRange. */
- (void)dispatchUpdateDelegateWithObjectType:(NSInteger)type;

/** @brief Call this method to send a message to updateDelegate that a value is updated. Useful in cases custom calculations require a view update.
 @param newText It is nil unless this is called as a result of shouldChangeCharactersInRange. */
- (void)dispatchUpdateDelegateWithObjectType:(NSInteger)type textField:(UITextField *)textField endEditing:(BOOL)endEditing atIndexPath:(NSIndexPath *)indexPath;

/** @brief Set to implement custom updates when a value is updated. Useful in cases custom calculations require a view update. */
@property (nonatomic, weak) id<MKUFieldModelDelegate> updateDelegate;

@end

@protocol MKUMutableObjectProtocol

@required
+ (NSString *)nameForOriginalObject;
+ (NSString *)nameForUpdatedObject;
+ (Class)defaultClassForUpdatedObject;
+ (Class)defaultClassForOriginalObject;

@end

@protocol MKUUpdateObjectProtocol <MKUMutableObjectProtocol>

@optional
- (BOOL)isLongValueForSectionType:(NSInteger)section;
- (BOOL)isEditableSectionType:(NSInteger)section;
- (BOOL)hasValueForSectionType:(NSInteger)section;
- (BOOL)isCommentSectionType:(NSInteger)section;

@end

@protocol MKUFieldModelDelegate <NSObject>

@optional
- (void)object:(MKUFieldModel *)obj didUpdateObjectType:(NSInteger)type;
- (void)object:(MKUFieldModel *)obj didUpdateObjectType:(NSInteger)type textField:(UITextField *)textField endEditing:(BOOL)endEditing atIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSString (MKUFieldModel) <MKUFieldModelProtocol, MKUDataUpdateProtocol, MKUPlaceholderProtocol>

@end

@interface NSArray (Property) <MKUArrayPropertyProtocol>

@end

@interface MKUFieldModel : MKUModel <MKUFieldModelProtocol, MKUDataUpdateProtocol>

/** @brief Automatically assigned in init. Gets reset in copy. */
@property (nonatomic, strong, readonly) NSString *GUID;

+ (void)iterateOverTypesForSectionType:(NSInteger)section block:(void(^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block;

//validation
/** @brief Loops through object types in the propertyEnumDictionary and checks for objects not being nil in case of NSObject,
 and them returning YES in case of MKUModel conforming to MKUDataUpdateProtocol. Default is no types. */
- (NSArray<NSNumber *> *)saveValidationObjectTypes;

/** @brief Loops through object types in the propertyEnumDictionary and checks for objects not being nil in case of NSObject,
 and them returning YES in case of MKUModel conforming to MKUDataUpdateProtocol. Default is no types. Updates might require mandatory fields like ID, so you might want to add those types for update to what is returned from saveValidationObjectTypes. */
- (NSArray<NSNumber *> *)updateValidationObjectTypes;

/** @brief Returns an array for a property that conforms to protocol MKUArrayPropertyProtocol. */
- (NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)arrayForObjectType:(NSUInteger)type;
/** @brief Returns an array for a section corresponding to a property that conforms to protocol MKUArrayPropertyProtocol. */
- (NSMutableArray<__kindof NSObject<MKUPlaceholderProtocol> *> *)arrayForSectionType:(NSUInteger)type;

@end


@interface MKUModelID : MKUFieldModel
/** @brief By convention, COUNT is used for ID in propertyEnumDictionary and *ValidationObjectTypes, but it can have any other value. */
@property (nonatomic, strong) NSNumber *ID;

+ (instancetype)objectWithID:(NSNumber *)ID;
- (BOOL)hasID;

@end


/** @note Don't call copy on this. It will reset the UpdatedObject to OriginalObject. */
@interface MKUMutableObject <__covariant ObjectType : __kindof NSObject<NSCopying> *, __covariant UpdateObjectType : __kindof NSObject<NSCopying> *> : MKUModel <MKUMutableObjectProtocol>

@property (nonatomic, strong) ObjectType OriginalObject;
@property (nonatomic, strong) UpdateObjectType UpdatedObject;

@property (nonatomic, assign, readonly) Class classForOriginalObject;
@property (nonatomic, assign, readonly) Class classForUpdatedObject;

/** @brief This innitialization copies object.
 @note If using generics, and if object is nil, OriginalObject wlll be nil. In that case defaultClassForUpdatedObject must be provided and will be used to initialize both
 OriginalObject and UpdatedObject. Otherwise, don't use the generic types, instead redefine these properties explicitly and use @dynamic.
 The reason is that the generic type is errased in runtime and some NSObject subclasses such as NSString, when handled by OS have actual type constant, such as
 NSCFString, and might not recognize selectors such as allocWithZone otherwise used to copy these properties in case of MKUModel. */
- (instancetype)initWithObject:(ObjectType)object;
/** @brief Reinitializes both OriginalObject and UpdatedObject. */
- (void)reset;
/** @brief Only sets OriginalObject = nil. */
- (void)resetOriginalObject;
/** @brief Creates a new instance with OriginalObject = nil. Other fields are set as is, not copied. */
- (instancetype)duplicateUpdateObject;
- (BOOL)isModified;
+ (NSMutableArray *)updateObjectsWithObjects:(NSArray<ObjectType> *)objects;

@end


/** @note Don't call copy on this. It will reset the UpdatedObject to OriginalObject. */
@interface MKUUpdateObject <__covariant ObjectType : __kindof NSObject<MKUFieldModelProtocol> *, __covariant UpdateObjectType : __kindof NSObject<MKUFieldModelProtocol> *> : MKUMutableObject <ObjectType, UpdateObjectType> <MKUUpdateObjectProtocol>

@property (nonatomic, strong) ObjectType OriginalObject;
@property (nonatomic, strong) UpdateObjectType UpdatedObject;
@property (nonatomic, strong) NSNumber *UserID;

@end


@interface MKUUpdateIDObject <__covariant ObjectType : __kindof MKUModelID *, __covariant UpdateObjectType : __kindof MKUModelID *> : MKUUpdateObject <ObjectType, UpdateObjectType>

@property (nonatomic, strong) ObjectType OriginalObject;
@property (nonatomic, strong) UpdateObjectType UpdatedObject;
/** @brief Returns YES if ID of OriginalObject is nonaero. */
- (BOOL)isUpdate;
 
@end


typedef NS_OPTIONS(NSUInteger, MKU_FIELD_LIST_TYPE) {
    MKU_FIELD_LIST_TYPE_NONE  = 0,
    MKU_FIELD_LIST_TYPE_A     = 1 << 0,
    MKU_FIELD_LIST_TYPE_B     = 1 << 1,
    MKU_FIELD_LIST_TYPE_C     = 1 << 2,
    MKU_FIELD_LIST_TYPE_D     = 1 << 3,
    MKU_FIELD_LIST_TYPE_COUNT = 1 << 4
};

/** @brief A model object that supports max generic list types.
 For NSObject, override description and return the title to be presented in UI.
 If conforming to MKUPlaceholderProtocol title  will be used.
 @note If there is no items, it sets the footer to noItemAvailableTitleForListOfType: */
@interface MKUFieldListModel
<__covariant ObjectTypeA : __kindof NSObject<MKUPlaceholderProtocol> *,
 __covariant ObjectTypeB : __kindof NSObject<MKUPlaceholderProtocol> *,
 __covariant ObjectTypeC : __kindof NSObject<MKUPlaceholderProtocol> *,
 __covariant ObjectTypeD : __kindof NSObject<MKUPlaceholderProtocol> *> : MKUFieldModel

// Unfortunately we can't parametrize these because then we can't use NSArray and custom object.
@property (nonatomic, strong) NSObject <MKUArrayPropertyProtocol> *itemsA;
@property (nonatomic, strong) NSObject <MKUArrayPropertyProtocol> *itemsB;
@property (nonatomic, strong) NSObject <MKUArrayPropertyProtocol> *itemsC;
@property (nonatomic, strong) NSObject <MKUArrayPropertyProtocol> *itemsD;

/** @brief The array that itemsA returns. */
- (NSMutableArray<ObjectTypeA> *)arrayA;
/** @brief The array that itemsB returns. */
- (NSMutableArray<ObjectTypeB> *)arrayB;
/** @brief The array that itemsC returns. */
- (NSMutableArray<ObjectTypeC> *)arrayC;
/** @brief The array that itemsD returns. */
- (NSMutableArray<ObjectTypeD> *)arrayD;

@property (nonatomic, assign) MKU_FIELD_LIST_TYPE activeListTypes;

- (NSUInteger)activeListsCount;

@end


/** @brief Both OriginalObject and UpdatedObject are lists of max 4 generic types
 @note Don't call copy on this. It will reset the UpdatedObject to OriginalObject. */
@interface MKUUpdateListObject
<__covariant ObjectTypeA : __kindof NSObject<MKUPlaceholderProtocol> *,
 __covariant ObjectTypeB : __kindof NSObject<MKUPlaceholderProtocol> *,
 __covariant ObjectTypeC : __kindof NSObject<MKUPlaceholderProtocol> *,
 __covariant ObjectTypeD : __kindof NSObject<MKUPlaceholderProtocol> *> : MKUUpdateObject
<MKUFieldListModel <ObjectTypeA, ObjectTypeB, ObjectTypeC, ObjectTypeD> *, MKUFieldListModel <ObjectTypeA, ObjectTypeB, ObjectTypeC, ObjectTypeD> *> <MKUUpdateObjectProtocol>

@property (nonatomic, strong) MKUFieldListModel <ObjectTypeA, ObjectTypeB, ObjectTypeC, ObjectTypeD> *OriginalObject;
@property (nonatomic, strong) MKUFieldListModel <ObjectTypeA, ObjectTypeB, ObjectTypeC, ObjectTypeD> *UpdatedObject;

@end


@interface MKUFieldSingleListModel <__covariant ObjectType : __kindof NSObject<MKUPlaceholderProtocol> *> : MKUFieldListModel <ObjectType, NSObject<MKUPlaceholderProtocol> *, NSObject<MKUPlaceholderProtocol> *, NSObject<MKUPlaceholderProtocol> *>

@property (nonatomic, strong) NSMutableArray <ObjectType> *itemsA;

@end

@interface MKUUpdateSingleListObject <__covariant ObjectType : __kindof NSObject<MKUPlaceholderProtocol> *> : MKUUpdateListObject
<ObjectType, NSObject<MKUPlaceholderProtocol> *, NSObject<MKUPlaceholderProtocol> *, NSObject<MKUPlaceholderProtocol> *>

@property (nonatomic, strong) MKUFieldSingleListModel <ObjectType> *OriginalObject;
@property (nonatomic, strong) MKUFieldSingleListModel <ObjectType> *UpdatedObject;

@end


@interface MKUCommentModel : MKUFieldModel

@property (nonatomic, strong) NSString *Notes;

@end

@interface MKUCommentUpdateObject : MKUUpdateObject

@property (nonatomic, strong) MKUCommentModel *OriginalObject;
@property (nonatomic, strong) MKUCommentModel *UpdatedObject;

@end

