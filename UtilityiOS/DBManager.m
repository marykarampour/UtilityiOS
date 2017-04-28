//
//  DBManager.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-24.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager ()

@property (nonatomic, strong) NSString *DBname;
@property (nonatomic, strong) NSString *DBDirectory;
@property (nonatomic, strong) NSString *DBPath;
@property (nonatomic, assign) sqlite3 *ppDb;

@property (nonatomic, strong) NSMutableArray *columns;
@property (nonatomic, assign) int affectedRowsCount;
@property (nonatomic, assign) long long lastInsertedRowID;
@property (nonatomic, strong) NSMutableArray *results;

@end

@implementation DBManager

- (instancetype)initWithDBFile:(NSString *)name {
    if (self = [super init]) {
        _DBDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        _DBname = name;
        _results = [[NSMutableArray alloc] init];
        _columns = [[NSMutableArray alloc] init];
        NSString *filename = [NSString stringWithFormat:@"%@.db", name];
        _DBPath = [_DBDirectory stringByAppendingPathComponent:filename];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_DBPath]) {
            [[NSFileManager defaultManager] createFileAtPath:_DBPath contents:nil attributes:nil];
        }
    }
    return self;
}

- (void)createTable:(NSString *)tableName withStatement:(NSString *)statement {
    
    const char *path = [_DBPath UTF8String];
    if (sqlite3_open(path, &_ppDb) == SQLITE_OK) {
        
        NSString *str = [NSString stringWithFormat:exec_create_table, tableName, statement];
        const char *sql_statement = [str UTF8String];
        char *error;
        int result = sqlite3_exec(_ppDb, sql_statement, NULL, NULL, &error);
        if (result != SQLITE_OK) {
            DEBUGLOG(@"Failed to create table %@ %s", tableName, error);
        }
        sqlite3_close(_ppDb);
    }
    else {
        DEBUGLOG(@"Failed to open/create table!");
    }
}

- (void)createDB:(NSDictionary *)tables {
    DEBUGLOG(@"DB Path: %@", _DBPath);
    for (NSString *tableName in [tables allKeys]) {
        [self createTable:tableName withStatement:[tables objectForKey:tableName]];
    }
}

- (void)dropDB {
    if ([[NSFileManager defaultManager] fileExistsAtPath:_DBPath]) {
        NSError *error;
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_DBPath error:&error];
        if (!success) {
            DEBUGLOG(@"Error removing document at path: %@", error.localizedDescription);
        }
    }
}

- (void)clearTable:(NSString *)tableName {
    [self runQuery:[[NSString stringWithFormat:exec_clear_table, tableName] UTF8String] withParameters:nil isExecutable:YES];
}

- (BOOL)runQuery:(const char *)query withParameters:(NSDictionary *)parameters isExecutable:(BOOL)isExecutable {
    
    BOOL success = YES;

    _results = [[NSMutableArray alloc] init];
    _columns = [[NSMutableArray alloc] init];
    
    int openDBResult = sqlite3_open([_DBPath UTF8String], &_ppDb);
    if (openDBResult == SQLITE_OK) {
        
        sqlite3_stmt *compliedStatement;
        int prepareStatementResult = sqlite3_prepare_v2(_ppDb, query, -1, &compliedStatement, NULL);
        if (prepareStatementResult == SQLITE_OK) {
            
            if (parameters) {
                NSArray *keys = [parameters allKeys];
                for (unsigned int i=1; i<=keys.count; i++) {
                    sqlite3_bind_value(compliedStatement, i, (__bridge const sqlite3_value *)(parameters[keys[i]]));
                }
            }
            
            if (!isExecutable) {
                
                while (sqlite3_step(compliedStatement) == SQLITE_ROW) {
                    
                    NSMutableArray *rowsData = [[NSMutableArray alloc] init];
                    int totalColumnsCount = sqlite3_column_count(compliedStatement);
                    for (unsigned int i=0; i<totalColumnsCount; i++) {
                        
                        char *dataChars = (char *)sqlite3_column_text(compliedStatement, i);
                        if (dataChars) {
                            [rowsData addObject:[NSString stringWithUTF8String:dataChars]];
                        }
                        if (_columns.count != totalColumnsCount) {
                            char *columnName = (char *)sqlite3_column_name(compliedStatement, i);
                            if (columnName) {
                                NSString *name = [NSString stringWithUTF8String:columnName];
                                if (![_columns containsObject:name]) {
                                    [_columns addObject:name];
                                }
                            }
                        }
                    }
                    
                    if (rowsData.count > 0) {
                        [_results addObject:rowsData];
                    }
                }
            }
            else {
                int executeResults = sqlite3_step(compliedStatement);
                if (executeResults == SQLITE_DONE) {
                    _affectedRowsCount = sqlite3_changes(_ppDb);
                    _lastInsertedRowID = sqlite3_last_insert_rowid(_ppDb);
                }
                else {
                    DEBUGLOG(@"Error executing query: %s", sqlite3_errmsg(_ppDb));
                    success = NO;
                }
            }
        }
        else {
            DEBUGLOG(@"Error executing query: %s", sqlite3_errmsg(_ppDb));
            success = NO;
        }
        sqlite3_finalize(compliedStatement);
    }
    sqlite3_close(_ppDb);
    return success;
}

- (NSArray *)loadData:(NSString *)query {
    [self runQuery:[query UTF8String] withParameters:nil isExecutable:NO];
    return _results;
}

- (BOOL)executeQuery:(NSString *)query {
    return [self runQuery:[query UTF8String] withParameters:nil isExecutable:YES];
}

- (NSArray *)loadData:(NSString *)query withParameters:(NSDictionary *)parameters {
    [self runQuery:[query UTF8String] withParameters:parameters isExecutable:NO];
    return _results;
}

- (BOOL)executeQuery:(NSString *)query withParameters:(NSDictionary *)parameters {
    return [self runQuery:[query UTF8String] withParameters:parameters isExecutable:YES];
}

- (BOOL)columnExists:(NSString *)column {
    
    sqlite3_stmt *select_statement;
    NSString *str = [NSString stringWithFormat:@"SELECT %@ FROM %@", column, _DBname];
    const char *sql_statement = [str UTF8String];
    
    if (sqlite3_prepare_v2(_ppDb, sql_statement, -1, &select_statement, NULL) == SQLITE_OK) {
        return YES;
    }
    return NO;
}

@end
