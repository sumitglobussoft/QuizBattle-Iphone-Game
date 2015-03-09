//
//  LogInViewController.m
//  QuizBattle
//
//  Created by Sumit Ghosh on 24/09/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "LogInViewController.h"
#import "ViewController.h"
#import <Parse/Parse.h>
#import "SingletonClass.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "TopicsViewController.h"
#import "FriendsViewController.h"
#import "MainHistoryViewController.h"
#import "MessagesViewController.h"
#import "DiscussionsViewController.h"
#import "AchievementsViewController.h"
#import "StoreViewController.h"
#import "SettingsViewController.h"
#import "ConnectionListener.h"
#import "RoomListener.h"
#import "NotificationListener.h"
@interface LogInViewController ()

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //------
        frgtPswClick=NO;
    //-----
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *customV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [customV setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    [self.view addSubview:customV];
   NSString *strBtnTitle = [ViewController languageSelectedStringForKey:@"Log In"];
    
    lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(120, 10,80 , 30)];
    lblHeader.text=strBtnTitle;
    lblHeader.textAlignment=NSTextAlignmentLeft;
    lblHeader.font=[UIFont boldSystemFontOfSize:20];
    lblHeader.textColor=[UIColor whiteColor];
    [customV addSubview:lblHeader];
   
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame=CGRectMake(self.view.frame.size.width-100, 10,90, 30);
    btnNext.titleLabel.textAlignment=NSTextAlignmentLeft;
    [btnNext setTitle:[ViewController languageSelectedStringForKey:@"Next >"] forState:UIControlStateNormal];
    btnNext.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [customV addSubview:btnNext];

    backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame=CGRectMake(customV.frame.origin.x+10, 10, 30, 30);
    backbtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    //[backbtn setTitle:[ViewController languageSelectedStringForKey:@"< Back"] forState:UIControlStateNormal];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"back_btnForall.png"] forState:UIControlStateNormal];
    [backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backbtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [backbtn addTarget:self action:@selector(btnBackActioninLogIn:) forControlEvents:UIControlEventTouchUpInside];
    [customV addSubview:backbtn];
    

    NSString *strEmail = [ViewController languageSelectedStringForKey:@"Email"];
    NSString *strPass = [ViewController languageSelectedStringForKey:@"Password"];
    txtFUsername = [[UITextField alloc] initWithFrame:CGRectMake(50, customV.frame.size.height+40, self.view.frame.size.width-100, 50)];
    txtFUsername.placeholder=strEmail;
    txtFUsername.layer.borderWidth=2;
    txtFUsername.layer.borderColor=[UIColor blackColor].CGColor;
    txtFUsername.textAlignment=NSTextAlignmentCenter;
    txtFUsername.delegate=self;
    txtFUsername.autocorrectionType=UITextAutocorrectionTypeNo;
    [txtFUsername setLeftViewMode:UITextFieldViewModeAlways];
    
    txtFUsername.leftView=envelopeImage;
    [self.view addSubview:txtFUsername];
    
    txtFPass = [[UITextField alloc] initWithFrame:CGRectMake(50, txtFUsername.frame.origin.y+txtFUsername.frame.size.height+20, self.view.frame.size.width-100, 50)];
    txtFPass.placeholder=strPass;
    txtFPass.secureTextEntry=YES;
    txtFPass.layer.borderWidth=2;
    txtFPass.layer.borderColor=[UIColor blackColor].CGColor;
    txtFPass.textAlignment=NSTextAlignmentCenter;
    txtFPass.delegate=self;
    [txtFPass setLeftViewMode:UITextFieldViewModeAlways];
    txtFPass.leftView=passwrdImage;
    [self.view addSubview:txtFPass];
   
    envelopeImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"email.png"]];
    envelopeImage.frame=CGRectMake(0, 0, envelopeImage.image.size.width+20, envelopeImage.image.size.height);
    envelopeImage.contentMode=UIViewContentModeCenter;
    passwrdImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password.png"]];
    passwrdImage.frame=CGRectMake(0, 0, passwrdImage.image.size.width+20, passwrdImage.image.size.height);
    passwrdImage.contentMode=UIViewContentModeCenter;

    forgotpswd=[[UIButton alloc]initWithFrame:CGRectMake(70, txtFPass.frame.origin.y+35, 200, 80)];
    NSString *forgetpswd=[NSString stringWithFormat:@"Forgot your password?"];
    [forgotpswd setTitle:forgetpswd forState:UIControlStateNormal];
    [forgotpswd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgotpswd.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    [forgotpswd addTarget:self action:@selector(forgetPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotpswd];
  
    //txtFPass.text = @"12345";
    //==========
    //[self initAppwrap];
}
-(void)createSessionQickBlox
{
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
       
        // session created
    } errorBlock:^(QBResponse *response) {
        // handle errors
        NSLog(@"Error in creating session in Quick Blox%@", response.error);
    }];
    
}

