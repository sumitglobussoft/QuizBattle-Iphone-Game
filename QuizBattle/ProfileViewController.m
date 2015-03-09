//
//  RecommendedViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/12/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "ProfileViewController.h"
#import "ChooseTopics.h"
#import "SettingsViewController.h"
#import "ChatScreenMessageViewController.h"
#import "ChatScreenUi.h"
#import "ViewController.h"
#import "Rect1.h"
#import "SingletonClass.h"
#import "AppDelegate.h"

@interface ProfileViewController ()
@property (nonatomic, strong)SettingsViewController *settingVC;
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPreviousView:) name:KDismissView object:nil];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [SingletonClass sharedSingleton].profileForSecondUser=FALSE;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDismissView object:nil];
}
-(void)goToPreviousView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //----------------------
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-30, 30, 50)];
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
    //---------------------------
        [NSThread detachNewThreadSelector:@selector(chatLogin) toTarget:self withObject:nil];
    [self fetchData];

    //adding scroll view
    //----------
    self.totalScorePoints=[[NSMutableArray alloc]init];
    self.subCategoryName=[[NSMutableArray alloc]init];
   self.subCategoryId=[[NSMutableArray alloc]init];
    if(![SingletonClass sharedSingleton].profileForSecondUser)
    {
        self.imageUser=[SingletonClass sharedSingleton].imageUser;
    }
    //---------
    profileScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    profileScroll.backgroundColor=[UIColor clearColor];
    profileScroll.scrollEnabled=YES;
    profileScroll.showsVerticalScrollIndicator=NO;
    profileScroll.bounces=NO;
    [self.view addSubview:profileScroll];
    
    
}

