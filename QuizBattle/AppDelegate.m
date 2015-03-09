//
//  AppDelegate.m
//  QuizBattle
//
//  Created by GBS-mac on 8/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//
#define APPWARP_APP_KEY     @"02b9e4acba991fee662a295dc69c438c9b0f9b0d173b1b78fcbea0d800d9565b"
#define APPWARP_SECRET_KEY  @"3baf02cd51f48d50c32274dfaa4e48b16257870b693d447e461c73db03ed9c41"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SingletonClass.h"
#import "ConnectionListener.h"
#import "RoomListener.h"
#import "NotificationListener.h"
#import "LogInViewController.h"
#import "CustomMenuViewController.h"
#import "SingletonClass.h"
#import "GameViewController.h"
#import "GameViewControllerChallenge.h"
#import "WaitingScreen.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <Quickblox/Quickblox.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
//    [Parse setApplicationId:@"rgU0N7CsEEkp1eCX5IQdIxhoCjBxyZLccZp1Jtr5" clientKey:@"Ro3v8sSs6lEzXHIvLep2YIeYkGZUcq5S9ks06aUC"];
    //--------QuickBlox
    
    [Parse setApplicationId:@"hZh4GXbHeoXdOtWi0MSaCBVvaCSoO0jYE2nFY70K" clientKey:@"yIQ47srERsNI233VGskfucw1RZMPPOVoD5JLPjKy"];

//    [Parse setApplicationId:@"BV914SRJfydkq0qhPm93eOLLpmFWErGnOOhXYE88" clientKey:@"e7VEpAUwHujrI89fW3TdBd1PXJawbCuIYxsWnZ67"];
    [PFFacebookUtils initializeFacebook];
    [self initializeAppWarp];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
