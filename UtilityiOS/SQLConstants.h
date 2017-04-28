//
//  SQLConstants.h
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-26.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QUERY_TYPE) {
    QUERY_TYPE_NONE = -1,
    QUERY_TYPE_INSERT,
    QUERY_TYPE_UPDATE,
    QUERY_TYPE_DELETE,
};

#pragma mark - db definitions

extern NSString * const db_version_key;             
extern NSString * const db_version;                 
extern NSString * const db_name;
extern NSString * const db_last_sync_time;

#pragma mark - tables

extern NSString * const table;

#pragma mark - execute queries

extern NSString * const exec_create_table;          

extern NSString * const exec_clear_table;           
extern NSString * const exec_drop_table;

extern NSString * const exec_PARGMA_table_info;
extern NSString * const exec_PRAGMA_foreign_key_list;

extern NSString * const exec_insert;
extern NSString * const exec_update;
extern NSString * const exec_delete;


@interface SQLConstants : NSObject

+ (DictStringString *)tableCreatePairs;

@end
