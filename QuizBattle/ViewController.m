//
//  ViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "GameViewController.h"
#import "LogInViewController.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "SignUpWithEmailViewController.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
@interface ViewController ()

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet) {
        //[self goTOHomeView];
        username=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        if([username isEqualToString:@"newuser"])
        {
            [self creteUI];
        }
        else
        {
            if ([UIScreen mainScreen].bounds.size.height>500)
            {
                imageViewBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                imageViewBackground.image=[UIImage imageNamed:@"Default~iphone.png"];
                [self.view addSubview:imageViewBackground];
                [self loginCheck];
                
            }
            else
            {
                imageViewBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
                imageViewBackground.image=[UIImage imageNamed:@"Default.png"];
                [self.view addSubview:imageViewBackground];
                [self loginCheck];
                
            }
        }
    }
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [SingletonClass sharedSingleton].view=self;
    [self playBackGroundMusic];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCustomView) name:@"addMainHomeScreen" object:nil];
  
}
-(void)playBackGroundMusic
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMusic:) name:@"BackgroundSound" object:nil];
    // Create audio player with background music
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"Fiverr - Menu Music for Andy - James Warburton Music" ofType:@"wav"];
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
    [self.backgroundMusicPlayer play];
//    self.backgroundMusicPlayer.delegate = self;  // We need this so we can restart after interruptions
    self.backgroundMusicPlayer.numberOfLoops = -1;
}
-(void)stopMusic:(NSNotification*)notify
{
    [self.backgroundMusicPlayer stop];
}
-(void)viewDidAppear {
    
    headerLabel.text=[ViewController languageSelectedStringForKey:@"LOG IN"];
    
    emailLogIn.titleLabel.text=[ViewController languageSelectedStringForKey:@"Email"];
    NSLog(@"Header label -=- %@",emailLogIn.titleLabel.text);
}
// UI for Login OPtion Screen  Only show once after login once it directly goes to home page

