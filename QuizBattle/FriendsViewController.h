//
//  FriendsViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface FriendsViewController : UIViewController<UITabBarDelegate,UITabBarControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    UITabBarController *FriendsTabBar;
    UIImageView *imgQuiz;
    UIImageView *imgFb;
    UIImageView *imgContacts;
}
@property (nonatomic,strong)NSString * previousView;
@property (nonatomic,strong)UITabBar *customTabBar;
@property (nonatomic, copy) NSArray *tabViewControllersArray;
@property (nonatomic, copy) UIViewController *selectedViewController;
@property(nonatomic)UINavigationController *navController;
@end
