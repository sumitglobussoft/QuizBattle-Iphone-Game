
//
//  CustomMenuViewController.m
//  MOVYT
//
//  Created by Sumit Ghosh on 27/05/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "CustomMenuViewController.h"
#import <objc/runtime.h>
#import "ViewController.h"
#import <Parse/Parse.h>
#import "SingletonClass.h"
#import "PurchaseView.h"
#import "UIViewController+MJPopupViewController.h"
#import "PopularViewController.h"
#import "QuizPlusViewController.h"
#import "NewContentViewController.h"
#import "ProfileViewController.h"
#import "MainHistoryViewController.h"
#import "ChooseTopics.h"
#import "GameViewController.h"
#import "AppDelegate.h"

@interface CustomMenuViewController ()
{
    NSInteger updateValue;
}
@property (nonatomic,strong)UITabBar *customTabBar;
@end

@implementation CustomMenuViewController
@synthesize viewControllers = _viewControllers;


-(void) backButtonUpdateNotification:(NSNotification *)notify{
    id value = [notify object];
    
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value isEqualToString:KUpdateHistory])
        {
            updateValue++;
           // updateValue = 1;
        }
        else if ([value isEqualToString:@"Firends_First"])
        {
            updateValue++;
            //updateValue = 2;
        }
        else if ([value isEqualToString:@"Friends_ProfileImage"])
        {
            updateValue++;
           // updateValue = 3;
        }
        else if ([value isEqualToString:@"Message_First"])
        {
            updateValue++;
            //updateValue = 4;
        }
        else if ([value isEqualToString:@"Profile_Message_First"])
        {
            updateValue++;
            //updateValue = 11;
        }
        else if ([value isEqualToString:@"Topics_First"])
        {
            updateValue++;
            //updateValue=5;
        }
        else if([value isEqualToString:@"Home_Again"])
        {
            updateValue++;
            //updateValue=6;
        }
        else if ([value isEqualToString:@"Home_Again_Ranking"])
        {
            
            self.menuLabel.text = [self languageSelectedStringForKey:@"Rankings"];
            updateValue++;
            //updateValue=7;
        }
        else if ([value isEqualToString:@"Home_Again_Discussion"])
        {
             self.menuLabel.text = [self languageSelectedStringForKey:@"Discussions"];
            updateValue++;
            //updateValue=8;
        }
        else if ([value isEqualToString:@"Game_Result_Ranking"])
        {
            updateValue++;
            //updateValue=9;
        }
        else if ([value isEqualToString:@"ChatScreen"])
        {
            //self.boosterView.hidden=TRUE;
            //self.boosterView.backgroundColor=[UIColor clearColor];
           // self.customTabBar.hidden=TRUE;
          //  self.customTabBar.userInteractionEnabled=NO;
        // self.headerView.hidden=TRUE;
            updateValue++;
            //updateValue=4;
        }
        else if ([value isEqualToString:@"ChatScreenDiscussion"])
        {
            //self.boosterView.hidden=TRUE;
            //self.boosterView.backgroundColor=[UIColor clearColor];
            // self.customTabBar.hidden=TRUE;
            //  self.customTabBar.userInteractionEnabled=NO;
            // self.headerView.hidden=TRUE;
            updateValue++;
            //updateValue=10;
        }
        else if ([value isEqualToString:@"SubCategoryView"])
        {
            updateValue++;
        }
        else if ([value isEqualToString:@"All_Topics"])
        {
            updateValue++;

        }

        
        
    }//End if Block NSString Class Check
}


-(void)backButtonAction:(UIButton *)button
{
    NSLog(@"Update Value %d",updateValue);
    if (updateValue==0)
    {
        UIViewController *newViewController = [_viewControllers objectAtIndex:0];
        _selectedSection = 1;
        _selectedIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:KDismissView object:nil];
        [self getSelectedViewControllers:newViewController];
    }
    else if (updateValue>0)
    {
        updateValue--;
        [[NSNotificationCenter defaultCenter] postNotificationName:KDismissView object:nil];
    }
    
//    else if(updateValue ==1)
//    {
//        NSLog(@"Hide History Data");
//        updateValue = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification" object:nil];
//        //MainHistoryViewController *newViewController = (MainHistoryViewController *)[_viewControllers objectAtIndex:3];
//        //[newViewController backBtnAction:nil];
//    }
//    else if(updateValue ==2)
//    {
//       //updateValue = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification" object:nil];
//    }
//    else if (updateValue == 3){
//        updateValue = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification" object:nil];
//    }
//    else if (updateValue==4){
//       updateValue =0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification" object:nil];
//    }
//    else if (updateValue==5)
//    {
//        updateValue = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification" object:nil];
//    }
//    else if (updateValue==6)
//    {
//        updateValue = 0;
//        self.menuLabel.text = [self languageSelectedStringForKey:self.selectedViewController.title];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification" object:nil];
//    }
//    else if (updateValue==7)
//    {
//        updateValue = 0;
//         self.menuLabel.text = [self languageSelectedStringForKey:self.selectedViewController.title];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification" object:nil];
//    }
//    else if (updateValue==8)
//    {
//        updateValue = 0;
//         self.menuLabel.text = [self languageSelectedStringForKey:self.selectedViewController.title];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification" object:nil];
//    }
//    else if (updateValue==9)
//    {
//        updateValue = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification" object:nil];
//    }
//    else if (updateValue==10)
//    {
//        updateValue = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissNotification" object:nil];
//    }
//    else if (updateValue==11)
//    {
//        updateValue = 0;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatDiscussionDismiss" object:nil];
//    }


}
#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImage) name:@"ChangeUserImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButtonForHome:) name:@"backButtonHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProducts:) name:@"updateproducts" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLifeUI) name:@"lifenotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backButtonAction:) name:@"backButtonStore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLanguage:) name:KLanguageUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButtonUpdateNotification:) name:KUpdateBackButtonNotification object:nil];

    [self.menuTableView reloadData];
}
-(void)changeImage
{
    imageVUser.image=[SingletonClass sharedSingleton].imageUser;
    lblUserName.text=[SingletonClass sharedSingleton].strUserName;
}
//Received Notification Method
-(void) reloadMenuTable:(NSNotification *)notify{
    
    id name = [notify object];
    if ([name isKindOfClass:[NSString class]]) {
        
        if ([name isEqualToString:@"LoggedInWithBroadCast"]){
            self.isSignIn = YES;
            
        }
        else if ([name isEqualToString:@"LoggedIn"]){
            self.isSignIn = YES;
        }
        [self.menuTableView reloadData];
    }
}