-(void)initAppwrap
{
    WarpClient *warpClient = [WarpClient getInstance];
    [warpClient setRecoveryAllowance:60];
    [warpClient enableTrace:YES];
    ConnectionListener *connectionListener = [[ConnectionListener alloc] initWithHelper:self];
    [warpClient addConnectionRequestListener:connectionListener];
    [warpClient addZoneRequestListener:connectionListener];
    RoomListener *roomListener = [[RoomListener alloc]initWithHelper:self];
    [warpClient addRoomRequestListener:roomListener];
    NotificationListener *notificationListener = [[NotificationListener alloc]initWithHelper:self];
    [warpClient addNotificationListener:notificationListener];
}


-(void)btnBackActioninLogIn:(id)sender
{
    if(frgtPswClick)
    {
        lblHeader.text=[ViewController languageSelectedStringForKey:@"Log In"];
        lblHeader.frame=CGRectMake(120, 10,80 , 30);
        txtFPass.hidden=NO;
        txtFUsername.hidden=NO;
        forgotpswd.hidden=NO;
        txtfEmail.hidden=YES;
        sendButton.hidden=YES;
        btnNext.hidden=NO;
        frgtPswClick=NO;
         sendlnktoEmail.text=@"";
    }
    else
    {
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)nextBtnAction:(id)sender
{
//    if(frgtPswClick)
//    {
//        [self resetPasswrdAction:nil];
//    }
//    else
   // {
        [self loginCheck];
   // }
}
-(void)loginCheck  {
  //  txtFUsername.text=@"Sukhm@gmail.com";
    UIImageView *imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-60, 30, 50)];
    [self.view addSubview:imageVAnim];
    
    NSArray *arrAnimImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"burning_rocket_01.png"],
                              [UIImage imageNamed:@"burning_rocket_02.png"],
                              [UIImage imageNamed:@"burning_rocket_03.png"],
                              [UIImage imageNamed:@"burning_rocket_04.png"],
                              [UIImage imageNamed:@"burning_rocket_05.png"],
                              [UIImage imageNamed:@"burning_rocket_06.png"],
                              [UIImage imageNamed:@"burning_rocket_07.png"],
                              [UIImage imageNamed:@"burning_rocket_08.png"], nil];
    
    imageVAnim.animationImages=arrAnimImages;
    imageVAnim.animationDuration=0.5;
    imageVAnim.animationRepeatCount=0;

    NSLog(@"Username =-=- %@ Password =--= %@",txtFUsername.text, txtFPass.text);
  [self createSessionQickBlox];

    if (txtFUsername.text.length<1) {
        [[[UIAlertView alloc] initWithTitle:@"" message:[ViewController languageSelectedStringForKey:@"Enter user name"] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"Ok"] otherButtonTitles:nil, nil] show];
        
        return;
    }
    else if (txtFPass.text.length<1){
        [[[UIAlertView alloc] initWithTitle:@"" message:[ViewController languageSelectedStringForKey:@"Enter password"] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"Ok"] otherButtonTitles:nil, nil] show];
        return;
    }
        [imageVAnim startAnimating];
    BOOL checkInternet=[ViewController networkCheck];
    if (checkInternet) {

        [PFUser logInWithUsernameInBackground:txtFUsername.text password:txtFPass.text block:^(PFUser *user, NSError *error) {
        
        if (user) {
            // Do stuff after successful login.
            [[NSUserDefaults standardUserDefaults] setObject:txtFUsername.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:txtFPass.text forKey:@"password"];
            [SingletonClass sharedSingleton].objectId=user.objectId;
            [self performSelector:@selector(connectAppWrap) withObject:nil afterDelay:3];
            NSLog(@"Object id on login %@",[SingletonClass sharedSingleton].objectId);
            CustomMenuViewController *obj = [LogInViewController goTOHomeView];
             [[NSUserDefaults standardUserDefaults] setObject:user.objectId forKey:@"objectid"];
            [imageVAnim stopAnimating];
            strUserObjectId = user.objectId;
            [self presentViewController:obj animated:YES completion:nil];
            NSLog(@"User ID Check -=-= %@",user.objectId);
            [[NSUserDefaults standardUserDefaults] setObject:user.objectId forKey:@"objectid"];
            
            if(user.isNew)
            {
          //   [self signUpInQuickblox];
            }
            else
            {
            //    [self signUpInQuickblox];
              //[self loginQuickblox];
            }
            
            //[self logInQuickblox];
            [self saveObjectIdInInstallation];
            
        } else {
            // The login failed. Check error to see why.
            
            [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Email or Password is wrong."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil]show];
            [imageVAnim stopAnimating];
        }
    }];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey: @"OK"] otherButtonTitles: nil] show];
    }
}
#pragma mark Forget Password
-(void)forgetPasswordAction:(id)sender
{
    lblHeader.frame=CGRectMake(100,10,120,30);
    lblHeader.text=[ViewController languageSelectedStringForKey:@"Password Search"];
    frgtPswClick=YES;
    txtFPass.hidden=YES;
    txtFUsername.hidden=YES;
    forgotpswd.hidden=YES;
    btnNext.hidden=YES;
    txtfEmail = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, self.view.frame.size.width-100, 50)];
    txtfEmail.placeholder=[ViewController languageSelectedStringForKey:@"Enter Email"];
    txtfEmail.layer.borderWidth=2;
    txtfEmail.layer.borderColor=[UIColor blackColor].CGColor;
    txtfEmail.textAlignment=NSTextAlignmentCenter;
    txtfEmail.delegate=self;
    txtfEmail.autocorrectionType=UITextAutocorrectionTypeNo;
    [txtfEmail setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:txtfEmail];
    sendButton=[[UIButton alloc]initWithFrame:CGRectMake(110,180, 77, 27)];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    [sendButton setTitle:@"보내" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
}


