//
//  RageIAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "RageIAPHelper.h"

@implementation RageIAPHelper

+ (RageIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RageIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects: @"com.globussoft.diamondx2",@"com.globussoft.diamondx6",@" com.globussoft.diamondx11",@"com.globussoft.diamondx24",@"com.globussoft.diamond78",@"com.globussoft.diamondx140", nil];
   
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}
@end