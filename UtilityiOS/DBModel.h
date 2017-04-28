//
//  DBModel.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "MKModel.h"
#import "MKPair.h"

@interface DBVarChar : MKModel

@property (nonatomic, strong) NSString *varchar;
@property (nonatomic, assign) NSUInteger length;

@end

@interface DBChar : MKModel

@property (nonatomic, strong) NSString *vchar;
@property (nonatomic, assign) NSUInteger length;

@end

@interface DBNumber : MKModel

@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, assign) NSUInteger length;

@end

@interface DBText : MKModel

@property (nonatomic, strong) NSString *text;

@end

@interface DBEnumValue<__covariant ObjctType> : MKModel

@property (nonatomic, strong) ObjctType value;
@property (nonatomic, assign) Class type;//type is same as ObjctType

@end

@interface DBEnum<__covariant ObjctType> : MKModel

@property (nonatomic, strong) NSArray<DBEnumValue<ObjctType> *> *values;

@end

@interface DBForeignKey : MKModel

@property (nonatomic, strong) NSString *columnName;
@property (nonatomic, strong) NSString *referencedColumnName;
@property (nonatomic, strong) NSString *referencedTableName;

@end

/**  **/

@interface DBModel : MKModel

- (NSString *)SQLKeysEqualValues;
- (MKPair *)SQLKeysWithValues;
//+ (NSString *)createTableQuery;

@end

@interface DBORM : NSObject



@end

