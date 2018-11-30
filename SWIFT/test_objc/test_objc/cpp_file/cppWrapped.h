//
//  cppWrapped.h
//  test_cpp
//
//  Created by KangHyunMoon on 2018. 5. 5..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

#ifndef cppWrapped_h
#define cppWrapped_h

#include <stdio.h>
#include <string>

class ItsCpp {
    
public:
    ItsCpp();
    ItsCpp(const std::string& name);
    ~ItsCpp();
    
public:
    // set/get name property
    void name(const std::string& name);
    const std::string& name();
    
private:
    std::string m_name;
};

#endif /* cppWrapped_h */
