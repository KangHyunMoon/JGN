//
//  main.c
//  stack
//
//  Created by moon on 2018. 9. 18..
//  Copyright © 2018년 moon. All rights reserved.
//

#include <stdio.h>

#define MAX_LIST_SIZE 30

typedef int element;
typedef struct {
    int list[MAX_LIST_SIZE];
    int length;
} ArrayListType;

void init(ArrayListType *L)
{
    L->length = 0;
}

int is_empty(ArrayListType *L)
{
    return L->length == 0;
}

int is_full(ArrayListType *L)
{
    return L->length == MAX_LIST_SIZE;
}

void add(ArrayListType *L, int position, element item)
{
    if ((!is_full(L)) && (position >= 0) && (position <= L->length))
    {
        int i;
        
        for (i= (L->length - 1); i>= position; i--)
        {
            L->list[i+1] = L->list[i];
        }
        L->list[position] = item;
    }
    
    
}

element delete(ArrayListType *L, int position)
{
    element item;
    int i;

    if ((position <0) || (position >= L->length))
    {
        printf("위치 에러!\n");
        return 0;
    }
    
    item = L->list[position];
    
    for (i=position; i < (L->length-1); i++)
    {
        L->list[position] = L->list[position+1];
    }
    
    L->length--;
    
    return item;
}


int main(void) {
    
    
    ArrayListType List;
    
    init(&List);
    
    List.length = 4;
    
    add(&List, 0, 0);
    add(&List, 1, 1);
    add(&List, 2, 2);
    add(&List, 3, 3);
    
    delete(&List, 3);
    delete(&List, 2);
    delete(&List, 1);
    delete(&List, 0);
    
    printf("1");
    
    return 0;
}
