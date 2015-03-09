    //
//  QuizBattleViewController.m
//  QuizBattle
//
//  Created by Sumit Ghosh on 11/09/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "QuizBattleViewController.h"
#import "GameViewControllerChallenge.h"
#import "ChooseTopics.h"
#import "AppDelegate.h"
#import "GameViewController.h"
#import "ProfileViewController.h"
#import "FriendsViewController.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>

@interface QuizBattleViewController ()

@end

@implementation QuizBattleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if([self.previousView isEqualToString:@"Challenge"])
    {
        
    }
    else
    {
      [self fetchFriends];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
   
}
-(void)viewDidDisappear:(BOOL)animated
{
    [SingletonClass sharedSingleton].pickFriendsChallenge=false;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Dummy Challenge Request UI
    //=====================
    friendsImage=[[NSMutableArray alloc]init];
    searchImage=[[NSMutableArray alloc]init];
    
    //======================
    dictForChallenege = [[NSMutableDictionary alloc]init];
    self.mutDict=[[NSMutableDictionary alloc]init];
    addfrndobjId=[[NSMutableArray alloc]init];
    addfrndinstltionId=[[NSMutableArray alloc]init];
    checkSearch=FALSE;
    
    [NSThread detachNewThreadSelector:@selector(uiForChallengeGame) toTarget:self withObject:nil];
    if([self.previousView isEqualToString:@"Challenge"])
    {
         [self fetchFriends];
    }
    
    //====================================================
    //=============
    [self createTableQuizFriend];
    [self noQuizFriendsUI];
    
     self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    PFObject *frndObj=[[SingletonClass sharedSingleton].userDetailinParse objectAtIndex:0];
    NSLog(@"Friends==%@",frndObj[@"Friends"]);
    if (frndObj[@"Friends"])
    {
        
     //   [self fetchFriends];
    }
    else
    {
        //[self noQuizFriendsUI];
    }
    
}
-(void)createTableQuizFriend
{
   
   if(!quizFriends)
   {
    quizFriends=[[UITableView alloc]initWithFrame:CGRectMake(20,10, self.view.frame.size.width-40, self.view.frame.size.height-160) style:UITableViewStyleGrouped];
    quizFriends.delegate=self;
    quizFriends.dataSource=self;
    quizFriends.backgroundColor=[UIColor clearColor];
    quizFriends.bounces=NO;
    quizFriends.showsVerticalScrollIndicator=NO;
    quizFriends.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:quizFriends];
       UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,quizFriends.frame.size.width,20)];
       quizFriends.tableFooterView=footerView;
    searchQuizFriends=[[UISearchBar alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-160, 44)];
    searchQuizFriends.placeholder=@"수색 친구";
    searchQuizFriends.delegate=self;
    searchQuizFriends.showsCancelButton=NO;
    UIView * tableHeader=[[UIView alloc]initWithFrame:CGRectMake(0,0,quizFriends.frame.size.width,40)];
    quizFriends.tableHeaderView=tableHeader;
    UIImageView * searchImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon.png"]];
    searchImageView.frame=CGRectMake(0, 0, 20, 20);
    searchImageView.contentMode=UIViewContentModeCenter;
    UITextField * searchTextField=[[UITextField alloc]initWithFrame:CGRectMake(2, 10,quizFriends.frame.size.width-4,30)];
    searchTextField.placeholder=@"찾기";
    searchTextField.layer.borderColor=[UIColor whiteColor].CGColor;
    searchTextField.layer.borderWidth=2;
    searchTextField.layer.cornerRadius=5;
    searchTextField.backgroundColor=[UIColor whiteColor];
    searchTextField.delegate=self;
    searchTextField.leftView=searchImageView;
    [searchTextField setLeftViewMode:UITextFieldViewModeAlways];
    [tableHeader addSubview:searchTextField];
   // self.quizFriends.tableHeaderView=searchQuizFriends;
    quizFriends.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
   }
    
}
-(void)uiForChallengeGame {
    
    NSLog(@"User ID for challenge =-=- %@",[SingletonClass sharedSingleton].objectId);
    
    PFQuery *query = [PFQuery queryWithClassName:@"ChallengeRequest"];
    
    [query whereKey:@"Player2Id" equalTo:[SingletonClass sharedSingleton].objectId];
    [query whereKey:@"Status" equalTo:@NO];
    
    NSArray *arrObjects1 = [query findObjects];
    NSLog(@"Final Objects Quiz Battle VC-=-= %@",arrObjects1);

    for (int i=0; i<[arrObjects1 count]; i++) {
        
        NSDictionary *dict = [arrObjects1 objectAtIndex:i];
        
        NSString *player1Id = [dict objectForKey:@"Player1Id"];
        
        NSArray *player1Ans = [dict objectForKey:@"Player1Answer"];
        
        NSArray *player1Scores = [dict objectForKey:@"Player1Scores"];
        NSArray *arrQuesIds = [dict objectForKey:@"QuestionId"];
        
        [dictForChallenege setObject:arrQuesIds forKey:@"questionsChall"];
        [dictForChallenege setObject:player1Scores forKey:@"scores"];
        [dictForChallenege setObject:player1Ans forKey:@"player1ans"];
        NSLog(@"Player 1 Id -=- %@ \n ,Palyer1 Answers =-=- %@, Scores =-=%@ \n, Ques ID -==-= %@ ",player1Id,player1Ans,player1Scores,arrQuesIds);
        [SingletonClass sharedSingleton].secondPlayerObjid=player1Id;
    }
//    [NSThread detachNewThreadSelector:@selector(fetchUserNameAndImage) toTarget:self withObject:nil];
}
-(void)noQuizFriendsUI
{
      if(!lblHeading)
    {
         lblHeading=[[UILabel alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2-30, self.view.frame.size.width-40,50)];
    }
   
    lblHeading.textColor=[UIColor blackColor];
    lblHeading.text=@"현재 친구가 없습니다";//[ViewController languageSelectedStringForKey:@"No Friends To Display"];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.hidden=YES;
    lblHeading.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:lblHeading];
    
    if(!labelDesc)
    {
         labelDesc=[[UILabel alloc]initWithFrame:CGRectMake(0,lblHeading.frame.origin.y+10,self.view.frame.size.width, 100)];
    }
   
    labelDesc.text=[ViewController languageSelectedStringForKey:@"Find your Quiz Battle Friends \n Its Fun to Compete With Friends"];
    labelDesc.numberOfLines=2;
    labelDesc.lineBreakMode=NSLineBreakByWordWrapping;
    labelDesc.hidden=YES;
    labelDesc.textAlignment=NSTextAlignmentCenter;
    labelDesc.font=[UIFont boldSystemFontOfSize:16];
    labelDesc.textColor=[UIColor blackColor];
    //[self.view addSubview:labelDesc];
    
    if(!imgView)
    {
    imgView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-56,self.view.frame.size.height/2.0-130, 112,85)];
    }
    imgView.image=[UIImage imageNamed:@"no_friend"];
    imgView.hidden=YES;
    [self.view addSubview:imgView];
    
    
}

