//
//  SQLConstants.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "SQLConstants.h"

NSString * const db_version_key                 = @"db_version_key";
NSString * const db_version                     = @"1.0.0";
NSString * const db_name                        = @"db";
NSString * const db_last_sync_time              = @"db_last_sync_time";

#pragma mark - tables

NSString * const table                          = @"table";

#pragma mark - create db

NSString * const create_table                   = @"";

#pragma mark - execute queries

NSString * const exec_create_table              = @"CREATE TABLE IF NOT EXISTS %@ %@";

NSString * const exec_clear_table               = @"DELETE FROM %@";
NSString * const exec_drop_table                = @"DROP TABLE %@";

NSString * const exec_PARGMA_table_info         = @"PRAGMA table_info(\"%@\")";
NSString * const exec_PRAGMA_foreign_key_list   =  @"PRAGMA foreign_key_list(\"%@\")";

NSString * const exec_insert                    = @"INSERT INTO %@ (%@) VALUES (%@)";
NSString * const exec_update                    = @"UPDATE %@ SET %@ WHERE %@";
NSString * const exec_delete                    = @"DELETE FROM %@ WHERE %@";

@implementation SQLConstants

+ (DictStringString *)tableCreatePairs {
    return @{
             table:create_table
             };
}

@end
