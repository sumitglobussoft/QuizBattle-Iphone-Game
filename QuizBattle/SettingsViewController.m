//
//  SettingsViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "SettingsViewController.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ViewController.h"
#import "LanguageViewController.h"
#import "MessageCustomCell.h"
#import "LogInViewController.h"
#import "AboutView.h"
#import "AppDelegate.h"
#import "CustomSegmentController.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize collectionImages,avtarImages,collectionWallpaper,profile,wallPaperImages;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
        
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    //----Country comes in runtime///
    PFObject * objCountry=[[SingletonClass sharedSingleton].userDetailinParse objectAtIndex:0];
    tfCountry.text=objCountry[@"Country"];
    //---------------
    tfDisplayName.text=[SingletonClass sharedSingleton].strUserName;
    [seg setTitle:[ViewController languageSelectedStringForKey:@"Settings"]forSegmentAtIndex:0];
    [seg setTitle:[ViewController languageSelectedStringForKey:@"profile"] forSegmentAtIndex:1];
    if(profileImage)
    {
        self.profileImageView.image=profileImage;
 
    }
    else
    {
    self.profileImageView.image=[SingletonClass sharedSingleton].imageUser;
    }
    if(profile)
    {
     //   [self displayProfile];
        mainSettingTable.hidden=TRUE;
        scrollProfile.hidden=false;
    }
    if (mainSettingTable)
    {
     tfTitle.text=[SingletonClass sharedSingleton].userRank;
        [mainSettingTable reloadData];
    }
    if(aboutView)
    {
        [aboutView removeFromSuperview];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    if(self.profile)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //collection
    userDefault = [NSUserDefaults standardUserDefaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLang:) name:@"languagechange" object:nil];
    
    avtarImages=[[NSMutableArray alloc]init];
    wallPaperImages=[[NSMutableArray alloc]init];
    for(int i=1;i<=10;i++)
    {
        NSString *imgName=[NSString stringWithFormat:@"wp_%d",i];
        [wallPaperImages addObject:imgName];
    }
    for(int i=1;i<=18;i++)
    {
        NSString * imgName=[NSString stringWithFormat:@"%d.png",i] ;
        
        [avtarImages addObject:imgName];
    }
    [self settingUi];
        // Do any additional setup after loading the view from its nib.
}
-(void)settingUi
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    //collection for wallpaper
    collectionWallpaper=[[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, self.view.bounds.size.width-40, self.view.frame.size.height-100) collectionViewLayout:layout];
    [collectionWallpaper setDataSource:self];
    [collectionWallpaper setDelegate:self];
    collectionWallpaper.bounces=NO;
    collectionWallpaper.showsVerticalScrollIndicator=NO;
    [collectionWallpaper registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CellWallpaper"];
    collectionWallpaper.backgroundColor=[UIColor colorWithRed:(CGFloat)167/255 green:(CGFloat)252/255 blue:(CGFloat)244/255 alpha:1];
    collectionWallpaper.allowsSelection=YES;
    collectionWallpaper.hidden=YES;
    
    //-------collection end
    scrollProfile=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width,self.view.frame.size.height-80)];
    scrollProfile.showsVerticalScrollIndicator=YES;
    
    
    //®scroll.userInteractionEnabled=YES;
    
    scrollProfile.contentSize = CGSizeMake(self.view.frame.size.width,self.view.bounds.size.height+150);
    
    [self.view addSubview:scrollProfile];
    [self displayProfile];
    if (!seg)
    {
        NSString *strSetting=[ViewController languageSelectedStringForKey:@"Settings"];
        NSString *strProfile=[ViewController languageSelectedStringForKey:@"profile"];
        seg= [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:strSetting,strProfile, nil]];
    }
    
    
    // seg.segmentedControlStyle  = UISegmentedControlStyleBar;
    seg.frame= CGRectMake(50, 5, 240, 30);
    [seg addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    //seg.selectedSegmentIndex=UISegmentedControlSegmentLeft;
    // seg.tintColor= [UIColor blackColor];
    seg.selectedSegmentIndex=0;
    seg.tintColor=[UIColor blackColor];
    seg.backgroundColor=[UIColor colorWithRed:(CGFloat)198/255 green:(CGFloat)230/255 blue:(CGFloat)245/255 alpha:1.0];
   
    //-------------------
    //---------------
    CustomSegmentController * segEdit=[[CustomSegmentController alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-40, 30)];
    [segEdit drawUi:2];
    
    [segEdit.segButton1 addTarget:self action:@selector(actionSegment1:) forControlEvents:UIControlEventTouchUpInside];
    segEdit.segButton1.tag=51;
    segEdit.segButton1.hidden=NO;
    [segEdit.segButton2 addTarget:self action:@selector(actionSegment1:) forControlEvents:UIControlEventTouchUpInside];
    segEdit.segButton2.backgroundColor=[UIColor whiteColor];
    segEdit.segButton2.hidden=NO;
    segEdit.segButton2.tag=52;

    //----------------
    [segEdit.segButton1 setTitle:[ViewController languageSelectedStringForKey:@"Settings"] forState:UIControlStateNormal];
    [segEdit.segButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [segEdit.segButton2 setTitle:@"프로필" forState:UIControlStateNormal];
    [segEdit.segButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    

 [self.view addSubview:segEdit];
    //--------------------
    mainSettingTable=[[UITableView alloc]initWithFrame:CGRectMake(10, 60, self.view.frame.size.width-20, self.view.frame.size.height-150) style:UITableViewStyleGrouped];
    mainSettingTable.delegate=self;
    mainSettingTable.dataSource=self;
    mainSettingTable.bounces=NO;
    mainSettingTable.showsVerticalScrollIndicator=NO;
    [mainSettingTable setBackgroundView:nil];
    mainSettingTable.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    [mainSettingTable sizeToFit];
    [scrollProfile addSubview:mainSettingTable];
    
    scrollProfile.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    scrollProfile.hidden=TRUE;
    [self.view addSubview:mainSettingTable];
    web_View=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    web_View.delegate=self;

    
}
-(void)segmentAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex==0)
    {
        mainSettingTable.hidden=FALSE;
        scrollProfile.hidden=TRUE;
    }
    else
    {
        mainSettingTable.hidden=TRUE;
        scrollProfile.hidden=false;
    }
}
-(void)changeLang:(NSNotification*)notification
{
    
    //CustomMenuViewController *obj = [LogInViewController goTOHomeView];
    //[self presentViewController:obj animated:YES completion:nil];
    
}
#pragma mark ===============================
#pragma mark Table View delegates Methods
#pragma mark ===============================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0)
    {
        return 4;
    }
    if(section==1)
    {
        return 3;
    }
    if(section==2)
    {
        return 1;
    }
        return 1;
    // return [arrTopics count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Setting";
    
    cells=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cells=[[MessageCustomCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cells.messageLable.frame=CGRectMake(60, 10, 120, 30);
    if(indexPath.section==0)
    {//section 0
        [cells.aSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        cells.selectionStyle=UITableViewCellSelectionStyleNone;
        if(indexPath.row==0)
        {
            
            cells.messageLable.text=[ViewController languageSelectedStringForKey:@"Music"];
            cells.iconImg.image=[UIImage imageNamed:@"music_setting.png"];
            cells.aSwitch.tag=0;
            checkMusic=[userDefault boolForKey:@"music"];
            if (checkMusic) {
                [cells.aSwitch setOn:YES];
            }
        }
        if(indexPath.row==1)
        {
            
            cells.messageLable.text=[ViewController languageSelectedStringForKey:@"Sound Effects"];
            cells.iconImg.image=[UIImage imageNamed:@"sound_effect.png"];
            cells.aSwitch.tag=1;
            checkSoundEffect=[userDefault boolForKey:@"soundeffect"];
            if (checkSoundEffect) {
                [cells.aSwitch setOn:YES];
            }
        }
        if(indexPath.row==2)
        {
            cells.messageLable.text=[ViewController languageSelectedStringForKey:@"Vibration"];
            cells.iconImg.image=[UIImage imageNamed:@"vibaration.png"];
            cells.aSwitch.tag=2;
            checkVibration=[userDefault boolForKey:@"vibrate"];
            if (checkVibration) {
                [cells.aSwitch setOn:YES];
            }
        }
        if(indexPath.row==3)
        {
            cells.iconImg.image=[UIImage imageNamed:@"privacy.png"];
            cells.messageLable.text=[ViewController languageSelectedStringForKey:@"Privacy Mode"];
            cells.aSwitch.tag=3;
            checkPrivacy=[userDefault boolForKey:@"privacy"];
            if (checkPrivacy) {
                [cells.aSwitch setOn:YES];
            }
        }
        
        //  cell1.messageLable.text=@"1";
        cells.clipsToBounds = YES;
        
    }//section 0
    
    //================================================
    
    if(indexPath.section==1)
    {//section 1
        [cells.aSwitch addTarget:self action:@selector(changeSwitchNotification:) forControlEvents:UIControlEventValueChanged];
        cells.selectionStyle=UITableViewCellSelectionStyleNone;
        if(indexPath.row==0)
        {
            cells.messageLable.text=[ViewController languageSelectedStringForKey:@"Challenge Notification"];
            cells.iconImg.image=[UIImage imageNamed:@"challenge_notification.png"];
            cells.aSwitch.tag=0;
            checkChallNoti=[userDefault boolForKey:@"challnoti"];
            if (checkChallNoti) {
                [cells.aSwitch setOn:YES];
            }
        }
        if(indexPath.row==1)
        {
            cells.messageLable.text=[ViewController languageSelectedStringForKey:@"Chat Notification"];
            cells.iconImg.image=[UIImage imageNamed:@"chat_notification.png"];
            cells.aSwitch.tag=1;
            checkChatNoti=[userDefault boolForKey:@"chatnoti"];
            if (checkChatNoti) {
                [cells.aSwitch setOn:YES];
            }
        }
        if(indexPath.row==2)
        {
            cells.messageLable.text=[ViewController languageSelectedStringForKey:@"Friend Notification"];
            cells.iconImg.image=[UIImage imageNamed:@"friend_notification.png"];
            cells.aSwitch.tag=2;
            checkFrndNoti=[userDefault boolForKey:@"frndnoti"];
            if (checkFrndNoti) {
                [cells.aSwitch setOn:YES];
            }
        }
        
    }//section 1
    
    //=======================================================
    
    if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            NSString *strText = [userDefault objectForKey:@"language"];
            cells.messageLable.text=[ViewController languageSelectedStringForKey:strText];
            cells.iconImg.image=[UIImage imageNamed:@"challenge_notification.png"];
            cells.selectionStyle=UITableViewCellSelectionStyleBlue;
            cells.aSwitch.hidden=TRUE;
            
            btnChange=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btnChange addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
            btnChange.frame=CGRectMake(210, 5, 80, 30);
            btnChange.layer.borderWidth=2;
            btnChange.layer.borderColor=[UIColor blueColor].CGColor;
            [btnChange setTitle:[ViewController languageSelectedStringForKey:@"change"] forState:UIControlStateNormal];
            btnChange.backgroundColor=[UIColor whiteColor];
            //[cells.contentView addSubview:btn];
        }
        cells.clipsToBounds = YES;
    }
        // Configure the cell...
    return cells;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 50;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==0)
    {
        return 40;
    }
    if(section==2)
    {
        return 400;
    }
    return 0;
}


- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [userDefault setObject:@"Korean" forKey:@"language"];
    [userDefault synchronize];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        
        UIView * headerViewL=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
        UILabel * lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.textColor=[UIColor blackColor];
        lbl.text=[ViewController languageSelectedStringForKey:@"GENERAL"];
        [self.view addSubview:headerViewL];
        [headerViewL addSubview:lbl];
        [headerViewL setClipsToBounds:YES];
        return headerViewL;
    }
    if(section==1)
    {
        UIView * headerViewL=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
        UILabel * lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.textColor=[UIColor blackColor];
        lbl.text=[ViewController languageSelectedStringForKey:@"PUSH NOTIFICATIONS"];
        [headerViewL addSubview:lbl];
        return headerViewL;
    }
    if(section==2)
    {
        UIView * headerViewL=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
        UILabel * lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.textColor=[UIColor blackColor];
        lbl.text=[ViewController languageSelectedStringForKey:@"LANGUAGES"];
        [headerViewL addSubview:lbl];
        return headerViewL;
    }
    if(section==3)
    {
        
        UIView * headerViewL=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
        UILabel * lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.textColor=[UIColor blackColor];
        lbl.text=[ViewController languageSelectedStringForKey:@"OTHER ACCOUNTS"];
        [headerViewL addSubview:lbl];
        return headerViewL;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==0)
    {
        UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        UILabel * lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.textColor=[UIColor blackColor];
        lbl.numberOfLines=2;
        lbl.font=[UIFont systemFontOfSize:15];
        lbl.text=[ViewController languageSelectedStringForKey:@"Accepts users as friends before they can\nchallenge,chat or view your profile"];
        [footerView addSubview:lbl];
        return [[UIView alloc]initWithFrame:CGRectZero];
        
    }
    if(section==2)
    {
        UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 400)];
        
        UIButton * about=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        about.backgroundColor=[UIColor whiteColor];
        [about addTarget:self action:@selector(aboutAction:) forControlEvents:UIControlEventTouchUpInside];
        [about setTitle:@"퀴즈배틀 안내" forState:UIControlStateNormal];
        
        about.frame=CGRectMake(20, 40, 250, 50);
        about.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        UIButton * logOut=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        logOut.backgroundColor=[UIColor redColor];

        [logOut setTitle:[ViewController languageSelectedStringForKey:@"Log Out"] forState:UIControlStateNormal];
        
        logOut.frame=CGRectMake(20, 100, 250, 50);
        logOut.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [logOut addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *btnl=[UIButton buttonWithType:UIButtonTypeRoundedRect];
       btnl.backgroundColor=[UIColor colorWithRed:(CGFloat)196/255 green:(CGFloat)189/255 blue:(CGFloat)151/255 alpha:1.0];
        [btnl setTitle:[ViewController languageSelectedStringForKey:@"Member Withdrawl"] forState:UIControlStateNormal];
        [btnl addTarget:self action:@selector(lastButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        btnl.frame=CGRectMake(20, 160, 250, 50);
        btnl.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        [footerView addSubview:btnl];
      
        
        [footerView addSubview:logOut];
        [footerView addSubview:about];
       
        return footerView;
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.5;
}
#pragma mark--
- (void)changeSwitch:(id)sender{
    
    if([sender tag]==0)
    {
        if([sender isOn]){
            // Execute any code when the switch is ON
         [self playmusic];
            [userDefault setBool:true forKey:@"music"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"BackgroundSound" object:nil];

            self.musicOn_Off=TRUE;
            ;
            NSLog(@"Switch is ON");
        } else{
            // Execute any code when the switch is OFF
            [userDefault setBool:false forKey:@"music"];
            [myAudioPlayer stop];
            NSLog(@"Switch is OFF");
        }
        [self.setDetail addObject:[NSNumber numberWithBool:(self.musicOn_Off)]];
    }
   else if([sender tag]==1)
    {
        if([sender isOn]){
           
            [userDefault setBool:true forKey:@"soundeffect"];
            NSLog(@"Switch is ON");
        } else{
            // Execute any code when the switch is OFF
            [userDefault setBool:false forKey:@"soundeffect"];
            NSLog(@"Switch is OFF");
        }
    }
   else if([sender tag]==2)
    {
        if([sender isOn])
        {
            self.vibrateOn_Off=TRUE;
            [userDefault setBool:true forKey:@"vibrate"];
        }
        else
        {
            [userDefault setBool:false forKey:@"vibrate"];
            self.vibrateOn_Off=FALSE;
        }
        [self.setDetail addObject:[NSNumber numberWithBool:(self.vibrateOn_Off)]];
    }
    
   else{
       if([sender isOn])
       {
           [userDefault setBool:true forKey:@"privacy"];
       }
       else
       {
           [userDefault setBool:false forKey:@"privacy"];
       }
   }
     [userDefault synchronize];
//    if(self.settingDelegate)
//    {
//        
//    }
//    if ([self.settingDelegate respondsToSelector:@selector(settingDetails:)])
//    {
//        [self.settingDelegate settingDetails:(self.setDetail)];
//    }
    
}
- (void)changeSwitchNotification:(id)sender{
    
    if([sender tag]==0)
    {
        if([sender isOn]){
            // Execute any code when the switch is ON
            [userDefault setBool:true forKey:@"challnoti"];
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            NSLog(@"Switch is ON");
        } else{
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeAlert |
             UIRemoteNotificationTypeSound];
            // Execute any code when the switch is OFF
            [userDefault setBool:false forKey:@"challnoti"];
            NSLog(@"Switch is OFF");
        }
    }
    else if([sender tag]==1)
    {
        if([sender isOn]){
            
            [userDefault setBool:true forKey:@"chatnoti"];
            NSLog(@"Switch is ON");
        } else{
            // Execute any code when the switch is OFF
            [userDefault setBool:false forKey:@"chatnoti"];
            NSLog(@"Switch is OFF");
        }
    }
       else{
        if([sender isOn])
        {
            [userDefault setBool:true forKey:@"frndnoti"];
        }
        else
        {
            [userDefault setBool:false forKey:@"frndnoti"];
        }
    }
    [userDefault synchronize];
}
-(void)changeSwitchAutoFrnd:(id)sender{
    
    if([sender tag]==0)
    {
        if([sender isOn]){
            // Execute any code when the switch is ON
            [userDefault setBool:true forKey:@"autofrnd"];
            NSLog(@"Switch is ON");
        } else{
            // Execute any code when the switch is OFF
            [userDefault setBool:false forKey:@"autofrnd"];
            NSLog(@"Switch is OFF");
        }
    }
}
-(void)playmusic
{
//     NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"l1" ofType: @"mp3"];
//    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
//      myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//     //myAudioPlayer.numberOfLoops = -1; //infinite loop
//      [myAudioPlayer play];
    NSString *pewPewPath = [[NSBundle mainBundle]
                            pathForResource:@"Fiverr - In-Game Music - Stab 2 -  For Andy - James Warburton Music" ofType:@"wav"];
    NSLog(@"sound file path %@",pewPewPath);
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL,&(_pewPewSound));
    AudioServicesPlaySystemSound(_pewPewSound);
    
}
#pragma mark ===============================
#pragma mark Profile Methods
#pragma mark ===============================
-(void)displayProfile
{
    CGFloat height,width;
    height=self.view.bounds.size.height;
    width=self.view.bounds.size.width;
    self.themeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width,height-320)];
    self.themeImageView.backgroundColor = [UIColor whiteColor];
    self.themeImageView.image=[UIImage imageNamed:@"wp_1.png"];
    self.themeImageView.userInteractionEnabled=YES;
    [scrollProfile addSubview:self.themeImageView];
    UILabel * editWallpaper=[[UILabel alloc]initWithFrame:CGRectMake(0,height-340, self.view.frame.size.width, 20)];
    editWallpaper.backgroundColor=[UIColor grayColor];
    editWallpaper.textAlignment=NSTextAlignmentCenter;
    editWallpaper.userInteractionEnabled=YES;
    editWallpaper.textColor=[UIColor whiteColor];
    editWallpaper.text=[ViewController languageSelectedStringForKey:@"EDIT WALLPAPER"];
    editWallpaper.font=[UIFont systemFontOfSize:10];
    [scrollProfile addSubview:editWallpaper];
    UITapGestureRecognizer *tapWall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectWallpaper:)];
    [editWallpaper addGestureRecognizer:tapWall];
    UILabel * editImage=[[UILabel alloc]initWithFrame:CGRectMake(140, 120, self.view.frame.size.width-280, 20)];
    editImage.backgroundColor=[UIColor clearColor];
    editImage.textAlignment=NSTextAlignmentCenter;
    editImage.userInteractionEnabled=YES;
    editImage.textColor=[UIColor whiteColor ];
    editImage.text=[ViewController languageSelectedStringForKey:@"Edit"];
    editImage.layer.opacity=0.6;
    editImage.font=[UIFont systemFontOfSize:10];
    [scrollProfile addSubview:editImage];
    UITapGestureRecognizer *tapProfileImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)];
    
    [editImage addGestureRecognizer:tapProfileImg];
    
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.themeImageView.frame.size.width/2-50,self.themeImageView.frame.size.height/2-80, 100, 100)];
    self.profileImageView.backgroundColor = [UIColor grayColor];
    //  [scroll addSubview:self.profileImageView];
   
    [scrollProfile insertSubview:self.profileImageView aboveSubview:self.themeImageView];
    self.profileImageView.layer.cornerRadius = 50;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 5;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    NSLog(@"image is present or not %@",[SingletonClass sharedSingleton].imageUser);
     self.profileImageView.image=[SingletonClass sharedSingleton].imageUser;
    //===============
    
    
    UILabel * lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, height-300, 80, 20)];
    //lblName.textColor=[UIColor whiteColor];
    lblName.text=[ViewController languageSelectedStringForKey:@"Display Name"];
    lblName.font=[UIFont systemFontOfSize:10];
    [scrollProfile addSubview:lblName];
    //text field
    tfDisplayName=[[UITextField alloc]initWithFrame:CGRectMake(10, height-280, 300, 30)];
    tfDisplayName.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
   tfDisplayName.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:15];
    tfDisplayName.backgroundColor=[UIColor whiteColor];
    tfDisplayName.text=[SingletonClass sharedSingleton].strUserName;
    NSLog(@"text field name%@",tfDisplayName.text);
    tfDisplayName.tag = 10;
    tfDisplayName.delegate=self;
    [scrollProfile addSubview:tfDisplayName];
    UILabel *lblTitle=[[UILabel alloc]init];
    lblTitle.frame=CGRectMake(10, height -250, 80, 20);
   // lblTitle.textColor=[UIColor whiteColor];
    lblTitle.text=[ViewController languageSelectedStringForKey:@"Title"];
    lblTitle.font=[UIFont systemFontOfSize:10];
    [scrollProfile addSubview:lblTitle];
     tfTitle=[[UITextField alloc]initWithFrame:CGRectMake(10,height-230, 300, 30)];
    tfTitle.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    tfTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    tfTitle.backgroundColor=[UIColor whiteColor];
    
    tfTitle.tag = 11;
    tfTitle.delegate=self;
    [scrollProfile addSubview:tfTitle];
    pickerArray = [[NSArray alloc]initWithObjects:@"대한민국",
                   @"일본",@"중국",@"미국",@"독일",@"프랑스",@"캐나다",@"영국",@"싱가폴",@"기타", nil];
        UILabel *lblCountry=[[UILabel alloc]init];
    lblCountry.frame=CGRectMake(10, height -190, 80, 20);
   // lblCountry.textColor=[UIColor whiteColor];
    lblCountry.text=[ViewController languageSelectedStringForKey:@"COUNTRY"];
    lblCountry.font=[UIFont systemFontOfSize:10];
    [scrollProfile addSubview:lblCountry];
    tfCountry=[[UITextField alloc]initWithFrame:CGRectMake(10,height-160, 300, 30)];
    tfCountry.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    tfCountry.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    tfCountry.backgroundColor=[UIColor whiteColor];
    
    tfCountry.delegate=self;
    tfCountry.tag = 14;
    [scrollProfile addSubview:tfCountry];
    myPickerView = [[UIPickerView alloc]init];
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.backgroundColor=[UIColor whiteColor];
    tfCountry.inputView=myPickerView;
    saveButton=[[UIButton alloc]initWithFrame:CGRectMake(130,height-120,90 , 30)];
    [saveButton setTitle:[ViewController languageSelectedStringForKey:@"Save"] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [saveButton addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.backgroundColor=[UIColor grayColor];
    saveButton.enabled=NO;
    [scrollProfile addSubview:saveButton];
    
}

-(void)selectImage:(UITapGestureRecognizer *)tapGesture
{
     saveButton.enabled=YES;
[saveButton setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    NSString *actionTitle = [ViewController languageSelectedStringForKey:@"Choose Profile Picture Source"];
    NSString *strCancel = [ViewController languageSelectedStringForKey:@"Cancel"];
    
    NSString *strTakePhoto = [ViewController languageSelectedStringForKey:@"Take Photo"];
    NSString *strChooseAvatar=[ViewController languageSelectedStringForKey:@"Choose Avatar"];
   
    NSString *strChooseP = [ViewController languageSelectedStringForKey:@"Choose Photo"];
    actionSheetImages = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:(id)self cancelButtonTitle:strCancel destructiveButtonTitle:nil otherButtonTitles:strTakePhoto,strChooseP,strChooseAvatar,nil];
    actionSheetImages.delegate=self;
    //actionSheetImages.frame=CGRectMake(0, 0, self.view.frame.size.width, 40);
    [actionSheetImages showInView:[UIApplication sharedApplication].keyWindow];
}


-(void)selectWallpaper:(UITapGestureRecognizer *)tapGesture
{
    saveButton.enabled=YES;
   [saveButton setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    NSString *actionTitle = [ViewController languageSelectedStringForKey:@"Choose Profile Picture Source"];
    NSString *strCancel = [ViewController languageSelectedStringForKey:@"Cancel"];
    
    NSString *strTakePhoto = [ViewController languageSelectedStringForKey:@"Take Photo"];
    
    NSString *strChooseP = [ViewController languageSelectedStringForKey:@"Choose Photo"];
    NSString *strChooseWallpaper = [ViewController languageSelectedStringForKey:@"Choose Wallpaper"];
    
    actionSheetWallpaper = [[UIActionSheet alloc] initWithTitle:actionTitle delegate:(id)self cancelButtonTitle:strCancel destructiveButtonTitle:nil otherButtonTitles:strTakePhoto,strChooseP,strChooseWallpaper, nil];
    
    [actionSheetWallpaper showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"Action sheet button index press -== %ld",(long)buttonIndex);
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate=self;
    
    if (buttonIndex==0)
    {
        self.imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        //[self.navigationController pushViewController:imagePicker animated:YES];
     [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex==1)
    {
        self.imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
       // [self.navigationController pushViewController:imagePicker animated:YES];
       [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else if (actionSheet==actionSheetImages&& buttonIndex==2)
    {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        collectionImages=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
        //cpllection for images
        [collectionImages setDataSource:self];
        [collectionImages setDelegate:self];
        
        [collectionImages registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [collectionImages setBackgroundColor:[UIColor clearColor]];
        collectionImages.allowsSelection=YES;
        collectionImages.hidden=YES;
        [self.view addSubview:collectionImages];
        collectionImages.hidden=FALSE;
        scrollProfile.hidden=TRUE;
        seg.hidden=TRUE;
    }
    else if(actionSheet==actionSheetWallpaper && buttonIndex==2)
    {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(100, 100);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [self.view addSubview:collectionWallpaper];
        collectionWallpaper.hidden=FALSE;
        scrollProfile.hidden=TRUE;
        seg.hidden=TRUE;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    NSLog(@"Image Info -=-= %@", editingInfo);
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
  [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Image Info Picking Media-=-= %@", info);
    
    
    profileImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Upload image
    //     [self uploadImage:imageData];
    //    [NSThread detachNewThreadSelector:@selector(uploadImage) toTarget:self withObject:imageData];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
   [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) handleTapGesture:(UITapGestureRecognizer *)tapGesture{
    
    [self.view endEditing:YES];
    self.profileInfo.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    if (!self.flatDatePicker) {
        self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
        self.flatDatePicker.delegate = self;
        NSString *strPickerText = [ViewController languageSelectedStringForKey:@"Select your birthday"];
        self.flatDatePicker.title = strPickerText;
        //        self.flatDatePicker.datePickerMode = FlatDatePickerModeTime;
        self.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
        
        [self.flatDatePicker show];
    }
    else{
        [self.flatDatePicker show];
    }
}
#pragma mark-------
#pragma mark Text Field delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    saveButton.enabled=YES;
    [saveButton setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    if (textField.tag ==10){
        [self.flatDatePicker dismiss];
        
        [UIView animateWithDuration:0.4 animations:^{
            [scrollProfile setContentOffset:CGPointMake(0, 260) animated:YES];
        }];
    }
    else if (textField.tag ==11){
        [self.flatDatePicker dismiss];
        [UIView animateWithDuration:0.4 animations:^{
            [scrollProfile setContentOffset:CGPointMake(0, 280) animated:YES];
        }];
    }
    else if (textField.tag ==12){
        [self.flatDatePicker dismiss];
        [UIView animateWithDuration:0.4 animations:^{
            [scrollProfile setContentOffset:CGPointMake(0, 320) animated:YES];
        }];
    }
    else if (textField.tag ==13){
        [self.flatDatePicker dismiss];
        [UIView animateWithDuration:0.4 animations:^{
            [scrollProfile setContentOffset:CGPointMake(0, 400) animated:YES];        }];
    }
    else if (textField.tag ==14){
        [self.flatDatePicker dismiss];
        [UIView animateWithDuration:0.4 animations:^{
            [scrollProfile setContentOffset:CGPointMake(0, 440) animated:YES];
        }];
    }
    else if (textField.tag ==15){
        [self.flatDatePicker dismiss];
        [UIView animateWithDuration:0.4 animations:^{
            [scrollProfile setContentOffset:CGPointMake(0, 500) animated:YES];
        }];
    }
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //    self.profileInfo.frame = CGRectMake(0, 5, self.profileInfo.frame.size.width, self.profileInfo.frame.size.height);
    [scrollProfile setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

// It is important for you to hide kwyboard

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
        //        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        [dateFormatter setDateFormat:@"dd/MM/yy"];
    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    setBirthDay.text = value;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.profileInfo.frame = CGRectMake(0,  200, self.view.frame.size.width, self.view.bounds.size.height);
    }];
}
- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender
{
    [UIView animateWithDuration:0.4 animations:^{
        self.profileInfo.frame = CGRectMake(0,  200, self.view.frame.size.width, self.view.bounds.size.height);
    }];
}

#pragma mark=====
#pragma mark collection delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView==collectionWallpaper)
    {
        return 10;
    }
    return 18;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView==collectionImages)
    {
        UICollectionViewCell *cell;
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        
        for (UIImageView *img in cell.contentView.subviews)
        {
            if ([img isKindOfClass:[UIImageView class]])
            {
                [img removeFromSuperview];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //  ********* Changed *******
            
            for (UIView *v in [cell.contentView subviews])
                [v removeFromSuperview];
            if ([self.collectionImages.indexPathsForVisibleItems containsObject:indexPath]) {
                
                UIImageView *avtarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:  [avtarImages objectAtIndex:indexPath.row]]];
                avtarImageView.layer.zPosition=2;
                cell.layer.zPosition=2;
                NSLog(@"images%@",[avtarImages objectAtIndex:indexPath.row]);
                avtarImageView.frame=CGRectMake(0, 0, 100, 100);
                
                cell.backgroundColor=[UIColor clearColor];
                
                [cell.contentView addSubview:avtarImageView];
            }
            // ********** Changed **********
        });
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    //Wallpaper cell
    if(collectionView==collectionWallpaper)
    {
        UICollectionViewCell *cellw=[collectionView dequeueReusableCellWithReuseIdentifier:@"CellWallpaper" forIndexPath:indexPath];
        
        for (UIImageView *img in cellw.contentView.subviews)
        {
            if ([img isKindOfClass:[UIImageView class]])
            {
                [img removeFromSuperview];
            }
        }
        
        UIImageView *wallPaper = [[UIImageView alloc]initWithImage:[UIImage imageNamed:  [wallPaperImages objectAtIndex:indexPath.row]]];
        wallPaper.frame=CGRectMake(0, 0,320, 240);
        
        cellw.backgroundColor=[UIColor redColor];
        [cellw.contentView addSubview:wallPaper];
        
        return cellw;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==collectionWallpaper) {
        return CGSizeMake(320, 240);
    }
    return CGSizeMake(100, 100);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index%ld",(long)indexPath.row);
    if(collectionView==collectionImages)
    {
        self.profileImageView.image=[UIImage imageNamed:[avtarImages objectAtIndex:indexPath.row]];
        self.profileImageView.backgroundColor = [UIColor clearColor];
        collectionImages.hidden=TRUE;
        scrollProfile.hidden=FALSE;
        seg.hidden=FALSE;
    }
    if(collectionView==collectionWallpaper)
    {
        self.themeImageView.image=[UIImage imageNamed:[wallPaperImages objectAtIndex:indexPath.row]];
        collectionWallpaper.hidden=TRUE;
        scrollProfile.hidden=FALSE;
        seg.hidden=FALSE;
        
    }
}
-(UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(collectionView==collectionWallpaper)
    {
       // return UIEdgeInsetsMake(50, 20, 50, 20);
    }
    return UIEdgeInsetsMake(50, 20, 50, 20);
}
-(void)lastButtonAction:(id)sender
{
    [self memberWithDrawlPopupUi:@""];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView==messageInitial)
    {
        if (buttonIndex!=[alertView cancelButtonIndex])
        {
           messageConfirmation=[[UIAlertView alloc]initWithTitle:nil message:[ViewController languageSelectedStringForKey:@"Are you sure you want to leave?"] delegate:self cancelButtonTitle:[ViewController languageSelectedStringForKey:@"Reject"]otherButtonTitles:[ViewController languageSelectedStringForKey:@"Yes"], nil];
            [messageConfirmation show];
        }
    }
    
        if(alertView==messageConfirmation)
        {
            if(buttonIndex==1)
            {
                
            }
        }
        
    
    
    
}
-(NSArray*)countryName
{
    NSArray *countries = [NSArray arrayWithObjects:@"Afghanistan", @"Akrotiri", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Anguilla", @"Antarctica", @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Aruba", @"Ashmore and Cartier Islands", @"Australia", @"Austria", @"Azerbaijan", @"The Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Bassas da India", @"Belarus", @"Belgium", @"Belize", @"Benin", @"Bermuda", @"Bhutan", @"Bolivia", @"Bosnia and Herzegovina", @"Botswana", @"Bouvet Island", @"Brazil", @"British Indian Ocean Territory", @"British Virgin Islands", @"Brunei", @"Bulgaria", @"Burkina Faso", @"Burma", @"Burundi", @"Cambodia", @"Cameroon", @"Canada", @"Cape Verde", @"Cayman Islands", @"Central African Republic", @"Chad", @"Chile", @"China", @"Christmas Island", @"Clipperton Island", @"Cocos (Keeling) Islands", @"Colombia", @"Comoros", @"Democratic Republic of the Congo", @"Republic of the Congo", @"Cook Islands", @"Coral Sea Islands", @"Costa Rica", @"Cote d'Ivoire", @"Croatia", @"Cuba", @"Cyprus", @"Czech Republic", @"Denmark", @"Dhekelia", @"Djibouti", @"Dominica", @"Dominican Republic", @"Ecuador", @"Egypt", @"El Salvador", @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia", @"Europa Island", @"Falkland Islands (Islas Malvinas)", @"Faroe Islands", @"Fiji", @"Finland", @"France", @"French Guiana", @"French Polynesia", @"French Southern and Antarctic Lands", @"Gabon", @"The Gambia", @"Gaza Strip", @"Georgia", @"Germany", @"Ghana", @"Gibraltar", @"Glorioso Islands", @"Greece", @"Greenland", @"Grenada", @"Guadeloupe", @"Guam", @"Guatemala", @"Guernsey", @"Guinea", @"Guinea-Bissau", @"Guyana", @"Haiti", @"Heard Island and McDonald Islands", @"Holy See (Vatican City)", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran", @"Iraq", @"Ireland", @"Isle of Man", @"Israel", @"Italy", @"Jamaica", @"Jan Mayen", @"Japan", @"Jersey", @"Jordan", @"Juan de Nova Island", @"Kazakhstan", @"Kenya", @"Kiribati", @"North Korea", @"South Korea", @"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia", @"Lebanon", @"Lesotho", @"Liberia", @"Libya", @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macau", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia", @"Maldives", @"Mali", @"Malta", @"Marshall Islands", @"Martinique", @"Mauritania", @"Mauritius", @"Mayotte", @"Mexico", @"Federated States of Micronesia", @"Moldova", @"Monaco", @"Mongolia", @"Montserrat", @"Morocco", @"Mozambique", @"Namibia", @"Nauru", @"Navassa Island", @"Nepal", @"Netherlands", @"Netherlands Antilles", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Niue", @"Norfolk Island", @"Northern Mariana Islands", @"Norway", @"Oman", @"Pakistan", @"Palau", @"Panama", @"Papua New Guinea", @"Paracel Islands", @"Paraguay", @"Peru", @"Philippines", @"Pitcairn Islands", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Reunion", @"Romania", @"Russia", @"Rwanda", @"Saint Helena", @"Saint Kitts and Nevis", @"Saint Lucia", @"Saint Pierre and Miquelon", @"Saint Vincent and the Grenadines", @"Samoa", @"San Marino", @"Sao Tome and Principe", @"Saudi Arabia", @"Senegal", @"Serbia", @"Montenegro", @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"Solomon Islands", @"Somalia", @"South Africa", @"South Georgia and the South Sandwich Islands", @"Spain", @"Spratly Islands", @"Sri Lanka", @"Sudan", @"Suriname", @"Svalbard", @"Swaziland", @"Sweden", @"Switzerland", @"Syria", @"Taiwan", @"Tajikistan", @"Tanzania", @"Thailand", @"Tibet", @"Timor-Leste", @"Togo", @"Tokelau", @"Tonga", @"Trinidad and Tobago", @"Tromelin Island", @"Tunisia", @"Turkey", @"Turkmenistan", @"Turks and Caicos Islands", @"Tuvalu", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Venezuela", @"Vietnam", @"Virgin Islands", @"Wake Island", @"Wallis and Futuna", @"West Bank", @"Western Sahara", @"Yemen", @"Zambia", @"Zimbabwe", nil];
    return countries;
}
-(void)changeAction:(id)sender
{
    LanguageViewController *obj=[[LanguageViewController alloc]init];
    [self presentViewController:obj animated:YES completion:nil];
}
#pragma mark Button Action in Settings/Profile
-(void)aboutAction:(id)sender
{
    [self createAboutView];
}
-(void)saveBtnAction:(id)sender
{
    
    UIImageView *imageVAnimL = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-30, 30, 50)];
    [self.view addSubview:imageVAnimL];
    
    NSArray *arrAnimImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"burning_rocket_01.png"],
                              [UIImage imageNamed:@"burning_rocket_02.png"],
                              [UIImage imageNamed:@"burning_rocket_03.png"],
                              [UIImage imageNamed:@"burning_rocket_04.png"],
                              [UIImage imageNamed:@"burning_rocket_05.png"],
                              [UIImage imageNamed:@"burning_rocket_06.png"],
                              [UIImage imageNamed:@"burning_rocket_07.png"],
                              [UIImage imageNamed:@"burning_rocket_08.png"], nil];
    
    imageVAnimL.animationImages=arrAnimImages;
    imageVAnimL.animationDuration=0.5;
    imageVAnimL.animationRepeatCount=0;
    [imageVAnimL startAnimating];

    
    NSData *data=UIImagePNGRepresentation(self.profileImageView.image);
    PFFile *imgFile=[PFFile fileWithData:data];
    [imgFile saveInBackgroundWithBlock:^(BOOL suceed,NSError *error)
     {
         if (suceed) {
    PFQuery *query=[PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[SingletonClass sharedSingleton].objectId block:^(PFObject *object,NSError *error)
     {
         if (!error) {
             object[@"name"]=tfDisplayName.text;
             object[@"Country"]=tfCountry.text;
             object[@"userimage"]=imgFile;
             [object saveInBackgroundWithBlock:^(BOOL suceed,NSError *error)
              {
                  if (suceed)
                  {
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeUserImage" object:nil];
                      [SingletonClass sharedSingleton].imageUser=profileImage;
                      [SingletonClass sharedSingleton].strUserName=tfDisplayName.text;
                      dispatch_async(dispatch_get_main_queue(), ^(void)
                                     {
                      [imageVAnimL stopAnimating];
                                     });
                      [self dataSavedPopup];
                      NSLog(@"Data Saved");
                  }
                  
                  else
                  {
                   NSLog(@"Error==%@",error);
                  }
              }];
         }
         else
         {
             NSLog(@"Error==%@",error);
         }
     }];
}
         
else
    {
    NSLog(@"Error==%@",error);
    }
     
}];
    
}


-(void)logoutAction:(id)sender
{
  [[NSUserDefaults standardUserDefaults] setObject:@"newuser" forKey:@"username"];
   //
 if([SingletonClass sharedSingleton].gameFromView)
 {
     ViewController * viewObj=(ViewController*)[SingletonClass sharedSingleton].view;
     
     //  //  [[KOSession sharedSession] close];
     
     AppDelegate *appdelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
     
     [appdelegate logOutKakao];
     [SingletonClass sharedSingleton].gameFromView=true;
     [appdelegate.window setRootViewController:viewObj];
  
 }
else
{
  [self dismissViewControllerAnimated:YES completion:nil];
}
    
    
}

    -(void)fbLinkAction
    {
        if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            [PFFacebookUtils linkUser:[PFUser currentUser] permissions:nil block:^(BOOL suceed,NSError *error)
             {
                 if (suceed) {
                     NSLog(@"User is linked with his facebook Account");
                     [btnChange setTitle:@"Linked" forState:UIControlStateNormal];
                     NSString *fbAcessToken=[[[FBSession activeSession]accessTokenData]accessToken];
                     [userDefault setBool:true forKey:@"FacebookLink"];
                     NSLog(@"FblinkAccessToken==%@",fbAcessToken);
                     [self fetchFacebookGameFriends:fbAcessToken];
                 }
                 else
                 {
                     NSLog(@"Error in linking to Facebook Account==%@",error);
                 }
             }];
        }
        else{
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL suceed,NSError *error)
             {
                 if (suceed) {
                     NSLog(@"User is no more linked to Facebook");
                     [btnChange setTitle:@"Link" forState:UIControlStateNormal];
                     [userDefault setBool:false forKey:@"FacebookLink"];
                 }
                 else
                 {
                     NSLog(@"Error in unlink Fb Account==%@",error);
                 }
             }];
        }
        
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
#pragma mark-----
#pragma mark alert view delegates
-(void)memberWithDrawlPopupUi:(NSString *)request
{
    
    backgroundAlertView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:backgroundAlertView];
    backgroundAlertView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2-120, 277, 200)];
    popUpImageview.image=[UIImage imageNamed:@"popup_small.png"];
    popUpImageview.userInteractionEnabled=YES;
    [backgroundAlertView addSubview:popUpImageview];
    lblReject=[[UILabel alloc]initWithFrame:CGRectMake(20,60, popUpImageview.frame.size.width-40, 80)];
    lblReject.text=[ViewController languageSelectedStringForKey:@"회원탈퇴를 하시면 게임을 이용하실 수 없으며 모든 계정 정보(DIA, 생명,퀴즈포인트 등)가 삭제됩니다 당신은 당신이 떠날 하시겠습니까?"];
    lblReject.lineBreakMode = NSLineBreakByWordWrapping;
    lblReject.numberOfLines = 0;
    lblReject.font=[UIFont systemFontOfSize:12];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UIButton * closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake(popUpImageview.frame.size.width-30,5,30, 30);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    closeBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:closeBtn];
        UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(40,popUpImageview.frame.size.height-40,86, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"btnpopup.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strAccept=[ViewController languageSelectedStringForKey:@"아니요"];
    [acceptBtn setTitle:strAccept forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(acceptButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:acceptBtn];
    UIButton * rejectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rejectBtn.frame=CGRectMake(popUpImageview.frame.size.width/2+15,popUpImageview.frame.size.height-40,86,30);
    [rejectBtn setBackgroundImage:[UIImage imageNamed:@"btn_2.png"] forState:UIControlStateNormal];
    [rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strReject=[ViewController languageSelectedStringForKey:@"예"];
    [rejectBtn setTitle:strReject forState:UIControlStateNormal];
    rejectBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [rejectBtn addTarget:self action:@selector(rejectButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:rejectBtn];
    
}
-(void)closeBtnAction:(id)sender
{
     [backgroundAlertView removeFromSuperview];
}
-(void)acceptButton:(id)sender
{
     [backgroundAlertView removeFromSuperview];
    [[PFUser currentUser] deleteInBackground];
    [PFCloud callFunctionInBackground:@"DeleteUser"
                       withParameters:@{@"userid": [SingletonClass sharedSingleton].objectId
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Response Result -==- %@", result);
                                        NSLog(@"Connect to cloud");
                                    }
                                    else
                                    {
                                        NSLog(@"Error in calling CloudCode %@",error);
                                    }
                                }];
 
}
-(void)rejectButton:(id)sender
{
    
    [backgroundAlertView removeFromSuperview];
}

#pragma mark about view
-(void)createAboutView
{
    aboutView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    aboutView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:aboutView];
    UIImageView *imglogo=[[UIImageView alloc]initWithFrame:CGRectMake(125, 30,70,70)];
    imglogo.image=[UIImage imageNamed:@"logo.png"];
    [aboutView addSubview:imglogo];
    UILabel *logolbl=[[UILabel alloc]initWithFrame:CGRectMake(0,imglogo.frame.origin.y+70, 320, 70)];
    logolbl.text=[ViewController languageSelectedStringForKey:@"Quiz Battle"];
    logolbl.textColor=[UIColor blackColor];
    logolbl.textAlignment=NSTextAlignmentCenter;
    logolbl.font=[UIFont boldSystemFontOfSize:26];
    [aboutView addSubview:logolbl];
    UIButton *termsOfUsebtn=[[UIButton alloc]initWithFrame:CGRectMake(0,imglogo.frame.origin.y+140, 320, 30)];
    [termsOfUsebtn setTitle:[ViewController languageSelectedStringForKey:@"Terms of Use"] forState:UIControlStateNormal];
    [termsOfUsebtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [termsOfUsebtn setTitleColor:[UIColor colorWithRed:(CGFloat)74/255 green:(CGFloat)192/255 blue:(CGFloat)180/255 alpha:1] forState:UIControlStateNormal];
    [termsOfUsebtn addTarget:self action:@selector(termsOfUseAction) forControlEvents:UIControlEventTouchUpInside];
    [aboutView addSubview:termsOfUsebtn];
    UIButton *privacyBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,imglogo.frame.origin.y+170, 320, 30)];
    [privacyBtn setTitle:[ViewController languageSelectedStringForKey:@"Privacy Policy"] forState:UIControlStateNormal];
    privacyBtn.userInteractionEnabled=YES;
    [privacyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [privacyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [privacyBtn addTarget:self action:@selector(supporturlAction) forControlEvents:UIControlEventTouchUpInside];
    [aboutView addSubview:privacyBtn];
    
    UILabel *custmrsuportlbl=[[UILabel alloc]initWithFrame:CGRectMake(0, imglogo.frame.origin.y+200, aboutView.frame.size.width, 40)];
    custmrsuportlbl.text=[ViewController languageSelectedStringForKey:@"For customer supportvisit"];
    
    custmrsuportlbl.textColor=[UIColor greenColor];
    custmrsuportlbl.font=[UIFont boldSystemFontOfSize:16];
    custmrsuportlbl.textAlignment=NSTextAlignmentCenter;
    // custmrsuportlbl.lineBreakMode=NSLineBreakByWordWrapping;
    [aboutView addSubview:custmrsuportlbl];
    UIButton *supportUrl=[[UIButton alloc]initWithFrame:CGRectMake(0,imglogo.frame.origin.y+250,aboutView.frame.size.width, 30)];
    [supportUrl setTitle:@"www.QuizBattle.com" forState:UIControlStateNormal];
    [supportUrl.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [supportUrl setTitleColor:[UIColor colorWithRed:(CGFloat)74/255 green:(CGFloat)192/255 blue:(CGFloat)180/255 alpha:1] forState:UIControlStateNormal];
    [supportUrl addTarget:self action:@selector(supporturlAction) forControlEvents:UIControlEventTouchUpInside];
    [aboutView addSubview:supportUrl];

}

#pragma mark AddTapGesture

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
        NSLog(@"Error %@",error);
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-30, 30, 50)];
    [web_View addSubview:imageVAnim];
    
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
    [web_View removeFromSuperview];
}
-(void)termsOfUseAction
{
    [aboutView removeFromSuperview];
    web_View.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:web_View];
    [web_View loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quiz-battle.co.kr/termsAndConditions.php"]]];
    
    [self.view addSubview:web_View];

   }