#pragma mark Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (checkSearch)
    {
        lblHeading.hidden=YES;
        imgView.hidden=YES;
        labelDesc.hidden=YES;
    return [searchResults count];
    }
    else if([quzfrndDetails count]>0)
    {
        lblHeading.hidden=YES;
        imgView.hidden=YES;
        labelDesc.hidden=YES;
    return [quzfrndDetails count];
    }
    else
    {
        lblHeading.hidden=NO;
        imgView.hidden=NO;
        labelDesc.hidden=NO;
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuizBattle Cell";
    
    MessageCustomCell *cell = [quizFriends dequeueReusableCellWithIdentifier:CellIdentifier];
    /////----------------
    if (cell==nil)
        
    {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (checkSearch)
    {
        PFObject *srchobj=[searchResults objectAtIndex:indexPath.row];
        //---------------------------------------
        NSString *message=srchobj[@"name"];
        NSLog(@"Search Name is==%@",message);
        NSString *grade=srchobj[@"Rank"];
        NSLog(@"Search Grade is==%@",grade);
        NSString *objectId=[srchobj objectId];
        NSLog(@"Objecct Id==%@",objectId);
        //[addfrndobjId addObject:objectId];
        NSString *instltnId=srchobj[@"deviceID"];
        NSLog(@"Installation Id==%@",instltnId);
        //[addfrndinstltionId addObject:instltnId];
        //----------------------------------------
         cell.challengeFriendButton.hidden=YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.contentView.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
         cell.topView.frame =CGRectMake(0, 0, 280, 50);
        cell.messageLable.frame = CGRectMake(50, 5, 200, 20);
        cell.messageLable.text=message;
        cell.lblDescription.frame = CGRectMake(50, 25, 200, 20);
        cell.lblDescription.text=grade;
        cell.addFriendButton.hidden=NO;
        cell.iconImg.image=[searchImage objectAtIndex:indexPath.row];
        cell.iconImg.userInteractionEnabled=YES;
        cell.iconImg.tag=indexPath.row;
        UITapGestureRecognizer *tapWall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [cell.iconImg addGestureRecognizer:tapWall];
        if([objectId isEqualToString:[SingletonClass sharedSingleton].objectId])
        {
            cell.addFriendButton.enabled=NO;
            cell.addFriendButton.tag=301;
        }
        else
        {
        cell.addFriendButton.tag=indexPath.row;
        }
        [cell.addFriendButton addTarget:self action:@selector(addButnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else
    {
        PFObject *bttlefrndObject=[quzfrndDetails objectAtIndex:indexPath.row];
        NSString *message=bttlefrndObject[@"name"];
        NSString *gradeMsg=bttlefrndObject[@"Rank"];
        ///------------------
         cell.topView.frame =CGRectMake(0, 0, 280, 50);
        cell.gameDelegate=self;
        cell.messageLable.frame = CGRectMake(50, 5, 250, 20);
        cell.messageLable.text=message;
        cell.iconImg.image=[friendsImage objectAtIndex:indexPath.row];
        cell.iconImg.userInteractionEnabled=YES;
        cell.iconImg.tag=indexPath.row;
        UITapGestureRecognizer *tapWall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [cell.iconImg addGestureRecognizer:tapWall];
        //-----------
                //-------------
        [cell.challengeFriendButton addTarget:self action:@selector(challengeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.challengeFriendButton.tag=indexPath.row;
        [cell.contentView addSubview:cell.challengeFriendButton];
        if([quzfrndDetails count]>0)
        {
           
        }
        cell.addFriendButton.hidden=YES;
        cell.challengeFriendButton.hidden=NO;
        cell.lblDescription.frame = CGRectMake(50, 25, 200, 20);
        cell.lblDescription.text=gradeMsg;
    }
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
        return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.frame.size.width, 60)];
        UILabel *headerLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, headerview.frame.size.width, 40)];
        headerLabel.textColor=[UIColor darkGrayColor];
            headerLabel.font=[UIFont boldSystemFontOfSize:18];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        headerLabel.text=[ViewController languageSelectedStringForKey:@"QUIZ BATTLE FRIENDS"];
        if (section==0)
        {
            [headerview addSubview:headerLabel];
        }
        return headerview;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSLog(@"search Result %@",[searchResults objectAtIndex:indexPath.row]);
        NSLog(@"Friend already %@",[quzfrndDetails objectAtIndex:indexPath.row]);
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }
       
}
#pragma mark -Challenge Button Action
-(void)challengeBtnAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"Tag Value = %ld",(long)button.tag);
    PFObject * objOppDetail=[quzfrndDetails objectAtIndex:button.tag];
    [SingletonClass sharedSingleton].secondPlayerObjid=[objOppDetail objectId];
   [SingletonClass sharedSingleton].secondPlayerInstallationId=objOppDetail[@"deviceID"];
    NSLog(@"Secon player id %@ %ld",[objOppDetail objectId],(long)button.tag);
    if([SingletonClass sharedSingleton].pickFriendsChallenge)
    {
        [self categoryAlreadyPickedPlayChallenge:nil];
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Firends_First"];
        ChooseTopics * chTopics=[[ChooseTopics alloc]init];
        [self.navigationController pushViewController:chTopics animated:YES];
    }

}