//    [application registerForRemoteNotificationTypes:
//     UIRemoteNotificationTypeBadge |
//     UIRemoteNotificationTypeAlert |
//     UIRemoteNotificationTypeSound];
    //-------
    /*[QBApplication sharedApplication].applicationId =17941;
    [QBConnection registerServiceKey:@"snvHrEbZufet93L"];
    [QBConnection registerServiceSecret:@"cJrZP4HyJVK5css"];
    [QBSettings setAccountKey:@"zmqPdDfzty79jG6wG91T"];*/
   
    [QBApplication sharedApplication].applicationId =15515;
    [QBConnection registerServiceKey:@"E747yAyFYPkvnVm"];
    [QBConnection registerServiceSecret:@"JRgT8L3zNMUNdpj"];
    [QBSettings setAccountKey:@"T92svfsFDQ5dA6fFdqse"];
    

    //-------
    id payloadData = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([payloadData isKindOfClass:[NSDictionary class]]) {
        //[self handleNotification:payloadData];
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *strCheckFirstRun = [userDefault objectForKey:@"firstrunQuiz"];
    NSLog(@"CheckFirstRun==%@",[userDefault objectForKey:@"firstrunQuiz"]);
    
    if (!strCheckFirstRun)
    {
        [userDefault setObject:@"0" forKey:@"currentDate"];
        [userDefault setObject:@"1" forKey:@"firstrunQuiz"];
        [userDefault setBool:YES forKey:@"music"];
        [userDefault setBool:YES forKey:@"soundeffect"];
        [userDefault setBool:YES forKey:@"vibrate"];
        [userDefault setBool:YES forKey:@"privacy"];
        [userDefault setBool:YES forKey:@"challnoti"];
        [userDefault setBool:YES forKey:@"frndnoti"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Korean" forKey:@"language"];
        [[NSUserDefaults standardUserDefaults]setInteger:10 forKey:@"buydiamond"];
         [[NSUserDefaults standardUserDefaults] setObject:@"newuser" forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setInteger:5 forKey:@"buylife"];
        
    }
    //[self createSessionQickBlox];
   
    //---------------
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rejectUi:) name:@"UserReject" object:nil];
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    [SingletonClass sharedSingleton].deviceToken=newDeviceToken;
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString *strInstallationId = currentInstallation.installationId;
    [SingletonClass sharedSingleton].installationId=strInstallationId;
    NSLog(@"Installation ID -=-= %@",strInstallationId);
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
//    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if(![SingletonClass sharedSingleton].isPlaying)
    {
        [self handleNotification:userInfo];
    }
    
}
-(void) handleNotification:(NSDictionary *)userInfo
{
    
    self.dictGamePlayDetails=[[NSMutableDictionary alloc]init];
    NSLog(@"userInfo handle = %@",userInfo);
    int type=[[userInfo objectForKey:@"Type"] intValue];
    
    
      int connectionStatus = [WarpClient getInstance].getConnectionState;
    //type for second player for main game
    if(type==500)
    {
        if([userInfo objectForKey:@"roomid"])
        {
            if (connectionStatus != 0)
            {
             [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
            }
            [SingletonClass sharedSingleton].secondPlayer=TRUE;
            [SingletonClass sharedSingleton].roomId=[userInfo objectForKey:@"roomid"];
            [[WarpClient getInstance]joinRoom:[userInfo objectForKey:@"roomid"]];
       }
        return;
    }
    
    //Main Game Play Notification
    if (type==100)
    {
            NSString *str =[userInfo objectForKey:@"userid"];
            NSArray *items = [str componentsSeparatedByString:@","];
            NSString *frndId =[items objectAtIndex:0];
            NSString *frndInstallationId =[items objectAtIndex:1];
            
            [SingletonClass sharedSingleton].secondPlayerInstallationId=frndInstallationId;
        
                [SingletonClass sharedSingleton].secondPlayerObjid=frndId;
        
            NSLog(@"Second Player ID -==- %@",[SingletonClass sharedSingleton].secondPlayerObjid);
            if ([SingletonClass sharedSingleton].secondPlayerObjid.length>0) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"selFriend" object:nil];
            }
            
            if (![SingletonClass sharedSingleton].checkBotUser)
            {
                if ([[userInfo allKeys] containsObject:@"Ques"])
                {
                    [SingletonClass sharedSingleton].strQuestionsId= [userInfo objectForKey:@"Ques"];
                    NSLog(@"Questions id in app delegate -== %@", [SingletonClass sharedSingleton].strQuestionsId);
                }
               
            }
        NSString *strAction = [userInfo objectForKey:@"action"];
        [SingletonClass sharedSingleton].roomNo=[userInfo objectForKey:@"room"];
        NSLog(@"room%@",[SingletonClass sharedSingleton].roomNo);
        NSLog(@"status = %d",connectionStatus);
        if ([strAction isEqualToString:@"com.quizbattle.welcome.UPDATE_STATUS"])
        {
            if([[SingletonClass sharedSingleton].roomNo isEqualToString:@"600"]&&!([SingletonClass sharedSingleton].secondPlayer))
            {
                
                [SingletonClass sharedSingleton].mainPlayer=TRUE;
                if (connectionStatus != 0)
                {
                    [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
                    [SingletonClass sharedSingleton].connectedNot=TRUE;
            }
            else
            {
            time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
            NSString *dateStr = [NSString stringWithFormat:@"%ld",unixTime];
            [[WarpClient getInstance] createRoomWithRoomName:dateStr roomOwner:@"Girish Tyagi" properties:NULL maxUsers:2];
                }
                NSLog(@"room id recieved%@",[userInfo objectForKey:@"roomid"]);
            }
            else
            {
                [SingletonClass sharedSingleton].secondPlayer=TRUE;
            }
       // }
        return;
    }
}//if for type 200
    //Challenge Notification
    if(type==700)
    {
        if(![SingletonClass sharedSingleton].isPlaying)
        {
        if([userInfo objectForKey:@"roomid"])
        {
            
            
                [SingletonClass sharedSingleton].roomId=[userInfo objectForKey:@"roomid"];
            
        }
        }//if main game is running
        
        return;
    }
    //Push For Challenge
    if(type==200)
    {
        if(![SingletonClass sharedSingleton].isPlaying)
        {
            [SingletonClass sharedSingleton].challStartCase=false;

            if (connectionStatus != 0)
            {
                [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
            }

        NSDictionary *alertDict = [userInfo objectForKey:@"aps"];
        NSString *alert = [NSString stringWithFormat:@"%@",[alertDict objectForKey:@"alert"]];
        
        self.message = [[UIAlertView alloc] initWithTitle:@"Request" message:alert delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
        [SingletonClass sharedSingleton].strQuestionsId= [userInfo objectForKey:@"Ques"];
        NSLog(@"Questions id in app delegate -== %@",[SingletonClass sharedSingleton].strQuestionsId);
        
        NSString *str =[userInfo objectForKey:@"userid"];
        NSArray *items = [str componentsSeparatedByString:@","];
        NSString *frndId =[items objectAtIndex:0];
        NSString *frndInstallationId =[items objectAtIndex:1];
        [SingletonClass sharedSingleton].secondPlayerInstallationId=frndInstallationId;
        if (![SingletonClass sharedSingleton].secondPlayerObjid.length>0)
        {
        [SingletonClass sharedSingleton].secondPlayerObjid=frndId;
        }
        NSLog(@"Second Player ID -==- %@",[SingletonClass sharedSingleton].secondPlayerObjid);
           //
            str =[userInfo objectForKey:@"cat"];
            items = [str componentsSeparatedByString:@","];
            NSString *strSubCatId =[items objectAtIndex:0];
            NSString *strSubCat=[items objectAtIndex:1];
            NSString *catId=[items objectAtIndex:2];
            NSLog(@"Challenge push content %@ %@ %@",catId,strSubCat,strSubCatId);
            subCatNameG=strSubCat;
             catIdG=catId;
            [SingletonClass sharedSingleton].selectedSubCat=[NSNumber numberWithInt:[strSubCatId intValue]];
            [SingletonClass sharedSingleton].strSelectedSubCat=strSubCat;
            subCatNameG=strSubCat;
            [SingletonClass sharedSingleton].strSelectedCategoryId=catId;
            [SingletonClass sharedSingleton].secondPlayerChallenge=TRUE;
       
           // NSString *frndInstallationId =[items objectAtIndex:1];
            [self fetchUserDetailRematch];
        }//if main game is running

        return;
      
    }//end class check block
    
    //----Rematch Handle Data----------------------------------
    //Rematch main  Push
    if(![SingletonClass sharedSingleton].rematchMain)
    {
    if(type==150)
    {
        [self fetchUserDetailRematch];
       
        [SingletonClass sharedSingleton].strQuestionsId= [userInfo objectForKey:@"Ques"];
        NSString *str =[userInfo objectForKey:@"userid"];
        NSArray *items = [str componentsSeparatedByString:@","];
        NSString *frndId =[items objectAtIndex:0];
        NSString *frndInstallationId =[items objectAtIndex:1];
         NSString *frndname =[items objectAtIndex:2];
        friendName=frndname;
        //--------------
        NSString *strCat =[userInfo objectForKey:@"cat"];
        NSArray *itemsCat = [strCat componentsSeparatedByString:@","];
     //   NSString *subCatId =[itemsCat objectAtIndex:0];
        NSString *subCatName =[itemsCat objectAtIndex:1];
        subCatNameG=subCatName;
        NSString *catId =[itemsCat objectAtIndex:2];
        catIdG=catId;
        NSLog(@"frnd name %@ cat id%@ sub cat name%@",frndname,catId,subCatName);
      //  NSString * rematchString=[NSString stringWithFormat:@"Rematch on %@",subCatName];
       // [self rejectUi:@"도전 신청이 왔습니다." catImg:catId];
        //--------------
        [SingletonClass sharedSingleton].secondPlayerObjid=frndId;
        [SingletonClass sharedSingleton].secondPlayerInstallationId=frndInstallationId;
        
        
    }
    //Rematch push for room id
    if(type==160)
    {
        if([userInfo objectForKey:@"roomid"])
        {
            
            [SingletonClass sharedSingleton].rematchSecond=TRUE;
            if (connectionStatus != 0)
            {
                [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
            }
            [SingletonClass sharedSingleton].secondPlayer=TRUE;
            [SingletonClass sharedSingleton].roomId=[userInfo objectForKey:@"roomid"];
           // [[WarpClient getInstance]joinRoom:[userInfo objectForKey:@"roomid"]];
        }
        return;
    }
    }//if for rematch is pressed.
}

-(void)fetchUserDetailRematch
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    PFQuery * query=[PFUser query];
    [query whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].secondPlayerObjid];
        NSArray *temp=[query findObjects];
        PFObject * objectImage=[temp objectAtIndex:0];
        PFFile  *strImage =objectImage[@"userimage"];
        NSData *imageData = [strImage getData];
        UIImage *image1 = [UIImage imageWithData:imageData];
        [SingletonClass sharedSingleton].imageSecondPlayer=image1;
        [SingletonClass sharedSingleton].strSecPlayerName=objectImage[@"name"];
        friendName=objectImage[@"name"];
        NSLog(@"User Detail %@",temp);
        [SingletonClass sharedSingleton].secondPLayerDetail=[NSArray arrayWithArray:temp];
        NSLog(@"Singleton GameDetail Dict %@",[SingletonClass sharedSingleton].secondPLayerDetail);
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           [self rejectUi:@"도전 신청이 왔습니다." catImg:catIdG];
                       });
    });
    
  
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if([SingletonClass sharedSingleton].roomId)
    {
        [[WarpClient getInstance]leaveRoom:[SingletonClass sharedSingleton].roomId];
    }
    

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if([SingletonClass sharedSingleton].isPlaying)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UserConnectionBreak" object:nil];

        if([SingletonClass sharedSingleton].roomId)
        {
            [[WarpClient getInstance]leaveRoom:[SingletonClass sharedSingleton].roomId];
        }
    }
    int connectionStatus = [WarpClient getInstance].getConnectionState;
    NSLog(@"status = %d",connectionStatus);
    if (connectionStatus== 0)
    {
        [[WarpClient getInstance] disconnect];
    }
    //[[WarpClient getInstance]setRecoveryAllowance:20];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    int connectionStatus = [WarpClient getInstance].getConnectionState;
    NSLog(@"status = %d",connectionStatus);
    if (connectionStatus != 0)
    {
        [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
    }

    //[[WarpClient getInstance] recoverConnection];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [KOSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if([SingletonClass sharedSingleton].roomId)
    {
    [[WarpClient getInstance]leaveRoom:[SingletonClass sharedSingleton].roomId];
    }
    int connectionStatus = [WarpClient getInstance].getConnectionState;
    NSLog(@"status = %d",connectionStatus);
    if (connectionStatus== 0)
    {
    [[WarpClient getInstance] disconnect];
    }
        [[PFFacebookUtils session] close];
}
#pragma mark FB Login---
- (BOOL)openSessionWithAllowLoginUI{
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"email",@"status_update",@"user_photos",@"user_birthday",@"user_about_me",@"user_friends",@"photo_upload",@"read_friendlists",@"publish_actions", nil];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            [SingletonClass sharedSingleton].objectId=user.objectId;
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
                [self fetchFacebookGameFriends:fbAccessToken];
                [self saveUserFbInfo];
                
            } else {
                
                CustomMenuViewController *obj=[LogInViewController goTOHomeView];
                AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                //    [appdelegate.window addSubview:obj.view];
                [appdelegate.window setRootViewController:obj];
                NSLog(@"User with facebook logged in!");
                NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
                [self fetchFacebookGameFriends:fbAccessToken];
                //  [self saveUserFbInfo];
            }
            
        }
    }];
    
    // Show loading indicator until login is finished
    return YES;
}
-(void)fetchFacebookGameFriends:(NSString *)accessToken{
    NSString *query =
    @"SELECT uid, name, pic_small FROM user WHERE is_app_user = 1 and uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() )";
    
    NSDictionary *queryParam = @{ @"q": query, @"access_token":accessToken };
    
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"parameters:queryParam HTTPMethod:@"GET"completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else {
            // NSLog(@"Result: %@", result);
            
            NSArray *friendInfo = (NSArray *) result[@"data"];
            
            NSLog(@"Array Count==%lu",(unsigned long)[friendInfo count]);
            
            NSLog(@"\n\nArray==%@",friendInfo);
            
            NSMutableArray *frndsarray = [[NSMutableArray alloc] init];
            NSMutableArray *frndNamearray=[[NSMutableArray alloc] init];
            NSMutableArray *imageArray=[[NSMutableArray alloc]init];
            for (int i =0; i<friendInfo.count; i++) {
                NSDictionary *dict = [friendInfo objectAtIndex:i];
                NSString *fbID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                NSString *fbName =[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                NSString *img=[NSString stringWithFormat:@"%@",[dict objectForKey:@"pic_small"]];
                NSLog(@"Url%@",img);
                
                [frndsarray addObject:fbID];
                [frndNamearray addObject:fbName];
                NSURL *url=[NSURL URLWithString:img];
                NSLog(@"%@",url);
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                NSURLResponse *response;
                NSError *error;
                
                NSData *data=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
                if (error == nil && data !=nil) {
                    [imageArray addObject:[UIImage imageWithData:data]];
                }
         
            }//End For Loop
            NSLog(@"img%@",imageArray);
            [SingletonClass sharedSingleton].fbfriendsId = frndsarray;
            [SingletonClass sharedSingleton].fbfriendsName=frndNamearray;
            [SingletonClass sharedSingleton].fbfriendsImage=imageArray;
            
        }
        
    }];
    
}



