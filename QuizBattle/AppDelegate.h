//
//  AppDelegate.h
//  QuizBattle
//
//  Created by GBS-mac on 8/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate>
{
    NSString *kakaoId,*subCatNameG,*catIdG;
    NSString *kakaousrnme,*friendName;
    PFFile *imgFile;
    UIImageView *imageVAnim;
    NSArray * arrImages;
    int countImage;
    UIScrollView *scrollView;
    UIImageView * image;
    UILabel * lblPlayerSelection;
    UIButton *cancelBtn;
    NSTimer * timerForConnectionPlayer;
    int countTime;
    NSString *strObjectId;
    int xAxis;
    UIView *backgroundView,*upperView,*lowerView;
    BOOL rematchPush,flag_QuiclBlox;
    UIView * rejectView;
}
@property(strong,nonatomic)ViewController *viewCObj;
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UIAlertView * message,*alertRematch;
@property (strong,nonatomic) NSMutableDictionary *dictGamePlayDetails;
-(BOOL) openSessionWithAllowLoginUI;
-(void)kakaoLogin;
-(void)logOutKakao;
@end
