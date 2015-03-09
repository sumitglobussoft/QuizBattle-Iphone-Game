//
//  SignUpWithEmailPage.m
//  QuizBattle
//
//  Created by GBS-mac on 8/7/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "SignUpWithEmailPage.h"
#import "ViewController.h"
#import <Parse/Parse.h>
#import "CustomMenuViewController.h"
#import "SingletonClass.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "TopicsViewController.h"
#import "FriendsViewController.h"
#import "MainHistoryViewController.h"
#import "MessagesViewController.h"
#import "DiscussionsViewController.h"
#import "AchievementsViewController.h"
#import "StoreViewController.h"
#import "SettingsViewController.h"
#import "SignUpWithEmailViewController.h"

@interface SignUpWithEmailPage ()

@end

@implementation SignUpWithEmailPage

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *customV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [customV setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    [self.view addSubview:customV];
    
    //    NSString *strBtnTitle = [ViewController languageSelectedStringForKey:@"Back"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(customV.frame.origin.x+5, 10, 30, 30);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back_btnForall.png"] forState:UIControlStateNormal];
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackActionInSignUp:) forControlEvents:UIControlEventTouchUpInside];
    [customV addSubview:btnBack];
//------------
    NSString *strSignUp = [ViewController languageSelectedStringForKey:@"Sign Up"];
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(40,10,self.view.frame.size.width-80,30)];
    lblHeader.text=strSignUp;
    lblHeader.textAlignment=NSTextAlignmentCenter;
    lblHeader.font=[UIFont boldSystemFontOfSize:20];
    lblHeader.textColor=[UIColor whiteColor];
    [customV addSubview:lblHeader];
    NSString *strBtnNext = @"다음에>";
