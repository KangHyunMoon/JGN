//
//  main.c
//  linked list
//
//  Created by moon on 2018. 9. 18..
//  Copyright © 2018년 moon. All rights reserved.
//

#include <stdio.h>

typedef int element;
typedef struct ListNode {
    element data;
    struct ListNode *link;
} ListNode;

void insert_node(ListNode** phead, ListNode *p, ListNode *new_node)
{
    if (*phead == NULL) //공백 리스트
    {
        new_node->link = NULL;
        *phead = new_node;
    }
    
    else if (p == NULL)// p가 NULL이면 첫번째 노드로 삽입
    {
        new_node->link = *phead;
        *phead = new_node;
    }
    
    else
    {
        new_node->link = p->link;
        p->link = new_node;
    }
}

void remove_node(ListNode **phead, ListNode *p, ListNode *removed)
{
    if ( p == NULL) // 이전 노드가 없으면
    {
        *phead = (*phead)->link;
    }
    
    else
    {
        
    }
    
}

int main(void)
{
    ListNode *p1;
    
    p1 = (ListNode *)malloc(sizeof(ListNode));
    p1->data = 10;
    p1->link = NULL;
    
    ListNode *p2;
    
    p2 = (ListNode *)malloc(sizeof(ListNode));
    p2->data = 20;
    p2->link = 1234;
    
    insert_node(&p1, p1, p2);
    
    
    return 0;
}
