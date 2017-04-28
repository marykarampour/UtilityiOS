//
//  SampleTable.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "DBModel.h"

@interface SampleTable : DBModel

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) DBVarChar *name;
@property (nonatomic, strong) DBChar *fixedToken;
@property (nonatomic, strong) DBText *text;
@property (nonatomic, strong) DBEnumValue<NSNumber *> *status;
@property (nonatomic, strong) DBEnumValue<DBVarChar *> *operationType;

@property (nonatomic, strong) DBForeignKey *parentId;

@end

