//
//  GraphLib.m
//  UtilityiOS
//
//  Created by Maryam Karampour on 2017-04-30.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#import "GraphLib.h"
#include "DBController.h"
#import "NSObject+CPPNSObject.h"
#import <objc/runtime.h>
#include "GraphORM.hpp"

//in SQL difs
typedef std::shared_ptr<QueryParamMap> QueryParamMapPTR;


@interface GraphLib ()

@end

@implementation GraphLib

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (DBTables)schemaTables {
    DictStringDictStringString *tablesDict = [[DBController instance] tables];
    DBTables tables;
    
    for (NSString *tableName in tablesDict) {
        Table table;
        for (NSDictionary *column in tablesDict[tableName]) {
            TableField field;
            for (NSString *fieldName in column.allKeys) {
                std::string name = [NSObject NSStringToCPPString:fieldName];
                std::string value = [NSObject NSStringToCPPString:column[fieldName]];
                TableFieldCell cell(name, value);
                field.push_back(cell);
            }
            table.push_back(field);
        }
        std::string pairName = [NSObject NSStringToCPPString:tableName];
        tables.insert(TableNameValuePair(pairName, table));
    }
    
    return tables;
}

- (DBForeignKeys)schemaForeignkeys {
    DictStringDictStringString *foreignkeysDict = [[DBController instance] foreignKeys];
    DBForeignKeys foreignkeys;
    
    for (NSString *keys in foreignkeysDict) {
        Table table;
        for (NSDictionary *column in foreignkeysDict[keys]) {
            TableField field;
            for (NSString *fieldName in column.allKeys) {
                std::string name = [NSObject NSStringToCPPString:fieldName];
                
                if (name == SQLITE_SCHEMA_USAGE_COLUMN_NAME ||
                    name == SQLITE_SCHEMA_USAGE_REFERENCED_TABLE_NAME ||
                    name == SQLITE_SCHEMA_USAGE_REFERENCED_COLUMN_NAME) {
                    
                    std::string value = [NSObject NSStringToCPPString:column[fieldName]];
                    TableFieldCell cell(name, value);
                    field.push_back(cell);
                }
            }
            if (field.size()>0) {
                table.push_back(field);
            }
        }
        std::string pairName = [NSObject NSStringToCPPString:keys];
        foreignkeys.insert(TableNameValuePair(pairName, table));
    }
    
    return foreignkeys;
}

- (DictStringDictStringStringArr *)queryParametersDict:(QueryParamMapPTR)paramsMap {
    
    MDictStringDictStringStringArr *paramsDict = [[MDictStringDictStringStringArr alloc] init];
    
    for (auto const & param : *paramsMap) {
        
        MDictStringStringArr *itemsDict = [[MDictStringStringArr alloc] init];
        NSString *parameName = [NSObject CPPStringToNSString:param.first];
        
        for (auto const & item : param.second) {
            
            MStringArr *arr = [[MStringArr alloc] init];
            NSString *key = [NSObject CPPStringToNSString:item.first];
            
            for (auto const & value : item.second) {
                NSString *valueStr = [NSObject CPPStringToNSString:value];
                [arr addObject:valueStr];
            }
            
            [itemsDict setObject:arr forKey:key];
        }
        
        [paramsDict setObject:itemsDict forKey:parameName];
    }
    
    return paramsDict;
}

- (QueryParamMapPTR)queryParametersMap:(DictStringDictStringStringArr *)paramsDict {
    
    QueryParamMapPTR paramsMap = QueryParamMapPTR(new QueryParamMap());

    for (NSString *param in paramsDict.allKeys) {
        StringMapStringVector itemsVect;
        std::string parameName = [NSObject NSStringToCPPString:param];
        DictStringStringArr *items = paramsDict[param];
        
        for (NSString *item in items.allKeys) {
            StringVector vect;
            std::string key = [NSObject NSStringToCPPString:item];
            
            for (NSString *value in items[item]) {
                std::string valueStr = [NSObject NSStringToCPPString:value];
                vect.push_back(valueStr);
            }
            itemsVect.insert(StringPairStringVector(key, vect));
        }
        paramsMap->insert(QueryParamPair(parameName, itemsVect));
    }

    return paramsMap;
}

- (NSString *)queryForParameters:(DictStringDictStringStringArr *)paramsDict tableName:(NSString *)tableName {
    DBTables tables = [self schemaTables];
    DBForeignKeys foreignKeys = [self schemaForeignkeys];
    
    GraphORM::QueryGenerator graph(tables, foreignKeys, SQL_TYPE_SQLITE);
    QueryParamMap paramsMap = *[self queryParametersMap:paramsDict];
    std::string tableNameStr = [NSObject NSStringToCPPString:tableName];
    
    NSString *query = [NSObject CPPStringToNSString:graph.select_query_for_parameters(SQL_SELECT_TYPE_ALL, paramsMap, tableNameStr, TableColumnPair(), TableColumnPair())];
    return query;
}

@end