-(void)creteUI {
    
    headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerLabel.backgroundColor=[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel.text=[ViewController languageSelectedStringForKey:@"LOG IN"];
    [self.view addSubview:headerLabel];
    
    UIImageView *imageLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wlcm_logo.png"]];
    [self.view addSubview:imageLogo];
       if (!kkTalkbtn)
       {
         kkTalkbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [kkTalkbtn setBackgroundImage:[UIImage imageNamed:@"kakaotalk.png"] forState:UIControlStateNormal];
        [kkTalkbtn addTarget:self action:@selector(kkbtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [kkTalkbtn setTitle:[ViewController languageSelectedStringForKey:@"KK Talk"] forState:UIControlStateNormal];
        [kkTalkbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:kkTalkbtn];
       }
        if (!emailLogIn)
        {
        emailLogIn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [emailLogIn setBackgroundColor:[UIColor colorWithRed:(CGFloat)239/255 green:(CGFloat)239/255 blue:(CGFloat)239/255 alpha:1.0]];
        NSString * strEmailLogin=[ViewController languageSelectedStringForKey:@"Email LogIn"];
        [emailLogIn setTitle:strEmailLogin forState:UIControlStateNormal];
        [emailLogIn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [emailLogIn addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:emailLogIn];
        }
    if (!emailRegistration)
    {
        emailRegistration=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [emailRegistration setBackgroundColor:[UIColor colorWithRed:(CGFloat)239/255 green:(CGFloat)239/255 blue:(CGFloat)239/255 alpha:1.0]];
        [emailRegistration.titleLabel setTextColor:[UIColor blackColor]];
         NSString * strEmailRegistration=[ViewController languageSelectedStringForKey:@"Email Registration"];
        [emailRegistration setTitle:strEmailRegistration forState:UIControlStateNormal];
        [emailRegistration setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [emailRegistration addTarget:self action:@selector(btnSignUpAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:emailRegistration];
    }
    /*if([UIScreen mainScreen].nativeScale >2.1f)
    {
        imageLogo.frame=CGRectMake(self.view.frame.size.width/2-88, 150, 150, 90);
        imageLogo.image=[UIImage imageNamed:@"wlcm_logo@3x.png"];
        btnFbConnect.frame=CGRectMake(10, 273, self.view.frame.size.width-15, 55);
        lblFbConnect.frame=CGRectMake(110, 5, btnFbConnect.frame.size.width-75, btnFbConnect.frame.size.height-10);
        
        kkTalkbtn.frame=CGRectMake(10, 345, self.view.frame.size.width-15, 55);
        kkLabel.frame=CGRectMake(110, 5, kkTalkbtn.frame.size.width-75, kkTalkbtn.frame.size.height-10);
        
        emailLogIn.frame=CGRectMake(10, kkTalkbtn.frame.origin.y+70,kkTalkbtn.frame.size.width/2,40);
        emailRegistration.frame=CGRectMake(emailLogIn.frame.origin.x+kkTalkbtn.frame.size.width/2+10, kkTalkbtn.frame.origin.y+70, kkTalkbtn.frame.size.width/2-10, 40);
    }
    else*/
    if ([UIScreen mainScreen].bounds.size.height>500)
    {
        imageLogo.frame=CGRectMake(self.view.frame.size.width/2-125, 110,250,131);
        btnFbConnect.frame=CGRectMake(10, 273, self.view.frame.size.width-15, 55);
        lblFbConnect.frame=CGRectMake(110, 5, btnFbConnect.frame.size.width-75, btnFbConnect.frame.size.height-10);
        
        kkTalkbtn.frame=CGRectMake(10, 345, self.view.frame.size.width-20, 55);

        kkLabel.frame=CGRectMake(110, 5, kkTalkbtn.frame.size.width-75, kkTalkbtn.frame.size.height-10);
      
        emailLogIn.frame=CGRectMake(10, kkTalkbtn.frame.origin.y+70,kkTalkbtn.frame.size.width/2,40);
        emailRegistration.frame=CGRectMake(emailLogIn.frame.origin.x+kkTalkbtn.frame.size.width/2+10, kkTalkbtn.frame.origin.y+70, kkTalkbtn.frame.size.width/2-10, 40);
    }
    else
    {
        imageLogo.frame=CGRectMake(self.view.frame.size.width/2-110, 120,220,121);
        btnFbConnect.frame=CGRectMake(10, 240, self.view.frame.size.width-15, 55);
        
        lblFbConnect.frame=CGRectMake(110, 5, btnFbConnect.frame.size.width-75, btnFbConnect.frame.size.height-10);
        //[kkTalkbtn setTitleEdgeInsets:UIEdgeInsetsMake(0,1200, 0, 0)];
        kkTalkbtn.frame=CGRectMake(10, 313, self.view.frame.size.width-20, 55);
        kkLabel.frame=CGRectMake(110, 5, kkTalkbtn.frame.size.width-75, kkTalkbtn.frame.size.height-10);
      
        emailLogIn.frame=CGRectMake(10, kkTalkbtn.frame.origin.y+68,kkTalkbtn.frame.size.width/2,40);
        emailRegistration.frame=CGRectMake(emailLogIn.frame.origin.x+kkTalkbtn.frame.size.width/2+10, kkTalkbtn.frame.origin.y+68, kkTalkbtn.frame.size.width/2-10, 40);
    }
}
-(void)loginButtonAction:(id)sender
{

    LogInViewController *obj=[[LogInViewController alloc]init];
    [self presentViewController:obj animated:YES completion:NULL];
    
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Questions"];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [query whereKey:@"objectId" containedIn:@[@"xDi7rXpcaE",@"hdFJsUA05i",@"cwfyZvnjFC",@"hJlK1ee21G",@"v71GQvgXRt"]];
        [query addAscendingOrder:@"objectId"];
        //[query whereKey:@"objectId" equalTo:@[@"xDi7rXpcaE",@"hdFJsUA05i",@"cwfyZvnjFC",@"hJlK1ee21G",@"v71GQvgXRt"]];
//        [query whereKey:@"objectId" equalTo:@""];
//        [query whereKey:@"objectId" equalTo:@""];
//        [query whereKey:@"objectId" equalTo:@""];
//        [query whereKey:@"objectId" equalTo:@""];
        NSArray *arrDetails = [query findObjects];
//        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"objectId" ascending:YES];
//        NSArray *tempArray = []
        NSLog(@"Question Array Details = %@",arrDetails);
    });
    */
}
-(void)loginCheck
{
    //  txtFUsername.text=@"Sukhm@gmail.com";
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-60, 30, 50)];
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
    username=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    password=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    NSLog(@"Username =-=- %@ Password =--= %@",username, password);
   [self createSessionQickBlox];
    
    
        [imageVAnim startAnimating];
    BOOL checkInternet=[ViewController networkCheck];
    if (checkInternet) {
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            
            if (user) {
                // Do stuff after successful login.
                dispatch_async(dispatch_get_main_queue(), ^(void)
                               {
                [SingletonClass sharedSingleton].objectId=user.objectId;
                [self performSelector:@selector(connectAppWrap) withObject:nil afterDelay:3];
                NSLog(@"Object id on login %@",[SingletonClass sharedSingleton].objectId);
                CustomMenuViewController *obj = [LogInViewController goTOHomeView];
                [[NSUserDefaults standardUserDefaults] setObject:user.objectId forKey:@"objectid"];
                [imageVAnim stopAnimating];
                strUserObjectId = user.objectId;
                [self presentViewController:obj animated:YES completion:nil];
                [imageViewBackground removeFromSuperview];
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
                 });
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
-(void)createSessionQickBlox
{
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
       if(flag_Kakao)
       {
        [self signUpInQuickblox];
       }
        else
        {
            [self loginQuickblox];
        }
        // session created
    } errorBlock:^(QBResponse *response) {
        // handle errors
        NSLog(@"Error in creating session in Quick Blox%@", response.error);
    }];
    
}
-(void)signUpInQuickblox
{
    
    QBUUser *user=[QBUUser user];
    // user.email=@"khomesh@globussoft.com";//txtFEmail.text;
    user.password=@"globussoft123";
    user.login=username;
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
    
    [QBRequest logInWithUserLogin:username password:@"globussoft123" successBlock:^(QBResponse *response, QBUUser *user)
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

-(void)connectAppWrap
{
    [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
}
#pragma mark SaveInQuickBlox
-(void)saveQuickBloxIdParse
{
    
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //
    PFObject * object=[PFUser currentUser];
    object[@"Quickbloxid"]=[SingletonClass sharedSingleton].quickBloxId;
    [object saveInBackgroundWithBlock:^(BOOL success,NSError * error)
     {
         if(error)
         {
             NSLog(@"Error in saving %@",error);
         }
     }];
    //});
}

-(void)btnSignUpAction:(id)sender {
    SignUpWithEmailViewController *obj = [[SignUpWithEmailViewController alloc] init];
    [self presentViewController:obj animated:YES completion:nil];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark ============================
#pragma mark Language change Method
#pragma mark ============================

+(NSString*)languageSelectedStringForKey:(NSString*) key
{
	NSString *path;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *strLan = [userDefault objectForKey:@"language"];
	
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
-(void)facebookConnectAction:(id)sender {
    
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet)
    {
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate openSessionWithAllowLoginUI];
    }
}

#pragma mark-

//=========Find Wi-Fi Status==================================

+ (BOOL)networkCheck {
    
    Reachability *wifiReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"NETWORKCHECK: Not Connected");
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            return NO;
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"NETWORKCHECK: Connected Via WWAN");
            return YES;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"NETWORKCHECK: Connected Via WiFi");
            return YES;
            break;
        }
    }
    return NO;
}
-(void)kkbtnAction:(id)sender
{
    
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet) {
//        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [self kakaoLogin];
    }
 
}
-(void) settingDetails:(NSArray *)settingDetail
{
    
    NSLog(@"Setting Detail==%@",settingDetail);
    [self.backgroundMusicPlayer stop];
    //    NSLog(@"Details = %@",settingDetail);
    //    home.title=[ViewController languageSelectedStringForKey:@"Home"];
    //    topic.title = [ViewController languageSelectedStringForKey:@"Topic"];
    //    friend.title  = [ViewController languageSelectedStringForKey:@"Friend"];
    //    history.title = [ViewController languageSelectedStringForKey:@"History"];
    //    message.title=[ViewController languageSelectedStringForKey:@"Messages"];
    //    discussion.title=[ViewController languageSelectedStringForKey:@"Discussions"];
    //    customMenuView.viewControllers = @[home,topic,friend,history,message,discussion,achievement,store,settings];
    //
    //    [self presentViewController:customMenuView animated:YES completion:nil];
}
#pragma mark Go To GameView
-(void)playGameChallenge:(NSNotification*)notify
{
    NSMutableDictionary *mutDict=[[NSMutableDictionary alloc]init];
    [mutDict setObject:[SingletonClass sharedSingleton].strQuestionsId forKey:@"questions"];
    [mutDict setObject:[SingletonClass sharedSingleton].secondPLayerDetail forKey:@"oponentPlayerDetail"];
    
    [self performSelector:@selector(goToGamePlayView:) withObject:mutDict];
}
-(void)goToGamePlayView:(NSDictionary*)details
{
    [SingletonClass sharedSingleton].gameFromView=true;
    GameViewController * objGame=[[GameViewController alloc]init];
    objGame.arrPlayerDetail=details;
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    [appdelegate.window addSubview:obj.view];
    [SingletonClass sharedSingleton].gameFromView=true;
    [appdelegate.window setRootViewController:objGame];
}
#pragma mark-----
#pragma mark alert view delegates
-(void)rejectUi:(NSString *)request
{
    
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 100)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 20)];
    lblReject.text=[ViewController languageSelectedStringForKey:@"Sorry User Reject"];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UIButton * okBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame=CGRectMake(120,popUpImageview.frame.size.height-40,120, 30);
    [okBtn setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strAccept=[ViewController languageSelectedStringForKey:@"Ok"];
    [okBtn setTitle:strAccept forState:UIControlStateNormal];
    okBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [okBtn addTarget:self action:@selector(acceptButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:okBtn];
    
}
-(void)acceptButton:(id)sender
{
   
    [rejectView removeFromSuperview];
}



#pragma mark==================================
#pragma mark Kakao Talk Integration
#pragma mark===================================
//Log In and session creation block
- (void)kakaoLogin
{
    
    [[KOSession sharedSession] close];
    
    [[KOSession sharedSession] openWithCompletionHandler: ^ ( NSError * error) {
        if ([[KOSession sharedSession] isOpen]) {
            // Login success
            NSLog (@". Login succeeded" );
            NSLog(@"ACCESS TOKEN KAKAO%@",[KOSession sharedSession].accessToken);
            //       [self userInfo1];
            [self getallInfo];
        } else {
            // failed
            [[KOSession sharedSession] close];
            NSLog (@ "Login failed in Kakao %@.",error);
        }
    }];
}//Log In and session creation method ends
//To get unique user id method
-(void)getallInfo
{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(appdelegate.window.frame.size.width/2-10, appdelegate.window.frame.size.height/2-30, 30, 50)];
    [appdelegate.window addSubview:imageVAnim];
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
    [imageVAnim startAnimating];
    [KOSessionTask meTaskWithCompletionHandler:^(KOUser* result, NSError *error)
     {
         if (result)
         {
             // success
             NSLog(@"userId=%@", result.ID);
             kakaoId=[NSString stringWithFormat:@"%@",result.ID];
             NSLog(@"kakaoId=%@",kakaoId);
             NSLog(@"nickName=%@", [result propertyForKey:@"nickname"]);
             NSLog(@"birthday=%@",[result propertyForKey:@"birthday"]);
             kakaousrnme=kakaoId;
             kakaousrnme=[NSString stringWithFormat:@"%@@kakao.com",kakaousrnme];
             kakaousrnme=[kakaousrnme lowercaseString];
             username=kakaousrnme;
             //add name with kakao id of user
             [SingletonClass sharedSingleton].strUserName=[result propertyForKey:@"nickname"];
             NSLog(@"%@",[SingletonClass sharedSingleton].strUserName);
             NSLog(@"kakaousrnme%@",kakaousrnme);
             
             //method for getting username and profile image in kakao talk
             [self userInfo];
             
         }
         else
         {
             // failed
         }
     }];
    
}

