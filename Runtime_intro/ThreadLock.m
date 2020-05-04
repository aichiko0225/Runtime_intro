//
//  ThreadLock.m
//  Runtime_intro
//  
//  Created by ash on 2020/5/3.
//  Copyright © 2020 ash. All rights reserved.
//
    

#import "ThreadLock.h"
#import <pthread/pthread.h>

typedef struct ct_sum
{
    int sum;
    pthread_mutex_t lock;
}ct_sum;


@interface ThreadLock ()
{
    int sum;
    pthread_mutex_t lock;
}

@end

@implementation ThreadLock

+ (void)initialize
{
    if (self == [ThreadLock class]) {
        
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        int i;
        pthread_t ptid1,ptid2;
//        int sum = 0;
        ct_sum cnt;
        pthread_mutex_init(&(cnt.lock),NULL);
        cnt.sum=0;
        pthread_create(&ptid1,NULL,add1,&cnt);
        pthread_create(&ptid2,NULL,add2,&cnt);

        pthread_mutex_lock(&(cnt.lock));
        printf("sum %d\n",cnt.sum);
        pthread_mutex_unlock(&(cnt.lock));
        pthread_join(ptid1,NULL);
        pthread_join(ptid2,NULL);
        pthread_mutex_destroy(&(cnt.lock));
    }
    return self;
}

void * add1(void * cnt)
{
    pthread_mutex_lock(&(((ct_sum*)cnt)->lock));
    int i;
    for(i=0; i<50; i++)
    {
        (*(ct_sum*)cnt).sum+=i;
    }
    pthread_mutex_unlock(&(((ct_sum*)cnt)->lock));
    pthread_exit(NULL);
    return 0;
}

void * add2(void *cnt)
{
    int i;
    cnt= (ct_sum*)cnt;
    pthread_mutex_lock(&(((ct_sum*)cnt)->lock));
    for(i=50; i<101; i++)
    {
        (*(ct_sum*)cnt).sum+=i;
    }
    pthread_mutex_unlock(&(((ct_sum*)cnt)->lock));
    pthread_exit(NULL);
    return 0;
}

@end