-(void)saveUserFbInfo
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            NSString *facebookID = userData[@"id"];
            
            
            // NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            // PFUser *fbUser =[PFUser new];
            if (facebookID) {
                [[PFUser currentUser] setObject:facebookID forKey:@"facebookId"];
            }
            
            NSString *name = userData[@"name"];
            if (name) {
                [[PFUser currentUser] setObject:name forKey:@"name"];
                [SingletonClass sharedSingleton].strUserName=name;
            }
            
            NSString *location = userData[@"location"][@"name"];
            if (location) {
                [[PFUser currentUser] setObject:location forKey:@"Country"];
            }
            
            //            NSString *gender = userData[@"gender"];
            //            if (gender) {
            //                userProfile[@"gender"] = gender;
            //            }
            //
            NSString *birthday = userData[@"birthday"];
            if (birthday) {
                [[PFUser currentUser] setObject:birthday forKey:@"birthday"];
            }
            
            
            
            NSString * picUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            NSURL *pictureURL = [NSURL URLWithString:picUrl];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                       if (connectionError == nil && data != nil) {
                                           [SingletonClass sharedSingleton].imageUser = [UIImage imageWithData:data];
                                           PFFile *imageFile=[PFFile fileWithData:data];
                                           [[PFUser currentUser] setObject:imageFile forKey:@"userimage"];
                                           NSLog(@"%@",[PFUser currentUser].objectId);
                                           [SingletonClass sharedSingleton].objectId=[PFUser currentUser].objectId;
                                           CustomMenuViewController *obj=[LogInViewController goTOHomeView];
                                           
                                           
                                           AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                           //    [appdelegate.window addSubview:obj.view];
                                           [appdelegate.window setRootViewController:obj];
                                           [[PFUser currentUser] saveInBackground];
                                           // Add a nice corner radius to the image
                                           
                                       } else {
                                           NSLog(@"Failed to load profile photo.");
                                       }
                                   }];
            
            
            
            
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
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
        
        [self parseloginViaKakao];
        flag_QuiclBlox=true;
        
       
    }
    else
    {
        //signup  in parse
        [self signUp_ParsesaveUserKakaoInfo];
    }
}
//Parse Log In Action
#pragma mark QuickBlox
-(void)createSessionQickBlox
{
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session)
     {
                 // session created
    } errorBlock:^(QBResponse *response) {
        // handle errors
        NSLog(@"%@", response.error);
    }];
    
}