-(void)categoryAlreadyPickedPlayChallenge:(id)sender
{
    //Boolean set----
    [SingletonClass sharedSingleton].mainPlayerChallenge=TRUE;
    [self fetchApponentDetailChallenge];
    //=====================
     [[NSNotificationCenter defaultCenter] removeObserver:self.friendObj name:KDismissView object:nil];
    width=self.view.bounds.size.width;
    height=self.view.bounds.size.height;
}
-(void)challengeScreenUi
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    topViewChallenge=[[UIView alloc]initWithFrame:appdelegate.window.frame];
    topViewChallenge.backgroundColor=[UIColor whiteColor];
    [appdelegate.window addSubview:topViewChallenge];
    profileImgView=[[UIImageView alloc]initWithFrame:CGRectMake(width-90, 80, 80  , 80)];
    profileImgView.layer.cornerRadius=40;
    profileImgView.layer.borderWidth=2.0f;
    profileImgView.layer.borderColor=[UIColor redColor].CGColor;
    profileImgView.layer.masksToBounds=YES;
    profileImgView.backgroundColor=[UIColor yellowColor];
    profileImgView.image=[SingletonClass sharedSingleton].imageUser;
    [topViewChallenge addSubview:profileImgView];
    
    UILabel * playerName=[[UILabel alloc]initWithFrame:CGRectMake(10,95,210,20)];
    playerName.textAlignment=NSTextAlignmentRight;
    playerName.text=[SingletonClass sharedSingleton].strUserName;
    playerName.textColor=[UIColor blackColor];
    [topViewChallenge addSubview:playerName];
    
    UILabel * gradeName=[[UILabel alloc]initWithFrame:CGRectMake(width-160,125,100, 20)];
    gradeName.textColor=[UIColor blackColor];
    gradeName.text=[SingletonClass sharedSingleton].userRank;
    [topViewChallenge addSubview:gradeName];
    
    UILabel * countryName=[[UILabel alloc]initWithFrame:CGRectMake(60, 150, 120, 60)];
    countryName.numberOfLines=0;
    countryName.text=[NSString stringWithFormat:@"에서 재생\n%@",[SingletonClass sharedSingleton].strCountry];
    countryName.textColor=[UIColor blackColor];
    [topViewChallenge addSubview:countryName];
    
    startGame=[[UIButton alloc]initWithFrame:CGRectMake(width/2-50,410, 100, 30)];
    [startGame setTitle:@"싱글게임" forState:UIControlStateNormal];
    [startGame setTitleColor:[UIColor colorWithRed:101.0f/255.0f green:178.0f/255.0f blue:215.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [startGame addTarget:self action:@selector(challengeStartGameAction:) forControlEvents:UIControlEventTouchUpInside];
    startGame.hidden=TRUE;
    startGame.backgroundColor=[UIColor whiteColor];
    startGame.layer.borderWidth=1;
    startGame.layer.borderColor=[UIColor greenColor].CGColor;
    startGame.layer.cornerRadius=5;
    [topViewChallenge addSubview:startGame];
    description=[[UILabel alloc]initWithFrame:CGRectMake(0, height+22, width, 40)];
    description.numberOfLines=0;
    description.text=@"상대방이 도전을 받을것인지 묻고 있습니다";
    description.textAlignment=NSTextAlignmentCenter;
    description.textColor=[UIColor blackColor];
    description.font=[UIFont boldSystemFontOfSize:15];
    [topViewChallenge addSubview:description];
    imgViewMobile=[[UIImageView alloc]initWithFrame:CGRectMake(140,280, 50, 100)];
    imgViewMobile.backgroundColor=[UIColor clearColor];
    imgViewMobile.image=[UIImage imageNamed:@"mobileImg.png"];
    [topViewChallenge addSubview:imgViewMobile];
  
}
-(void)cancelBtnAction:(id)sender
{
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
}
#pragma mark AddTapGesture
-(void) handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Friends_ProfileImage"];
    [SingletonClass sharedSingleton].profileForSecondUser=TRUE;
    NSLog(@"Tag value of image view %ld",(long)tapGesture.view.tag);
    ProfileViewController * profileUser=[[ProfileViewController alloc]init];
    NSLog(@"Data sent to Profile %@",[quzfrndDetails objectAtIndex:(long)tapGesture.view.tag]);
    profileUser.profileUserdetail=[quzfrndDetails objectAtIndex:(long)tapGesture.view.tag];
    profileUser.imageUser=[friendsImage objectAtIndex:(long)tapGesture.view.tag];
    PFObject * objBlock=[quzfrndDetails objectAtIndex:(long)tapGesture.view.tag];
    
    if([objBlock[@"BlockUser"] containsObject:[SingletonClass sharedSingleton].objectId])
    {
        profileUser.checkBlock=TRUE;
    }
    profileUser.frndStatus=@"Friend";
   // [self presentViewController:profileUser animated:YES completion:nil];
    FriendsViewController *frnd=(FriendsViewController*)self.friendObj;
    [frnd.navigationController pushViewController:profileUser animated:YES];
 //   [self.navigationController pushViewController:profileUser animated:YES];
    
}
-(void)gameDetailsForChallenge:(NSDictionary*)details
{
    [topViewChallenge removeFromSuperview];
    GameViewControllerChallenge *objGameChallenge = [[GameViewControllerChallenge alloc] init];
    objGameChallenge.arrPlayerDetail=details;
    objGameChallenge.challengeReqObjId=challengeReqObjId;
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [SingletonClass sharedSingleton].gameFromView=true;
    [appdelegate.window setRootViewController:objGameChallenge];
}
-(void)startGamePressedOfChallenge:(id) sender
{
    GameViewControllerChallenge *objGameChallenge = [[GameViewControllerChallenge alloc] init];
    objGameChallenge.arrPlayerDetail=dictForChallenege;
    objGameChallenge.challengeReqObjId=challengeReqObjId;
   [SingletonClass sharedSingleton].singleGameChallengedPlayer=YES;
      //  AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [SingletonClass sharedSingleton].gameFromView=true;
    [self presentViewController:objGameChallenge animated:YES completion:nil];
}

