//
//  SQLDefinitions.hpp
//  MySQLAPI
//
//  Created by Maryam Karampour on 2017-02-15.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#ifndef SQLDefinitions_hpp
#define SQLDefinitions_hpp

#include "GORMUtility.hpp"

//TODO: separate between public and private header
//Queries
extern const std::string & GET_TABLES_QUERY;
extern const std::string & DESCRIBE_TABLE_QUERY;
extern const std::string & GET_TABLE_FOREIGN_KEYS_QUERY;

//Other Constants
extern const std::string & ALIAS_PREFIX;
extern const std::string & COUNT_SUFFIX;
extern const std::string & NULL_STR;
extern const std::string & NUM_ALIAS;
extern const std::string & DENOM_ALIAS;
extern const std::string & GROUP_COLUMN_ALIAS;

extern const std::string & MYSQL_SCHEMA_USAGE_COLUMN_NAME;
extern const std::string & MYSQL_SCHEMA_USAGE_REFERENCED_TABLE_NAME;
extern const std::string & MYSQL_SCHEMA_USAGE_REFERENCED_COLUMN_NAME;
extern const std::string & MYSQL_SCHEMA_TABLE_COLUMN_FIELD;
extern const std::string & MYSQL_SCHEMA_TABLE_COLUMN_TYPE;

extern const std::string & SQLITE_SCHEMA_USAGE_COLUMN_NAME;
extern const std::string & SQLITE_SCHEMA_USAGE_REFERENCED_TABLE_NAME;
extern const std::string & SQLITE_SCHEMA_USAGE_REFERENCED_COLUMN_NAME;
extern const std::string & SQLITE_SCHEMA_TABLE_COLUMN_FIELD;
extern const std::string & SQLITE_SCHEMA_TABLE_COLUMN_TYPE;

extern const std::string & SCHEMA_TABLE_COLUMN_TYPE_DATETIME;
extern const std::string & SCHEMA_TABLE_COLUMN_TYPE_INTEGER_4;

//Types

typedef std::pair<std::string, std::string> TableFieldCell;
typedef std::vector<TableFieldCell>         TableField;
typedef std::vector<TableField>             Table;
typedef std::pair<std::string, Table>       TableNameValuePair;

typedef std::map<std::string, Table>        TableNameMap;
typedef TableNameMap                        DBTables;
typedef TableNameMap                        DBForeignKeys;

typedef std::pair<std::string, StringMapStringVector> QueryParamPair;
typedef std::map<std::string, StringMapStringVector> QueryParamMap;

typedef std::pair<std::string, std::string> TableColumnPair;

typedef enum {
    SQL_TYPE_MYSQL,
    SQL_TYPE_SQLITE
} SQL_TYPE;

typedef enum {
    SQL_SELECT_TYPE_ALL,
    SQL_SELECT_TYPE_ALL_DISTINCT,
    SQL_SELECT_TYPE_COUNT,
    SQL_SELECT_TYPE_COUNT_DISTINCT,
    SQL_SELECT_TYPE_COUNT_GROUPBY,
    SQL_SELECT_TYPE_COUNT_DISTINCT_GROUPBY,
//    SQL_SELECT_TYPE_TABLES_COLUMNS,
//    SQL_SELECT_TYPE_COUNT_TABLES_COLUMNS
    
}SQL_SELECT_TYPE;

#endif /* SQLDefinitions_h */