-(void)signUpInQuickblox
{
    
    QBUUser *user=[QBUUser user];
    // user.email=@"khomesh@globussoft.com";//txtFEmail.text;
    NSLog(@"Kakao User Name %@",kakaousrnme);
    user.login=kakaousrnme;
    user.password=@"globussoft123";
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
    [QBRequest logInWithUserLogin:kakaousrnme password:@"globussoft123" successBlock:^(QBResponse *response, QBUUser *user)
     {
         
         [SingletonClass sharedSingleton].quickBloxId=[NSString stringWithFormat:@"%ld",(unsigned long)[user ID]];
                  NSLog(@"Successfully Log in Quick blox id %ld",(unsigned long)[user ID]);
         [self saveQuickBloxIdParse];
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
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addMainHomeScreen" object:nil];
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
    
  imageVAnim.frame=CGRectMake(self.window.frame.size.width/2-10, self.window.frame.size.height/2-30, 30, 50);
    [self.window addSubview:imageVAnim];
    
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
                    [NSThread detachNewThreadSelector:@selector(createSessionQickBlox) toTarget:self withObject:nil];
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
-(void)connectAppWrap
{
    [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
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
//Parse Log In Action
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
       return [KOSession handleOpenURL: url];
    
}

#pragma mark---AppWarpinitialization
-(void)initializeAppWarp
{
    
    // NSLog(@"%s",__FUNCTION__);
    [WarpClient initWarp:APPWARP_APP_KEY secretKey:APPWARP_SECRET_KEY];
     WarpClient *warpClient = [WarpClient getInstance];
    [warpClient setRecoveryAllowance:10];
    [warpClient enableTrace:YES];
    ConnectionListener *connectionListener = [[ConnectionListener alloc] initWithHelper:self];
    [warpClient addConnectionRequestListener:connectionListener];
    [warpClient addZoneRequestListener:connectionListener];
    RoomListener *roomListener = [[RoomListener alloc]initWithHelper:self];
    [warpClient addRoomRequestListener:roomListener];
    NotificationListener *notificationListener = [[NotificationListener alloc]initWithHelper:self];
    [warpClient addNotificationListener:notificationListener];
    
    
}

#pragma mark-----
#pragma mark Challenge and Rematch
-(void)acceptButton:(id)sender
{
    
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
    //---
    [[WarpClient getInstance]joinRoom:[SingletonClass sharedSingleton].roomId];
    
    //---
    if([SingletonClass sharedSingleton].secondPlayerChallenge)
    {
        [self performSelector:@selector(performSelectioninStartCase) withObject:nil afterDelay:2];
    }
    else
    {
        //rematch
        [self screenAfterAccepClickRematch:@"accept"];
    }
    
    
}

-(void)performSelectioninStartCase
{
    if([SingletonClass sharedSingleton].userLeftRoom)
    {
        [self screenForChallengeWaiting];
        [self performSelector:@selector(accepActionForChallenge) withObject:nil afterDelay:5];
        
    }
    else
    {
        [self screenAfterAccepClickRematch:@"accept"];
    }
}

-(void)screenAfterAccepClickRematch:(NSString *)accept_reject
{
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:backgroundView];
    upperView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height/2)];
    upperView.backgroundColor=[UIColor whiteColor];
    [backgroundView addSubview:upperView];
    UIImageView *imageVUser = [[UIImageView alloc]initWithFrame:CGRectMake(self.window.bounds.size.width/2-30, 80, 60, 60)];
    imageVUser.image=[SingletonClass sharedSingleton].imageUser;
    imageVUser.layer.cornerRadius=30;
    imageVUser.clipsToBounds=YES;
    [upperView addSubview:imageVUser];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 150,self.window.bounds.size.width, 50)];
    lblName.font=[UIFont boldSystemFontOfSize:15];
    lblName.textColor=[UIColor blackColor];
    lblName.text=[SingletonClass sharedSingleton].strUserName;
    lblName.textAlignment=NSTextAlignmentCenter;
    [upperView addSubview:lblName];
    
    UILabel *gradeName=[[UILabel alloc] initWithFrame:CGRectMake(0, lblName.frame.origin.y+20, self.window.frame.size.width, 50)];
    gradeName.font=[UIFont boldSystemFontOfSize:15];
    gradeName.textColor=[UIColor blackColor];
    gradeName.text=[SingletonClass sharedSingleton].userRank;
    gradeName.textAlignment=NSTextAlignmentCenter;
    [upperView addSubview:gradeName];
    //seperation line
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor blackColor].CGColor;
    
    border.frame = CGRectMake(0, upperView.frame.size.height - 3, upperView.frame.size.width, 3);
    [upperView.layer addSublayer:border];
    
    UIImageView * clockImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.window.bounds.size.width/2-50,self.window.bounds.size.height-200,100,100)];
    clockImageView.image=[UIImage imageNamed:@"clock.png"];
    [backgroundView addSubview:clockImageView];
    
    //----------------------------
    timerForConnectionPlayer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector:@selector(animateUSerSelection) userInfo: nil repeats:YES];
    countTime=0;
    [timerForConnectionPlayer fire];
}
-(void)animateUSerSelection {
    
    countTime++;
    
    if (countTime>10) {
        
        if ([timerForConnectionPlayer isValid]) {
            [timerForConnectionPlayer invalidate];
            //timerForbotPlayerimer = nil;
            
            [self rejectUi:@"Sorry User Reject" catImg:@""];
        }
    }
    if(countTime==3)
    {
        if([SingletonClass sharedSingleton].rematchSecond||[SingletonClass sharedSingleton].secondPlayerChallenge)
        {
            NSLog(@"Testing Flag 1");
            //Lower View added
            [self addLowerView];
            if ([timerForConnectionPlayer isValid])
            {
                
                [timerForConnectionPlayer invalidate];
                
            }
            [self performSelector:@selector(sendToGameScreen) withObject:nil afterDelay:1];
        }
        
        
    }
}
-(void)sendToGameScreen
{
    [self playGameChallenge];
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"gameUiChallenge" object:nil];
}