#pragma mark===============================
#pragma mark Challenge UI and methods
#pragma mark===============================

-(void)challengeStartGameAction :(id)sender
{
    self.startButtonChallenge=TRUE;
    if([SingletonClass sharedSingleton].roomId)
    {
        [[WarpClient getInstance]leaveRoom:[SingletonClass sharedSingleton].roomId
         ];
        [[WarpClient getInstance]deleteRoom:[SingletonClass sharedSingleton].roomId];
        
    }
    [self animationRocket];
    
    dispatch_async(dispatch_get_main_queue(),^(void) {
        
        [self performSelector:@selector(loadOponnentPlayerInChallenge) withObject:nil afterDelay:4];
    });
}
-(void)loadOponnentPlayerInChallenge
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    cancel.hidden=TRUE;
    startGame.hidden=TRUE;
    [imageVAnim stopAnimating];
    UIImageView *imageVsecPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, appdelegate.window.bounds.size.width,appdelegate.window.bounds.size.height-250)];
    imageVsecPlayer.backgroundColor=[UIColor whiteColor];
    [topViewChallenge addSubview:imageVsecPlayer];
    
    UIImageView *profileImgSecPlayer=[[UIImageView alloc]initWithFrame:CGRectMake(20, appdelegate.window.bounds.size.height-180, 80, 80)];
    profileImgSecPlayer.layer.cornerRadius=40;
    profileImgSecPlayer.layer.borderWidth=2.0f;
    profileImgSecPlayer.layer.borderColor=[UIColor redColor].CGColor;
    profileImgSecPlayer.layer.masksToBounds=YES;
    profileImgSecPlayer.backgroundColor=[UIColor yellowColor];
    profileImgSecPlayer.image=[SingletonClass sharedSingleton].imageSecondPlayer;
    [topViewChallenge addSubview:profileImgSecPlayer];
    
    UILabel * playerName=[[UILabel alloc]initWithFrame:CGRectMake(105,appdelegate.window.bounds.size.height-170,210,20)];
    playerName.textAlignment=NSTextAlignmentLeft;
    playerName.text=[SingletonClass sharedSingleton].strSecPlayerName;
    playerName.textColor=[UIColor blackColor];
    [topViewChallenge addSubview:playerName];
    
    UILabel * gradeName=[[UILabel alloc]initWithFrame:CGRectMake(105,appdelegate.window.bounds.size.height-140,100, 20)];
    gradeName.text=[SingletonClass sharedSingleton].strSecPlayerRank;
    gradeName.textColor=[UIColor blackColor];
    [topViewChallenge addSubview:gradeName];
    
    UILabel * countryName=[[UILabel alloc]initWithFrame:CGRectMake(160,appdelegate.window.bounds.size.height-100, 120, 60)];
    countryName.numberOfLines=0;
    countryName.text=[NSString stringWithFormat:@"에서 재생\n%@",[SingletonClass sharedSingleton].strCountry];;
    countryName.textColor=[UIColor blackColor];
    [topViewChallenge addSubview:countryName];
    
    [self performSelector:@selector(startGamePressedOfChallenge:) withObject:[SingletonClass sharedSingleton].strQuestionsId afterDelay:2];
    
}

