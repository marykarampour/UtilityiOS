//
//  GraphORM.cpp
//  GraphORM
//
//  Created by Maryam Karampour on 2017-02-14.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#include "GraphORM.hpp"

using namespace GraphORM;

#pragma mark - Graph

Graph::Graph() {
    vertices = std::vector<Vertex_ptr>();
}

Graph::~Graph() {
    
}

void Graph::addVertex(Vertex_ptr vertex) {
    vertices.push_back(vertex);
}

bool Graph::vertex_links_to(const Vertex_ptr vertex, const std::string name) {
    Vertex_ptr vx = vertex_for_name(name);
    if (vx) {
        for (auto const & dir : vertex->edges) {
            if ((dir.first.first == vx->index && dir.second.first == vertex->index) ||
                (dir.second.first == vx->index && dir.first.first == vertex->index)) {
                return true;
            }
        }
    }
    return false;
}

Vertex_ptr Graph::vertex_for_name(const std::string name) {
    for (auto & vx : vertices) {
        if (vx->name == name) {
            return vx;
        }
    }
    return nullptr;
}

Vertex_ptr Graph::vertex_for_index(Index index) {
    for (auto & vx : vertices) {
        if (vx->index == index) {
            return vx;
        }
    }
    return nullptr;
}
//TODO: should not call this if edge has index of vertex analyst and analyst_id
Vertex_ptr Graph::second_vertex_for_edge(Direction edge, Vertex_ptr vertex, bool moveForward) {
    
    for (auto const & vx : vertices) {
        if (vx != vertex) {
            for (auto const & dir : vx->edges) {
                if (dir == edge) {
                    if (moveForward) {
                        if (dir.first.first == vertex->index) {
                            return vx;
                        }
                    }
                    else {
                        if (dir.second.first == vertex->index) {
                            return vx;
                        }
                    }
                }
            }
        }
    }
    return nullptr;
}

Direction_ptr Graph::edge_connecting(Vertex_ptr v1, Vertex_ptr v2, const bool moveForward) {
    if (v1 && v2) {
        for (auto const & dir1 : v1->edges) {
            for (auto const & dir2 : v2->edges) {
                if (!moveForward && dir1.first.first == dir2.first.first) {
                    return Direction_ptr(new Direction(dir1));
                }
                else if (moveForward && dir1.second.first == dir2.second.first) {
                    return Direction_ptr(new Direction(dir1));
                }
            }
        }
    }
    return nullptr;
}

void Graph::pop_link(ReferenceLink link) {
    if (link.priorLinkIndices.size() > 1) {
        Index lastIndex = link.priorLinkIndices.back();
        Index priorIndex = link.priorLinkIndices[link.priorLinkIndices.size()-2];
        for (auto const & vx : vertices) {
            if (vx != link.vertex) {
                for (auto const & dir : vx->edges) {
                    if (dir.first.first == priorIndex && dir.second.first == lastIndex) {
                        link.priorLinkIndices.pop_back();
                        link.vertex = vx;
                        break;
                    }
                }
            }
        }
    }
}

#pragma mark - QueryGenerator