-(void)addLowerView
{
    
    lowerView =[[UIView alloc]initWithFrame:CGRectMake(0, self.window.bounds.size.height/2+3, self.window.bounds.size.width, self.window.bounds.size.height/2)];
    lowerView.backgroundColor=[UIColor whiteColor];
    [backgroundView addSubview:lowerView];
    UIImageView *imageVUser = [[UIImageView alloc]initWithFrame:CGRectMake(self.window.bounds.size.width/2-30, 80, 60, 60)];
    imageVUser.image=[SingletonClass sharedSingleton].imageUser;
    imageVUser.layer.cornerRadius=30;
    imageVUser.clipsToBounds=YES;
    [lowerView addSubview:imageVUser];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 150,self.window.bounds.size.width, 50)];
    lblName.font=[UIFont boldSystemFontOfSize:15];
    lblName.textColor=[UIColor blackColor];
    lblName.text=friendName;
    lblName.textAlignment=NSTextAlignmentCenter;
    [lowerView addSubview:lblName];
    
    UILabel *gradeName=[[UILabel alloc] initWithFrame:CGRectMake(0, lblName.frame.origin.y+20, self.window.frame.size.width, 50)];
    gradeName.font=[UIFont boldSystemFontOfSize:15];
    gradeName.textColor=[UIColor blackColor];
    gradeName.text=[SingletonClass sharedSingleton].userRank;
    gradeName.textAlignment=NSTextAlignmentCenter;
    [lowerView addSubview:gradeName];
    
    
}
#pragma mark Go To GameView
-(void)playGameChallenge
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
    [appdelegate.window setRootViewController:objGame];
}
#pragma mark---------