//----------
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNext.frame=CGRectMake(self.view.frame.size.width-100, 10,90, 30);
    [btnNext setTitle:strBtnNext forState:UIControlStateNormal];
    btnNext.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(btnNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [customV addSubview:btnNext];
    envelopeImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"email.png"]];
    envelopeImage.frame=CGRectMake(0, 0, envelopeImage.image.size.width+20, envelopeImage.image.size.height);
    envelopeImage.contentMode=UIViewContentModeCenter;
    passwrdImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password.png"]];
    passwrdImage.frame=CGRectMake(0, 0, passwrdImage.image.size.width+20, passwrdImage.image.size.height);
    passwrdImage.contentMode=UIViewContentModeCenter;
    
    countryIconImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"country__icon.png"]];
    countryIconImage.frame=CGRectMake(0, 0, passwrdImage.image.size.width+20, passwrdImage.image.size.height);
    countryIconImage.contentMode=UIViewContentModeCenter;

    NSString *strEmail = [ViewController languageSelectedStringForKey:@"Email"];
    NSString *strPass = [ViewController languageSelectedStringForKey:@"Password"];
    
    txtFEmail = [[UITextField alloc] initWithFrame:CGRectMake(50, customV.frame.size.height+40, self.view.frame.size.width-100, 50)];
    txtFEmail.placeholder=strEmail;
    txtFEmail.layer.borderWidth=2;
    txtFEmail.layer.borderColor=[UIColor blackColor].CGColor;
    txtFEmail.textAlignment=NSTextAlignmentCenter;
    txtFEmail.delegate=self;
    txtFEmail.leftView=envelopeImage;
    [txtFEmail setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:txtFEmail];
    
    txtFPass = [[UITextField alloc] initWithFrame:CGRectMake(50, txtFEmail.frame.origin.y+txtFEmail.frame.size.height+20, self.view.frame.size.width-100, 50)];
    txtFPass.placeholder=strPass;
    txtFPass.secureTextEntry=YES;
    txtFPass.layer.borderWidth=2;
    txtFPass.layer.borderColor=[UIColor blackColor].CGColor;
    txtFPass.textAlignment=NSTextAlignmentCenter;
    txtFPass.delegate=self;
    txtFPass.leftView=passwrdImage;
    [txtFPass setLeftViewMode:UITextFieldViewModeAlways];
    [self.view addSubview:txtFPass];
    
    
    NSString *strCountry=@"국가";//[ViewController languageSelectedStringForKey:@"Country"];
    pickerArray = [[NSArray alloc]initWithObjects:@"대한민국",
                   @"일본",@"중국",@"미국",@"독일",@"프랑스",@"캐나다",@"영국",@"싱가폴",@"기타", nil];
    txtFCountry = [[UITextField alloc] initWithFrame:CGRectMake(50, txtFPass.frame.origin.y+txtFPass.frame.size.height+20, self.view.frame.size.width-100, 50)];
    txtFCountry.placeholder=strCountry;
    txtFCountry.layer.borderWidth=2;
    txtFCountry.layer.borderColor=[UIColor blackColor].CGColor;
    txtFCountry.textAlignment=NSTextAlignmentCenter;
    txtFCountry.delegate=self;
    txtFCountry.leftView=countryIconImage;
    [txtFCountry setLeftViewMode:UITextFieldViewModeAlways];
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.backgroundColor=[UIColor whiteColor];
    txtFCountry.inputView=myPickerView;
        [self.view addSubview:txtFCountry];
    
    //---------------------
    
    [self agreeConditionsUi];
}
#pragma mark delegate of pickerview
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
}
-(void)done:(id)sender
{
    [myPickerView resignFirstResponder];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    [txtFCountry resignFirstResponder];
    [txtFCountry setText:[pickerArray objectAtIndex:row]];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

-(void)agreeConditionsUi
{
    //////////////UI///////////////////////////
    checkMarkFirst=[UIButton buttonWithType:UIButtonTypeCustom];
    checkMarkFirst.frame=CGRectMake(30, self.view.frame.size.height-180, 25,25);
    checkMarkFirst.layer.cornerRadius=12.5;
    [checkMarkFirst setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [checkMarkFirst addTarget:self action:@selector(checkMarkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkMarkFirst];
    UILabel *lblStatement1=[[UILabel alloc]initWithFrame:CGRectMake(60, self.view.frame.size.height-180, self.view.frame.size.width-90, 25)];
    lblStatement1.text=@"모든 약관에 동의합니다";
    lblStatement1.font=[UIFont boldSystemFontOfSize:15];
    lblStatement1.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lblStatement1];
    
    checkMarkSecond=[UIButton buttonWithType:UIButtonTypeCustom];
    checkMarkSecond.frame=CGRectMake(30, self.view.frame.size.height-150, 25,25);
    checkMarkSecond.layer.cornerRadius=12.5;
    [checkMarkSecond setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [checkMarkSecond addTarget:self action:@selector(checkMarkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkMarkSecond];
    UILabel *lblStatement2=[[UILabel alloc]initWithFrame:CGRectMake(60, self.view.frame.size.height-150, self.view.frame.size.width-90, 25)];
    lblStatement2.text=@"서비스";
    lblStatement2.font=[UIFont boldSystemFontOfSize:15];
    lblStatement2.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lblStatement2];
    
    checkMarkThird=[UIButton buttonWithType:UIButtonTypeCustom];
    checkMarkThird.frame=CGRectMake(30, self.view.frame.size.height-120, 25,25);
    checkMarkThird.layer.cornerRadius=12.5;
    [checkMarkThird setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [checkMarkThird addTarget:self action:@selector(checkMarkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkMarkThird];
    UILabel *lblStatement3=[[UILabel alloc]initWithFrame:CGRectMake(60, self.view.frame.size.height-120, self.view.frame.size.width-90, 25)];
    lblStatement3.text=@"서비스 이용약관 (필수)";
    lblStatement3.font=[UIFont boldSystemFontOfSize:15];
    lblStatement3.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:lblStatement3];
    
    checkMarkFourth=[UIButton buttonWithType:UIButtonTypeCustom];
    checkMarkFourth.frame=CGRectMake(30, self.view.frame.size.height-90, 25,25);
    checkMarkFourth.layer.cornerRadius=12.5;
    [checkMarkFourth setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
    [checkMarkFourth addTarget:self action:@selector(checkMarkAction:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:checkMarkFourth];
    UILabel *lblStatement4=[[UILabel alloc]initWithFrame:CGRectMake(60, self.view.frame.size.height-90, self.view.frame.size.width-90, 25)];
    lblStatement4.text=[ViewController languageSelectedStringForKey:@"Location"];
    lblStatement4.font=[UIFont boldSystemFontOfSize:15];
    lblStatement4.textAlignment=NSTextAlignmentLeft;
    //[self.view addSubview:lblStatement4];
    
    UIButton *DetailsServicesbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    DetailsServicesbtn.frame=CGRectMake(200,self.view.frame.size.height-150, 70, 25);
    [DetailsServicesbtn setBackgroundImage:[UIImage imageNamed:@"essential.png"] forState:UIControlStateNormal];
    [DetailsServicesbtn setTitle:@"상세 내용보기" forState:UIControlStateNormal];
    [DetailsServicesbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [DetailsServicesbtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    DetailsServicesbtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [DetailsServicesbtn addTarget:self action:@selector(DetailsServicesbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DetailsServicesbtn];
    
    UIButton *DetailsPersonalbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    DetailsPersonalbtn.frame=CGRectMake(200,self.view.frame.size.height-120, 70, 25);
    [DetailsPersonalbtn setBackgroundImage:[UIImage imageNamed:@"essential.png"] forState:UIControlStateNormal];
    [DetailsPersonalbtn setTitle:@"상세 내용보기" forState:UIControlStateNormal];
    [DetailsPersonalbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [DetailsPersonalbtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    DetailsPersonalbtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [DetailsPersonalbtn addTarget:self action:@selector(DetailsPersonalbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DetailsPersonalbtn];
    
    UIButton *DetailsLocationbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    DetailsLocationbtn.frame=CGRectMake(200,self.view.frame.size.height-90, 70, 25);
    [DetailsLocationbtn setBackgroundImage:[UIImage imageNamed:@"essential.png"] forState:UIControlStateNormal];
    [DetailsLocationbtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [DetailsLocationbtn setTitle:@"상세 내용보기" forState:UIControlStateNormal];
    [DetailsLocationbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    DetailsLocationbtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [DetailsLocationbtn addTarget:self action:@selector(DetailsLocationbtnAction) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:DetailsLocationbtn];
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,50, self.view.frame.size.width, self.view.frame.size.height)];
    webView.delegate=self;
    webView.backgroundColor=[UIColor whiteColor];
}
/////////////////Check Mark Action///////////////////////////
-(void)checkMarkAction:(UIButton*)button
{
    
    if(button==checkMarkFirst)
    {
        if (!checkMarkFirstInd) {
            [checkMarkFirst setImage:[UIImage imageNamed:@"check_mark.png"] forState:UIControlStateNormal];
            [checkMarkSecond setImage:[UIImage imageNamed:@"check_mark.png"] forState:UIControlStateNormal];
            [checkMarkThird setImage:[UIImage imageNamed:@"check_mark.png"] forState:UIControlStateNormal];
            [checkMarkFourth setImage:[UIImage imageNamed:@"check_mark.png"] forState:UIControlStateNormal];
            checkMarkFirstInd=TRUE;
            checkMarkSecondInd=TRUE;
            checkMarkThirdInd=TRUE;
            checkMarkFourthInd=TRUE;
        }
        else
        {
            [checkMarkFirst setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            [checkMarkSecond setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            [checkMarkThird setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            [checkMarkFourth setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            checkMarkFirstInd=FALSE;
            checkMarkSecondInd=FALSE;
            checkMarkThirdInd=FALSE;
            checkMarkFourthInd=FALSE;
        }
        
    }
    else if (button==checkMarkSecond)
    {
        if (!checkMarkSecondInd)
            
        {
            
            [checkMarkSecond setImage:[UIImage imageNamed:@"check_mark.png"] forState:UIControlStateNormal];
            checkMarkSecondInd=TRUE;
        }
        else
        {
            [checkMarkSecond setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            checkMarkSecondInd=FALSE;
        }
    }
    else if (button==checkMarkThird)
    {
        if (!checkMarkThirdInd)
        {
            [checkMarkThird setImage:[UIImage imageNamed:@"check_mark.png"] forState:UIControlStateNormal];
            checkMarkThirdInd=TRUE;
        }
        else
        {
            [checkMarkThird setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            checkMarkThirdInd=FALSE;
        }
    }
    else if (button==checkMarkFourth)
    {
        
        if (!checkMarkFourthInd)
        {
            [checkMarkFourth setImage:[UIImage imageNamed:@"check_mark.png"] forState:UIControlStateNormal];
            checkMarkFourthInd=TRUE;
        }
        else
        {
            [checkMarkFourth setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
            checkMarkFourthInd=FALSE;
        }
        
    }
}
//////////////////Buttons and Web View/////////////////////
-(void)DetailsServicesbtnAction
{
    if (checkMarkSecondInd) {
        
        
       [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quiz-battle.co.kr/termsAndConditions.php"]]];
       // [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.marketmongoose.com/members/aff.php?aff=013"]]];
        [self.view addSubview:webView];
    }
}
-(void)DetailsPersonalbtnAction
{
    if (checkMarkThirdInd) {
        
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quiz-battle.co.kr/privacyPolicies.php"]]];        [self.view addSubview:webView];
    }
}
-(void)DetailsLocationbtnAction
{
    if (checkMarkFourthInd) {
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quiz-battle.co.kr/termsAndConditions.php"]]];
        
        [self.view addSubview:webView];
    }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [imageVAnim stopAnimating];
    UIButton *backbtnweb=[[UIButton alloc]initWithFrame:CGRectMake(300,0, 20,20)];
    [backbtnweb setImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [backbtnweb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backbtnweb addTarget:self action:@selector(backbtnWebAction) forControlEvents:UIControlEventTouchUpInside];
    [webView addSubview:backbtnweb];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error) {
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
        [imageVAnim stopAnimating];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-30, 30, 50)];
    [webView addSubview:imageVAnim];
    
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
}
-(void)backbtnWebAction
{
    [webView removeFromSuperview];
}
-(void)btnBackActionInSignUp:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createSessionQickBlox
{
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        [self signUpInQuickblox];
        // session created
    } errorBlock:^(QBResponse *response) {
        // handle errors
        NSLog(@"%@", response.error);
    }];
    
}

-(void)btnNextAction:(id)sender
{
    
     NSString *strOk = [ViewController languageSelectedStringForKey:@"OK"];
    
    if ([txtFEmail.text isEqualToString:@""]) {
        NSString *strMess = [ViewController languageSelectedStringForKey:@"Please Enter Email."];
        
        [[[UIAlertView alloc] initWithTitle:@"" message:strMess delegate:nil cancelButtonTitle:strOk otherButtonTitles: nil] show];
    }
    else if ([txtFPass.text isEqualToString:@""]) {
        NSString *strMess = [ViewController languageSelectedStringForKey:@"Please Enter Password."];
        
        [[[UIAlertView alloc] initWithTitle:@"" message:strMess delegate:nil cancelButtonTitle:strOk otherButtonTitles: nil] show];
    }
    else{
        
        BOOL checkInternet =  [ViewController networkCheck];
        
        if (checkInternet) {
           
             [self saveInfoInParse];
          [self createSessionQickBlox];
           
        }
        else{
            [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
        }
//        HomeViewController *obj = [[HomeViewController alloc]init];
//        [self presentViewController:obj animated:YES completion:nil];
    }
}
#pragma mark QuickBlox
-(void)signUpInQuickblox
{
    
    QBUUser *user=[QBUUser user];
    // user.email=@"khomesh@globussoft.com";//txtFEmail.text;
    user.password=@"globussoft123";
    user.login=txtFEmail.text;
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
    
    [QBRequest logInWithUserLogin:txtFEmail.text password:@"globussoft123" successBlock:^(QBResponse *response, QBUUser *user)
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

-(void)goTOHomeView
{
    
    HomeViewController *home = [[HomeViewController alloc]init];
    home.title=[ViewController languageSelectedStringForKey:@"Home"];
    
    TopicsViewController *topic = [[TopicsViewController alloc] initWithNibName:@"TopicsViewController" bundle:nil];
    topic.title = @"토픽";
    //topic.title = [ViewController languageSelectedStringForKey:@"Topic"];
    
    FriendsViewController *friend = [[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil];
    friend.title  = [ViewController languageSelectedStringForKey:@"Friend"];
    
    MainHistoryViewController *history = [[MainHistoryViewController alloc] init];
     history.title = @"히스토리";
    //history.title = [ViewController languageSelectedStringForKey:@"History"];
    
    MessagesViewController *message = [[MessagesViewController alloc]initWithNibName:@"MessagesViewController" bundle:nil];
    message.title=[ViewController languageSelectedStringForKey:@"Messages"];
    
    DiscussionsViewController *discussion = [[DiscussionsViewController alloc] initWithNibName:@"DiscussionsViewController" bundle:nil];
    discussion.title=[ViewController languageSelectedStringForKey:@"Discussions"];
    
    AchievementsViewController *achievement = [[AchievementsViewController alloc] initWithNibName:@"AchievementsViewController" bundle:nil];
    achievement.title=[ViewController languageSelectedStringForKey:@"Achievements"];
    
    StoreViewController *store = [[StoreViewController alloc] initWithNibName:@"StoreViewController" bundle:nil];
    store.title=[ViewController languageSelectedStringForKey:@"Store"];
    
    SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settings.title=@"설정";
   // settings.title=[ViewController languageSelectedStringForKey:@"Settings"];
    UINavigationController *messageNavi = [[UINavigationController alloc] initWithRootViewController:message];
    messageNavi.navigationBar.hidden = YES;
    UINavigationController *discussionNavi = [[UINavigationController alloc] initWithRootViewController:discussion];
    discussionNavi.navigationBar.hidden = YES;
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:home];
    homeNavi.navigationBar.hidden = YES;
    UINavigationController *topicNavi = [[UINavigationController alloc] initWithRootViewController:topic];
    topicNavi.navigationBar.hidden = YES;
    CustomMenuViewController *customMenuView = [[CustomMenuViewController alloc] init];
    customMenuView.numberOfSections = 1;
    customMenuView.viewControllers = @[homeNavi,topicNavi,friend,history,messageNavi,discussionNavi,achievement,store,settings];
    
    [self presentViewController:customMenuView animated:YES completion:nil];
}

-(void)saveInfoInParse
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
    PFFile *imageFile = [PFFile fileWithName:@"ProfilePic.jpg" data:self.dataImage];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            PFUser *object = [PFUser new];
            
            [object setUsername:txtFEmail.text];
            [object setPassword:txtFPass.text];
            [object setEmail:txtFEmail.text];
            object[@"birthday"]=self.strBirthday;
            object[@"userimage"]=imageFile;
            object[@"Rank"]=@"베이비";
            object[@"TotalXP"]=[NSNumber numberWithInt:0];
            object[@"deviceID"]=[SingletonClass sharedSingleton].installationId;
            object[@"name"]=self.strUserName;
            object[@"PrivacyMode"]=@YES;
            object[@"Diamond"]=@0;
            object[@"Type"]=[NSString stringWithFormat:@"user"];
            NSMutableArray * emptyArray=[[NSMutableArray alloc]init];
            object[@"Friends"]=emptyArray;
            object[@"BlockUser"]=emptyArray;
            object[@"Country"]=txtFCountry.text;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [object signUpInBackgroundWithBlock:^(BOOL succeed, NSError *error){
                   
                    if (succeed) {
                    NSLog(@"Save to Parse");
                [[NSUserDefaults standardUserDefaults] setObject:txtFEmail.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:txtFPass.text forKey:@"password"];
                        [self performSelector:@selector(connectAppWrap) withObject:nil afterDelay:3];

                    [[NSUserDefaults standardUserDefaults] setObject:self.strUserName forKey:@"name"];
                    NSString * objectId = [object objectId];
                        [SingletonClass sharedSingleton].objectId=objectId;
                        //[[NSUserDefaults standardUserDefaults] setObject:objectId forKey:@"objectid"];
                    [self saveUserIdInInstallation];
                  
                        dispatch_async(dispatch_get_main_queue(), ^(void)
                                       {
                                    [imageVAnim stopAnimating];
                                           [self goTOHomeView];
                                       });

                    
                    }
                    if (error) {
                    NSLog(@"Error to Save == %@",error.localizedDescription);
                    }
                }];
            });
            
            
//            object[@"username"]=self.strUserName;
            
//            object[@"email"]=txtFEmail.text;
//            object[@"password"]=txtFPass.text;
//            [object setObject:imageFile forKey:@"userimage"];
            
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [object saveEventually:^(BOOL succeed, NSError *error){
//                    
//                    if (succeed) {
//                        NSLog(@"Save to Parse");
//                        
//                        [[NSUserDefaults standardUserDefaults] setObject:self.strUserName forKey:@"name"];
//                       
//                        
//                        NSString * objectId = [object objectId];
//                        
//                        [[NSUserDefaults standardUserDefaults] setObject:objectId forKey:@"objectid"];
//                    }
//                    if (error) {
//                        NSLog(@"Error to Save == %@",error.localizedDescription);
//                    }
//                }];
//    });
//        }
//    }];
            
        }
    }];
}
-(void)connectAppWrap
{
    [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
}
#pragma mark Text Field Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
        return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];

    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField==txtFEmail) {
        checkEmail = [self checkEMail:txtFEmail.text];
        
        if (!checkEmail) {
            NSString *strWarning = [ViewController languageSelectedStringForKey:@"Warning"];
            NSString *strMess = [ViewController languageSelectedStringForKey:@"Please Enter correct email."];
            NSString *strOk = [ViewController languageSelectedStringForKey:@"OK"];
            
            [[[UIAlertView alloc]initWithTitle:strWarning message:strMess delegate:self cancelButtonTitle:strOk otherButtonTitles:nil] show];
            return NO;
        }
        else
            return YES;
    }
    else
        return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [txtFPass resignFirstResponder];
    [txtFEmail resignFirstResponder];
}
-(BOOL) checkEMail:(NSString *)email{
   
    BOOL returenvalue = NO;
    BOOL stricterFilter = YES;
    
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:email] == YES){
        returenvalue = YES;
    }
    else{
        returenvalue = NO;
    }
    
    return returenvalue;
}
-(void)saveUserIdInInstallation {
    
    NSString *strObjectId = [SingletonClass sharedSingleton].objectId;//[[NSUserDefaults standardUserDefaults] objectForKey:@"objectid"];
    
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet) {
        
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation setObject:strObjectId forKey:@"UserId"];
            [currentInstallation deviceType];
            [currentInstallation saveInBackground];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
    }
}
-(void)dealloc
{
    txtFEmail.delegate=nil;
    myPickerView.delegate=nil;
    txtFPass.delegate=nil;
    txtFCountry.delegate=nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
