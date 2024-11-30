//
//  GraphORM.hpp
//  GraphORM
//
//  Created by Maryam Karampour on 2017-02-14.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#ifndef GraphORM_hpp
#define GraphORM_hpp

#include <stdio.h>
#include <vector>
#include "SQLDefinitions.hpp"

//#pragma GCC visibility push(default)

namespace GraphORM {
    
    typedef std::vector<Direction> DirVector;

    class Vertex {
        
    public:
        DirVector edges;
        Index index;
        std::string name;
        bool isLinker;
        
        bool operator==(Vertex &v1) {
            if (this->isLinker != v1.isLinker) {
                return false;
            }
            if (this->name != v1.name) {
                return false;
            }
            if (this->index != v1.index) {
                return false;
            }
            if (this->edges != v1.edges) {
                return false;
            }
            return true;
        }
        bool operator!=(Vertex &v1) {
            return !(*this == v1);
        }
    };


    typedef std::shared_ptr<Vertex> Vertex_ptr;
    
    class ReferenceLink {
    public:
        Vertex_ptr vertex;
        IndexVector priorLinkIndices;
        
        bool operator==(ReferenceLink &link) {
            if (*this->vertex != *link.vertex) {
                return false;
            }
            if (!compare_vecotrs(this->priorLinkIndices, link.priorLinkIndices)) {
                return false;
            }
            return true;
        }
        bool operator==(const ReferenceLink &link) {
            if (*this->vertex != *link.vertex) {
                return false;
            }
            if (!compare_vecotrs(this->priorLinkIndices, link.priorLinkIndices)) {
                return false;
            }
            return true;
        }//not working, fix
        bool operator!=(ReferenceLink &link) {
            return !(*this == link);
        }
        bool operator!=(const ReferenceLink &link) {
            return !(*this == link);
        }
    };
    
    typedef std::vector<ReferenceLink> ReferenceChain;

    /* @brief An ORM-like Graph designed for mapping the structure of a database. The databse should follow some conventions:
        1. Linker tables have a couple of FK/PKs and no other PK
        2. Any direct link via FK between two tables is one direction, no two sided direction is allowed (this is to make sure maximum optimisation)
        3. There should not be a circular one directional direct or indirect reference between tables like A->B->C->A through FKs
        4. Linkers are only used for many to many relations, NOT to make indirect one directional connections where FK can provide such a connection
        5. If a table references itself, the reference column is NULL in rows where referenced by other rows (parent-child relation)
        6. QueryParamMap All of these items are no-ref columns i.e. not FK
     */
    class Graph {
        
    public:
        std::vector<Vertex_ptr> vertices;
        
        Graph();
        ~Graph();
        
        void addVertex(Vertex_ptr vertex);
        void pop_link(ReferenceLink link);
        
        bool vertex_links_to(const Vertex_ptr vertex, const std::string name);
        Vertex_ptr vertex_for_name(const std::string name);
        Vertex_ptr vertex_for_index(Index index);
        Vertex_ptr second_vertex_for_edge(const Direction edge, Vertex_ptr vertex, const bool moveForward);
        Direction_ptr edge_connecting(Vertex_ptr v1, Vertex_ptr v2, const bool moveForward);
    };

    typedef std::unique_ptr<Graph> Graph_ptr;

    class QueryGenerator {
        Graph_ptr graph;
        //TODO: make these smart pointers?
        StringVector references;
        ReferenceChain chain;
        StringVector joins;
        StringVector conditions;
//        StringVector onStrings;
        
        std::string schemaColumnNameKey;
        std::string schemaReferenceColumnNameKey;
        std::string schemaReferenceTableNameKey;
        std::string schemaTableColumnFieldKey;
        std::string schemaTableColumnTypeKey;
        
        SQL_TYPE SQLType;
        //TODO: make this graph and remove these
        DBTables tables;
        DBForeignKeys foreign_keys;
        
        bool vertex_is_final(const Vertex_ptr &vertex, const std::string param, ReferenceLink priorLink, const bool moveForward);
        bool table_has_column(const std::string tableName, const std::string columnName);
        bool column_is_date(const std::string tableName, const std::string columnName);
        bool table_is_linker(const std::string tableName);
        bool chain_contains_param(const std::string param);

        void process_condition(const std::string tableName, const std::string columnName, StringVector items);
        void process_joins(const ReferenceLink link);

    public:
        QueryGenerator(const DBTables &tables, const DBForeignKeys &foreign_keys, SQL_TYPE sql_imp = SQL_TYPE_MYSQL);
        ~QueryGenerator() {}
        
        std::string from_query_for_parameters(const QueryParamMap &params, const std::string tableName);
        
        TableColumnPair pair_for_groupby(const std::string selectTableName, const TableColumnPair groupPair);
        
        std::string select_query_for_parameters(SQL_SELECT_TYPE selectType, const QueryParamMap &params, const std::string tableName, const TableColumnPair countPair, const TableColumnPair groupPair);
        std::string average_query_for_parameters(const QueryParamMap &numParams, const QueryParamMap &denomParams, const std::string numTableName, const std::string denomTableName, const TableColumnPair numCountPair, const TableColumnPair denomCountPair, const TableColumnPair groupPair);

    };
    
}

//#pragma GCC visibility pop
#endif /* GraphORM_hpp */