//To get username and updated profile image
-(void)userInfo
{
    
    [KOSessionTask talkProfileTaskWithCompletionHandler: ^(KOTalkProfile *result,NSError *error)
     {
         NSLog(@"%@",result);
         if(result)
         {
             // success
             
             
             NSLog (@"%@" ,result.nickName);
             [SingletonClass sharedSingleton].strUserName=result.nickName;
             NSString *imageUrl=result.profileImageURL;
             if ([imageUrl isKindOfClass:[NSString class]])
             {
                 NSData  *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                 [SingletonClass sharedSingleton].imageUser=[UIImage imageWithData:imageData];
                 imgFile=[PFFile fileWithData:imageData];
                 //for saving image file in Parse
                 //[self saveUserKakaoInfo:imageData];
                 if (!error)
                 {
                     [NSThread detachNewThreadSelector:@selector(checkfirstSignUp) toTarget:self withObject:nil];
                     
                 }
                 
             }
         }
         else if(error)
         {
             // failed
             
             NSLog(@"Failed %@",error);
             
             
             
             NSData * imageData =UIImageJPEGRepresentation([UIImage imageNamed:@"1.png"], 0.05f);
             imgFile=[PFFile fileWithName:@"ProfilePic.png" data:imageData];
             [NSThread detachNewThreadSelector:@selector(checkfirstSignUp) toTarget:self withObject:nil];
             
         }
         [[KOSession sharedSession]close];
     }];
    
    
}
-(void)logOutKakao
{
    
    //[[KOSession sharedSession] close];
    /* [[KOSession sharedSession] logoutAndCloseWithCompletionHandler: ^ ( BOOL success, NSError * error) {
     if (success)
     {
     NSLog(@"Log out From Kakao");
     // logout success
     } else {
     // failed
     NSLog (@ ". failed to logout" );
     }
     }];
     */
}

