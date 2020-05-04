//
//  HelloWorld.m
//  Runtime_intro
//  
//  Created by ash on 2020/5/4.
//  Copyright © 2020 ash. All rights reserved.
//
    

#import "HelloWorld.h"

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
    
}

/**
打印链表

@param head 给定链表
*/
- (void)printList:(struct Node *)head
{
    
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


@end