-(void)accepActionForChallenge
{
    if([SingletonClass sharedSingleton].userLeftRoom)
    {
        [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
        [self gameViewControllerChallenge];
    }
    else
    {
        [self challengeRequestDelete];
    }
    
}

-(void)rejectUi:(NSString *)request catImg:(NSString *)catImage
{
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.window.frame.size.width,self.window.frame.size.height)];
    [self.window addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.window.frame.size.height/2-20, self.window.frame.size.width-20, 180)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(popUpImageview.frame.size.width/2-40, 10, 30, 30)];
    imgView.image=[UIImage imageNamed:@"1_small.png"];
    [popUpImageview addSubview:imgView];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(popUpImageview.frame.size.width/2, 10, popUpImageview.frame.size.width, 20)];
    lblReject.text=friendName;
    lblReject.textAlignment=NSTextAlignmentLeft;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UILabel * desc=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, popUpImageview.frame.size.width, 20)];
    desc.text=request;
    desc.textAlignment=NSTextAlignmentCenter;
    desc.textColor=[UIColor blackColor];
    [popUpImageview addSubview:desc];

    UILabel * lblctegornName=[[UILabel alloc]initWithFrame:CGRectMake(popUpImageview.frame.size.width/2, 70, popUpImageview.frame.size.width, 20)];
    lblctegornName.text=subCatNameG;
    lblctegornName.textAlignment=NSTextAlignmentLeft;
    lblctegornName.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblctegornName];
    UIImageView * imgViewCat=[[UIImageView alloc]initWithFrame:CGRectMake(popUpImageview.frame.size.width/2-40, 70, 30, 30)];
    imgViewCat.image=[UIImage imageNamed:catImage];
    [popUpImageview addSubview:imgViewCat];
    UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(15,popUpImageview.frame.size.height-40,120, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [acceptBtn setTitle:@"Accept" forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(acceptButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:acceptBtn];
    UIButton * rejectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rejectBtn.frame=CGRectMake(popUpImageview.frame.size.width/2+15,popUpImageview.frame.size.height-40,120,30);
    [rejectBtn setBackgroundImage:[UIImage imageNamed:@"reject_btn.png"] forState:UIControlStateNormal];
    [rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rejectBtn setTitle:@"Reject" forState:UIControlStateNormal];
    rejectBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [rejectBtn addTarget:self action:@selector(rejectButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:rejectBtn];

}

#pragma mark-------
-(void)gameViewControllerChallenge
{
    GameViewControllerChallenge *challengeGame = [[GameViewControllerChallenge alloc] init];
    [SingletonClass sharedSingleton].singleGameChallengedPlayer=NO;
    [SingletonClass sharedSingleton].challStartCase=YES;
   
    [self.window setRootViewController:challengeGame];

}

-(void)rejectButton:(id)sender
{
    [self challengeRequestDelete];
    [[WarpClient getInstance] sendPrivateChat:@"reject" toUser:[SingletonClass sharedSingleton].secondPlayerObjid];
    //[[WarpClient getInstance]sendChat:@"reject"];
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
    
}
-(void)screenForChallengeWaiting
{
    upperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height)];
    upperView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:upperView];

    UIImageView *imageVUser = [[UIImageView alloc]initWithFrame:CGRectMake(self.window.frame.size.width/2-30, 80, 60, 60)];
    imageVUser.image=[SingletonClass sharedSingleton].imageUser;
    imageVUser.layer.cornerRadius=30;
    imageVUser.clipsToBounds=YES;
    [upperView addSubview:imageVUser];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 150,self.window.frame.size.width, 50)];
    lblName.font=[UIFont boldSystemFontOfSize:15];
    lblName.textColor=[UIColor blackColor];
    lblName.text=[SingletonClass sharedSingleton].strUserName;
    lblName.textAlignment=NSTextAlignmentCenter;
    [upperView addSubview:lblName];
    
    UILabel *gradeName=[[UILabel alloc] initWithFrame:CGRectMake(0, lblName.frame.origin.y+20, self.window.frame.size.width, 50)];
    gradeName.font=[UIFont boldSystemFontOfSize:15];
    gradeName.textColor=[UIColor blackColor];
    gradeName.text=[SingletonClass sharedSingleton].userRank;
    gradeName.textAlignment=NSTextAlignmentCenter;
    [upperView addSubview:gradeName];
    UIImageView * clockImage=[[UIImageView alloc]initWithFrame:CGRectMake(140,280, 50, 100)];
    clockImage.image=[UIImage imageNamed:@"mobileImg.png"];
    [upperView addSubview:clockImage];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(self.alertRematch==alertView)
    {
        if(buttonIndex==1)
        {
            [[WarpClient getInstance]sendChat:@"accept"];
            
        }
        else if (buttonIndex==2)
        {
            [[WarpClient getInstance]sendChat:@"reject"];
        }
    }
    
    
    if(alertView==self.message)
    {
    
        if(buttonIndex == 1)
        {
                NSLog(@"Room id %@",[SingletonClass sharedSingleton].roomId);
                [self fetchQuestion];
                [[WarpClient getInstance]joinRoom:[SingletonClass sharedSingleton].roomId];
        }
        else
        {
                //[SingletonClass sharedSingleton].strQuestionsId= nil;
        }
    }
}
-(void)challengeRequestDelete
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    PFQuery * query=[PFQuery queryWithClassName:@"ChallengeRequest"];
    [query whereKey:@"OpponentId" equalTo:[SingletonClass sharedSingleton].objectId];
    [query whereKey:@"SubCategoryId" equalTo:[SingletonClass sharedSingleton].selectedSubCat];
        
    NSArray * temp=[query findObjects];
    for(int i=0;i<[temp count];i++)
    {
    PFObject * obj=[temp objectAtIndex:i];
    [obj deleteInBackgroundWithBlock:^(BOOL succeded,NSError *error)
     {
       if(error)
       {
           NSLog(@"Error in deletion %@",error);
       }
     }];
    }
    });
}
#pragma mark-
-(void)fetchQuestion
{
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]init];
    
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            
            BOOL checkInternet =  [ViewController networkCheck];
            
            if (checkInternet) {
                
                PFQuery *query = [PFUser query];
                [query whereKey:@"objectId" equalTo: [SingletonClass sharedSingleton].secondPlayerObjid];
                
                NSArray *arrDetails = [query findObjects];
                
                NSLog(@"Arry Details --= %@",arrDetails);
                
                [mutDict setObject:arrDetails forKey:@"oponentPlayerDetail"];
                NSLog(@"Questions Id -==- %@",[SingletonClass sharedSingleton].strQuestionsId);
                [mutDict setObject:[SingletonClass sharedSingleton].strQuestionsId forKey:@"questions"];
                
                if (arrDetails.count>0) {
                    
                    NSDictionary *dict = [arrDetails objectAtIndex:0];
                    
                    NSLog(@"Second player dict details --==- %@",dict);
                    [SingletonClass sharedSingleton].strSecPlayerName = [dict objectForKey:@"username"];
                    
                    PFFile  *strImage = [dict objectForKey:@"userimage"];
                    
                    NSData *imageData = [strImage getData];
                    UIImage *image1 = [UIImage imageWithData:imageData];
                    
                    [SingletonClass sharedSingleton].imageSecondPlayer = image1;
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
                });
            }
        }
    });
    
    [self performSelector:@selector(goToGamePlayView:) withObject:mutDict
               afterDelay:2];
    
}

