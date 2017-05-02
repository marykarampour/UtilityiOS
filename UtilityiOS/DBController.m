//
//  DBORM.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "DBController.h"
#import "ModelIncludeHeaders.h"
#import "NSString+Utility.h"

@implementation DBController

+ (DBController *)instance {
    static DBController *db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[self alloc] init];
    });
    return db;
}

- (instancetype)init {
    if (self = [super init]) {
        _dbManager = [[DBManager alloc] initWithDBFile:db_name];
    }
    return self;
}

- (BOOL)dbVersionIsUpToDate {
    BOOL updated = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *dbVersion = [defaults stringForKey:db_version_key];
    if (!dbVersion || ![dbVersion isEqualToString:db_version]) {
        updated = NO;
    }
    return updated;
}

- (void)initializeDB {
    [_dbManager createDB:[SQLConstants tableCreatePairs]];
}

- (void)resetDB {
    [_dbManager dropDB];
    [self initializeDB];
    [self resetDBVersionSyncTime];
}

- (void)updateDB {
    //Do the update
    [self resetDBVersionSyncTime];
}

- (void)resetDBVersionSyncTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:db_version forKey:db_version_key];
    [defaults setObject:@0 forKey:db_last_sync_time];
    [defaults synchronize];
}

#pragma mark - execute

- (void)execute:(QUERY_TYPE)query objects:(NSArray<DBModel *> *)data {
    switch (query) {
        case QUERY_TYPE_INSERT:
            [self insertObjects:data];
            break;
        case QUERY_TYPE_UPDATE:
            [self updateObjects:data];
            break;
        case QUERY_TYPE_DELETE:
            [self deleteObjects:data];
            break;
        default:
            break;
    }
}

- (void)insertObjects:(NSArray<DBModel *> *)data {
    
    for (DBModel *object in data) {
        Class className = [object class];
        if (![className isSubclassOfClass:[DBModel class]]) {
            return;
        }
        
        MKPair *keyValues = [object SQLKeysWithValues];
        if (keyValues.key.length) {
            NSString *stmt = [NSString stringWithFormat:exec_insert, [self tableNameForClass:className], keyValues.key, keyValues.value];
            DEBUGLOG(@"%@", stmt);
            [self.dbManager executeQuery:stmt];
        }
    }
}

- (void)updateObjects:(NSArray<DBModel *> *)data {
    
    for (DBModel *object in data) {
        Class className = [object class];
        if (![className isSubclassOfClass:[DBModel class]]) {
            return;
        }
        
        NSString *keyValues = [object SQLKeysEqualValues];
        NSString *where = [self whereStringForIUD:object];
        if (keyValues.length) {
            NSString *stmt = [NSString stringWithFormat:exec_update, [self tableNameForClass:className], keyValues, where];
            DEBUGLOG(@"%@", stmt);
            [self.dbManager executeQuery:stmt];
        }
    }
}

- (void)deleteObjects:(NSArray<DBModel *> *)data {
    
    for (DBModel *object in data) {
        Class className = [object class];
        if (![className isSubclassOfClass:[DBModel class]]) {
            return;
        }
        
        NSString *where = [self whereStringForIUD:object];
        if (where.length) {
            NSString *stmt = [NSString stringWithFormat:exec_insert, [self tableNameForClass:className], where];
            DEBUGLOG(@"%@", stmt);
            [self.dbManager executeQuery:stmt];
        }
    }
}

#pragma mark - query helpers

- (NSString *)whereStringForIUD:(DBModel *)object {
    Class className = [object class];
    NSArray<NSString *> *columnNames =  [self primaryColumnsForTable:[self tableNameForClass:className]];
    NSMutableString *whereString = [@"" mutableCopy];
   
    for (NSString *name in columnNames) {
        [whereString appendString:[NSString stringWithFormat:@"%@=\"%@\"", name, [object valueForKey:[object convertToProperty:name]]]];
        if (![name isEqualToString:columnNames.lastObject]) {
            [whereString appendString:@" AND "];
        }
    }
    return whereString;
}

- (NSArray<NSString *> *)primaryColumnsForTable:(NSString *)tableName {
    NSArray *columns = [self.dbManager loadData:[NSString stringWithFormat:exec_PARGMA_table_info, tableName]];
    NSMutableArray *columnNames = [[NSMutableArray alloc] init];
    for (NSDictionary *column in columns) {
        if ([column isKindOfClass:[NSDictionary class]]) {
            NSString *name = column[@"name"];
            NSString *pk = column[@"pk"];
            if (name.length && pk.length && [[pk stringToNumber] compare:@0] == NSOrderedDescending) {
                [columnNames addObject:name];
            }
        }
    }
    return columnNames;
}

#pragma - schema

- (DictStringDictStringString *)foreignKeys {
    MDictStringDictStringString *keys = [[NSMutableDictionary alloc] init];
    for (NSString *table in [SQLConstants tableCreatePairs].allKeys) {
        ArrDictStringString *result = [self.dbManager loadData:[NSString stringWithFormat:exec_PRAGMA_foreign_key_list, table]];
        [keys setObject:result forKey:table];
    }
    
    return keys;
}

- (DictStringDictStringString *)tables {
    MDictStringDictStringString *keys = [[NSMutableDictionary alloc] init];
    for (NSString *table in [SQLConstants tableCreatePairs].allKeys) {
        ArrDictStringString *result = [self.dbManager loadData:[NSString stringWithFormat:exec_PARGMA_table_info, table]];
        [keys setObject:result forKey:table];
    }
    
    return keys;
}

#pragma mark - helpers

- (NSString *)tableNameForClass:(Class)objectClass {
    return [NSStringFromClass(objectClass) format:StringFormatUnderScoreIgnoreDigits];
}

@end
