//
//  MainHistoryViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/14/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "MainHistoryViewController.h"
#import "LanguageViewController.h"
#import "GameViewController.h"
#import "GameViewControllerChallenge.h"
#import "GameOverViewController.h"
#import "Ranking.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "AppDelegate.h"
@interface MainHistoryViewController ()

@end

@implementation MainHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDismissView object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPreviousView:) name:KDismissView object:nil];
    footerButton.hidden=NO;
    [tableHistory reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    currentSelection=-1;
    isDisplayAllHistory = NO;
    //-----------------------
    self.opponenetId=[[NSMutableArray alloc]init];
    self.categoryName=[[NSMutableArray alloc]init];
   self.opponenetImage=[[NSMutableArray alloc]init];
    self.categoryId=[[NSMutableArray alloc]init];
    self.screenShotImage=[[NSMutableArray alloc]init];
    dictForChallenege=[[NSMutableDictionary alloc]init];
    //------------------------
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    [self createHistoryTable];
  [self fetchDtafromParse];
  //[self performSelectorInBackground:@selector(fetchDtafromParse) withObject:nil];
}
-(void)createHistoryTable
{
    tableHistory=[[UITableView alloc]initWithFrame:CGRectMake(20, 0,self.view.frame.size.width-40 , self.view.frame.size.height-160)];
    tableHistory.separatorStyle=UITableViewCellSeparatorStyleNone;
   tableHistory.delegate=self;
    tableHistory.dataSource=self;
    //self.backbtn=[[UIButton alloc]initWithFrame:CGRectMake(20,0,80,50)];
         tableHistory.backgroundColor=[UIColor clearColor];
    self.dataDescription=[[NSMutableArray alloc]init];
    [self.view addSubview:tableHistory];
    
}
-(void)goToPreviousView:(id)sender
{
    self.backbtn.hidden=YES;
    footerButton.hidden=NO;
    isDisplayAllHistory = NO;
    [tableHistory reloadData];
}
-(void)backBtnAction:(id)sender {
    
    self.backbtn.hidden=YES;
    footerButton.hidden=NO;
    isDisplayAllHistory = NO;
    [tableHistory reloadData];
}
-(void)noHistoryUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0]];
    UILabel *lblHeading=[[UILabel alloc]initWithFrame:CGRectMake(40, self.view.frame.size.height/2+20, self.view.frame.size.width-80,50)];
    lblHeading.textColor=[UIColor blackColor];
    lblHeading.text=[ViewController languageSelectedStringForKey:@"MAN WITHOUT A PAST"];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:lblHeading];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake( self.view.frame.size.width/2-25, self.view.frame.size.height/2.0-40, 50,50)];
    imgView.image=[UIImage imageNamed:@"no_past.png"];
    [self.view addSubview:imgView];
}
#pragma mark--------
#pragma mark Table Delegates
#pragma mark--------
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(currentSelection==indexPath.section)
    {
        return 150;
    }
    
    return 48.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
    
}
/*- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(!footerButton.hidden)
    {
    if (section==3) {
        return 100;
    }
    }
    
        return 0;
    
}*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
       if(isDisplayAllHistory==YES)
    {
        return self.categoryName.count;
    }
    
    if (self.categoryName.count>4) {
        return 4;
    }
    return self.categoryName.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 40;
    }
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==3 && isDisplayAllHistory==NO && self.categoryName.count>4) {
        return 40;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section==3 && isDisplayAllHistory==NO && self.categoryName.count>4) {
        if (!_footerView) {
            _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            _footerView.backgroundColor = [UIColor clearColor];
            footerButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 10, 70, 30)];
            [footerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [footerButton setTitle:[ViewController languageSelectedStringForKey:@"View All"] forState:UIControlStateNormal];
            [footerButton addTarget:self action:@selector(viewAction) forControlEvents:UIControlEventTouchUpInside];
            footerButton.layer.borderWidth=1;
            footerButton.layer.borderColor=[UIColor greenColor].CGColor;
            footerButton.backgroundColor=[UIColor clearColor];
            [_footerView addSubview:footerButton];
        }
        return _footerView;
    }
    return nil;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"History";
    
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"History"];
    if (cell == nil)
    {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
      cell.topView.frame =CGRectMake(0, 0, 280, 50);
    cell.messageLable.text=[self.categoryName objectAtIndex:indexPath.section];
    cell.messageLable.frame = CGRectMake(50, 5, 260, 20);
    cell.lblDescription.frame=CGRectMake(50, 28, 260, 15);
    cell.lblDescription.text=[self.dataDescription objectAtIndex:indexPath.section];
    cell.lblDescription.font=[UIFont systemFontOfSize:10];
    NSString * catId=[NSString stringWithFormat:@"%@.png",[self.categoryId objectAtIndex:indexPath.section]] ;
    NSLog(@"Category Id-=-=%@",[self.categoryId objectAtIndex:indexPath.section]);
    cell.iconImg.image=[UIImage imageNamed:catId];
    cell.playerImageIcon.image=[self.opponenetImage objectAtIndex:indexPath.section];
    cell.gameDelegate=self;
    cell.backgroundColor=[UIColor clearColor];
    //--------button actions-------
    [cell.btnResult addTarget:self action:@selector(showResult:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRematch addTarget:self action:@selector(rematchAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDiscussion addTarget:self action:@selector(discussionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRanking addTarget:self action:@selector(rankingAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPlay addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnChallenge addTarget:self action:@selector(challengeAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnRematch.tag=indexPath.section;
    cell.btnChallenge.tag=indexPath.section;
    //--------------------
    if(currentSelection==indexPath.section)
    {
        cell.buttonView.hidden=NO;
        
    }
    else
    {
        cell.buttonView.hidden=YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Selected row data.
    PFObject * rowdata=[self.historyData objectAtIndex:indexPath.section];
    NSLog(@"History Selected Row %@",rowdata);
    [SingletonClass sharedSingleton].selectedSubCat=rowdata[@"SubCategoryId"];
    
    [SingletonClass sharedSingleton].strSelectedSubCat=rowdata[@"CategoryName"];
    [SingletonClass sharedSingleton].strSecPlayerName=rowdata[@"Opponent"][@"name"];
    [SingletonClass sharedSingleton].secondPlayerObjid=[rowdata[@"Opponent"] objectId];
    [SingletonClass sharedSingleton].secondPlayerInstallationId=rowdata[@"Opponent"][@"deviceID"];
 
    if([rowdata[@"Opponent"][@"BlockUser"]containsObject:[SingletonClass sharedSingleton].objectId])
    {
        //[self userBlockedPopUp:@"상대방이 당신을 차단하였습니다"];
        userBlockDecStr=@"User Blocked u";
        NSLog(@"User Blocked u");
    }
     else if([[SingletonClass sharedSingleton].userBlockList containsObject:[rowdata[@"Opponent"] objectId]])
     {
         userBlockDecStr=@"u Blocked User";
         // [self userBlockedPopUp:@"상대방을 차단하였습니다"];
         NSLog(@"u Blocked User");
     }
    else
    {
        userBlockDecStr=@"no one block";
    }
    if([rowdata[@"Opponent"][@"Type"] isEqualToString:@"bot"])
    {
        checkBot=YES;
    }
    else
    {
        checkBot=NO;
    }
    
    if(currentSelection==indexPath.section)
    {
        currentSelection=-1;
        [tableHistory reloadData];
        return;
    }
    NSInteger row = [indexPath section];
    currentSelection = row;
    [UIView animateWithDuration:1 animations:^{
        [tableHistory reloadData];
    }];

    
}
-(void)userBlockedPopUp:(NSString*)message
{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIView * tempView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,appdelegate.window.frame.size.width,appdelegate.window.frame.size.height)];
    [appdelegate.window addSubview:tempView];
    
    tempView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageviewL=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2, self.view.frame.size.width-20, 100)];
    popUpImageviewL.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageviewL.userInteractionEnabled=YES;
    [tempView addSubview:popUpImageviewL];
    UILabel * lblRejectL=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageviewL.frame.size.width, 20)];
    lblRejectL.text=message;
    lblRejectL.textAlignment=NSTextAlignmentCenter;
    lblRejectL.textColor=[UIColor blackColor];
    [popUpImageviewL addSubview:lblRejectL];
    
    //-------
    UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(popUpImageviewL.frame.size.width-30,5,30, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(acceptButtonOk:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageviewL addSubview:acceptBtn];
    //------
    /*UIButton * okBtnL=[UIButton buttonWithType:UIButtonTypeCustom];
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

-(void)addFooterButton
{
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 40)];
    if(!footerButton)
    {
        footerButton=[[UIButton alloc]initWithFrame:CGRectMake(90, 40, self.view.frame.size.width/2-50, 30)];
    }
    [footerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footerButton setTitle:[ViewController languageSelectedStringForKey:@"View All"] forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(viewAction) forControlEvents:UIControlEventTouchUpInside];
    footerButton.layer.borderWidth=1;
    footerButton.layer.borderColor=[UIColor whiteColor].CGColor;
    footerButton.backgroundColor=[UIColor clearColor];
    [footerView addSubview:footerButton];
    tableHistory.tableFooterView=footerView;
}
-(void)viewAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:KUpdateHistory];
    self.backbtn.hidden=NO;
    footerButton.hidden=YES;
    isDisplayAllHistory = YES;
    [tableHistory reloadData];
}
#pragma mark------
#pragma mark History button methods
#pragma mark--------
-(void)showResult:(UIButton*)button
{
    
    PFObject *object=[self.historyData objectAtIndex:0];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=1; i<=5; i++)
        {
            NSString * screenshotStr=[NSString stringWithFormat:@"screenshot%d",i];
            PFFile *imageFile = object[screenshotStr];
            NSData *imageData = [imageFile getData];
            UIImage *imageScreenShot = [UIImage imageWithData:imageData];
            [self.screenShotImage addObject:imageScreenShot];
            
        }
        dispatch_async(dispatch_get_main_queue(),^(void) {
            //-------------------
            [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Game_Result_Ranking"];
            GameOverViewController *obj = [[GameOverViewController alloc] init];
            //obj.delegate = self;
            obj.arrScreenShots=self.screenShotImage;
            NSLog(@"opponent and user score Main History %@ %@",object[@"userscore"],object[@"opponentscore"]);
            [SingletonClass sharedSingleton].imageSecondPlayer=[self.opponenetImage objectAtIndex:(button.tag)];
         //   [SingletonClass sharedSingleton].strSecPlayerName=[self.]
            obj.arrScorePlayer1=object[@"userscore"];
            obj.arrScorePlayer2=object[@"opponentscore"];
            obj.resultFromHistory=@"History";
            [self.navigationController pushViewController:obj animated:YES];
          //  NSDictionary* dict = [NSDictionary dictionaryWithObject:
                                 // [NSString stringWithFormat:@"Show"]
                                                       //      forKey:@"detect"];

            // [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
        });
        
    });
     }
-(void)rematchAction:(UIButton*)button
{
    if(checkBot)
    {
        [self performSelector:@selector(rematchRejected) withObject:nil afterDelay:3];
       
    }
    else
    {
    NSLog(@"Opponent Detail %@",[self.historyData objectAtIndex:button.tag]);
    PFObject * opponenetDetail=[self.historyData objectAtIndex:button.tag];
    NSString * oppDeviceId=opponenetDetail[@"Opponent"][@"deviceID"];
    NSString * oppUserId=[opponenetDetail[@"Opponent"] objectId];
    [SingletonClass sharedSingleton].rematchMain=TRUE;
    NSLog(@"Rematch Parameters %@ %@",oppDeviceId,oppUserId);
    [SingletonClass sharedSingleton].secondPlayerObjid=oppUserId;
    [SingletonClass sharedSingleton].secondPlayerInstallationId=oppDeviceId;
    [SingletonClass sharedSingleton].imageSecondPlayer=[self.opponenetImage objectAtIndex:button.tag];
    //Created room for rematch
    int connection=[[WarpClient getInstance]getConnectionState];
    if(connection==0)
    {
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    NSString *dateStr = [NSString stringWithFormat:@"%ld",unixTime];
    [[WarpClient getInstance] createRoomWithRoomName:dateStr roomOwner:@"Girish Tyagi" properties:NULL maxUsers:2];
    }
    else
    {
        [SingletonClass sharedSingleton].connectedNot=TRUE;
        [[WarpClient getInstance]connectWithUserName:[SingletonClass sharedSingleton].objectId];
    }
        [self cloudCall:(int)button.tag];

    }//else
    [self rematchOpponentNotificationScreen];
  }
-(void)cloudCall:(int)index
{
   NSNumber *subCatID = [SingletonClass sharedSingleton].selectedSubCat;
    NSString * subCategoryName=[SingletonClass sharedSingleton].strSelectedSubCat;
    PFObject * opponenetDetail=[self.historyData objectAtIndex:index];
    [SingletonClass sharedSingleton].secondPLayerDetail=opponenetDetail[@"Opponent"];
    NSString * oppDeviceId=opponenetDetail[@"Opponent"][@"deviceID"];
    NSString * oppUserId=[opponenetDetail[@"Opponent"] objectId];
    [SingletonClass sharedSingleton].secondPlayerObjid=oppUserId;
    [SingletonClass sharedSingleton].secondPlayerInstallationId=oppDeviceId;
    NSLog(@"%@ %@ userid%@ installation%@ opponent%@ deviceopp%@",subCatID,subCategoryName,[SingletonClass sharedSingleton].objectId,[SingletonClass sharedSingleton].installationId,oppUserId,oppDeviceId);
    NSNumber * mainId=@100;
    [PFCloud callFunctionInBackground:@"Rematch"
     withParameters:@{@"subcategoryid":subCatID,@"subcategoryname":[SingletonClass sharedSingleton].strSelectedSubCat,@"userid":[SingletonClass sharedSingleton].objectId,@"uniqueid":[SingletonClass sharedSingleton].installationId,@"opppnent":oppUserId,@"uniqueid1":oppDeviceId,@"mainid":mainId}
                        block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        
                                        NSLog(@"Response Result -==- %@", result);
                                        if (![SingletonClass sharedSingleton].strQuestionsId.length>0)
                                        {
                                            [SingletonClass sharedSingleton].strQuestionsId= result;
                                  int connectionStatus=[[WarpClient getInstance] getConnectionState];
                                           if (connectionStatus != 0)
                                            {
                                                [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
                                            }

                                        }
                                        NSLog(@"Connect to cloud");
                                   
                                    }
                                    else
                                    {
                                        NSLog(@"Error in calling Cloud Code%@",error);
                                    }
                }];

}

-(void)rematchOpponentNotificationScreen
{
    //Playing Status Set True
  //  [SingletonClass sharedSingleton].isPlaying=TRUE;
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appdelegate.window.bounds.size.width,appdelegate.window.bounds.size.height)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [appdelegate.window addSubview:backgroundView];
    upperView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,appdelegate.window.bounds.size.width,appdelegate.window.bounds.size.height/2)];
    upperView.backgroundColor=[UIColor whiteColor];
    [backgroundView addSubview:upperView];
    UIImageView *imageVUser = [[UIImageView alloc]initWithFrame:CGRectMake(appdelegate.window.bounds.size.width/2-30, 80, 60, 60)];
    imageVUser.image=[SingletonClass sharedSingleton].imageUser;
    imageVUser.layer.cornerRadius=30;
    imageVUser.clipsToBounds=YES;
    [upperView addSubview:imageVUser];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 150,appdelegate.window.bounds.size.width, 50)];
    lblName.font=[UIFont boldSystemFontOfSize:15];
    lblName.textColor=[UIColor blackColor];
    lblName.text=[SingletonClass sharedSingleton].strUserName;
    lblName.textAlignment=NSTextAlignmentCenter;
    [upperView addSubview:lblName];
    
    UILabel *gradeName=[[UILabel alloc] initWithFrame:CGRectMake(0, lblName.frame.origin.y+20,appdelegate.window.frame.size.width, 50)];
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
    
    UIImageView * clockImageView=[[UIImageView alloc]initWithFrame:CGRectMake(appdelegate.window.bounds.size.width/2-50,appdelegate.window.bounds.size.height-200,100,100)];
    clockImageView.image=[UIImage imageNamed:@"clock.png"];
    [backgroundView addSubview:clockImageView];
    UIButton * cancelBtnL=[[UIButton alloc]initWithFrame:CGRectMake(backgroundView.frame.size.width/2-40,backgroundView.frame.size.height-80,80,40)];
    [cancelBtnL addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtnL.backgroundColor=[UIColor redColor];
    [cancelBtnL setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtnL setTintColor:[UIColor blackColor]];
    [backgroundView addSubview:cancelBtnL];
    
    //----------------------------
}

-(void)cancelBtnAction:(id)sender
{
    [backgroundView removeFromSuperview];
}
-(void)playGameChallenge:(NSNotification*)notify
{
  //  [self performSelector:@selector(goToGamePlayView:) withObject:self.mutDict];
}
-(void)goToGamePlayView:(NSDictionary*)details
{
    GameViewController * objGame=[[GameViewController alloc]init];
    objGame.arrPlayerDetail=details;
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    [appdelegate.window addSubview:obj.view];
    [SingletonClass sharedSingleton].gameFromView=true;
    [appdelegate.window setRootViewController:objGame];
}
#pragma mark Discussion Action
-(void)discussionBtnAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Home_Again_Discussion"];    CreateDiscussionViewController * createDiscussoin = [[CreateDiscussionViewController alloc]init];
    [self.navigationController pushViewController:createDiscussoin animated:YES];
    //--------
   // NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          //[NSString stringWithFormat:@"Show"]
                                                   //  forKey:@"detect"];
    
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}

#pragma mark Ranking=====
-(void)rankingAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Home_Again_Ranking"];
    Ranking * ranks=[[Ranking alloc]init];
    [self.navigationController pushViewController:ranks animated:YES];
    
    //--------
   // NSDictionary* dict = [NSDictionary dictionaryWithObject:
                        //  [NSString stringWithFormat:@"Show"]
                                                   //  forKey:@"detect"];
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}
#pragma mark play now--
-(void)playBtnAction:(id)sender
{
    GamePLayMethods * obj=[[GamePLayMethods alloc]init];
    obj.gameDelegate=self;
    [obj playNowButtonAction];
}
#pragma mark--------
#pragma mark Challenge
#pragma mark--------
-(void)challengeAction:(UIButton*)button
{
    BOOL userBlockedL=false;
   if(!checkBot)
   {
       if([userBlockDecStr isEqualToString:@"User Blocked u"])
       {
           userBlockedL=TRUE;
           [self userBlockedPopUp:@"상대방이 당신을 차단하였습니다"];
       }
       else if ([userBlockDecStr isEqualToString:@"u Blocked User"])
       {
           userBlockedL=TRUE;
           [self userBlockedPopUp:@"상대방을 차단하였습니다"];
       }
       else
       {
           userBlockedL=FALSE;
           //not block
           PFObject * obj=[self.historyData objectAtIndex:button.tag];
           NSLog(@"History Data/.....%@...%@",[obj[@"Opponent"] objectId],obj[@"Opponent"][@"deviceId"]);
           [SingletonClass sharedSingleton].selectedSubCat=obj[@"SubCategoryId"];
           if(obj[@"CategoryName"])
           {
               [SingletonClass sharedSingleton].strSelectedSubCat=obj[@"CategoryName"];
           }
           else
           {
               [SingletonClass sharedSingleton].strSelectedSubCat=obj[@"SubCategoryName"];
           }
           [SingletonClass sharedSingleton].mainPlayerChallenge=TRUE;
           [SingletonClass sharedSingleton].strSelectedCategoryId=obj[@"CategoryId"];
           [SingletonClass sharedSingleton].secondPlayerObjid =[obj[@"Opponent"] objectId];
           [SingletonClass sharedSingleton].secondPlayerInstallationId=obj[@"Opponent"][@"deviceId"];
           [self fetchApponentDetailChallenge];
           int connectionStatus = [WarpClient getInstance].getConnectionState;
           
           if (connectionStatus != 0)
           {
               [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
           }

       }
       
       
      }
    else
    {
        [self performSelector:@selector(rematchRejected) withObject:nil afterDelay:5];
    }
    
    //=====================
    if(!userBlockedL)
    {
    width=self.view.bounds.size.width;
    height=self.view.bounds.size.height;
    
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
    
    cancel=[[UIButton alloc]initWithFrame:CGRectMake(width/2-50,400, 100, 40)];
    [cancel setTitle:@"cancel" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(endGame:) forControlEvents:UIControlEventTouchUpInside];
    cancel.backgroundColor=[UIColor whiteColor];
    cancel.layer.cornerRadius=5;
    cancel.layer.borderColor=[UIColor greenColor].CGColor;
    cancel.layer.borderWidth=1;
    //[topViewChallenge addSubview:cancel];
    
    description=[[UILabel alloc]initWithFrame:CGRectMake(0, height+22, width, 40)];
    description.numberOfLines=0;
    description.text=@"상대방이 도전을 받을것인지 묻고 있습니다";
    description.textAlignment=NSTextAlignmentCenter;
    description.textColor=[UIColor blackColor];
    description.font=[UIFont boldSystemFontOfSize:15];
    [topViewChallenge addSubview:description];
    imgViewMobile=[[UIImageView alloc]initWithFrame:CGRectMake(140,270, 50, 100)];
    imgViewMobile.backgroundColor=[UIColor clearColor];
    imgViewMobile.image=[UIImage imageNamed:@"mobileImg.png"];
    [topViewChallenge addSubview:imgViewMobile];
    }
    //[topViewChallenge addSubview:description];
}
#pragma mark===============================
#pragma mark Challenge UI and methods
#pragma mark===============================

-(void)challengeStartGameAction :(id)sender
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
    
    
    dispatch_async(dispatch_get_main_queue(),^(void) {
        
        [self performSelector:@selector(loadOponnentPlayerInChallenge) withObject:nil afterDelay:4];
    });
}

-(void)fetchApponentDetailChallenge
{
    //    [SingletonClass sharedSingleton].secondPlayerObjid=@"nFvTMPhDiZ";
    //    [SingletonClass sharedSingleton].secondPlayerInstallationId=@"708a9020-a995-4e63-9108-d27f09835821";
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            PFQuery *query = [PFUser query];
            
            [query whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].secondPlayerObjid];
            
            NSArray *arrObjectsChallenge = [query findObjects];
            [SingletonClass sharedSingleton].secondPLayerDetail=arrObjectsChallenge;
            NSLog(@"Array object Challenge Details -==- %@",arrObjectsChallenge);
            //[self.mutDict setObject:arrObjectsChallenge forKey:@"oponentPlayerDetail"];
            
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
    //sukhmeet for challenge
}

-(void)loadOponnentPlayerInChallenge
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [imageVAnim stopAnimating];
    UIImageView *imageVsecPlayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, appdelegate.window.bounds.size.width,appdelegate.window.frame.size.height)];
    imageVsecPlayer.backgroundColor=[UIColor whiteColor];
    [topViewChallenge addSubview:imageVsecPlayer];
    
    UIImageView *profileImgSecPlayer=[[UIImageView alloc]initWithFrame:CGRectMake(20,280, 80, 80)];
    profileImgSecPlayer.layer.cornerRadius=40;
    profileImgSecPlayer.layer.borderWidth=2.0f;
    profileImgSecPlayer.layer.borderColor=[UIColor redColor].CGColor;
    profileImgSecPlayer.layer.masksToBounds=YES;
    profileImgSecPlayer.backgroundColor=[UIColor yellowColor];
    profileImgSecPlayer.image=[SingletonClass sharedSingleton].imageSecondPlayer;
    [topViewChallenge addSubview:profileImgSecPlayer];
    
    UILabel * playerName=[[UILabel alloc]initWithFrame:CGRectMake(105,300,210,20)];
    playerName.textAlignment=NSTextAlignmentLeft;
    playerName.text=[SingletonClass sharedSingleton].strSecPlayerName;
    playerName.textColor=[UIColor blackColor];
    [topViewChallenge addSubview:playerName];
    
    UILabel * gradeName=[[UILabel alloc]initWithFrame:CGRectMake(105,330,100, 20)];
    gradeName.text=[SingletonClass sharedSingleton].strSecPlayerRank;
    gradeName.textColor=[UIColor blackColor];
    [topViewChallenge addSubview:gradeName];
    
    UILabel * countryName=[[UILabel alloc]initWithFrame:CGRectMake(160, 360, 120, 60)];
    countryName.numberOfLines=0;
    countryName.text=[NSString stringWithFormat:@"에서 재생\n%@",[SingletonClass sharedSingleton].strCountry];;
    countryName.textColor=[UIColor blackColor];
    [topViewChallenge addSubview:countryName];
    
    [self performSelector:@selector(startGamePressedOfChallenge:) withObject:[SingletonClass sharedSingleton].strQuestionsId afterDelay:2];
    
}
-(void)startGamePressedOfChallenge:(id) sender
{
    topViewChallenge.hidden=YES;
    [topViewChallenge removeFromSuperview];
//    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    GameViewControllerChallenge *objGameChallenge = [[GameViewControllerChallenge alloc] init];
    objGameChallenge.arrPlayerDetail=dictForChallenege;
    [SingletonClass sharedSingleton].singleGameChallengedPlayer=YES;
    if([SingletonClass sharedSingleton].roomId)
    {
        [[WarpClient getInstance]leaveRoom:[SingletonClass sharedSingleton].roomId
         ];
        [[WarpClient getInstance]deleteRoom:[SingletonClass sharedSingleton].roomId];
        
    }

    self.navigationController.navigationBar.hidden=YES;
    //AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[SingletonClass sharedSingleton].gameFromView=true;
    [self presentViewController:objGameChallenge animated:YES completion:nil];
   
}
-(void)endGame:(id)sender
{
    topViewChallenge.hidden=YES;
    [topViewChallenge removeFromSuperview];
    
}
-(void)fetchQuesForChallengeFromCloud
{
    //    [SingletonClass sharedSingleton].selectedSubCat=[NSNumber numberWithInt:101];
    NSNumber *subCatID = [SingletonClass sharedSingleton].selectedSubCat;
    
    NSLog(@"%@second %@ selected Sub category id%@",[SingletonClass sharedSingleton].secondPlayerObjid,[SingletonClass sharedSingleton].secondPlayerInstallationId,[SingletonClass sharedSingleton].strSelectedCategoryId);
    // [self saveChallengeStatus];
    [PFCloud callFunctionInBackground:@"Challange"
                       withParameters:@{@"subcategoryid":subCatID,@"subcategoryname":[SingletonClass sharedSingleton].strSelectedSubCat,@"userid":[SingletonClass sharedSingleton].objectId,@"uniqueid":[SingletonClass sharedSingleton].installationId ,@"opppnent":[SingletonClass sharedSingleton].secondPlayerObjid, @"uniqueid1":[SingletonClass sharedSingleton].secondPlayerInstallationId,@"mainid":[SingletonClass sharedSingleton].strSelectedCategoryId
                                        }
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        
                                        
                                        //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playGameChallenge:) name:@"gameUiChallenge" object:nil];
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
                                        
                                        [SingletonClass sharedSingleton].mainPlayerChallenge=true;
                                        //-------------
                                        NSLog(@"Response Result -==- %@", result);
                                        
                                        
                                        //Notification for challenge sukhmeet
                                        
                                        
                                        
                                        NSLog(@"Connect to cloud");
                                    }
                                }];
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
                 imgViewMobile.frame=CGRectMake(125,280, 70, 70);
                 imgViewMobile.image=[UIImage imageNamed:@"clock.png"];
                 description.text=@"먼저 싱글게임을 하면 나중에 상대방의 싱글게임이 반영됩니다";

                 startGame.hidden=FALSE;
             }];
             
             [SingletonClass sharedSingleton].challengeRequestObjId=[challengeRequest objectId];
             NSLog(@"Challenge Request ObjectId %@",[challengeRequest objectId]);
         }
     }
     ];
}

//-(void)playGameChallenge:(NSNotification*)notify
//{
//    [self performSelector:@selector(goToGamePlayView:) withObject:self.mutDict];
//}

-(void)goToGamePlayViewChallenge:(NSDictionary*)details
{
    [topViewChallenge removeFromSuperview];
    //topViewChallenge.hidden=YES;
    [self gameDetailsForChallenge:details];
    
}

#pragma mark Parse Method
#pragma mark--------
-(void)fetchDtafromParse
{
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, 100, 30, 50)];
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
    PFQuery * query=[PFQuery queryWithClassName:@"GameResult"];
    [query whereKey:@"UserId"equalTo:[SingletonClass sharedSingleton].objectId];
    [query orderByDescending:@"createdAt"];
    query.limit=10;
    [query includeKey:@"Opponent"];
    //For history fetch opponent id
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //-------------------
       NSMutableArray * winingStatus=[[NSMutableArray alloc]init];
        NSMutableArray * dateCompared=[[NSMutableArray alloc]init];
        NSMutableArray * opponenetId=[[NSMutableArray alloc]init];
        //------------------------
        NSArray * temp=[query findObjects];
     NSLog(@"History Details%@",temp);
        self.historyData=[NSArray arrayWithArray:temp];
        
        for(int i=0;i<[temp count];i++)
        {
            
            PFObject * objHistory=[temp objectAtIndex:i];
            
            if([objHistory[@"opponentscore"] count]>0)
            {
                if(objHistory[@"Opponent"])
                {
                    [opponenetId addObject:objHistory[@"Opponent"]];
                    [winingStatus addObject:objHistory[@"winnerstatus"]];
                    
                    NSDate * date=objHistory.createdAt;
                    [dateCompared  addObject:[self compareDate:date]];
                    [self.categoryName addObject:objHistory[@"CategoryName"]];
                    [self.categoryId addObject:objHistory[@"CategoryId"]];
                    [self prepareDescription:[objHistory[@"winnerstatus"] intValue]  :objHistory[@"Opponent"][@"name"] :[self compareDate:date]];
                    PFFile *imageFile = objHistory[@"Opponent"][@"userimage"];
                    NSData *imageData = [imageFile getData];
                    UIImage *imageUser = [UIImage imageWithData:imageData];
                    if(imageUser)
                        [self.opponenetImage addObject:imageUser];
                }

            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           [tableHistory reloadData];
                           [imageVAnim stopAnimating];
                           if ([self.categoryName count]==0)
                           {
                               [self noHistoryUI];
                           }
                       });

        
    });
}
-(NSString*)prepareDescription:(int)winningStatus :(NSString*)name :(NSString*)dateStr
{
    NSString * status;
    switch (winningStatus) {
        case 0:
           status=[ViewController languageSelectedStringForKey:@"Win"];
            break;
            case 1:
            status=[ViewController languageSelectedStringForKey:@"Lost"];
            break;
        case 2:
        status=[ViewController languageSelectedStringForKey:@"Draw"];
            break;
        default:
            break;
    }
    
    //strings for  language change
    
    NSString *strYou=[ViewController languageSelectedStringForKey:@"You"];
    NSString *strFrom=[ViewController languageSelectedStringForKey:@"from"];
    NSString *strAgo=[ViewController languageSelectedStringForKey:@"ago"];
    [self.dataDescription addObject:[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",strYou,status,strFrom,name,dateStr,strAgo]];
   // NSLog(@"%@",[NSString stringWithFormat:@"You %@ from %@ %@ ago",status,name,dateStr]);
    return [NSString stringWithFormat:@"  %@ %@ %@",name,dateStr,strAgo];
}
-(NSString*)compareDate:(NSDate*)oldDate
{
    NSDate *currentDate = [NSDate date];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDate  toDate:currentDate  options:0];
    
    int months = (int)[conversionInfo month];
    int days = (int)[conversionInfo day];
    int hours = (int)[conversionInfo hour];
    int minutes = (int)[conversionInfo minute];
    //int seconds = (int)[conversionInfo second];
    
   // NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
    if(months>1)
    {
        NSString *strMonth=[ViewController languageSelectedStringForKey:@"months"];
        return [NSString stringWithFormat:@"%d %@",months,strMonth];
   
    }
   else if(days>1)
    {
        NSString *strDay=[ViewController languageSelectedStringForKey:@"days"];
        return [NSString stringWithFormat:@"%d %@",days,strDay];
    }
    else if(hours>=1)
    {
            NSString *strHours=[ViewController languageSelectedStringForKey:@"hours"];          return [NSString stringWithFormat:@"%d %@",hours,strHours];

    }
    else if(minutes>=1)
    {
        NSString *strMin=[ViewController languageSelectedStringForKey:@"minutes"];
        return [NSString stringWithFormat:@"%d %@",minutes,strMin];
    }
    else
    {
        return [NSString stringWithFormat:@""];
    }
}
-(void)fetchImage
{
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
    

    for(int i=0;i<[self.opponenetId count];i++)
    {
    dispatch_async(GCDBackgroundThread, ^{
            @autoreleasepool {
PFQuery * query=[PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId"equalTo:[self.opponenetId objectAtIndex:i]];
                
                
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects)
            {
                NSLog(@"image data %@",objects);
                PFFile  *strImage = object[@"userimage"];
                NSData *imageData = [strImage getData];
                UIImage *imageUser = [UIImage imageWithData:imageData];
                [self.opponenetImage addObject:imageUser];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [imageVAnim stopAnimating];
                                [tableHistory reloadData];

                           });

                   }
            }];
    }
    });
    }
}
-(void)gameDetailsAnotherGame:(NSDictionary *)details
{
    
    GameViewController *objGame = [[GameViewController alloc] init];
    objGame.arrPlayerDetail=details;
    NSLog(@"obj Players Details -== %@",objGame.arrPlayerDetail);
    [self presentViewController:objGame animated:YES completion:nil];
}

-(void)gameDetails:(NSDictionary*)details
{
    
    GameViewController *objGameVC = [[GameViewController alloc] init];
    objGameVC.arrPlayerDetail=details;
    //NSLog(@"obj Players Details -== %@",objGameVC.arrPlayerDetail);
    [self presentViewController:objGameVC animated:YES completion:nil];
}

-(void)rematchRejected
{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,appdelegate.window.bounds.size.width,appdelegate.window.bounds.size.height)];
    [appdelegate.window addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 100)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 20)];
    lblReject.text=@"죄송 상대는 거부";
    lblReject.font=[UIFont boldSystemFontOfSize:15];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    //------
    UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(popUpImageview.frame.size.width-30,5,30, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    NSString * strAccept=[ViewController languageSelectedStringForKey:@"Using"];
    //    [acceptBtn setTitle:strAccept forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:acceptBtn];
    
   /* UIButton * okButton=[UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame=CGRectMake(100,popUpImageview.frame.size.height-40,100, 30);
    okButton.layer.borderWidth=2;
    okButton.layer.borderColor=[UIColor blackColor].CGColor;
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton setTitle:[ViewController languageSelectedStringForKey:@"OK"] forState:UIControlStateNormal];
    okButton.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:okButton];*/
}
-(void)okButtonAction
{
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
     [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
    //[self cancelBtnAction:nil];
    
}


#pragma mark-------

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