QueryGenerator::QueryGenerator(const DBTables &tables, const DBForeignKeys &foreign_keys, SQL_TYPE sql_imp) {
    
    switch (sql_imp) {
        case SQL_TYPE_SQLITE: {
            schemaColumnNameKey             = SQLITE_SCHEMA_USAGE_COLUMN_NAME;
            schemaReferenceColumnNameKey    = SQLITE_SCHEMA_USAGE_REFERENCED_COLUMN_NAME;
            schemaReferenceTableNameKey     = SQLITE_SCHEMA_USAGE_REFERENCED_TABLE_NAME;
            schemaTableColumnFieldKey       = SQLITE_SCHEMA_TABLE_COLUMN_FIELD;
            schemaTableColumnTypeKey        = SQLITE_SCHEMA_TABLE_COLUMN_TYPE;
        }
            break;
        default: {
            schemaColumnNameKey             = MYSQL_SCHEMA_USAGE_COLUMN_NAME;
            schemaReferenceColumnNameKey    = MYSQL_SCHEMA_USAGE_REFERENCED_COLUMN_NAME;
            schemaReferenceTableNameKey     = MYSQL_SCHEMA_USAGE_REFERENCED_TABLE_NAME;
            schemaTableColumnFieldKey       = MYSQL_SCHEMA_TABLE_COLUMN_FIELD;
            schemaTableColumnTypeKey        = MYSQL_SCHEMA_TABLE_COLUMN_TYPE;
        }
            break;
    }
    
    this->SQLType = sql_imp;
    this->tables = tables;
    this->foreign_keys = foreign_keys;
    graph = Graph_ptr(new Graph());
    
    Index i=0;
    for (auto const & table : foreign_keys) {
        
        Vertex_ptr vertex = Vertex_ptr(new Vertex());
        vertex->name = table.first;
        vertex->index = i;
        vertex->edges = DirVector();
        
        unsigned int primaryKeyCount = 0;
        unsigned int foreignKeyCount = 0;
        
        for (auto const & keys : table.second) {
            for (auto const & constraint : keys) {
                if (constraint.first == schemaReferenceTableNameKey) {
                    if (constraint.second == NULL_STR) {
                        primaryKeyCount ++;
                    }
                    else {
                        foreignKeyCount ++;
                    }
                }
            }
        }
        
        vertex->isLinker = (foreignKeyCount > 1 && primaryKeyCount == foreignKeyCount);
        
        graph->vertices.push_back(vertex);
        i++;
    }
    
    for (auto & vertex : graph->vertices) {
    
        for (auto const & table : foreign_keys) {
            
            for (auto const & keys : table.second) {
                
                std::string column_name;
                std::string reference_table_name;
                std::string reference_column_name;
                
                for (auto const & constraint : keys) {
                    if (constraint.first == schemaColumnNameKey) {
                        column_name = constraint.second;
                    }
                    else if (constraint.first == schemaReferenceTableNameKey) {
                        reference_table_name = constraint.second;
                    }
                    else if (constraint.first == schemaReferenceColumnNameKey) {
                        reference_column_name = constraint.second;
                    }
                }
                
                if (vertex->name == reference_table_name) {
                    
                    for (auto const & refVx : graph->vertices) {
                        //create and add direction between two connecting vertices
                        if (table.first == refVx->name) {
                            IndexString refIndString(refVx->index, column_name);
                            IndexString indString(vertex->index, reference_column_name);
                            
                            Direction dir(refIndString, indString);
                            if (!vector_contains_object(vertex->edges, dir)) {
                                vertex->edges.push_back(dir);
                            }
                            if (!vector_contains_object(refVx->edges, dir)) {
                                refVx->edges.push_back(dir);
                            }
                            
                            break;
                        }
                    }
                }
                
            }
        
        }
    }
    
    
}

bool QueryGenerator::table_has_column(std::string tableName, std::string columnName) {
    for (auto const table : tables) {
        if (table.first == tableName) {
            if (table.second.size() > 0) {
                for (auto const column : table.second) {
                    for (auto const field : column) {
                        if (field.second == columnName) {
                            return true;
                        }
                    }
                }
            }
        }
    }
    return false;
}

bool QueryGenerator::chain_contains_param(const std::string param) {
    for (auto const & link : chain) {
        if (link.vertex->name == param) {
            return true;
        }
    }
    return false;
}