-(void)fetchApponentDetailChallenge
{

    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            PFQuery *query = [PFUser query];
            [query whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].secondPlayerObjid];
            NSArray *arrObjectsChallenge = [query findObjects];
            [SingletonClass sharedSingleton].secondPLayerDetail=arrObjectsChallenge;
            NSLog(@"Array object Challenge Details -==- %@",arrObjectsChallenge);
            [self.mutDict setObject:arrObjectsChallenge forKey:@"oponentPlayerDetail"];
            NSDictionary *dict = [arrObjectsChallenge objectAtIndex:0];
            NSString *strName = [dict objectForKey:@"name"];
            [SingletonClass sharedSingleton].strSecPlayerName = strName;
            NSString *rank = [dict objectForKey:@"Rank"];
            [SingletonClass sharedSingleton].strSecPlayerRank=rank;
            NSString *strInstallationId = [dict objectForKey:@"deviceID"];
            [SingletonClass sharedSingleton].secondPlayerInstallationId = strInstallationId;
            PFFile  *strImage = [dict objectForKey:@"userimage"];
            NSData *imageData = [strImage getData];
            UIImage *imageSecPlayer = [UIImage imageWithData:imageData];
            [SingletonClass sharedSingleton].imageSecondPlayer=imageSecPlayer;
            dispatch_async(dispatch_get_main_queue(),^(void) {
            [self performSelector:@selector(fetchQuesForChallengeFromCloud) withObject:nil afterDelay:2];
            });
            
        }
    });
}


