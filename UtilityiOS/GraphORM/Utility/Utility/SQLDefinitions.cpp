//
//  SQLDefinitions.cpp
//  MySQLAPI
//
//  Created by Maryam Karampour on 2017-02-15.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#include "SQLDefinitions.hpp"

const std::string & GET_TABLES_QUERY = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=\"%s\";";
const std::string & DESCRIBE_TABLE_QUERY = "describe %s;";
const std::string & GET_TABLE_FOREIGN_KEYS_QUERY = "SELECT COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA=\"%s\" AND TABLE_NAME=\"%s\"";// AND REFERENCED_TABLE_NAME IS NOT NULL";



const std::string & ALIAS_PREFIX = "a_";
const std::string & COUNT_SUFFIX = "_COUNT";
const std::string & NULL_STR = "NULL";
const std::string & NUM_ALIAS = "NUM_VALUE";
const std::string & DENOM_ALIAS = "DENOM_VALUE";
const std::string & GROUP_COLUMN_ALIAS = "GROUP_COLUMN";

const std::string & MYSQL_SCHEMA_USAGE_COLUMN_NAME = "COLUMN_NAME";
const std::string & MYSQL_SCHEMA_USAGE_REFERENCED_TABLE_NAME = "REFERENCED_TABLE_NAME";
const std::string & MYSQL_SCHEMA_USAGE_REFERENCED_COLUMN_NAME = "REFERENCED_COLUMN_NAME";
const std::string & MYSQL_SCHEMA_TABLE_COLUMN_FIELD = "Field";
const std::string & MYSQL_SCHEMA_TABLE_COLUMN_TYPE = "Type";

const std::string & SQLITE_SCHEMA_USAGE_COLUMN_NAME = "from";
const std::string & SQLITE_SCHEMA_USAGE_REFERENCED_TABLE_NAME = "table";
const std::string & SQLITE_SCHEMA_USAGE_REFERENCED_COLUMN_NAME = "to";
const std::string & SQLITE_SCHEMA_TABLE_COLUMN_FIELD = "name";
const std::string & SQLITE_SCHEMA_TABLE_COLUMN_TYPE = "type";

const std::string & SCHEMA_TABLE_COLUMN_TYPE_DATETIME = "datetime";
#warning - this needs to be conveted to datetime in SQLite
const std::string & SCHEMA_TABLE_COLUMN_TYPE_INTEGER_4 = "integer(4)";