-(void)resetPasswrdAction:(id)sender
{
    
    if (txtfEmail.text.length<1) {
        [[[UIAlertView alloc]initWithTitle:@"" message:[ViewController languageSelectedStringForKey:@"Please Enter your email"] delegate:self cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles:nil]show];
    }
    else
    {
        customHedrViewfrgtpswd.hidden=YES;
        
        //password reset action
        
        [PFUser requestPasswordResetForEmailInBackground:txtfEmail.text block:^(BOOL success,NSError * error){
            
            if(error)
            {
                if(!sendlnktoEmail)
                {
                   sendlnktoEmail=[[UILabel alloc]initWithFrame:CGRectMake(0,200, 320,100)];
                }
                
                sendlnktoEmail.text=[ViewController languageSelectedStringForKey:@"Please enter your correct Email Id"];
                sendlnktoEmail.textColor=[UIColor blueColor];
                sendlnktoEmail.textAlignment=NSTextAlignmentCenter;
                sendlnktoEmail.numberOfLines=3;
                sendlnktoEmail.lineBreakMode=NSLineBreakByWordWrapping;
                sendlnktoEmail.font=[UIFont boldSystemFontOfSize:20];
                [self.view addSubview:sendlnktoEmail];
  
            }
            else
            {
                if(!sendlnktoEmail)
                {
                    sendlnktoEmail=[[UILabel alloc]initWithFrame:CGRectMake(0,200, 320,100)];
                }
            sendlnktoEmail.text=[ViewController languageSelectedStringForKey:@"Password reset link  has been sent to your email"];
                sendlnktoEmail.textColor=[UIColor blueColor];
                sendlnktoEmail.textAlignment=NSTextAlignmentCenter;
                sendlnktoEmail.numberOfLines=3;
                sendlnktoEmail.lineBreakMode=NSLineBreakByWordWrapping;
                sendlnktoEmail.font=[UIFont boldSystemFontOfSize:20];
                [self.view addSubview:sendlnktoEmail];
                txtfEmail.hidden=YES;
            }
            
            }];
    
        
    }
}
-(void)backAction:(id)sender
{
   // self.frgtpsrdView.hidden=YES;
    txtFPass.hidden=NO;
   txtFUsername.hidden=NO;
    forgotpswd.hidden=NO;
   
    [[[self.view subviews] objectAtIndex:0] removeFromSuperview];
 //[self.frgtpsrdView removeFromSuperview];
}
-(void)connectAppWrap
{
     [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
}
-(void)sendAction:(id)sender
{
     [self resetPasswrdAction:nil];
}
#pragma mark QuickBlox
-(void)signUpInQuickblox
{
    
    QBUUser *user=[QBUUser user];
   // user.email=@"khomesh@globussoft.com";//txtFEmail.text;
    user.password=@"globussoft123";
    user.login=txtFUsername.text;
    //txtFPass.text;
    [QBRequest signUp:user successBlock:^(QBResponse *response,QBUUser *user)
     {
         [self loginQuickblox];
         NSLog(@"Sucessfully Signed Up");
         
         
     }errorBlock:^(QBResponse *response)
     {
         NSLog(@"Error==%@",response.error);
     }];
    
}
-(void)loginQuickblox
{
  //  txtFUsername.text=@"Sukhm@gmail.com";
    NSLog(@"txtFusername %@",txtFUsername.text);
    [QBRequest logInWithUserLogin:txtFUsername.text password:@"globussoft123" successBlock:^(QBResponse *response, QBUUser *user)
     {
        
         [SingletonClass sharedSingleton].quickBloxId=[NSString stringWithFormat:@"%ld",(unsigned long)[user ID]];
         [self saveQuickBloxIdParse];
         NSLog(@"Successfully Log in Quick blox id %ld",(unsigned long)[user ID]);
         // Success, do something
     }
    errorBlock:^(QBResponse *response) {
       // error handling
        NSLog(@"error: %@", response.error);
        }];
    

}
#pragma mark SaveInQuickBlox
-(void)saveQuickBloxIdParse
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

    PFObject * object=[PFUser currentUser];
    object[@"Quickbloxid"]=[SingletonClass sharedSingleton].quickBloxId;
        [object save];
    });
}
-(void)saveObjectIdInInstallation {
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    [currentInstallation setObject:strUserObjectId forKey:@"UserId"];
    [currentInstallation deviceType];
    [currentInstallation saveInBackground];
    
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    
    [query whereKey:@"objectId" equalTo:strUserObjectId];
    
    [query getObjectInBackgroundWithId:strUserObjectId block:^(PFObject *object, NSError *error){
        
   object[@"deviceID"]=[SingletonClass sharedSingleton].installationId;
        [object saveInBackground];
    }];
        }});
}
-(void)btnBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