-(void)fetchQuesForChallengeFromCloud
{
    NSNumber *subCatID = [SingletonClass sharedSingleton].selectedSubCat;

    //    [SingletonClass sharedSingleton].selectedSubCat=[NSNumber numberWithInt:101];
    //    NSNumber *subCatID = [SingletonClass sharedSingleton].selectedSubCat;
    NSLog(@"%@second %@",[SingletonClass sharedSingleton].secondPlayerObjid,[SingletonClass sharedSingleton].secondPlayerInstallationId);
   // [self saveChallengeStatus];
    [PFCloud callFunctionInBackground:@"Challange"
                       withParameters:@{@"subcategoryid":subCatID,@"subcategoryname":[SingletonClass sharedSingleton].strSelectedSubCat,@"userid":[SingletonClass sharedSingleton].objectId,@"uniqueid":[SingletonClass sharedSingleton].installationId ,@"opppnent":[SingletonClass sharedSingleton].secondPlayerObjid, @"uniqueid1":[SingletonClass sharedSingleton].secondPlayerInstallationId,@"mainid":[SingletonClass sharedSingleton].strSelectedCategoryId
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                       
                                        [SingletonClass sharedSingleton].strQuestionsId= result;
                                        [dictForChallenege setObject:result forKey:@"questionsChall"];
                                        int connectionStatus = [WarpClient getInstance].getConnectionState;
                                        
                                        if (connectionStatus != 0)
                                        {
                                            [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
                                        }
                                        else
                                        {
                                            //Room Create Main Player
                                            time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
                                            NSString *dateStr = [NSString stringWithFormat:@"%ld",unixTime];
                                            [[WarpClient getInstance] createRoomWithRoomName:dateStr roomOwner:@"Girish Tyagi" properties:NULL maxUsers:2];
                                        }
                                       
                                        

                                        //[self.mutDict setObject:[SingletonClass sharedSingleton].strQuestionsId forKey:@"questions"];
                                       [self saveRequestInChallenge];
                                        
                                        if(self.startButtonChallenge)
                                        {
                                            
                                            //[self performSelector:@selector(goToGamePlayViewChallenge:) withObject:[SingletonClass sharedSingleton].strQuestionsId afterDelay:2];
                                        }
                                        
                                        
                                        else
                                        {
                                            [SingletonClass sharedSingleton].mainPlayerChallenge=true;
                                            //-------------
                                            NSLog(@"Response Result -==- %@", result);
                                            
                                            
                                            //Notification for challenge sukhmeet
                                           
                                            
                                            
                                        }
                                        
                                        NSLog(@"Connect to cloud");
                                    }
                                }];
}
-(void)saveChallengeStatus
{
    PFObject *chStatus=[PFObject objectWithClassName:@"ChallengeRequest"];
    chStatus[@"UserId"]=[SingletonClass sharedSingleton].objectId;
    chStatus[@"OpponentId"]=[SingletonClass sharedSingleton].secondPlayerObjid;
    chStatus[@"ChallengeStatus"]=@0;
    [chStatus saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
        if (succeed) {
            NSLog(@"Save to Parse");
            
            BOOL checkInternet =  [ViewController networkCheck];
            
            if (checkInternet)
            {
               
                NSLog(@"Message send...");
            }
            else{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
        }
        if (error) {
            NSLog(@"Error to Save == %@",error.localizedDescription);
        }
    }
     ];
    
}
-(void)saveRequestInChallenge
{
    PFObject * challengeRequest=[PFObject objectWithClassName:@"ChallengeRequest"];
    challengeRequest[@"OpponentId"]=[SingletonClass sharedSingleton].secondPlayerObjid;
    challengeRequest[@"ChallengeStatus"]=@0;
    //challengeRequest[@"UserGameResult"]=
    challengeRequest[@"SubCategoryId"]=[SingletonClass sharedSingleton].selectedSubCat;
    challengeRequest[@"Question"]=[SingletonClass sharedSingleton].strQuestionsId;
    challengeRequest[@"SubCategoryName"]=[SingletonClass sharedSingleton].strSelectedSubCat;
    challengeRequest[@"CategoryId"]=[NSNumber numberWithInt:[[SingletonClass sharedSingleton].strSelectedCategoryId intValue]];
    challengeRequest[@"userIdPointer"]=[PFUser objectWithoutDataWithObjectId:[SingletonClass sharedSingleton].objectId];
    [challengeRequest saveInBackgroundWithBlock:^(BOOL succeded,NSError * error)
     {
         if(succeded)
         {
             [UIView animateWithDuration:0.4 animations:^{
                // cancel.frame=CGRectMake(self.view.frame.size.width/2+40, 400, 100, 40);
                 imgViewMobile.frame=CGRectMake(125,280, 70, 70);
                 imgViewMobile.image=[UIImage imageNamed:@"clock.png"];
                 description.text=@"먼저 싱글게임을 하면 나중에 상대방의 싱글게임이 반영됩니다";
                 imgViewMobile.image=[UIImage imageNamed:@"clock.png"];
                 startGame.hidden=FALSE;
             }];
             
             
             [SingletonClass sharedSingleton].challengeRequestObjId=[challengeRequest objectId];
             NSLog(@"Challenge Request ObjectId %@",challengeReqObjId);
         }
     }
     ];
}


