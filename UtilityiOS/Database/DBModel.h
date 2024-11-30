//
//  DBModel.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKUModel.h"
#import "MKUPair.h"
#import "MKUDateRange.h"

@interface DBModel : MKUModel

@property (nonatomic, strong) NSString *operationType;

- (NSString *)SQLKeysEqualValues;
- (__kindof MKUKeyValue *)SQLKeysWithValues;
+ (NSString *)classIDName;
//+ (NSString *)createTableQuery;

/** @brief column name format, subclass can override for custom format */
+ (StringFormat)dbColumnNameFormat;
/** @brief property name format, subclass can override for custom format */
+ (StringFormat)dbPropertyNameFormat;
/** @brief class name from table, e.g. table --> ABCTable, subclass can override for custom format, default capitalized camel case */
+ (NSString *)dbClassNameForTable:(NSString *)table;
/** @brief table name from class, e.g. ABCTable ---> table, subclass can override for custom format, default underscore */
+ (NSString *)dbTableName;
/** @brief property name from class, e.g. ABCTableType ---> tableType, subclass can override for custom format, default camel case */
+ (NSString *)dbPropertyName;

@end

@protocol DBPrimaryModelProtocol <NSObject>

@required
@property (nonatomic, strong) id Id;

- (NSString *)IDString;

@end

@interface DBStaticModel : DBModel

@end


typedef NS_ENUM(NSUInteger, SYNC_STATUS_TYPE) {
    SYNC_STATUS_TYPE_I,
    SYNC_STATUS_TYPE_N,
    SYNC_STATUS_TYPE_P
};

typedef NSString * SYNC_STATUS_NAME;


@interface DBDynamicModel : DBModel

@property (nonatomic, strong) NSString *syncStatus;

+ (SYNC_STATUS_NAME)nameForSyncStatus:(SYNC_STATUS_TYPE)type;
+ (SYNC_STATUS_TYPE)typeForSyncName:(SYNC_STATUS_NAME)name;


@end

@interface DBStaticPrimaryModel : DBStaticModel <DBPrimaryModelProtocol>

@property (nonatomic, strong) NSNumber *Id;

@end

@interface DBDynamicPrimaryModel : DBDynamicModel <DBPrimaryModelProtocol>

@property (nonatomic, strong) NSString *Id;

- (void)setID;

@end


@interface DBDynamicCompositePrimaryModel : DBDynamicModel <DBPrimaryModelProtocol>

@property (nonatomic, strong) NSNumber *Id;

@end

//combine both date and non-date columns, make these subclass, values id dynamic
/** @brief both name and values are needed if column is not an object, only pass objects as values without name */
@interface DBColumn : NSObject <NSCopying>

@property (nonatomic, strong) NSString *name;
/** @brief if it is _kindof DBModel<DBPrimaryModelProtocol> the column is used as foreign key of table of the class of value */
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, assign) BOOL isNull;

+ (DBColumn *)columnWithName:(NSString *)name values:(NSArray *)values;

/** @brief creates an array of columns with name and single value */
+ (NSArray <DBColumn *> *)columnsWithNames:(StringArr *)names values:(StringArr *)values;

@end

@interface DBIntervalColumn : NSObject <NSCopying>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) MKUInterval *values;
@property (nonatomic, assign) BOOL isNull;

@end
