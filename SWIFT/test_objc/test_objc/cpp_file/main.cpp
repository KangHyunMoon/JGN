//
//  main.cpp
//  test_cpp
//
//  Created by KangHyunMoon on 2018. 5. 5..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

#include "cppWrapped.h"

ItsCpp::ItsCpp() {
    name("");
}

ItsCpp::ItsCpp(const std::string& name) {
    this->name(name);
}

ItsCpp::~ItsCpp() {
}

void ItsCpp::name(const std::string &name) {
    this->m_name = name;
}

const std::string& ItsCpp::name() {
    return this->m_name;
}
