/*
 *  GraphORMLibrary.cpp
 *  GraphORMLibrary
 *
 *  Created by Maryam Karampour on 2017-02-11.
 *  Copyright © 2017 Maryam Karampour. All rights reserved.
 *
 */

#include <iostream>
#include "GraphORMLibrary.hpp"
#include "GraphORMLibraryPriv.hpp"

void GraphORMLibrary::HelloWorld(const char * s)
{
    GraphORMLibraryPriv *theObj = new GraphORMLibraryPriv;
    theObj->HelloWorldPriv(s);
    delete theObj;
};

void GraphORMLibraryPriv::HelloWorldPriv(const char * s) 
{
    std::cout << s << std::endl;
};

