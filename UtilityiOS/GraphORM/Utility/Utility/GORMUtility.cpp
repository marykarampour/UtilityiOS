//
//  Utility.cpp
//  MySQLAPI
//
//  Created by Maryam Karampour on 2017-03-01.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#include "GORMUtility.hpp"

std::string concatenate_strings_vector(StringVector vect, std::string separator) {
    std::string str = "";
    for (auto const & value : vect) {
        str.append(value);
        if (value != vect.back()) {
            str.append(separator);
        }
    }
    return str;
}

void param_map(ParamMap_ptr params, const std::string paramName, const std::string column, const StringVector items) {
    
    StringMapStringVector param;
    if (params->count(paramName)) {
        param = params->at(paramName);
    }
    param.insert(StringPairStringVector(column, items));
    params->erase(paramName);
    params->insert(std::pair<std::string, StringMapStringVector>(paramName, param));
}