#pragma mark Parse
-(void)checkfirstSignUp
{
    //query to find user is already signed up or not
    PFQuery *query=[PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username"equalTo:kakaousrnme];
    NSLog(@"kakaousername==%@",kakaousrnme);
    NSArray *arrobject=[query findObjects];
    if ([arrobject count]>0)
    {
        //login in parse
        
        [self createSessionQickBlox];
        [self parseloginViaKakao];
      
        //[NSThread detachNewThreadSelector:@selector(createSessionQickBlox) toTarget:self withObject:nil];
        
    }
    else
    {
        //signup  in parse
        [self signUp_ParsesaveUserKakaoInfo];
    }
}
//Parse Log In Action

-(void)parseloginViaKakao
{
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [PFUser logInWithUsernameInBackground:kakaousrnme password:@"globussoft" block:^(PFUser *user, NSError *error) {
        if (!error) {
            [imageVAnim startAnimating];
            //To show custom menu view
            [[NSUserDefaults standardUserDefaults] setObject:kakaousrnme forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:@"globussoft" forKey:@"password"];
            [SingletonClass sharedSingleton].objectId=user.objectId;
            NSLog(@"objectId=%@",[SingletonClass sharedSingleton].objectId);
            NSLog(@"User==%@",[SingletonClass sharedSingleton].strUserName);
            NSLog(@"Sucessfully logged In");
            
            [self saveUserIdInInstallation];
            [self addCustomView];
            [imageVAnim stopAnimating];
            
            
        }
        else
        {
            NSLog(@"log In failed in parse via kakao");
        }
    }];
}
//For saving User Info and SignUp IN Parse
-(void)signUp_ParsesaveUserKakaoInfo
{
    
    imageVAnim.frame=CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-30, 30, 50);
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
    
    [imageVAnim startAnimating];
    [imgFile saveInBackgroundWithBlock:^(BOOL suceed,NSError *error)
     {
         PFUser *object=[PFUser new];
         [object setUsername:kakaousrnme];
         [object setPassword:@"globussoft"];
         object[@"name"]=[SingletonClass sharedSingleton].strUserName;
         object[@"userimage"]=imgFile;
         object[@"Rank"]=@"베이비";
         object[@"TotalXP"]=[NSNumber numberWithInt:0];
         object[@"deviceID"]=[SingletonClass sharedSingleton].installationId;
         NSMutableArray * emptyarray=[[NSMutableArray alloc]init];
         object[@"Friends"]=emptyarray;
         object[@"Type"]=@"user";
         object[@"PrivacyMode"]=@YES;
         object[@"BlockUser"]=emptyarray;
         object[@"Diamond"]=@0;
         object[@"email"]=kakaousrnme;
         PFInstallation *currentInstallation = [PFInstallation currentInstallation];
         NSLog(@"Country %@",[currentInstallation timeZone]);
         object[@"Country"]=[currentInstallation timeZone];
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
             //For signUp In Parse
             [object signUpInBackgroundWithBlock:^(BOOL succeed, NSError *error){
                 if (succeed) {
                     NSLog(@"Save to Parse");
                     NSLog(@"myobjid==%@",[PFUser currentUser].objectId);
                     [SingletonClass sharedSingleton].objectId=[PFUser currentUser].objectId;
                      flag_Kakao=true;
                     [self createSessionQickBlox];
                     
                  //   [NSThread detachNewThreadSelector:@selector(createSessionQickBlox) toTarget:self withObject:nil];
                     [self saveUserIdInInstallation];
                     [self performSelector:@selector(connectAppWrap) withObject:nil afterDelay:3];
                     [imageVAnim stopAnimating];
                     [self parseloginViaKakao];
                     
                 }
                 if (error) {
                     NSLog(@"Error to Save == %@",error.localizedDescription);
                 }
             }];
         });
         
     }];
    
    
}

-(void)saveUserIdInInstallation {
    
    NSString *strObjectIdL = [SingletonClass sharedSingleton].objectId;
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet) {
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:strObjectIdL forKey:@"UserId"];
        [currentInstallation deviceType];
        [currentInstallation saveInBackground];
        NSLog(@"In check internet in save user id");
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}


-(void)addCustomView
{
    CustomMenuViewController *obj=[LogInViewController goTOHomeView];
    
    [self presentViewController:obj animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
