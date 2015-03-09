//
//  SingletonClass.m
//  QuizBattle
//
//  Created by GBS-mac on 8/22/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.

#import "SingletonClass.h"

@implementation SingletonClass

static SingletonClass *sharedSingleton;

+(SingletonClass*)sharedSingleton {
    
    @synchronized(self){
        
        if(!sharedSingleton){
            sharedSingleton=[[SingletonClass alloc]init];
        }
    }
    return sharedSingleton;
}

@end