//
//  Utility.hpp
//  MySQLAPI
//
//  Created by Maryam Karampour on 2017-03-01.
//  Copyright © 2017 Maryam Karampour. All rights reserved.
//

#ifndef Utility_hpp
#define Utility_hpp

#include "GORMDefinitions.hpp"
#include <cstdio>

//this and the function should be in SQLDefs
typedef std::shared_ptr<std::map<std::string, StringMapStringVector>> ParamMap_ptr;;

#pragma mark - Error

class ErrorObject {
    std::string error;
    std::string location;
    std::string message;
    long status;
    
public:
    ErrorObject() {}
    ErrorObject(std::string err, std::string loc, std::string msg, long statusCode) : error(err), location(loc), message(msg), status(statusCode) {}
    
    std::string string_value() {
        return ((error.length() || message.length()) ? "Error --> " + error + " in " + location + " Message --> " + message : "");}
    long getStatus() {return status;}
};

class LoggerObject {
    std::string path;
    
protected:
    LoggerObject() {}
    ~LoggerObject() {}
public:
    static LoggerObject &Logger() {
        static LoggerObject instance;
        return instance;
    }
    
    LoggerObject(LoggerObject const&) = delete;
    LoggerObject(LoggerObject &&) = delete;
    LoggerObject & operator=(LoggerObject const&) = delete;
    LoggerObject & operator=(LoggerObject &&) = delete;
    
    void setPath(std::string path) {this->path = path;}
    void log(std::string str) {
        if(std::freopen(this->path.c_str(), "r+", stdout)) {
            std::printf("%s\n", str.c_str()); // this is written to a log.txt
            std::fclose(stdout);
        }
    }
};

#pragma mark - string

template <typename ... Args>
std::string string_with_format(const std::string & format_str, Args ... args) {
    size_t size = std::snprintf(nullptr, 0, format_str.c_str(), args ...) + 1;
    std::unique_ptr<char[]> buffer(new char[size]);
    snprintf(buffer.get(), size, format_str.c_str(), args ...);
    return std::string(buffer.get(), buffer.get()+size-1);
}

std::string concatenate_strings_vector(StringVector vect, std::string separator);

#pragma mark - containers

template <typename T>
bool vector_contains_object(std::vector<T> vect, T value) {
    return !(std::find(vect.begin(), vect.end(), value) == vect.end());
}

template <typename T>
bool compare_vecotrs(std::vector<T> v1, std::vector<T> v2) {
    std::sort(v1.begin(), v1.end());
    std::sort(v2.begin(), v2.end());
    return (v1 == v2);
}

template <typename T>
void vector_remove_element(std::vector<T> & vect, T element) {
    vect.erase(std::remove(vect.begin(), vect.end(), element), vect.end());
}

template <typename T, typename S>
void erase_key_in_map(std::map<T, S> & map, T key) {
    for (auto it = map.begin(); it != map.end();) {
        if (it.first == key) {
            it = map.erase(it);
        }
        else {
            it ++;
        }
    }
}

template <typename T, typename S>
void erase_value_in_map(std::map<T, S> & map, S value) {
    for (auto it = map.begin(); it != map.end();) {
        if (it.second == value) {
            it = map.erase(it);
        }
        else {
            it ++;
        }
    }
}

template <typename T, typename S>
long find_location(std::map<T, S> & map, S value) {
    return std::distance(map.begin(), std::find(map.begin(), map.end(), value));
}

void param_map(ParamMap_ptr params, const std::string paramName, const std::string column, const StringVector items);


#endif /* Utility_hpp */
