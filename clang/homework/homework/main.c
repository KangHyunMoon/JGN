#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NAME_LEN 20
#define PHONE_LEN 20
#define LIST_NUM 100

enum { QUIT = 0, INPUT, SHOWALL, SEARCH, REPLACE, DELETE };
enum { EMPTY =1,INUSE,DELETED};

typedef struct phoneData
{
    char name[NAME_LEN];
    char phoneNum[PHONE_LEN];
    struct phoneData *leftChild, *rightChild;
    
} phoneData;

int numOfData = 0;
phoneData *gRoot = NULL;
phoneData *queue[LIST_NUM];

int front = LIST_NUM-1;
int rear = LIST_NUM-1;

void ShowMenu();
void clear_inputBuffer();
void InputPhoneData();
int getString(char *buf, int maxLen);
void ShowAllData(phoneData *root);
void ShowPhoneInfo(phoneData *phone);
void SearchPhoneData();
void ReplacePhoneData();
void DeletePhoneData();
void Sort();
int is_empty();
void enqueue(phoneData *root);
void preoreder(phoneData *root);
void levelorder(phoneData *root);

void enqueue(phoneData *root)
{
    rear = (rear + 1) % LIST_NUM;
    queue[rear] = root;
}

phoneData *dequeue(){
    front = (front+1)%LIST_NUM;
    return queue[front];
}

int is_empty()
{
    return front == rear;
}

int main(){
    
    int inputMenu = 0;
    
    while (1){
        
        ShowMenu();
        fputs("Select a number: ", stdout);
        scanf("%d", &inputMenu);
        clear_inputBuffer();  // 입력버퍼 비우기
        
        switch (inputMenu){
                
            case INPUT:
                InputPhoneData();
                break;
                
            case SHOWALL:
                ShowAllData(gRoot);
                break;
                
            case SEARCH:
                SearchPhoneData();
                break;
                
            case REPLACE:
                ReplacePhoneData();
                break;
                
            case DELETE:
                DeletePhoneData();
                break;
                
        }
        
        if (inputMenu == QUIT)
        {
            puts("Bye~");
            break;
        }
    }
    return 0;
}

void ReplacePhoneData(){
    
    phoneData *root = gRoot;
    
    char replaceNum[PHONE_LEN];
    char searchName[NAME_LEN];
    
    fputs("Name: ", stdout);
    if(getString(searchName, NAME_LEN) ==1){
        return;
    }
    int flag =1;
    if(searchName != 0){
        while(flag){
            if(!strcmp(root->name,searchName)){
                ShowPhoneInfo(root);
                
                fputs("New phone number: ", stdout);
                if (getString(replaceNum, PHONE_LEN) == 1){
                    
                    return;
                }
                strcpy(root->phoneNum, replaceNum);
                flag = 0;
            }
            else if(strcmp(root->name,searchName)>0)
                root = root->leftChild;
            else
                root = root -> rightChild;
        }
        puts("Phone number is replaced.");
        return;
    }
    printf("'%s' is not in the list.\n",searchName);
    
}

void DeletePhoneData(){
    
    phoneData *pPre = NULL;
    phoneData *pLoc = gRoot;
    phoneData *pPre2, *pLoc2, *child;
    
    char searchName[NAME_LEN];
    
    fputs("Name: ", stdout);
    if(getString(searchName, NAME_LEN) ==1){
        return;
    }
    
    while(pLoc != NULL){
        if(!strcmp(pLoc->name,searchName)){
            break;
        }
        pPre = pLoc;
        pLoc = (strcmp(pLoc->name,searchName)>0) ? pLoc->leftChild : pLoc->rightChild;
    }
    if(pLoc == NULL)
        printf("'%s' is not in the list.",searchName);
    
    if((pLoc->leftChild == NULL)&&(pLoc->rightChild==NULL)){
        if(pPre != NULL){
            if(pPre->leftChild == pLoc)
                pPre->leftChild = NULL;
            else
                pPre->rightChild = NULL;
        }
        else
            gRoot = NULL;
        free(pLoc);
        puts("Phone number is deleted.");
    }
    else if((pLoc->leftChild == NULL)||(pLoc->rightChild==NULL)){
        child = (pLoc->leftChild != NULL) ? pLoc->leftChild : pLoc->rightChild;
        if(pPre!=NULL){
            if(pPre->leftChild == pLoc)
                pPre->leftChild = child;
            else
                pPre->rightChild = child;
        }
        else
            gRoot = child;
        free(pLoc);
        puts("Phone number is deleted.");
    }
    else{
        pPre2 = pLoc;
        pLoc2 = pLoc->rightChild;
        while(pLoc2->leftChild !=NULL){
            pPre2 = pLoc2;
            pLoc2 = pLoc2->leftChild;
        }
        if(pPre2->leftChild == pLoc2)
            pPre2->leftChild = pLoc2->rightChild;
        else
            pPre2->rightChild = pLoc2->rightChild;
        
        strcpy(pLoc->name, pLoc2->name);
        strcpy(pLoc->phoneNum, pLoc2->phoneNum);
        free(pLoc2);
        puts("Phone number is deleted.");
    }
}