#pragma mark -
-(void) setViewControllers:(NSArray *)viewControllers{
    
    _viewControllers = [viewControllers copy];
    
    for (UIViewController *viewController in _viewControllers ) {
        [self addChildViewController:viewController];
        
        viewController.view.frame = CGRectMake(0, 90,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-140);
        [viewController didMoveToParentViewController:self];
    }
}
-(void) setSecondSectionViewControllers:(NSArray *)secondSectionViewControllers{
    
    _secondSectionViewControllers = [secondSectionViewControllers copy];
    
    for (UIViewController *viewController in _secondSectionViewControllers ) {
        [self addChildViewController:viewController];
        
        viewController.view.frame = CGRectMake(0, 90,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height-90);
        [viewController didMoveToParentViewController:self];
    }
}
-(void) setSelectedViewController:(UIViewController *)selectedViewController{
    _selectedViewController = selectedViewController;
}

-(void) setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
}

-(NSArray *) getAllViewControllers{
    return self.viewControllers;
}
-(void) setSelectedSection:(NSInteger)selectedSection{
    _selectedSection = selectedSection;
}
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    screenSize = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)39/255 green:(CGFloat)39/255 blue:(CGFloat)41/255 alpha:1];
    
    userDefault = [NSUserDefaults standardUserDefaults];
    
    time=120;
    updateValue=0;
   
        
    totalDiamond = (int)[userDefault integerForKey:@"buydiamond"];
    [userDefault synchronize];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.screen_height = [UIScreen mainScreen].bounds.size.height;
    self.isSignIn = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMenuTable:) name:@"UpdateMenuTable" object:nil];
    
    //Add View SubView;
    self.mainsubView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.screen_height-45)];
    NSLog(@"Main sub view frame X=-=- %f \n Y == %f",[UIScreen mainScreen].bounds.origin.x,[UIScreen mainScreen].bounds.origin.y);
    self.mainsubView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainsubView];
    
    //Add Header View
    CGFloat hh;
    CGRect frame_b;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        hh = 75;
        frame_b = CGRectMake(680, 30, 45, 25);
        
    }
    else{
        hh = 55;
        
        frame_b = CGRectMake(255, 20, 45, 25);
    }
    CGRect frame = CGRectMake(0, 0, screenSize.size.width, hh);
    
    self.headerView = [[UIView alloc] initWithFrame:frame];
    self.headerView.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f];
    [self.mainsubView addSubview:self.headerView];
    
    NSLog(@"Width menu== %f",screenSize.size.width);
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(10, 20, 30, 30);
    [self.backButton setImage:[UIImage imageNamed:@"back_btnForall.png"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.backButton];
    //=======================================
    // Add Booster View
    
    self.boosterView = [[UIView alloc] initWithFrame:CGRectMake(0, hh, self.view.frame.size.width, 35)];
    self.boosterView.backgroundColor =[UIColor colorWithRed:(CGFloat)53/255 green:(CGFloat)83/255 blue:(CGFloat)119/255 alpha:1];
    //
    self.boosterView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.mainsubView addSubview:self.boosterView];
    
    [self boosterViewUI];
    
    //=======================================
    // Add Container View
    frame = CGRectMake(0, 90, screenSize.size.width, screenSize.size.height-135);
    self.contentContainerView = [[UIView alloc] initWithFrame:frame];
    self.contentContainerView.backgroundColor = [UIColor grayColor];
    self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.mainsubView addSubview:self.contentContainerView];
    //------------------
    //Add Topic Button
    
    
    //--------
    //-------------------
    //============================
    //Add Menu Button
    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = frame_b;
    self.menuButton.titleLabel.font = [UIFont systemFontOfSize:9.0f];
    self.menuButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    //self.menuButton.titleLabel.layer.
    [self.menuButton addTarget:self action:@selector(menuButtonClciked:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    [self.headerView addSubview:self.menuButton];
    
    //===================================
    
    //Add Menu Lable
    self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, 100, 30)];
    self.menuLabel.backgroundColor = [UIColor clearColor];
    self.menuLabel.font = [UIFont boldSystemFontOfSize:15];
    self.menuLabel.textColor = [UIColor whiteColor];
    self.menuLabel.textAlignment = NSTextAlignmentCenter;
    self.menuLabel.text = _selectedViewController.title;
    [self.headerView addSubview:self.menuLabel];
    
    //====================================
    
    self.selectedIndex = 0;
    self.selectedViewController = [_viewControllers objectAtIndex:0];
    [self updateViewContainer];
    [self createMenuTableView];
    //Adding Swipr Gesture
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.mainsubView addGestureRecognizer:self.swipeGesture];
    NSString * value=[[NSUserDefaults standardUserDefaults]objectForKey:@"language"];
    UITabBarItem *firstTabItem,*secondTabItem,*thirdTabItem,*fourthTabItem,*fifthTabItem;
     [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateNormal];
    if ([value isEqualToString:@"Korean"]){
         firstTabItem= [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"homeTab.png"] selectedImage:[UIImage imageNamed:@"homeTab.png"]];
        firstTabItem.tag = 10;
       secondTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"grade.png"] selectedImage:[UIImage imageNamed:@"grade.png"]];
        secondTabItem.tag = 0;
        thirdTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"quizplus.png"] selectedImage:[UIImage imageNamed:@"quizplus.png"]];
        thirdTabItem.tag = 1;
        fourthTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"new.png"] selectedImage:[UIImage imageNamed:@"new.png"]];
        fourthTabItem.tag = 2;
        fifthTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"profile.png"] selectedImage:[UIImage imageNamed:@"profile.png"]];
        fifthTabItem.tag = 3;
        self.customTabBar.items = @[firstTabItem, secondTabItem, thirdTabItem, fourthTabItem, fifthTabItem];
    }
    else {
        firstTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"homeTab.png"] selectedImage:[UIImage imageNamed:@"homeTab.png"]];
        firstTabItem.tag = 10;
        
        secondTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"grade.png"] selectedImage:[UIImage imageNamed:@"grade_active.png"]];
        secondTabItem.tag = 0;
        thirdTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"quizplus.png"] selectedImage:[UIImage imageNamed:@"quizplus_active.png"]];
        thirdTabItem.tag = 1;
        fourthTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"new.png"] selectedImage:[UIImage imageNamed:@"new_active.png"]];
        fourthTabItem.tag = 2;
        fifthTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"profile.png"] selectedImage:[UIImage imageNamed:@"profile_active.png"]];
        fifthTabItem.tag = 3;
        self.customTabBar.items = @[firstTabItem, secondTabItem, thirdTabItem, fourthTabItem, fifthTabItem];
    }
    //========================
    //Adding Custom Tab Bar
    self.customTabBar.items = @[firstTabItem, secondTabItem, thirdTabItem, fourthTabItem, fifthTabItem];
    self.customTabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, screenSize.size.height-45, screenSize.size.width, 50)];
    [self.customTabBar setBackgroundImage:[UIImage imageNamed:@"footer.png"]];
      self.customTabBar.delegate = self;
    self.customTabBar.items = @[firstTabItem, secondTabItem, thirdTabItem, fourthTabItem, fifthTabItem];
    UIImage *tabBarSelectedImage=[UIImage imageNamed:@"footer_active_main.png"];//[[UIImage imageNamed:@"footer_bg_active.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20,20,0,20)];
    self.customTabBar.selectionIndicatorImage=tabBarSelectedImage;
    self.customTabBar.selectedItem = firstTabItem;
   // self.customTabBar.barTintColor = [UIColor colorWithRed:(CGFloat)241/255 green:(CGFloat)241/255 blue:(CGFloat)241/255 alpha:1.0];
   self.customTabBar.selectedImageTintColor = [UIColor whiteColor];
    [self.view addSubview:self.customTabBar];
    
       for (UITabBarItem *tbi in self.customTabBar.items)
       {
           tbi.image = [tbi.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       }
        //===============
    PopularViewController *populerVC = [[PopularViewController alloc] init];
    populerVC.title =[ViewController languageSelectedStringForKey:@"Grade"];
    [self addChildViewController:populerVC];
    UINavigationController *populerNavi = [[UINavigationController alloc] initWithRootViewController:populerVC];
    populerNavi.navigationBar.hidden = YES;
    QuizPlusViewController *quizPlusVC  = [[QuizPlusViewController alloc] init];
    quizPlusVC.title =[ViewController languageSelectedStringForKey:@"Quiz"];
    [self addChildViewController:quizPlusVC];
    NewContentViewController *newContentVC = [[NewContentViewController alloc] init];
    newContentVC.title =[ViewController languageSelectedStringForKey:@"New Content"];
    [self addChildViewController:newContentVC];
    UINavigationController *newContentNavi = [[UINavigationController alloc] initWithRootViewController:newContentVC];
    newContentNavi.navigationBar.hidden = YES;
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    profileVC.title =@"프로필";//[ViewController languageSelectedStringForKey:@"Profile"];
    [self addChildViewController:profileVC];
    UINavigationController *ProfileNavi = [[UINavigationController alloc] initWithRootViewController:profileVC];
    ProfileNavi.navigationBar.hidden = YES;
    NSArray *tabBarArray = @[populerNavi,quizPlusVC,newContentNavi,ProfileNavi];
    _tabViewControllersArray = [tabBarArray copy];
    
    
    //Notifications are set up
    
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playGameChallenge:) name:@"gameUiChallenge" object:nil];
    
    
    
    
}
#pragma mark -
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"selected item title = %@",item.title);
    NSLog(@"Tag = %d",(int)item.tag);
    if (item.tag==10)
    {
        if (self.selectedIndex==0)
        {
            return;
        }
        UIViewController *newViewController = [_viewControllers objectAtIndex:0];
        self.selectedIndex = 0;
        [self getSelectedViewControllers:newViewController];
        
    }
    else{
        
        if(item.tag==1)
        {
            PFObject *objUsrDetail=[[SingletonClass sharedSingleton].userDetailinParse objectAtIndex:0];
            NSNumber *totalXp=objUsrDetail[@"TotalXP"];
            [SingletonClass sharedSingleton].totalXp=[NSString stringWithFormat:@"%d",[totalXp intValue]];
            NSLog(@"%@",totalXp);
            int xp=[totalXp intValue];
            if (xp >15771)
            {
                self.selectedIndex = -1;
                UIViewController *newViewController = [_tabViewControllersArray objectAtIndex:item.tag];
                [self getSelectedViewControllers:newViewController];
  
            }
            else
            {
                [self cannotPostQuestion:@"중학생부터 퀴즈를낼 수 있어요"];

            }
        }//condition for 2
        else
        {
            self.selectedIndex = -1;
        UIViewController *newViewController = [_tabViewControllersArray objectAtIndex:item.tag];
        
        [self getSelectedViewControllers:newViewController];
        }
    }
    
}
-(void) tabBarItemSelected:(UITabBarItem *)selectedItem{
    
}
#pragma mark -
-(void) reloadProducts:(NSNotification *)notify{
    
    totalDiamond = (int)[userDefault integerForKey:@"buydiamond"];
    
    [btnDiamond setTitle:[NSString stringWithFormat:@"%d",totalDiamond] forState:UIControlStateNormal];
    
    int buyBoosterCount = (int)[userDefault integerForKey:@"buybooster"];
    
    [btnBooster setTitle:[NSString stringWithFormat:@"%d",buyBoosterCount] forState:UIControlStateNormal];
    
    [self changeLifeUI];
}
-(void)boosterViewUI
{
  
    
      [self compareDate];
    
    if (!btnDiamond) {
        btnDiamond = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDiamond.frame=CGRectMake(3, 5, 68,23);
        btnDiamond.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [btnDiamond setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
        btnDiamond.userInteractionEnabled=NO;
        [btnDiamond setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [btnDiamond setBackgroundImage:[UIImage imageNamed:@"diamond.png"] forState:UIControlStateNormal];
        [self.boosterView addSubview:btnDiamond];
    }
    [btnDiamond setTitle:[NSString stringWithFormat:@"%d",totalDiamond] forState:UIControlStateNormal];
    [btnDiamond setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
     btnDiamond.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    
    UIButton *btnDiamondPlus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnDiamondPlus.frame=CGRectMake(btnDiamond.frame.origin.x+btnDiamond.frame.size.width-15, 10, 15, 15);
    [btnDiamondPlus addTarget:self action:@selector(btnDiamondPlusAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnDiamondPlus setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
    [btnDiamondPlus setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [self.boosterView addSubview:btnDiamondPlus];
    
    int buyBoosterCount = (int)[userDefault integerForKey:@"buybooster"];
//    UIView *boosterBackView=[[UIView alloc]initWithFrame:CGRectMake(btnDiamondPlus.frame.origin.x+btnDiamondPlus.frame.size.width+9, 2, 78, 25)];
//    boosterBackView.backgroundColor=[UIColor clearColor];
//    boosterBackView.layer.cornerRadius=3;
   

    if (!btnBooster) {
        btnBooster = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnBooster.frame=CGRectMake(btnDiamondPlus.frame.origin.x+btnDiamondPlus.frame.size.width+9, 2, 67, 33);
        [btnBooster setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnBooster.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        //btnBooster.userInteractionEnabled=NO;
         [btnBooster setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [btnBooster setBackgroundImage:[UIImage imageNamed:@"boosterNew.png"] forState:UIControlStateNormal];
        [btnBooster addTarget:self action:@selector(boosterAction) forControlEvents:UIControlEventTouchUpInside];
        [self.boosterView addSubview:btnBooster];
    }
    [btnBooster setTitle:[NSString stringWithFormat:@"%d",buyBoosterCount] forState:UIControlStateNormal];
    
    UIButton *btnBoosterPlus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnBoosterPlus.frame=CGRectMake(btnBooster.frame.origin.x+btnBooster.frame.size.width-13, 11, 15, 15);
    [btnBoosterPlus setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [btnBoosterPlus addTarget:self action:@selector(btnBoosterPlusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.boosterView addSubview:btnBoosterPlus];
    
    if (!btnLife) {
        btnLife = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnLife.frame=CGRectMake(btnBooster.frame.origin.x+btnBooster.frame.size.width+7, 8, 147, 17);
        btnLife.userInteractionEnabled=NO;
        [self.boosterView addSubview:btnLife];
    }
    
    if (!lblLifeTime) {
        lblLifeTime=[[UILabel alloc]initWithFrame:CGRectMake(109, 0, 45, 20)];
        lblLifeTime.font=[UIFont boldSystemFontOfSize:11];
        lblLifeTime.textColor=[UIColor blackColor];
        [btnLife addSubview:lblLifeTime];
    }
    [self changeLifeUI];
    UIButton *btnLifePlus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLifePlus.frame=CGRectMake(self.view.frame.size.width-23, 10, 15, 15);
    [btnLifePlus setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [btnLifePlus addTarget:self action:@selector(btnLifePlusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.boosterView addSubview:btnLifePlus];
}


-(void)changeLifeUI {
    
    int lifeCount = (int)[userDefault integerForKey:@"buylife"];
    
    switch (lifeCount) {
        case 0:
            [btnLife setBackgroundImage:[UIImage imageNamed:@"empty_life.png"] forState:UIControlStateNormal];
            break;
        case 1:
            [btnLife setBackgroundImage:[UIImage imageNamed:@"1_life.png"] forState:UIControlStateNormal];
            break;
        case 2:
            [btnLife setBackgroundImage:[UIImage imageNamed:@"2_life.png"] forState:UIControlStateNormal];
            break;
        case 3:
            [btnLife setBackgroundImage:[UIImage imageNamed:@"3_life.png"] forState:UIControlStateNormal];
            break;
        case 4:
            [btnLife setBackgroundImage:[UIImage imageNamed:@"4_life.png"] forState:UIControlStateNormal];
            break;
        case 5:
            [btnLife setBackgroundImage:[UIImage imageNamed:@"full_life.png"] forState:UIControlStateNormal];
            break;
        default:
            [btnLife setBackgroundImage:[UIImage imageNamed:@"full_life.png"] forState:UIControlStateNormal];
            break;
    }
    
    if (lifeCount ==5) {
        lblLifeTime.text=@"00:00";
        if ([timer isValid]) {
            timer = nil;
            [timer invalidate];
        }
    }
    else if (lifeCount<5) {
        
        if (![timer isValid]) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(lifeTimer) userInfo:nil repeats:YES];
            [timer fire];
        }
    }
    else {
        
        int extraLife = lifeCount-5;
        lblLifeTime.text=[NSString stringWithFormat:@"+ %d",extraLife];
        NSLog(@"Label Life =--=%@",lblLifeTime.text);
    }
}
-(void)lifeTimer {
    
    time--;
    
    if (time==0) {
        
        int totalLife = [userDefault integerForKey:@"buylife"];
        totalLife++;
        [userDefault setInteger:totalLife forKey:@"buylife"];
        [userDefault synchronize];
        
        if ([timer isValid]) {
            [timer invalidate];
            timer=nil;
        }
        time = 120;
        [self changeLifeUI];
    }
    else{
        int min = time/60;
        int sec = time%60;
        if (sec<10) {
            lblLifeTime.text=[NSString stringWithFormat:@"0%d:0%d",min,sec];
        }
        else{
            lblLifeTime.text=[NSString stringWithFormat:@"0%d:%d",min,sec];
        }
    }
}
#pragma mark timer methods
////////////////////ComPare Date////////////////////////////////
-(void)compareDate
{
    NSString *strDate=[userDefault objectForKey:@"currentDate"];
    NSLog(@"date==%@",strDate);
    if (![strDate isEqualToString:@"0"]) {
        NSDate *currentDate=[NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSString *strCurrentDate = [formatter stringFromDate:currentDate];
        
        currentDate=[formatter dateFromString:strCurrentDate];
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        NSDate *oldDate = [formatter1 dateFromString:strDate];
        
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
        NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
       
        NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDate  toDate:currentDate  options:0];
        
        //int months = (int)[conversionInfo month];
        int days = (int)[conversionInfo day];
        int hours = (int)[conversionInfo hour];
        int minutes = (int)[conversionInfo minute];
        int seconds = (int)[conversionInfo second];
        [self shouldCheckBoostTimer:days andHour:hours andMin:minutes andSec:seconds];
    }
    
    
}
-(void)shouldCheckBoostTimer:(int)day andHour:(int)hour andMin:(int)minu andSec:(int)seco
{
    int hoursInMin=hour*60;
    hoursInMin=hoursInMin+minu;
    
    int totalTime=hoursInMin*60+seco;
    int remTime=3600-totalTime;
    
    if(day>0 || totalTime>=3600)
    {
        [userDefault setObject:@"0" forKey:@"currentDate"];
        [userDefault synchronize];
        NSLog(@"Disable Booster");
        btnBooster.titleLabel.hidden=NO;
    }
    
    else
    {
        [btnBooster setTitle:@"" forState:UIControlStateNormal];
        boosterTime=remTime;
        timerForBooster = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(boosterTimer) userInfo:nil repeats:YES];
        [timerForBooster fire];
    }
}
-(void)boosterAction
{
    [self boosterTakenAlert:@"당신은 부스터 를 사용하고 싶습니다 ?"];


}

-(void)boosterTimer
{
   
    if (boosterTime==0)
    {
        int currentBooster=[userDefault integerForKey:@"buybooster"];
        [btnBooster setTitle:[NSString stringWithFormat:@"%d",currentBooster] forState:UIControlStateNormal];
        if([timerForBooster isValid])
        {
            
            [timerForBooster invalidate];
            
        }
    }
    btnBooster.titleLabel.font=[UIFont boldSystemFontOfSize:11];
    int min = boosterTime/60;
    int sec = boosterTime%60;
    if (min>10)
    {
        if(sec>10)
        {
            //lblLifeTime.text=[NSString stringWithFormat:@"0%d:0%d",min,sec];
            [btnBooster setTitle:[NSString stringWithFormat:@"%d:%d",min,sec] forState:UIControlStateNormal];
            [btnBooster setTitleEdgeInsets:UIEdgeInsetsMake(0,5 , 0, 0)];
        }
        else
        {
             [btnBooster setTitleEdgeInsets:UIEdgeInsetsMake(0,5, 0, 0)];
            [btnBooster setTitle:[NSString stringWithFormat:@"%d:0%d",min,sec] forState:UIControlStateNormal];
        }
        
    }
    else
    {
        if(sec>10)
        {
            [btnBooster setTitleEdgeInsets:UIEdgeInsetsMake(0,5 , 0, 0)];
            //lblLifeTime.text=[NSString stringWithFormat:@"0%d:0%d",min,sec];
            [btnBooster setTitle:[NSString stringWithFormat:@"%d:%d",min,sec] forState:UIControlStateNormal];
        }
        else
        {
            [btnBooster setTitleEdgeInsets:UIEdgeInsetsMake(0,5 , 0, 0)];
            [btnBooster setTitle:[NSString stringWithFormat:@"%d:0%d",min,sec] forState:UIControlStateNormal];
        }
    }
    
    
    boosterTime--;
}


#pragma mark
#pragma mark Button Action Methods

-(void)btnLifePlusAction:(id)sender {
    
    PurchaseView *obj = [[PurchaseView alloc]initWithButton:@"life"];
    obj.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    obj.delegate=self;
    
    [self presentPopupViewController:obj animationType:MJPopupViewAnimationSlideTopBottom];
}
-(void)btnBoosterPlusAction:(id)sender {
    
   // self.headerView.backgroundColor=[UIColor colorWithRed:(CGFloat)26/255 green:(CGFloat)26/255 blue:(CGFloat)26/255 alpha:1];
    self.contentContainerView.backgroundColor=[UIColor colorWithRed:(CGFloat)26/255 green:(CGFloat)26/255 blue:(CGFloat)26/255 alpha:1];
    
    PurchaseView *obj = [[PurchaseView alloc]initWithButton:@"booster"];
    obj.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    obj.delegate=self;
    [self presentPopupViewController:obj animationType:MJPopupViewAnimationSlideTopBottom];
}
-(void)btnDiamondPlusAction:(id)sender {
    
    PurchaseView *obj = [[PurchaseView alloc]initWithButton:@"diamond"];
    obj.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    obj.delegate=self;
    [self presentPopupViewController:obj animationType:MJPopupViewAnimationSlideTopBottom];
}
- (void)cancelButtonClicked:(PurchaseView *)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
-(void) handleSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture{
    
    if (self.mainsubView.frame.origin.x<0) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
            
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(-200, 0,screenSize.size.width, screenSize.size.height-45);
        }completion:^(BOOL finish){
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        }];
    }
}
-(void) createMenuTableView
{
    
    if (!self.menuTableView)
    {
        self.selectedIndex = 0;
        self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-200, 90, 200, self.screen_height-140) style:UITableViewStylePlain];
        
        self.menuTableView.backgroundColor =  [UIColor colorWithRed:(CGFloat)39/255 green:(CGFloat)39/255 blue:(CGFloat)41/255 alpha:1];
        
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        
    }
    else
    {
        [self.menuTableView reloadData];
    }
    
    [self.view insertSubview:self.menuTableView belowSubview:self.mainsubView];
    
    
    if (!imageVUser)
    {
        imageVUser = [[UIImageView alloc] init];
        imageVUser.frame=CGRectMake(self.view.frame.size.width-180, 25, 60, 60);
        imageVUser.layer.cornerRadius=30;
        imageVUser.clipsToBounds=YES;
        //        [self.headerView addSubview:imageVUser];
        [self.view insertSubview:imageVUser belowSubview:self.mainsubView];
    }
    if (!lblUserName) {
        
        lblUserName = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100,50, 50, 20)];
        lblUserName.font=[UIFont boldSystemFontOfSize:12];
        lblUserName.textColor=[UIColor whiteColor];
        //        [self.headerView addSubview:lblUserName];
        [self.view insertSubview:lblUserName belowSubview:self.mainsubView];
    }
    if (!lblUserRank) {
        lblUserRank=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 70,90, 20)];
        lblUserRank.font=[UIFont boldSystemFontOfSize:12];
        lblUserRank.textColor=[UIColor whiteColor];
        [self.view insertSubview:lblUserRank belowSubview:self.mainsubView];
    }
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet)
    {
        [NSThread detachNewThreadSelector:@selector(fetchUserNameAndImage) toTarget:self withObject:nil];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
    }
    
}
-(void)fetchUserNameAndImage
{
    
    PFQuery *query = [PFUser query];
    NSLog(@"Object Id =--= %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"objectid"]);
    [query whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].objectId];
    NSArray *arr = [query findObjects];
    [SingletonClass sharedSingleton].userDetailinParse=[NSArray arrayWithArray:arr];
    PFObject *objUsrDetail=[[SingletonClass sharedSingleton].userDetailinParse objectAtIndex:0];
    [SingletonClass sharedSingleton].userBlockList=objUsrDetail[@"BlockUser"];
    NSNumber *totalXp=objUsrDetail[@"TotalXP"];
    [SingletonClass sharedSingleton].totalXp=[NSString stringWithFormat:@"%d",[totalXp intValue]];
    NSDictionary *dict = [arr objectAtIndex:0];
    
    NSString *strName = [dict objectForKey:@"name"];
    
    lblUserName.text=strName;
    [SingletonClass sharedSingleton].strUserName = strName;
    NSString *strRank = [dict objectForKey:@"Rank"];
    [SingletonClass sharedSingleton].userRank=strRank;
    [SingletonClass sharedSingleton].strCountry=[dict objectForKey:@"Country"];
      lblUserRank.text=[ViewController languageSelectedStringForKey:strRank];
    PFFile  *strImage = [dict objectForKey:@"userimage"];
    [SingletonClass sharedSingleton].imageFileUrl=strImage.url;
    NSLog(@"%@ user image url",strImage.url);
    NSData *imageData = [strImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    imageVUser.image=image;
    
    [SingletonClass sharedSingleton].imageUser=image;
    
}
#pragma mark -
-(void) menuButtonClciked:(id)sender{
    
    if (self.mainsubView.frame.origin.x<0 ) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(0, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
            
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            self.mainsubView.frame = CGRectMake(-200, 0,screenSize.size.width, screenSize.size.height-45);
            
        }completion:^(BOOL finish){
            
            self.swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
            
        }];
    }
    
    
}