-(void)supporturlAction
{
    [aboutView removeFromSuperview];
    web_View.backgroundColor=[UIColor whiteColor];
    [web_View loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quiz-battle.co.kr/termsAndConditions.php"]]];
    
    [self.view addSubview:web_View];
    
}
#pragma mark---------
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
    [tfCountry resignFirstResponder];
    [tfCountry setText:[pickerArray objectAtIndex:row]];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

-(void)dataSavedPopup
{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        UIView * tempView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,appdelegate.window.frame.size.width,appdelegate.window.frame.size.height)];
    [appdelegate.window addSubview:tempView];

    tempView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageviewL=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2, self.view.frame.size.width-20, 100)];
    popUpImageviewL.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageviewL.userInteractionEnabled=YES;
    [tempView addSubview:popUpImageviewL];
    UILabel * lblRejectL=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, popUpImageviewL.frame.size.width, 20)];
    lblRejectL.text=@"데이터 저장";
    lblRejectL.textAlignment=NSTextAlignmentCenter;
    lblRejectL.textColor=[UIColor blackColor];
    [popUpImageviewL addSubview:lblRejectL];
    UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(popUpImageviewL.frame.size.width-30,5,30, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(acceptButtonOk:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageviewL addSubview:acceptBtn];
    
    
   /* UIButton * okBtnL=[UIButton buttonWithType:UIButtonTypeCustom];
    okBtnL.frame=CGRectMake(120,popUpImageviewL.frame.size.height-40,120, 30);
    [okBtnL setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [okBtnL setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strAccept=[ViewController languageSelectedStringForKey:@"Ok"];
    [okBtnL setTitle:strAccept forState:UIControlStateNormal];
    okBtnL.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [okBtnL addTarget:self action:@selector(acceptButtonOk:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageviewL addSubview:okBtnL];*/
    
}
-(void)acceptButtonOk:(id)sender
{
   [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
}
-(void)actionSegment1:(UIButton*)btn
{
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if(btn.tag==51)
    {
        //----------------
        mainSettingTable.hidden=FALSE;
        scrollProfile.hidden=TRUE;
        //----------------Button Color
        UIButton * btnL=(UIButton*)[self.view viewWithTag:52];
        [btnL setBackgroundColor:[UIColor whiteColor]];
        [btnL setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
               //-----------
    }
    else if(btn.tag==52)
    {
        //------------------
        mainSettingTable.hidden=TRUE;
        scrollProfile.hidden=false;
        //-------------------
        UIButton * btnL=(UIButton*)[self.view viewWithTag:51];
        [btnL setBackgroundColor:[UIColor whiteColor]];
        [btnL setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //--------------
        
    }
    
}
-(void)dealloc
{
       self.imagePicker.delegate=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
