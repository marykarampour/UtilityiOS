//
//  Definitions.h
//  Utility
//
//  Created by Maryam Karampour on 2017-02-14.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#ifndef Definitions_hpp
#define Definitions_hpp

#include <stdio.h>
#include <iostream>
#include <vector>
#include <map>
#include <memory>
#include <algorithm>

#ifdef DEBUG
#define GORMDEBUGLOG(s, ...) std::cout << string_with_format(s, ##__VA_ARGS__) + "\n";
#else
#define GORMDEBUGLOG(s, ...)
#endif

#define FUNC_LINE std::string(__FILE__) + " " + std::string(__FUNCTION__) + " line " + std::to_string(__LINE__) + "\n"

typedef std::vector<std::string>                StringVector;
typedef std::vector<StringVector>               StringVectorVector;
typedef std::pair<std::string, StringVector>    StringPairStringVector;
typedef std::map<std::string, StringVector>     StringMapStringVector;
typedef std::pair<std::string, std::string>     StringStringPair;
typedef std::map<std::string, std::string>      StringStringMap;

typedef unsigned int                            Index;
typedef std::pair<Index, std::string>           IndexString;
typedef std::pair<IndexString, IndexString>     Direction;
typedef std::shared_ptr<Direction>              Direction_ptr;
typedef std::vector<Index>                      IndexVector;
typedef std::vector<IndexString>                IndexStringVector;

#endif /* Definitions_h */