-(void)createUi
{
    //-------
    NSLog(@"User Detail in Profile %@",self.profileUserdetail);
    //PFObject * profileUserdetail=[self.userDetail objectAtIndex:0];
   
    //------
    
    CGFloat  width,heightFirstSection;
    //    height=self.view.bounds.size.height;
    width=self.view.bounds.size.width;
    if(![SingletonClass sharedSingleton].profileForSecondUser)
    {
        heightFirstSection=400;
    }
    else
    {
        heightFirstSection=500;
    }
    self.themeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heightFirstSection)];
    self.themeImageView.userInteractionEnabled=YES;
    self.themeImageView.backgroundColor=[UIColor colorWithRed: 100.0/255.0f green:200.0/255.0f blue:150.0/255.0f alpha:1.0];
    self.themeImageView.image=[UIImage imageNamed:@"wp_1.png"];
    [profileScroll addSubview:self.themeImageView];
    
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.themeImageView.frame.size.width/2-50,100, 80, 80)];
    self.profileImageView.backgroundColor = [UIColor clearColor];
    self.profileImageView.layer.cornerRadius = 40;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 5;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.image= self.imageUser;
    [profileScroll insertSubview:self.profileImageView aboveSubview:self.themeImageView];
    self.profileImageView.userInteractionEnabled=YES;
    tapProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.profileImageView addGestureRecognizer:tapProfile];
    
    UILabel * name=[[UILabel alloc]initWithFrame:CGRectMake(width-240, 180, 150, 30)];
    name.text=[SingletonClass sharedSingleton].strUserName;
    name.font=[UIFont boldSystemFontOfSize:20];
    name.textColor=[UIColor whiteColor];
    name.textAlignment=NSTextAlignmentCenter;
    [self.themeImageView addSubview:name];
   
    UILabel * gradeName=[[UILabel alloc]initWithFrame:CGRectMake(width-245,210, 150, 30)];
    gradeName.text=[SingletonClass sharedSingleton].userRank;
    gradeName.textColor=[UIColor whiteColor];
    gradeName.font=[UIFont boldSystemFontOfSize:15];
    gradeName.textAlignment=NSTextAlignmentCenter;
    [self.themeImageView addSubview:gradeName];

    //-------------profileForSecondUser
    if([SingletonClass sharedSingleton].profileForSecondUser)
    {
    gradeName.text= self.profileUserdetail[@"Rank"];
    name.text=self.profileUserdetail[@"name"];
    chat=[[UIButton alloc]initWithFrame:CGRectMake(20, self.themeImageView.bounds.size.height-240, width/2-40, 40)];
    [chat setBackgroundImage:[UIImage imageNamed:@"chat.png"] forState:UIControlStateNormal];
    [chat setTitle:[ViewController languageSelectedStringForKey:@"Chat"] forState:UIControlStateNormal];
    //[chat.titleLabel setTextAlignment: NSTextAlignmentLeft];
    [chat setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
     chat.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [chat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chat addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
    [profileScroll addSubview:chat];
    //--
    
    challenge=[[UIButton alloc]initWithFrame:CGRectMake(width/2+20, self.themeImageView.bounds.size.height-240, width/2-40, 40)];
       [challenge setBackgroundImage:[UIImage imageNamed:@"challengeProfile.png"] forState:UIControlStateNormal];
    [challenge setTitle:[ViewController languageSelectedStringForKey:@"Challenge"] forState:UIControlStateNormal];
    challenge.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [challenge setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [challenge setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [challenge addTarget:self action:@selector(challengeAction) forControlEvents:UIControlEventTouchUpInside];

        [challenge setEnabled:YES];
    [self.themeImageView addSubview:challenge];
    //--
    unfriend=[[UIButton alloc]initWithFrame:CGRectMake(20, self.themeImageView.bounds.size.height-180, width/2-40, 40)];
        if([self.frndStatus isEqualToString:@"Friend"])
        {
          [unfriend setTitle:[ViewController languageSelectedStringForKey:@"UnFriend"] forState:UIControlStateNormal];
            [unfriend setBackgroundImage:[UIImage imageNamed:@"add_friends.png"] forState:UIControlStateNormal];
            [unfriend addTarget:self action:@selector(unfriend:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
           [unfriend setTitle:[ViewController languageSelectedStringForKey:@"Friend"] forState:UIControlStateNormal];
            [unfriend setBackgroundImage:[UIImage imageNamed:@"unfriend.png"] forState:UIControlStateNormal];
            [unfriend addTarget:self action:@selector(frndRequest) forControlEvents:UIControlEventTouchUpInside];
        }
        if(self.checkFrnReqSend)
        {
            [unfriend setEnabled:NO];
        }
    unfriend.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [unfriend setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [unfriend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.themeImageView addSubview:unfriend];
    //--
    block=[[UIButton alloc]initWithFrame:CGRectMake(width/2+20, self.themeImageView.bounds.size.height-180, width/2-40, 40)];
    [block setTitle:[ViewController languageSelectedStringForKey:@"Block"] forState:UIControlStateNormal];
    block.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [block setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
        [block setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];        [block setBackgroundImage:[UIImage imageNamed:@"block.png"] forState:UIControlStateNormal];
    [block addTarget:self action:@selector(blockBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.themeImageView addSubview:block];
    UILabel * friendNameTag=[[UILabel alloc]initWithFrame:CGRectMake(width/2-60,self.themeImageView.bounds.size.height-120,width/2-40, 40)];
    friendNameTag.text=[ViewController languageSelectedStringForKey:@"Friends"];
    friendNameTag.textAlignment=NSTextAlignmentCenter;
    friendNameTag.textColor=[UIColor whiteColor];
    [self.themeImageView addSubview:friendNameTag];
    UILabel * friendLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/2-60, self.themeImageView.bounds.size.height-60, 120, 40)];
    [friendLabel setBackgroundColor:[UIColor whiteColor]];
    friendLabel.text=[NSString stringWithFormat:@"%d",[self.noOfFriends intValue]];
    friendLabel.textAlignment=NSTextAlignmentCenter;
    friendLabel.font=[UIFont boldSystemFontOfSize:15];
    friendLabel.textColor=[UIColor blackColor];
    [self.themeImageView addSubview:friendLabel];
    }
    //---
    else
    {
        //profile edit Button
        UIButton * profileEdit=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-30, 50, 30, 20)];
        [profileEdit setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
        [profileEdit addTarget:self action:@selector(goToProfile) forControlEvents:UIControlEventTouchUpInside];
        [profileScroll addSubview:profileEdit];
    UILabel * friendNameTag=[[UILabel alloc]initWithFrame:CGRectMake(20,self.themeImageView.bounds.size.height-140,width/2-40, 40)];
    friendNameTag.text=[ViewController languageSelectedStringForKey:@"Friends"];
    friendNameTag.textAlignment=NSTextAlignmentCenter;
    friendNameTag.textColor=[UIColor whiteColor];
        friendNameTag.textAlignment=NSTextAlignmentCenter;
    [self.themeImageView addSubview:friendNameTag];
    
    UILabel * achivementTag=[[UILabel alloc]initWithFrame:CGRectMake(width/2+20, self.themeImageView.bounds.size.height-140,width/2-40,40)];
    achivementTag.text=[ViewController languageSelectedStringForKey:@"Achievements"];
    achivementTag.textAlignment=NSTextAlignmentCenter;
    achivementTag.textColor=[UIColor whiteColor];
    [self.themeImageView addSubview:achivementTag];

    //--
    UIButton * friends=[[UIButton alloc]initWithFrame:CGRectMake(20, self.themeImageView.bounds.size.height-80, width/2-40, 40)];
    [friends setBackgroundColor:[UIColor whiteColor]];
    [friends setTitle:[self friendsCount] forState:UIControlStateNormal];
    friends.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [friends setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [friends addTarget:self action:@selector(friendView:) forControlEvents:UIControlEventTouchUpInside];
    [self.themeImageView addSubview:friends];
    //--

    UIButton * achievments=[[UIButton alloc]initWithFrame:CGRectMake(width/2+20, self.themeImageView.bounds.size.height-80, width/2-40, 40)];
     [achievments setBackgroundColor:[UIColor whiteColor]];
    [achievments setTitle:[self achievementsCount] forState:UIControlStateNormal];
    achievments.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [achievments setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//[achievments addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.themeImageView addSubview:achievments];
   //profileScroll.contentSize = CGSizeMake(self.view.frame.size.width, heightFirstSection+130);
    }
    if(self.checkBlock)
    {
        chat.enabled=NO;
        challenge.enabled=NO;
    }
    else
    {
        
    }
    //===============Total Score UI===============
    if([self.subCategoryName count]>1)
    {
        NSLog(@"frame %f ",self.view.bounds.size.height);
        //profileScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.bounds.size.height+680);
    self.viewTotalScore=[[UIView alloc]initWithFrame:CGRectMake(0,heightFirstSection, self.view.bounds.size.width, 500)];
    self.viewTotalScore.backgroundColor=[UIColor orangeColor];
        
      if([self.totalScorePoints count]>1)
      {
    Rect1 *pieGraph=[[Rect1 alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 500)];
    pieGraph.backgroundColor=[UIColor blackColor];
    pieGraph.winGainStatus=[NSArray arrayWithObjects:[NSNumber numberWithFloat:win] ,[NSNumber numberWithFloat:draw],[NSNumber numberWithFloat:loose], nil];
    pieGraph.flagProfile=FALSE;
        if(self.totalScorePoints)
        {
            pieGraph.totalScore=self.totalScorePoints;
            pieGraph.totalScoreOfAllPoints=[NSNumber numberWithFloat:totalScore];
 
        }
    pieGraph.subcategoryId=self.subCategoryId;
    pieGraph.subcategoryName=self.subCategoryName;
    [self.viewTotalScore addSubview:pieGraph];
      }
    [profileScroll addSubview:self.viewTotalScore];
    }
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in profileScroll.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [profileScroll setContentSize:(CGSizeMake(320, scrollViewHeight+20))];
   /* CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in profileScroll.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [profileScroll setContentSize:(CGSizeMake(320, scrollViewHeight))];*/
}
-(void)friendView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)goToProfile
{
   
        self.settingVC = [[SettingsViewController alloc]init];
        self.settingVC.profile=YES;
        [self.navigationController pushViewController:self.settingVC animated:YES];
    
}
#pragma mark Action of Profile Buttons
-(void)chatAction:(id)sender
{
    /*ChatScreenUi * chat=[[ChatScreenUi alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:chat];*/
//    //chat screen Sukhmeet final
    [chat setEnabled:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Profile_Message_First"];
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"AddChatScreen" object:nil];
  gotoChat=[[ChatScreenMessageViewController alloc]init];
    // [self returnDialogIdOfTapUser:dialogs];
    gotoChat.opponenetImage=self.imageUser;
    if(self.profileUserdetail[@"Quickbloxid"])
    {
         gotoChat.reciepentId=self.profileUserdetail[@"Quickbloxid"];
    }
    else
    {
         gotoChat.reciepentId=self.quickBloxId;
    }
   
    gotoChat.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    gotoChat.previousView=@"Ranking";
    [self.navigationController pushViewController:gotoChat animated:YES];
    //    //[self presentViewController:gotoChat animated:YES completion:nil];
//   // [self chatLogin];
}
-(void)checkBlockAction
{
    
    
}
-(void)blockBtnAction:(id)sender
{
    PFObject *profileObj=[[SingletonClass sharedSingleton].userDetailinParse objectAtIndex:0];
    NSMutableArray *blockUser=[[NSMutableArray alloc]init];
    blockUser=profileObj[@"BlockUser"];
    NSString *objectId=[self.profileUserdetail objectId];
    if (self.checkBlock)
    {
         [blockUser removeObject:objectId];
        [block setTitle:@"Block" forState:UIControlStateNormal];
        self.checkBlock=FALSE;
    }
    else
    {
        [blockUser addObject:objectId];
        [block setTitle:@"Unblock" forState:UIControlStateNormal];
         self.checkBlock=TRUE;
    }
    
    PFQuery *query=[PFQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[SingletonClass sharedSingleton].objectId block:^(PFObject *obj,NSError *error)
     {
         obj[@"BlockUser"]=blockUser;
         [obj saveInBackgroundWithBlock:^(BOOL suceed,NSError *error)
          {
              if (suceed) {
                  NSLog(@"Data Saved");
                  [SingletonClass sharedSingleton].userBlockList=blockUser;
                  
              }
              else
              {
                  NSLog(@"Error==%@",error);
              }
          }];
         
     }];
    
}
#pragma mark QBChat-----------
-(void)chatLogin
{
    if([[QBChat instance] isLoggedIn])
    {
        [self retriveDialogs];
    }
    else
    {
    QBUUser *currentUser = [QBUUser user];
    // NSLog(@"%d",[[SingletonClass sharedSingleton].quickBloxId intValue]);
    currentUser.ID =[[SingletonClass sharedSingleton].quickBloxId intValue]; // your current user's ID
    currentUser.password =@"globussoft123"; // your current user's password
    
    // set Chat delegate
    [QBChat instance].delegate = self;
    // login to Chat
    [[QBChat instance] loginWithUser:currentUser];
    }
}
#pragma mark -
#pragma mark QBChatDelegate

// Chat delegate
-(void) chatDidLogin{
    [self retriveDialogs];
    // You have successfully signed in to QuickBlox Chat
    //[self sendMessage];
}
-(void)retriveDialogs
{
    NSMutableDictionary *extendedRequest = [NSMutableDictionary new];
    extendedRequest[@"limit"] = @(100);
    [QBChat dialogsWithExtendedRequest:extendedRequest delegate:self];
}
#pragma mark -
#pragma mark QBActionStatusDelegate

- (void)completedWithResult:(Result *)result
{
    NSLog(@"result of dialogs %@ success%d",result.errors,result.success);
    if (result.success && [result isKindOfClass:[QBDialogsPagedResult class]])
    {
        QBDialogsPagedResult *pagedResult = (QBDialogsPagedResult *)result;
        NSArray *dialogs = pagedResult.dialogs;
        NSLog(@"Dialogs: %@", dialogs);
        
        //--
        for(int i=0;i<[dialogs count];i++)
        {
            
            QBChatDialog * dialog=[dialogs objectAtIndex:i];
            NSLog(@"dialog id %@",dialog);
            if( dialog.recipientID==[self.profileUserdetail[@"Quickbloxid"] integerValue])
            {
                gotoChat.dialogId=dialog.ID;
               // gotoChat.reciepentId=[NSString stringWithFormat:@"%ld",(unsigned long)dialog.recipientID];
            }
        }
        
      // AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
        //[appdelegate.window addSubview:gotoChat.view];
       
       // [self.navigationController pushViewController:gotoChat animated:YES];
    }
}
-(NSString*)returnDialogIdOfTapUser:(NSArray*)dialogId
{

        return nil;
}

#pragma mark=====
#pragma mark custom delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}
#pragma mark Parse Code For Pie
-(void)fetchData
{
     NSLog(@"User Detail in Profile %@",self.profileUserdetail);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"object id in profile %@",self.profileUserdetail.objectId);

    PFQuery * query=[PFQuery queryWithClassName:@"GameResult"];
        if(![SingletonClass sharedSingleton].profileForSecondUser)
        {
        [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
        }
        else
        {
            if(self.profileUserdetail[@"UserId"])
            {
            [query whereKey:@"UserId" equalTo:self.profileUserdetail[@"UserId"]];
            }
            else
            {
              [query whereKey:@"UserId" equalTo:self.profileUserdetail.objectId];
            }
        }
        
   [query selectKeys:@[@"winnerstatus"]];
    NSArray * temp=[query findObjects];
    NSLog(@"Profile status of win %@",temp);
    
    for(int i=0;i<[temp count];i++)
    {  int status;
        PFObject * obj=[temp objectAtIndex:i];
        if(obj[@"winnerstatus"])
        {
           status= [obj[@"winnerstatus"] intValue];
        }
      
        if(status==0)
        {
            win++;
        }
        else if (status==1)
        {
            loose++;
        }
        else if (status==2)
        {
            draw++;
        }
        
    }
    win=win/[temp count]*100;
    loose=loose/[temp count]*100;
    draw=draw/[temp count]*100;
    NSLog(@"Winnin %f loose %f draw %f",win,loose,draw);
        //------------------------------Total Score Query-----------
        
        //-----------------
               //----------------
        
        
        query=[PFQuery queryWithClassName:@"UserGrade"];
        if(![SingletonClass sharedSingleton].profileForSecondUser)
        {
            [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
        }
        else
        {
            if(self.profileUserdetail[@"UserId"])
            {
                [query whereKey:@"UserId" equalTo:self.profileUserdetail[@"UserId"]];
            }
            else
            {
                [query whereKey:@"UserId" equalTo:self.profileUserdetail.objectId];
            }
        }

        [query orderByAscending:@"gradepoints"];
        temp=[query findObjects];
        int total=0;
        
        for(int i=0;i<[temp count];i++)
        {
            PFObject * obj=[temp objectAtIndex:i];
            int val=[self progress:[obj[@"gradepoints"]intValue]];
            //[self.totalScorePoints addObject:[NSNumber numberWithFloat:val]];
            
            NSLog(@"Sub category name%@ & Id profile%@",self.subCategoryId,self.subCategoryName);
            NSLog(@"value %d",val);
            total=val+total;
            if(i<=4)
            {
                [self.subCategoryName addObject:obj[@"SubcategoryName"]];
                [self.subCategoryId addObject:obj[@"CategoryId"]];
                [self.totalScorePoints addObject:[NSNumber numberWithInt:val]];
            }
            
        }
        [self.subCategoryName addObject:@"Other"];
        [self.subCategoryId addObject:@"555"];
        [self.totalScorePoints addObject:[NSNumber numberWithFloat:total]];

        totalScore=total;
        NSLog(@"Data for Total Score%@ %d",self.totalScorePoints,total);
        //-----------------------
        
        dispatch_async(dispatch_get_main_queue(),^(void) {
            [imageVAnim stopAnimating];
            [self createUi];
        });

        
    });
}
-(float)progress:(NSInteger)points {
    
    float gradePoint=0;
    if(points<=811)
    {
        return gradePoint=1;
    }
    if(points>=811&&points<=1220)
    {
        return gradePoint=2;
    }
    else if (points>=1221&&points<=1700)
    {
        return gradePoint=3;
    }
    else if (points>=1701&&points<=2250)
    {
        return gradePoint=4;
    }
    else if (points>=2250&&points<=2870)
    {
        return gradePoint=5;
    }
    else if(points>=2871&&points<=3560)
    {
        return gradePoint=6;
    }
    else if(points>=3561&&points<=5150)
    {
        return gradePoint=7;
    }
       else if(points>=5151&&points<=7020)
        {
            return gradePoint=7;
        }
        else if (points>=7021&&points<=9170)
        {
            return gradePoint=8;
        }
        else if (points>=9170&&points<=15770)
        {
            return gradePoint=9;
        }
        
   
    else if(points>=5151&&points<=7020)
        {
            return gradePoint=10;
        }
        else if (points>=7021&&points<=9170)
        {
            return gradePoint=11;
        }
        else if (points>=9170&&points<=15770)
        {
            return gradePoint=12;
        }
        
   
     else if(points>=15771&&points<=24120)
        {
            return gradePoint=13;
        }
        else if (points>=24121&&points<=34220)
        {
            return gradePoint=14;
        }
        else if (points>=34221&&points<=59670)
        {
            return gradePoint=15;
        }
        
  
     else         if(points>=59671&&points<=92120)
        {
            return gradePoint=16;
        }
        else if (points>=92121&&points<=131570)
        {
            return gradePoint=17;
        }
        else if (points>=131571&&points<=178020)
        {
            return gradePoint=18;
        }
        else if (points>=131571&&points<=178020)
        {
            return gradePoint=19;
        }
        else if (points>=178021&&points<=359370)
        {
            return gradePoint=20;
        }
        
   
     else if(points>=359371&&points<=801620)
        {
            return gradePoint=21;
        }
   
 else if(points>=801621&&points<=1418870)
        {
            return gradePoint=22;
        }
  
     else  if(points>=1418771)
        {
            return gradePoint=23;
        }
  
    
    return 0;
}
#pragma mark Calculate Friends and Achievements
-(NSString *)friendsCount
{
    NSString *strFriendCount;
    if ([SingletonClass sharedSingleton].profileForSecondUser)
    {
        NSArray *arr=self.profileUserdetail[@"Friends"];
        NSLog(@"Arr=%lu",(unsigned long)[arr count]);
        strFriendCount=[NSString stringWithFormat:@"%lu",(unsigned long)[arr count]];
        NSLog( @"Number of Friends=%@",strFriendCount);
    }
    else
    {
        PFObject *obj=[[SingletonClass sharedSingleton].userDetailinParse objectAtIndex:0];
        NSArray *arr=obj[@"Friends"];
        NSLog(@"Arr=%lu",(unsigned long)[arr count]);
        strFriendCount=[NSString stringWithFormat:@"%lu",(unsigned long)[arr count]];
        NSLog( @"Number of Friends=%@",strFriendCount);
        
    }
    return strFriendCount;
}
-(NSString *)achievementsCount
{
    
    
    PFObject *obj=[[SingletonClass sharedSingleton].userDetailinParse objectAtIndex:0];
    NSNumber *xpValue=obj[@"TotalXP"];
    
    int xp=[xpValue intValue];
    if (xp<810) {
        return @"0";
    }
    else if (xp>=811 && xp<=5150)
    {
        return @"1";
    }
    else if(xp>=5151 && xp<=15770)
    {
        return @"2";
    }
    else if (xp>=15771 && xp<=59670)
    {
        return @"3";
    }
    else if (xp>=59671 && xp<=359370 )
    {
        return @"4";
    }
    else if (xp>=359371 && xp<=801620)
    {
        return @"5";
    }
    else if (xp>=801621 && xp<=1418870)
    {
        return @"6";
    }
    else if (xp>=1418871)
    {
        return @"7";
    }
    
    else
    {
        return @"";
    }
}
-(void)frndRequest
{
    [unfriend setEnabled:NO];
    PFObject *obj=[PFObject objectWithClassName:@"FriendRequest"];
    obj[@"UserIdPointer"]=[PFUser objectWithoutDataWithObjectId:[SingletonClass sharedSingleton].objectId];
    NSLog(@"User Id in==%@",obj[@"UserIdPointer"]);
    obj[@"FriendStatus"]=@NO;
    obj[@"FriendId"]=self.profileUserdetail[@"UserId"];
    NSLog(@"Friend Id in==%@",obj[@"FriendId"]);
    [obj saveInBackgroundWithBlock:^(BOOL suceed,NSError *error)
     {
         if (suceed) {
             NSLog(@"Sucessfully Saved In Friend Request Class");
         }
         else
         {
             NSLog(@"Error==%@",error);
         }
     }];

}
-(void)unfriend:(id)sender
{
    [unfriend setEnabled:NO];
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            

    PFQuery * unfriendQuery=[PFQuery queryWithClassName:@"_User"];
            [unfriendQuery whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].objectId];
    [unfriendQuery selectKeys:@[@"Friends"]];
    NSArray * arr=[unfriendQuery findObjects];
    PFObject * unfriendObj=[arr objectAtIndex:0];
    NSMutableArray * frndArray=[[NSMutableArray alloc]initWithArray:unfriendObj[@"Friends"]];
    NSLog(@"friend detail %@",frndArray);
            for (int i=0; i<[frndArray count]; i++)
            {
                if([[frndArray objectAtIndex:i] isEqualToString:self.profileUserdetail.objectId])
                {
                    [frndArray removeObjectAtIndex:i];
                    
                }
            }
            unfriendObj[@"Friends"]=frndArray;
            [unfriendObj save];
        }
        //===================
        
        NSLog(@"profile userDetail %@",self.profileUserdetail);
        
        [PFCloud callFunctionInBackground:@"UnFriend"
                           withParameters:@{@"id":[SingletonClass sharedSingleton].objectId,@"username":self.profileUserdetail[@"username"]}
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

        
        
        
    });
    
}
-(void)challengeAction
{
    if(self.profileUserdetail[@"UserId"])
    {
        [SingletonClass sharedSingleton].secondPlayerObjid=self.profileUserdetail[@"UserId"];
    }
    else
    {
        [SingletonClass sharedSingleton].secondPlayerObjid=self.profileUserdetail.objectId;
        
    }

    ChooseTopics * chTopics=[[ChooseTopics alloc]init];
    [self.navigationController pushViewController:chTopics animated:YES];
}
-(void)magnifyingUi
{
    showProfileImageMagnifying=[[UIView alloc]init];
    showProfileImageMagnifying.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    showProfileImageMagnifying.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:showProfileImageMagnifying];
    tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [showProfileImageMagnifying addGestureRecognizer:tapView];
    self.view.userInteractionEnabled=YES;
    UIImageView *profileL=[[UIImageView alloc]init];
    profileL.frame=CGRectMake(self.view.frame.size.width/2-75,self.view.frame.size.height/2-75, 150, 150);
    profileL.layer.cornerRadius=75;
    profileL.clipsToBounds=YES;
    profileL.image=self.imageUser;
    [showProfileImageMagnifying addSubview:profileL];
    
}
-(void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if(tapGesture==tapProfile)
    {
        [self magnifyingUi];
    }
    else if (tapGesture==tapView)
    {
        [showProfileImageMagnifying removeFromSuperview];
    }
    
}

-(void)dealloc
{
    
    
}/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