-(void)goToGamePlayViewChallenge:(NSDictionary*)details
{
           topViewChallenge.hidden=YES;
        [self gameDetailsForChallenge:details];
   
}
-(void)endGame:(id)sender
{
    
    topViewChallenge.hidden=YES;
    [topViewChallenge removeFromSuperview];
    
}
-(void)setFlagForGameRequest
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"GameRequest"];
    [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
    [query orderByAscending:@"createdAt"];
    NSArray *arrObjects = [query findObjects];
    
    PFObject * myObject = [arrObjects lastObject];
    myObject[@"GameComplete"]=@YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [myObject saveEventually:^(BOOL succeed, NSError *error){
            
            if (succeed) {
                NSLog(@"Save to Parse");
                BOOL checkInternet =  [ViewController networkCheck];
                
                if (checkInternet) {
                    NSLog(@"Flag Value change in parse.");
                }
                else{
                    [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
                }
            }
        }];
    });
}

#pragma mark Search Friends and Search bar delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchResults=nil;
    searchBar.showsCancelButton=YES;
    [searchImage removeAllObjects];
    NSLog(@"searchResults are ==%@",searchResults);
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    checkSearch=FALSE;
    [quizFriends reloadData];
    
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton=NO;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
}

#pragma mark Text Field Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    strsearch=textField.text;
    if(strsearch.length==0)
    {
        searchResults=nil;
        [searchImage removeAllObjects];
        checkSearch=FALSE;
        [quizFriends reloadData];
    }

    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    strsearch=textField.text;
    if (strsearch.length>2) {
        [self searchData];
        
    }
    else if(strsearch.length==0)
    {
        searchResults=nil;
        [searchImage removeAllObjects];
       checkSearch =FALSE;
        [quizFriends reloadData];
    }


    return YES;
}
#pragma mark--------
-(void)searchData
{
    PFQuery *query=[PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"name" hasPrefix:strsearch];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^
                   {
                       NSArray *arrObjects= [query findObjects];
                       searchResults=[NSArray arrayWithArray:arrObjects];
                       for (int i=0; i<[searchResults count]; i++)
                       {
                           PFObject *srchobj=[searchResults objectAtIndex:i];
                           PFFile *frndImage=srchobj[@"userimage"];
                           NSData *data=[frndImage getData];
                           if (data) {
                               UIImage *frndpic=[UIImage imageWithData:data];
                               [searchImage addObject:frndpic];
                               NSLog(@"Search Image is==%@",friendsImage);
                           }
                           else
                           {
                              
                               UIImage *image=[UIImage imageNamed:@"fb.png"];
                               
                               [searchImage addObject:image];
                               
                           }
                           
                       }
                       NSLog(@"Array %@",searchResults);
                       dispatch_async(dispatch_get_main_queue(),^{
                           checkSearch=TRUE;
                           [quizFriends reloadData];
                       });
                   });
}
#pragma MARK Add Action
-(void)addButnAction:(UIButton *)sender
{
    sender.enabled=NO;
    PFObject * objSearchFriend=[searchResults objectAtIndex:sender.tag];
    NSLog(@"Button Tag==%ld",(long)sender.tag);
    NSString *frndobjctId=[objSearchFriend objectId];
    NSLog(@"friends objectId-==-%@",frndobjctId);
    NSString *frndInstallationId=objSearchFriend[@"deviceID"];
    [self sendPushforFriendrequest:frndobjctId instalationId:frndInstallationId];
    
}
-(void)sendPushforFriendrequest:(NSString *)friendobjectId instalationId:(NSString *)installationId
{
    NSDictionary *data = @{
                           @"Type": @"300",@"objectId":friendobjectId,@"action": @"com.quizbattle.welcome.UPDATE_STATUS",@"alert":@"friend"
                           };
    PFQuery *pushquery=[PFInstallation query];
    [pushquery whereKey:@"UserId" equalTo:friendobjectId];
    [pushquery whereKey:@"installationId" equalTo:installationId];
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushquery];
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (succeeded) {
                NSLog(@"Successful Push send");
                [self saveRequestInParse:friendobjectId];
            }
        } else {
            NSLog(@"Push sending error: %@", [error userInfo]);
        }
    }];
    
    
}
-(void)checkFriendRequest
{
    
}
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
//controller.searchBar.frame=CGRectMake(20,50, self.view.frame.size.width-40,40);
//    controller.searchBar.showsCancelButton=NO;
//    controller.searchResultsTableView.frame=CGRectMake(20,50, self.view.frame.size.width-40,40);
}
-(void)saveRequestInParse:(NSString *)frndObjectId
{
    PFObject *obj=[PFObject objectWithClassName:@"FriendRequest"];
    obj[@"UserIdPointer"]=[PFUser objectWithoutDataWithObjectId:[SingletonClass sharedSingleton].objectId];
    NSLog(@"User Id in==%@",obj[@"UserIdPointer"]);
    obj[@"FriendStatus"]=@NO;
    obj[@"FriendId"]=frndObjectId;
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
#pragma mark Fetch Friends
-(void)fetchFriends
{
    [self animationRocket];
    @try
    {
        PFQuery * findNewFriend=[PFQuery queryWithClassName:@"_User"];
        [findNewFriend whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].objectId];
        [findNewFriend selectKeys:@[@"Friends"]];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSArray * tempFriend=[findNewFriend findObjects];
            NSLog(@"Temp Friends %@",tempFriend);
            NSArray * temp;
            if([tempFriend count]>0)
            {
                PFObject * friends=[tempFriend objectAtIndex:0];
                PFQuery * forFriends=[PFQuery queryWithClassName:@"_User"];
                NSLog(@"friends %@",friends[@"Friends"]);
                [forFriends whereKey:@"objectId" containedIn:friends[@"Friends"]];
                temp=[forFriends findObjects];
                NSLog(@"Friends Detail in QuizBattle %@",temp);
                quzfrndDetails=[NSArray arrayWithArray:temp];
                //fetch image
                for(int i=0;i<[temp count];i++)
                {
                    PFObject * imgFriends=[temp objectAtIndex:i];
                    PFFile *imageFile = imgFriends[@"userimage"];
                    NSData *imageData = [imageFile getData];
                    UIImage *image = [UIImage imageWithData:imageData];
                    [friendsImage addObject:image];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if([temp count]>0)
                {
                    if(!quizFriends)
                    {
                        [self createTableQuizFriend];
                    }
                    else
                    {
                        [quizFriends reloadData];
                    }
                    //               } lblHeading.hidden=YES;
                    //                imgView.hidden=YES;
                    //                labelDesc.hidden=YES;
                }
                else
                {
                    
                    
                    
                }
                [imageVAnim stopAnimating];
                
            });
            
        });

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
-(void)animationRocket
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
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
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