#pragma mark -
#pragma mark TableView Delegate and DataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        
        return self.viewControllers.count;
    }
    else if (section == 1){
        return self.secondSectionViewControllers.count;
    }
    return 0;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIColor *firstColor =  [UIColor colorWithRed:(CGFloat)39/255 green:(CGFloat)39/255 blue:(CGFloat)41/255 alpha:1];
    UIColor *secColor = [UIColor colorWithRed:(CGFloat)48/255 green:(CGFloat)48/255 blue:(CGFloat)50/255 alpha:1];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = cell.contentView.frame;
    layer.colors = [NSArray arrayWithObjects:(id)firstColor.CGColor,(id)secColor.CGColor, nil];
    
    [cell.contentView.layer insertSublayer:layer atIndex:0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //Check Section
    NSString * title=[NSString stringWithFormat:@"%@",[(UIViewController *)[_viewControllers objectAtIndex:indexPath.row] title]];
//    NSLog(@"Title = %@",title);
    
    cell.textLabel.text =  [self languageSelectedStringForKey:title];
    NSString *cellValueOrignal = [(UIViewController *)[self.viewControllers objectAtIndex:indexPath.row]title];
    NSString *cellValue=[ViewController languageSelectedStringForKey:cellValueOrignal];
    //adding now
//    NSLog(@"cell value %@",cellValue);
    
    if ([cellValue isEqualToString:@"Home"] || [cellValue isEqualToString:@"홈"]) {
        cell.imageView.image=[UIImage imageNamed:@"home.png"];
    }
    else if ([cellValue isEqualToString:@"Topic"] || [cellValue isEqualToString:@"토픽"]) {
        cell.imageView.image=[UIImage imageNamed:@"topic.png"];
    }
    else if ([cellValue isEqualToString:@"Friend"] || [cellValue isEqualToString:@"친구"]) {
        cell.imageView.image=[UIImage imageNamed:@"friends.png"];
    }
    else if ([cellValue isEqualToString:@"History"] || [cellValue isEqualToString:@"히스토리"]) {
        cell.imageView.image=[UIImage imageNamed:@"slideHistory.png"];
    }
    else if ([cellValue isEqualToString:@"Messages"] || [cellValue isEqualToString:@"메시지"]) {
        cell.imageView.image=[UIImage imageNamed:@"message.png"];
    }
    else if ([cellValue isEqualToString:@"Discussions"] || [cellValue isEqualToString:@"토론"]) {
        cell.imageView.image=[UIImage imageNamed:@"discussion.png"];
    }
    else if ([cellValue isEqualToString:@"Achievements"] || [cellValue isEqualToString:@"뱃지"]) {
        cell.imageView.image=[UIImage imageNamed:@"achievements.png"];
    }
    else if ([cellValue isEqualToString:@"Store"] || [cellValue isEqualToString:@"스토어"]) {
        cell.imageView.image=[UIImage imageNamed:@"store.png"];
    }
    else if ([cellValue isEqualToString:@"Settings"] || [cellValue isEqualToString:@"설정"]) {
        cell.imageView.image=[UIImage imageNamed:@"settings.png"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Dismiss Menu TableView with Animation
    [UIView animateWithDuration:.5 animations:^{
        
        self.mainsubView.frame = CGRectMake(0, 0, screenSize.size.width, screenSize.size.height-45);
        
    }completion:^(BOOL finished){
        //After completion
        //first check if new selected view controller is equals to previously selected view controller
        UIViewController *newViewController = [_viewControllers objectAtIndex:indexPath.row];
        if ([newViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)newViewController popToRootViewControllerAnimated:YES];
        }
        if (self.selectedIndex==indexPath.row  && self.selectedSection == indexPath.section) {
          //  return;
        }
        if (indexPath.row==0) {
            self.customTabBar.selectedItem = [self.customTabBar.items objectAtIndex:0];
        }
        else{
            self.customTabBar.selectedItem = nil;
        }
        
        _selectedSection = indexPath.section;
        _selectedIndex = indexPath.row;
        
        [self getSelectedViewControllers:newViewController];
        updateValue = 0;
    }];
    self.topicButton.hidden=YES;
    
}
#pragma mark -
-(void) getSelectedViewControllers:(UIViewController *)newViewController{
    // selected new view controller
    UIViewController *oldViewController = _selectedViewController;
    
    if (newViewController != nil) {
        [oldViewController.view removeFromSuperview];
        _selectedViewController = newViewController;
        
        //Update Container View with selected view controller view
        [self updateViewContainer];
        //Check Delegate assign or not
    }
}
-(void) updateViewContainer{
    self.selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.selectedViewController.view.frame = self.contentContainerView.bounds;
    
    self.menuLabel.text = [self languageSelectedStringForKey:self.selectedViewController.title];//self.selectedViewController.title;
    NSLog(@"menu label -=- %@",self.menuLabel.text);
    [self.contentContainerView addSubview:self.selectedViewController.view];
    if (self.selectedIndex==0)
    {
        self.backButton.hidden = YES;
    }
    else{
        self.backButton.hidden = NO;
    }
    
}
-(void)backButtonForHome:(NSNotification*)notify
{
    if([[[notify userInfo] valueForKey:@"detect"]isEqualToString:@"Show"])
    {
       self.backButton.hidden=NO;
    }
    else
    {
        self.backButton.hidden=YES;
    }
   
}
-(NSString*) languageSelectedStringForKey:(NSString*) key
{
	NSString *path;
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *strLan = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
	
    if([strLan isEqualToString:@"English"])
		path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
	
    else if([strLan isEqualToString:@"Korean"])
		path = [[NSBundle mainBundle] pathForResource:@"ko" ofType:@"lproj"];
    else{
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
	NSBundle* languageBundle = [NSBundle bundleWithPath:path];
	NSString* str=[languageBundle localizedStringForKey:key value:@"" table:nil];
	return str;
}
-(void) updateLanguage:(NSNotification *)notify{
    
    id value = [notify object];
    if (![value isKindOfClass:[NSString class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([value isEqualToString:@"Korean"]){
            UITabBarItem *firstTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"home_k.png"] selectedImage:[UIImage imageNamed:@"home_k_active.png"]];
            firstTabItem.tag = 10;
            
            UITabBarItem *secondTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"grade_k.png"] selectedImage:[UIImage imageNamed:@"grade_K_active.png"]];
            secondTabItem.tag = 0;
            UITabBarItem *thirdTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"quizplus_k.png"] selectedImage:[UIImage imageNamed:@"quizplus_k_active.png"]];
            thirdTabItem.tag = 1;
            UITabBarItem *fourthTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"new_k.png"] selectedImage:[UIImage imageNamed:@"new_k_active.png"]];
            fourthTabItem.tag = 2;
            UITabBarItem *fifthTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"profile_k.png"] selectedImage:[UIImage imageNamed:@"profile_k_active.png"]];
            fifthTabItem.tag = 3;
            self.customTabBar.items = @[firstTabItem, secondTabItem, thirdTabItem, fourthTabItem, fifthTabItem];
        }
        else {
            UITabBarItem *firstTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"home_e.png"] selectedImage:[UIImage imageNamed:@"home_active.png"]];
            firstTabItem.tag = 10;
            
            UITabBarItem *secondTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"grade.png"] selectedImage:[UIImage imageNamed:@"grade_active.png"]];
            secondTabItem.tag = 0;
            UITabBarItem *thirdTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"quizplus.png"] selectedImage:[UIImage imageNamed:@"quizplus_active.png"]];
            thirdTabItem.tag = 1;
            UITabBarItem *fourthTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"new.png"] selectedImage:[UIImage imageNamed:@"new_active.png"]];
            fourthTabItem.tag = 2;
            UITabBarItem *fifthTabItem = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"profile.png"] selectedImage:[UIImage imageNamed:@"profile_active.png"]];
            fifthTabItem.tag = 3;
            self.customTabBar.items = @[firstTabItem, secondTabItem, thirdTabItem, fourthTabItem, fifthTabItem];
        }
        NSString *title = [self languageSelectedStringForKey:@"Back"];
        [self.backButton setTitle:[NSString stringWithFormat:@"    %@",title] forState:UIControlStateNormal];
        self.menuLabel.text = [self languageSelectedStringForKey:@"Settings"];
        [self.backButton.titleLabel sizeToFit];
        [self.menuTableView reloadData];
    });
    
}
#pragma mark-----
#pragma mark alert view delegates
-(void)boosterTakenAlert:(NSString *)request
{
    
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 100)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 20)];
    lblReject.text=[ViewController languageSelectedStringForKey:request ];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(15,popUpImageview.frame.size.height-40,120, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strAccept=@"용도";//[ViewController languageSelectedStringForKey:@"Using"];
    [acceptBtn setTitle:strAccept forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(acceptButtonBooster:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:acceptBtn];
    UIButton * rejectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rejectBtn.frame=CGRectMake(popUpImageview.frame.size.width/2+15,popUpImageview.frame.size.height-40,120,30);
    [rejectBtn setBackgroundImage:[UIImage imageNamed:@"reject_btn.png"] forState:UIControlStateNormal];
    [rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strReject=[ViewController languageSelectedStringForKey:@"Cancel"];
    [rejectBtn setTitle:strReject forState:UIControlStateNormal];
    rejectBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [rejectBtn addTarget:self action:@selector(rejectButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:rejectBtn];
    
}
-(void)acceptButtonBooster:(id)sender
{
        boosterTime=3600;
    int buyBoosterCount=[userDefault integerForKey:@"buybooster"];
    if(buyBoosterCount>0)
    {
        int buyBoosterCount = (int)[userDefault integerForKey:@"buybooster"];
        
        [btnBooster setTitle:[NSString stringWithFormat:@"%d",buyBoosterCount] forState:UIControlStateNormal];
       [btnBooster setUserInteractionEnabled:NO];
     NSDate *currentDate=[NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
      [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
       NSString *strCurrentDate=[formatter stringFromDate:currentDate];
       [userDefault setObject:strCurrentDate forKey:@"currentDate"];
       timerForBooster = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(boosterTimer) userInfo:nil repeats:YES];
       [timerForBooster fire];
      [SingletonClass sharedSingleton].boosterEnable=TRUE;
    [rejectView removeFromSuperview];
    }

}
-(void)rejectButton:(id)sender
{
   
    [rejectView removeFromSuperview];
}
-(void)cannotPostQuestion:(NSString *)request
{
    
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 100)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0,40, popUpImageview.frame.size.width, 20)];
    lblReject.text=[ViewController languageSelectedStringForKey:request ];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(popUpImageview.frame.size.width-30,5,30, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    NSString * strAccept=[ViewController languageSelectedStringForKey:@"Using"];
//    [acceptBtn setTitle:strAccept forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(cancelButtonPopup:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:acceptBtn];
    
    
}
-(void)cancelButtonPopup:(id)sender
{
    [rejectView removeFromSuperview];
}


@end

static void * const kMyPropertyAssociatedStorageKey = (void*)&kMyPropertyAssociatedStorageKey;

@implementation UIViewController (CustomMenuViewControllerItem)
@dynamic customMenuViewController;

static char const * const orderedElementKey;

-(void) setCustomMenuViewController:(CustomMenuViewController *)customMenuViewController{
    
    NSLog(@"cc==%@",customMenuViewController.viewControllers);
    
    objc_setAssociatedObject(self, &orderedElementKey, customMenuViewController,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CustomMenuViewController *) customMenuViewController{
    
    if (objc_getAssociatedObject(self, &orderedElementKey) != nil)
    {
        NSLog(@"Element: %@", objc_getAssociatedObject(self, orderedElementKey));
    }
    
    NSLog(@"Element: %@", objc_getAssociatedObject(self, &orderedElementKey));
    //    return objc_getAssociatedObject(self, @selector(customMenuViewController));
    return objc_getAssociatedObject(self, orderedElementKey);
    //return  self.customMenuViewController;
}
-(void)dealloc
{
    NSLog(@"Dealloc Called");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