#warning - maybe just make it work bsed on SQL implementation, i.e. SQLite, MySQL etc.
bool QueryGenerator::column_is_date(const std::string tableName, const std::string columnName) {
    for (auto const table : tables) {
        if (table.first == tableName) {
            if (table.second.size() > 0) {
                for (auto const column : table.second) {
                    std::string name;
                    std::string type;
                    for (auto const field : column) {
                        if (field.first == schemaTableColumnFieldKey) {
                            name = field.second;
                        }
                        else if (field.first == schemaTableColumnTypeKey) {
                            type = field.second;
                        }
                    }
                    if (name == columnName && (type == SCHEMA_TABLE_COLUMN_TYPE_DATETIME || type == SCHEMA_TABLE_COLUMN_TYPE_INTEGER_4)) {
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

bool QueryGenerator::vertex_is_final(const Vertex_ptr &vertex, const std::string param, ReferenceLink priorLink, const bool moveForward) {
    
    for (auto const & edge : vertex->edges) {
        
        if (edge.first.first == edge.second.first) {
            
//            if (!vector_contains_object(references, vertex->name)) {
//                
//                references.push_back(vertex->name);
//            }
//            ReferenceLink nextLink;
//            nextLink.vertex = vertex;
//            nextLink.priorLinkIndices = priorLink.priorLinkIndices;
//            nextLink.priorLinkIndices.push_back(vertex->index);
            
            if (vector_contains_object(chain, priorLink)) {
                //TODO: template not used
                long index = std::distance(chain.begin(), std::find(chain.begin(), chain.end(), priorLink));
                
                priorLink.priorLinkIndices.push_back(vertex->index);
                chain[index] = priorLink;
//                chain.push_back(priorLink);
            }
            
//            if (!vector_contains_object(chain, nextLink)) {
//                chain.push_back(nextLink);
//            }
            continue;
        }
        else {
            Vertex_ptr nextVertex = graph->second_vertex_for_edge(edge, vertex, moveForward);
            
            if (nextVertex) {
                if (!vector_contains_object(references, nextVertex->name)) {
                    
                    references.push_back(nextVertex->name);
                    
                    ReferenceLink nextLink;
                    nextLink.vertex = nextVertex;
                    nextLink.priorLinkIndices = priorLink.priorLinkIndices;
                    nextLink.priorLinkIndices.push_back(nextVertex->index);
                    
//                    if (!vector_contains_object(chain, nextLink)) {
                        chain.push_back(nextLink);
//                    }
//                    DEBUGLOG("next vertex is %s", nextVertex->name.c_str());
                    
                    if (vertex_is_final(nextVertex, nextVertex->name, nextLink, moveForward)) {
                        continue;
                        //                    return true;
                    }
                }
                else {
                    continue;
                }
            }
            else {
                graph->pop_link(priorLink);
                //            continue;
                //            return true;
            }

        }
        
    }
 
    return false;
}

void QueryGenerator::process_condition(const std::string tableName, const std::string columnName, StringVector items) {
        //param is a column in the given table need table name
    if (table_has_column(tableName, columnName) && items.size()) {
        std::string conditionSTR;
        if (column_is_date(tableName, columnName) && (items.size() == 2)) {
            switch (SQLType) {
                case SQL_TYPE_SQLITE: {
                    conditionSTR = string_with_format(" %s%s.%s >= %s AND %s%s.%s < %s", ALIAS_PREFIX.c_str(), tableName.c_str(), columnName.c_str(), items[0].c_str(), ALIAS_PREFIX.c_str(), tableName.c_str(), columnName.c_str(), items[1].c_str());
                    //                            conditionSTR = string_with_format(" %s%s.%s >= DATE(%s) AND %s%s.%s < DATE(%s)", ALIAS_PREFIX.c_str(), param.first.c_str(), columnData.first.c_str(), columnData.second[0].c_str(), ALIAS_PREFIX.c_str(), param.first.c_str(), columnData.first.c_str(), columnData.second[1].c_str()); this is what should be with datetime
                    
                }
                    break;
                default: {
                    conditionSTR = string_with_format(" %s%s.%s >= FROM_UNIXTIME(%s) AND %s%s.%s < FROM_UNIXTIME(%s)", ALIAS_PREFIX.c_str(), tableName.c_str(), columnName.c_str(), items[0].c_str(), ALIAS_PREFIX.c_str(), tableName.c_str(), columnName.c_str(), items[1].c_str());
                }
                    break;
            }
        }
        else {
            conditionSTR = string_with_format(" %s%s.%s IN (%s)", ALIAS_PREFIX.c_str(), tableName.c_str(), columnName.c_str(), concatenate_strings_vector(items, ", ").c_str());
        }
        
        if (!vector_contains_object(conditions, conditionSTR)) {
            conditions.push_back(conditionSTR);
        }
    }
}

void QueryGenerator::process_joins(const GraphORM::ReferenceLink link) {
    for (long i=0; i<link.priorLinkIndices.size()-1; i++) {
        
        Vertex_ptr initialVertex = graph->vertex_for_index(link.priorLinkIndices[i]);
        Vertex_ptr nextVertex = graph->vertex_for_index(link.priorLinkIndices[i+1]);
        Direction_ptr edge = graph->edge_connecting(initialVertex, nextVertex, true);
        
        if (initialVertex->index == nextVertex->index) {
            //get all elements in param for this, do a query to identify parents, divide the elemnts into two sets of parents and children
            //select * from defect d inner join defect_type dt where dt.id in (789, 790, 798, 799) and parent_id IN (select id from defect_type where id in (1, 2)) AND dt.plant_id=10;
            continue;
        }
        
        if (edge) {
            
            std::string column_name = edge->first.second;
            std::string reference_column_name = edge->second.second;
            
            std::string joinSTR = string_with_format(" INNER JOIN %s %s%s ", nextVertex->name.c_str(), ALIAS_PREFIX.c_str(), nextVertex->name.c_str());
            
            std::string onSTR = string_with_format(" ON %s%s.%s=%s%s.%s", ALIAS_PREFIX.c_str(), nextVertex->name.c_str(), reference_column_name.c_str(), ALIAS_PREFIX.c_str(), initialVertex->name.c_str(), column_name.c_str());
            
            joinSTR += onSTR;
            
            if (!vector_contains_object(joins, joinSTR)) {
                joins.push_back(joinSTR);
            }
            
        }
    }
}

std::string QueryGenerator::from_query_for_parameters(const QueryParamMap &params, const std::string tableName) {
    
    std::string query;
    
    //loop through params, loop through edges of param, and recursively their edges to find index of tablename then join all the edges
    Vertex_ptr tableVertex = graph->vertex_for_name(tableName);
#warning - this generates chain, make it a function
    if (tableVertex) {
        if (tables.count(tableName)) {
            ReferenceLink link;
            link.vertex = tableVertex;
            link.priorLinkIndices.push_back(tableVertex->index);
            chain.push_back(link);
            vertex_is_final(tableVertex, tableName, link, true);
        }
    }
    
    QueryParamMap loopParams = params;
    QueryParamMap processingParams = params;
    ReferenceChain processingChain = chain;
    
    for (auto const & link : chain) {
        for (auto const & param : loopParams) {
            if (!chain_contains_param(param.first)) {
                continue;
            }
            //process processing params and delete processed item from processingParams
            if (link.vertex->name == param.first) {
                
                StringMapStringVector processingItems;
                
                for (auto const & item : param.second) {
                    //is item a column in param vertex, and in any of vertices of chain as reference?
                    //if yes link that vertex to tablename, if true for all items remove this link from processing chain, if no join this vertex/param
                    //All of these items are no-ref columns because of structure of JSON in PQR
                    bool isReference = false;
                    
                    for (auto const & dir : link.vertex->edges) {
                        Vertex_ptr priorVertex = graph->second_vertex_for_edge(dir, link.vertex, false);
                        //have these checks in a function
                        
                        if (priorVertex && chain_contains_param(priorVertex->name) && /*vector_contains_object(excludeTableNames, priorVertex->name)*/ params.count(priorVertex->name) && item.first == dir.second.second && table_has_column(priorVertex->name, dir.second.second)) {
                            //it is reference
                            isReference = true;
                            break;
                        }
                        
                    }
                    if (!isReference) {
                        processingItems.insert(item);
                    }
                    
                }
                if (processingItems.size() == 0) {
                    //don't join, it is referenced elsewhere, remove this link, may not be needed cause we wil remove them one by one
                    vector_remove_element(processingChain, link);
                }
                else {
                    
                    QueryParamPair processingPair(param.first, processingItems);
                    
                    for (auto const & item : processingItems) {
                        process_condition(link.vertex->name, item.first, item.second);
                        processingParams[param.first].erase(item.first);
                        if (processingParams[param.first].size() == 0) {
                            processingParams.erase(param.first);
                        }
                        
                    }
                    process_joins(link);
                }
                
            }
            else {
                for (auto const & item : param.second) {
                    
                    for (auto const & dir : link.vertex->edges) {
                        Vertex_ptr priorVertex = graph->second_vertex_for_edge(dir, link.vertex, true);
                        if (priorVertex && params.count(priorVertex->name) && priorVertex->name == param.first && item.first == dir.second.second && table_has_column(priorVertex->name, dir.second.second)) {
                            //it is reference
                            process_condition(link.vertex->name, dir.first.second, item.second);
                            processingParams[param.first].erase(item.first);
                            if (processingParams[param.first].size() == 0) {
                                processingParams.erase(param.first);
                            }
                            process_joins(link);
                            break;
                        }
                        
                    }
                    
                }
                
            }
        }
        loopParams = processingParams;
    }
    
    query = string_with_format(" FROM\n  %s %s%s ", tableName.c_str(), ALIAS_PREFIX.c_str(), tableName.c_str(), ALIAS_PREFIX.c_str(), tableName.c_str());
    
    for (auto const & join : joins) {
        query += join + "\n";
    }
    
    //    if (onStrings.size() > 0) {
    //        query += " ON ";
    //    }
    //
    //    for (auto const & onSTR : onStrings) {
    //        query += onSTR;
    //        if (onSTR != onStrings.back()) {
    //            query += "\n  AND ";
    //        }
    //    }
    
    if (conditions.size() > 0) {
        query += " WHERE ";
    }
    
    for (auto const & cond : conditions) {
        query += cond;
        if (cond != conditions.back()) {
            query += "\n  AND ";
        }
    }
    
    //    query += ";";
    
    
    references.clear();
    chain.clear();
    joins.clear();
    conditions.clear();
    return query;
}

TableColumnPair QueryGenerator::pair_for_groupby(const std::string selectTableName, const TableColumnPair groupPair) {
    TableColumnPair conditionPair = groupPair;
    Vertex_ptr groupVertex = graph->vertex_for_name(groupPair.first);

    if (groupVertex != nullptr) {
        for (auto const & dir : groupVertex->edges) {
            Vertex_ptr nextVertex = graph->second_vertex_for_edge(dir, groupVertex, false);
            if (nextVertex && !nextVertex->isLinker) {
                if (dir.second.first == groupVertex->index && dir.second.second == groupPair.second) {
                    conditionPair.first = nextVertex->name;
                    conditionPair.second = dir.first.second;
                    break;
                }
            }
        }
    }
    return conditionPair;
}

std::string QueryGenerator::select_query_for_parameters(SQL_SELECT_TYPE selectType, const QueryParamMap &params, const std::string tableName, const TableColumnPair countPair, const TableColumnPair groupPair) {
    
    
    std::string selectSTR;
    std::string query = from_query_for_parameters(params, tableName);
    //TODO: for group by create params with only groub pair, iterate through links of param/group table if ref select ref table else select self, returns a TableColumnPair pair: TableColumnPair pair_for_groupby(const QueryParamMap & params, const std::string tableName, const TableColumnPair groupPair);
//TODO: warning - error for when grouppair is not supplied
    TableColumnPair groupByPair = pair_for_groupby(tableName, groupPair);
    std::string groupBySTR;
    //This option for whether track single days or daytime can come in as parameter
    //This GROUP_COLUMN_ALIAS doesn't let the column name show in results which may be desired
    if (column_is_date(groupByPair.first, groupByPair.second)) {
        groupBySTR = string_with_format("DATE(%s%s.%s) AS %s", ALIAS_PREFIX.c_str(), groupByPair.first.c_str(), groupByPair.second.c_str(), GROUP_COLUMN_ALIAS.c_str());
    }
    else {
        groupBySTR = string_with_format("%s%s.%s AS %s", ALIAS_PREFIX.c_str(), groupByPair.first.c_str(), groupByPair.second.c_str(), GROUP_COLUMN_ALIAS.c_str());
    }
    
    switch (selectType) {
        case SQL_SELECT_TYPE_COUNT: {
            query = string_with_format("SELECT COUNT(%s%s.%s) AS %s%s\n %s", ALIAS_PREFIX.c_str(), countPair.first.c_str(), countPair.second.c_str(), countPair.first.c_str(), COUNT_SUFFIX.c_str(), query.c_str());
        }
            break;
        case SQL_SELECT_TYPE_COUNT_GROUPBY: {
            query = string_with_format("SELECT COUNT(%s%s.%s) AS %s%s, %s\n %s\n GROUP BY %s", ALIAS_PREFIX.c_str(), countPair.first.c_str(), countPair.second.c_str(), countPair.first.c_str(), COUNT_SUFFIX.c_str(), groupBySTR.c_str(), query.c_str(), GROUP_COLUMN_ALIAS.c_str());
        }
            break;
        case SQL_SELECT_TYPE_COUNT_DISTINCT: {
            query = string_with_format("SELECT COUNT(DISTINCT %s%s.%s) AS %s%s\n %s", ALIAS_PREFIX.c_str(), countPair.first.c_str(), countPair.second.c_str(), countPair.first.c_str(), COUNT_SUFFIX.c_str(), query.c_str());
        }
            break;
        case SQL_SELECT_TYPE_COUNT_DISTINCT_GROUPBY: {
            query = string_with_format("SELECT COUNT(DISTINCT %s%s.%s) AS %s%s, %s\n %s\n GROUP BY %s", ALIAS_PREFIX.c_str(), countPair.first.c_str(), countPair.second.c_str(), countPair.first.c_str(), COUNT_SUFFIX.c_str(), groupBySTR.c_str(), query.c_str(), GROUP_COLUMN_ALIAS.c_str());
        }
            break;
        case SQL_SELECT_TYPE_ALL_DISTINCT: {
            query = string_with_format("SELECT DISTINCT * %s ", query.c_str());
        }
            break;
        default: {
            query = string_with_format("SELECT * %s", query.c_str());
        }
            break;
    }
    
    return query;
    
    
}

std::string QueryGenerator::average_query_for_parameters(const QueryParamMap &numParams, const QueryParamMap &denomParams, const std::string numTableName, const std::string denomTableName, const TableColumnPair numCountPair, const TableColumnPair denomCountPair, const TableColumnPair groupPair) {
    std::string query;
    std::string numQuery = select_query_for_parameters(SQL_SELECT_TYPE_COUNT_DISTINCT_GROUPBY, numParams, numTableName, numCountPair, groupPair);
    std::string denomQuery = select_query_for_parameters(SQL_SELECT_TYPE_COUNT_DISTINCT_GROUPBY, denomParams, denomTableName, denomCountPair, groupPair);
    std::string numCountAlias = numCountPair.first + COUNT_SUFFIX;
    std::string denomCountAlias = denomCountPair.first + COUNT_SUFFIX;
    TableColumnPair groupByPair = pair_for_groupby(denomTableName, groupPair);

    query = string_with_format("SELECT %s.%s / %s.%s, %s.%s\n FROM\n(%s) AS %s\n INNER JOIN\n(%s) AS %s\n ON %s.%s = %s.%s;", NUM_ALIAS.c_str(), numCountAlias.c_str(), DENOM_ALIAS.c_str(), denomCountAlias.c_str(), NUM_ALIAS.c_str(), GROUP_COLUMN_ALIAS.c_str(), denomQuery.c_str(), DENOM_ALIAS.c_str(), numQuery.c_str(), NUM_ALIAS.c_str(), NUM_ALIAS.c_str(), GROUP_COLUMN_ALIAS.c_str(), DENOM_ALIAS.c_str(), GROUP_COLUMN_ALIAS.c_str());
    
    return query;
}


//for join vectors  -  add logic for those selecting via linker tables like select from plant where analyst ...

//    if (initialVertex) {
//        for (auto const & param : params) {
//            if (vertex_is_final(initialVertex, param.first, true)) {
//                DEBUGLOG("ended");
//            }
//            else {
//loop through linkers from param, find linker vertex's next vertex forward, then process backwards
//                Vertex_ptr paramVertex = graph->vertex_for_name(param.first);
//
//                for (auto const & edge : paramVertex->edges) {
//
//                    Vertex_ptr linkVertex = graph->second_vertex_for_edge(edge, paramVertex, false);
//                    if (linkVertex && linkVertex->isLinker) {
//
//                        for (auto const & linkEdge : linkVertex->edges) {
//                            if (linkEdge != edge) {
//                                Vertex_ptr nextVertex = graph->second_vertex_for_edge(linkEdge, linkVertex, true);
//                                DEBUGLOG("next vertex is %s", nextVertex->name.c_str());
//                                if (nextVertex != paramVertex) {
//                                     vertex_is_final(nextVertex, tableName, false);
//                                }
//
//                            }
//                        }
//                    }
//                }
//                vertex_is_final(*initialVertex, param.first, false);
//            }
//        }
//    }
//
