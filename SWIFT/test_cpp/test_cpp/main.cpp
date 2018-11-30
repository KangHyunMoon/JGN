//
//  main.cpp
//  test_cpp
//
//  Created by KangHyunMoon on 2018. 5. 5..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include "cppWrapped.h"

#include <string.h>

void CppWrapped::foo(int n)
{
    printf("%d", n);
}

int main(int argc, const char * argv[]) {
    CppWrapped::foo(1234);
    return 0;
}