void SearchPhoneData(){
    
    phoneData *root = gRoot;
    
    char searchName[NAME_LEN];
    
    fputs("Name: ", stdout);
    if(getString(searchName, NAME_LEN) ==1){
        return;
    }
    while(root){
        if(!strcmp(root->name, searchName)){
            ShowPhoneInfo(root);
            return;
        }
        else if(strcmp(root->name, searchName)>0)
            root = root->leftChild;
        else
            root = root ->rightChild;
    }
    printf("'%s' is not in the list.\n",searchName);
}

void ShowMenu(){
    
    puts("--------Menu----------");
    puts(" 0. Quit");
    puts(" 1. New phone number");
    puts(" 2. Display all");
    puts(" 3. Search");
    puts(" 4. Replace");
    puts(" 5. Delete");
    puts("----------------------");
    fputs("Menu>> ", stdout);
}

void clear_inputBuffer()
{
    // fflush(stdin);
    while (getchar() != '\n');     // 입력버퍼 비우기
}

void InputPhoneData()
{
    phoneData *pNew = (phoneData *)malloc(sizeof(phoneData));
    phoneData *pLoc = gRoot;
    phoneData *pPre = NULL;
    pNew -> leftChild = pNew -> rightChild = NULL;
    
    if(numOfData >= LIST_NUM)
    {
        puts("Out of memory");
        return;
    }
    
    fputs("Name: ", stdout);
    if(getString(pNew->name, NAME_LEN) == 1)
    {
        return;
    }
    
    fputs("Phone number: ", stdout);
    if(getString(pNew->phoneNum, PHONE_LEN) == 1)
    {
        return;
    }
    
    while(pLoc){
        if(strcmp(pNew->name,pLoc->name)){
            if(strcmp(pNew->name,pLoc->name)==0)
                return;
            pPre = pLoc;
            pLoc = (strcmp(pNew->name,pLoc->name)<0) ? pLoc->leftChild : pLoc->rightChild;
            
        }
    }
    
    if(pPre){
        if(strcmp(pNew->name,pPre->name)<0)
            pPre->leftChild = pNew;
        else
            pPre->rightChild=pNew;
    }
    else
        gRoot = pNew;
    
    puts("New phone number is added.");
}

int getString(char *buf, int maxLen)
{
    int i;
    char ch;
    
    for (i = 0; i < maxLen; i++)
    {
        ch = getchar();
        
        if (ch == '\n')
        {
            buf[i] = '\0';
            return 0;
        }
        buf[i] = ch;
    }
    
    puts("Too long string");
    printf("Maximum input length is %d bytes.", maxLen - 1);
    clear_inputBuffer();
    return 1;
}
void preorder(phoneData *root){
    if(root){
        ShowPhoneInfo(root);
        preorder(root->leftChild);
        preorder(root->rightChild);
    }
}

void levelorder(phoneData *root){
    if (root == NULL)
    {
        return;
    }
    
    enqueue(root);
    
    while (is_empty() == NULL)
    {
        phoneData* x= dequeue();
        ShowPhoneInfo(x);
        if (x->leftChild != NULL)
        {
            enqueue(x->leftChild);
        }
        if (x->rightChild != NULL)
        {
            enqueue(x->rightChild);
        }
    }
}

void ShowAllData(phoneData *root)
{
    if(root != NULL){
        //preorder(root);
        levelorder(root);
    }
    
    puts("End of list");
}

void ShowPhoneInfo(phoneData *phone)
{
    puts("---------------------------");
    printf("| Name: %s\n", phone->name);
    printf("| Phone number: %s\n", phone->phoneNum);
    puts("---------------------------");
}

