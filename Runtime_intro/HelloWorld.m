//
//  HelloWorld.m
//  Runtime_intro
//  
//  Created by ash on 2020/5/4.
//  Copyright © 2020 ash. All rights reserved.
//
    

#import "HelloWorld.h"
#import <UIKit/UIKit.h>

@implementation HelloWorld

/// 一、字符串反转
// 给定字符串 "hello,world",实现将其反转。输出结果：dlrow,olleh
- (void)charReverse
{
    // OC
    NSString *string = @"hello,world";
    NSLog(@"%@", string);
    
    NSMutableString *reverString = [NSMutableString stringWithString:string];
    
    NSInteger length = [string length];
    for (NSInteger i = 0; i < (length+1)/2; i++) {
        
        [reverString replaceCharactersInRange:NSMakeRange(i, 1) withString:[string substringWithRange:NSMakeRange(length-i-1, 1)]];
        
        [reverString replaceCharactersInRange:NSMakeRange(length-i-1, 1) withString:[string substringWithRange:NSMakeRange(i, 1)]];
    }
    
    NSLog(@"reverString: %@", reverString);
    
    // C
    
    char chars[100];
    
    memcpy(chars, [string cStringUsingEncoding:NSUTF8StringEncoding], [string length]);
    
    //设置两个指针，一个指向字符串开头，一个指向字符串末尾
    char *begin = chars;
    
    char *end = chars + strlen(chars) - 1;
    
    //遍历字符数组，逐步交换两个指针所指向的内容，同时移动指针到对应的下个位置，直至begin>=end
    while (begin < end) {
        char temp = *begin;
        
        *(begin++) = *end;
        *(end--) = temp;
    }
    
    NSLog(@"reverseChar[]:%s",chars);
}


/// 链表反转
// 反转前：1->2->3->4->NULL
// 反转后：4->3->2->1->NULL
/**  定义一个链表  */
struct Node {
    NSInteger data;
    
    struct Node *next;
};

- (void)listReverse
{
    struct Node *p = [self constructList];
    
    [self printList:p];
    
    //反转后的链表头部
    struct Node * newH = NULL;
    //头插法
    while (p != NULL) {
        //记录下一个结点
        struct Node *temp = p->next;
        //当前结点的next指向新链表的头部
        p->next = newH;
        //更改新链表头部为当前结点
        newH = p;
        //移动p到下一个结点
        p = temp;
    }
    [self printList:newH];
}

/**
打印链表

@param head 给定链表
*/
- (void)printList:(struct Node *)head
{
    struct Node *temp = head;
    printf("list is : ");
    
    while (temp != NULL) {
        printf("%zd ",temp->data);
        temp = temp->next;
    }
    
    printf("\n");
}

/**  构造链表  */
- (struct Node *)constructList
{
    //头结点
    struct Node *head = NULL;
    //尾结点
    struct Node *cur = NULL;
    
    for (NSInteger i = 0; i < 10; i++) {
        struct Node *node = malloc(sizeof(struct Node));
        
        node->data = i;
        //头结点为空，新结点即为头结点
        if (head==NULL) {
            head = node;
        }else {
            //当前结点的next为尾结点
            cur->next = node;
        }
        //设置当前结点为新结点
        cur = node;
    }
    
    return head;
}


/// 有序数组合并
// 将有序数组 {1,4,6,7,9} 和 {2,3,5,6,8,9,10,11,12} 合并为
// {1,2,3,4,5,6,6,7,8,9,9,10,11,12}

- (void)orderListMerge
{
    int aLen = 5, bLen = 9;
    int a[] = {1,4,6,7,9};
    int b[] = {2,3,5,6,8,9,10,11,12};
    
    [self printList:a length:aLen];
    
    [self printList:b length:bLen];
    
    int resultLen = aLen + bLen;
    
    int result[resultLen];
    // p和q分别为a和b的下标，i为合并结果数组的下标
    int p = 0, q = 0, i = 0;
    //任一数组没有达到s边界则进行遍历
    while (p < aLen && q < bLen) {
        
        //如果a数组对应位置的值小于b数组对应位置的值,则存储a数组的值，并移动a数组的下标与合并结果数组的下标
        if (a[p] < b[q]) {
            result[i++] = a[p++];
        }else {
            //否则存储b数组的值，并移动b数组的下标与合并结果数组的下标
            result[i++] = b[q++];
        }
    }
    
    //如果a数组有剩余，将a数组剩余部分拼接到合并结果数组的后面
    while (++p < aLen) {
        result[i++] = a[p];
    }
    
    //如果b数组有剩余，将b数组剩余部分拼接到合并结果数组的后面
    while (q < bLen) {
        result[i++] = b[q++];
    }
    
    [self printList:result length:resultLen];
}

- (void)printList:(int [])list length:(int)length
{
    for (int i = 0; i < length; i++) {
        printf("%d ",list[i]);
    }
    printf("\n");
}


// HASH算法

//哈希表
//例：给定值是字母a，对应ASCII码值是97，数组索引下标为97。
//这里的ASCII码，就算是一种哈希函数，存储和查找都通过该函数，有效地提高查找效率。
//在一个字符串中找到第一个只出现一次的字符。如输入"abaccdeff"，输出'b'
//字符(char)是一个长度为8的数据类型，因此总共有256种可能。
//每个字母根据其ASCII码值作为数组下标对应数组种的一个数字。数组中存储的是每个字符出现的次数。

- (void)hashTest
{
    NSString *testString = @"hhaabccdeef";
    char testCh[100];
    memcpy(testCh, [testString cStringUsingEncoding:NSUTF8StringEncoding], [testString length]);
    
    int list[256];
    
    for (int i = 0; i < 256; i++) {
        list[i] = 0;
    }
    
    char *p = testCh;
    
    char result = '\0';
    
    while (*p != result) {
        
        list[*(p++)]++;
    }
    
    p = testCh;
    
    while (*p != result) {
        
        if (list[*p] == 1) {

            result = *p;
            
            break;
        }
        
        p++;
    }
    
    printf("result:%c",result);
}

// 查找两个子视图的共同父视图
// 思路:分别记录两个子视图的所有父视图并保存到数组中，然后倒序寻找,直至找到第一个不一样的父视图。

- (void)findCommonSuperViews:(UIView *)view1 view2:(UIView *)view2
{
    NSArray *superViews1 = [self findSuperViews:view1];
    
    NSArray *superViews2 = [self findSuperViews:view2];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    int i = 0;
    
    while (i < MIN(superViews1.count, superViews2.count)) {
        
        UIView *super1 = superViews1[superViews1.count - i - 1];
        
        UIView *super2 = superViews2[superViews2.count - i - 1];
        
        if (super1 == super2) {
            [resultArray addObject:super1];
            i++;
        }else {
            break;
        }
    }
    
    NSLog(@"resultArray:%@",resultArray);
}

- (NSArray <UIView *>*)findSuperViews:(UIView *)view
{
    UIView * temp = view.superview;
    
    NSMutableArray * result = [NSMutableArray array];
    
    while (temp) {
        [result addObject:temp];
        temp = temp.superview;
    }
    
    return result;
}

- (void)exchangeNum1:(int)num1 num2:(int)num2 {
    num1 = num1 ^ num2;
    printf("first value %d\n",num1);
    num2 = num1 ^ num2;
    printf("second value %d\n",num2);
    num1 = num1 ^ num2;
    printf("third value %d\n",num1);
}

@end