#pragma mark-----
#pragma mark alert view delegates
-(void)rejectUi:(NSString *)request
{
    
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.window.frame.size.width,self.window.frame.size.height)];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.window.frame.size.height/2-20, self.window.frame.size.width-20, 100)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 20)];
    lblReject.text=[ViewController languageSelectedStringForKey:@"죄송합니다 사용자 는 거부"];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    //-------
    UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(popUpImageview.frame.size.width-30,5,30, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(acceptButtonOk:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:acceptBtn];

    
    //--------
    
    
   /* UIButton * okBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame=CGRectMake(120,popUpImageview.frame.size.height-40,120, 30);
    [okBtn setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strAccept=[ViewController languageSelectedStringForKey:@"Ok"];
    [okBtn setTitle:strAccept forState:UIControlStateNormal];
    okBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [okBtn addTarget:self action:@selector(acceptButtonOk:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:okBtn];*/
    
}
-(void)acceptButtonOk:(id)sender
{
    
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
    CustomMenuViewController *obj = [LogInViewController goTOHomeView];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    // [appdelegate.window addSubview:obj.view];
    [appdelegate.window setRootViewController:obj];
    [SingletonClass sharedSingleton].rematchMain=false;
    [SingletonClass sharedSingleton].rematchSecond=false;
    [SingletonClass sharedSingleton].mainPlayerChallenge=false;
    [SingletonClass sharedSingleton].secondPlayerChallenge=false;
    [rejectView removeFromSuperview];
    
}

/*-(void)goToGamePlayView:(NSDictionary*)details
{
    GameViewController * obj=[[GameViewController alloc]init];
    obj.arrPlayerDetail=details;
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [appdelegate.window setRootViewController:obj];
}
*/

@end