+(CustomMenuViewController*)goTOHomeView
{
    
    HomeViewController *home = [[HomeViewController alloc]init];
    home.title=[ViewController languageSelectedStringForKey:@"Home"];
    NSLog(@"Title =- %@",home.title);
    TopicsViewController *topic = [[TopicsViewController alloc] initWithNibName:@"TopicsViewController" bundle:nil];
    topic.title = @"토픽";//[ViewController languageSelectedStringForKey:@"Topic"];
    
    FriendsViewController *friend = [[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil];
    friend.title  = [ViewController languageSelectedStringForKey:@"Friend"];
    
    MainHistoryViewController *history = [[MainHistoryViewController alloc] init];
    history.title = @"히스토리";//[ViewController languageSelectedStringForKey:@"History"];
    
    MessagesViewController *message = [[MessagesViewController alloc]initWithNibName:@"MessagesViewController" bundle:nil];
    message.title=[ViewController languageSelectedStringForKey:@"Messages"];
    
    DiscussionsViewController *discussion = [[DiscussionsViewController alloc] initWithNibName:@"DiscussionsViewController" bundle:nil];
    discussion.title=[ViewController languageSelectedStringForKey:@"Discussions"];
    
    AchievementsViewController *achievement = [[AchievementsViewController alloc] initWithNibName:@"AchievementsViewController" bundle:nil];
    achievement.title=[ViewController languageSelectedStringForKey:@"Achievements"];
    
    StoreViewController *store = [[StoreViewController alloc] initWithNibName:@"StoreViewController" bundle:nil];
    store.title=[ViewController languageSelectedStringForKey:@"Store"];
    
    SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settings.title=@"설정";//[ViewController languageSelectedStringForKey:@"Settings"];
    
    UINavigationController *messageNavi = [[UINavigationController alloc] initWithRootViewController:message];
    messageNavi.navigationBar.hidden = YES;
    UINavigationController *friendNavi = [[UINavigationController alloc] initWithRootViewController:friend];
    friendNavi.navigationBar.hidden=YES;
    UINavigationController *discussionNavi = [[UINavigationController alloc] initWithRootViewController:discussion];
    discussionNavi.navigationBar.hidden = YES;
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:home];
    homeNavi.navigationBar.hidden = YES;
    UINavigationController *topicNavi = [[UINavigationController alloc] initWithRootViewController:topic];
    topicNavi.navigationBar.hidden = YES;
    UINavigationController *historyNavi = [[UINavigationController alloc] initWithRootViewController:history];
    historyNavi.navigationBar.hidden = YES;
    
    CustomMenuViewController *customMenuView =[[CustomMenuViewController alloc] init];
    customMenuView.numberOfSections = 1;
    customMenuView.viewControllers = @[homeNavi,topicNavi,friendNavi,historyNavi,messageNavi,discussionNavi,achievement,store,settings];
    
    return customMenuView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [txtFPass resignFirstResponder];
    [txtFUsername resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
