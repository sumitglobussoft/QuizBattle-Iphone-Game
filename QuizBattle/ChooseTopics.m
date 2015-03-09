//
//  ChooseTopics.m
//  QuizBattle
//
//  Created by GLB-254 on 10/13/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import "ChooseTopics.h"
#import "MessageCustomCell.h"
#import "GameViewController.h"
#import "GameViewControllerChallenge.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "AppDelegate.h"
@interface ChooseTopics ()

@end

@implementation ChooseTopics

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) goToPreviousView:(NSNotification *)notify{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPreviousView:) name:KDismissView object:nil];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDismissView object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];    [self uiforTable];
    [self fetchDtafromParse];
    dictForChallenege=[[NSMutableDictionary alloc]init];
}
-(void)uiforTable
{
    chooseTopicTable=[[UITableView alloc]initWithFrame:CGRectMake(20, 10, self.view.bounds.size.width-40, self.view.bounds.size.height-180)];
    chooseTopicTable.delegate=self;
    chooseTopicTable.dataSource=self;
    chooseTopicTable.bounces=NO;
    chooseTopicTable.showsVerticalScrollIndicator=NO;
    chooseTopicTable.backgroundColor=[UIColor clearColor];
    [self.view addSubview:chooseTopicTable];
    pickCategory=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, chooseTopicTable.frame.size.width, 44)];
    pickCategory.placeholder=@"Search all topics";
    pickCategory.delegate=self;
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, chooseTopicTable.frame.size.width,30)];
    UILabel * yours=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, chooseTopicTable.frame.size.width, 20)];
    yours.text=@"당신 것";
    yours.textAlignment=NSTextAlignmentCenter;
    yours.font=[UIFont boldSystemFontOfSize:15];
    [headerView addSubview:yours];
   chooseTopicTable.tableHeaderView=headerView;
    
    UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, chooseTopicTable.frame.size.width,30)];
    
    chooseTopicTable.tableFooterView=footerView;
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark----------
#pragma mark Table Delegates
#pragma mark----------
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
           return 50;
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
      return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        
        return [[UIView alloc]initWithFrame:CGRectZero];
        
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.arrData count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChooseTopic";
    
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.pickCategoryButton =[UIButton buttonWithType:UIButtonTypeCustom];
    }
    cell.gameDelegate=self;
    cell.topView.frame =CGRectMake(0, 0, 280,50);

    cell.messageLable.frame = CGRectMake(60, 10, 260, 20);
    cell.messageLable.font=[UIFont systemFontOfSize:13];
    PFObject *object = [self.arrData objectAtIndex:indexPath.section];
    NSString *message;
    if(object[@"CategoryName"])
    {
        message = object[@"CategoryName"];
    }
    else
    {
         message = object[@"SubCategoryName"];
    }
    
    //-------------------
    
    cell.pickCategoryButton.frame=CGRectMake(cell.contentView.frame.size.width-130, 8, 70, 30);
    cell.pickCategoryButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [cell.pickCategoryButton setTitle:@"선택" forState:UIControlStateNormal];
    [cell.pickCategoryButton setTitleColor:[UIColor colorWithRed:(CGFloat)27/255 green:(CGFloat)210/255 blue:(CGFloat)130/255 alpha:1] forState:UIControlStateNormal];
    [[cell.pickCategoryButton layer] setBorderWidth:2.0f];
    [[cell.pickCategoryButton layer] setBorderColor:[UIColor greenColor].CGColor];
    
    [cell.topView insertSubview:cell.pickCategoryButton belowSubview:cell.topView];
    [cell.pickCategoryButton addTarget:self action:@selector(categoryPickedForChallenge:) forControlEvents:UIControlEventTouchUpInside];
    cell.pickCategoryButton.tag=indexPath.section;
    //--------------------

   // [SingletonClass sharedSingleton].selectedSubCat=object[@"CategoryId"];
    [SingletonClass sharedSingleton].strSelectedSubCat=message;
    cell.messageLable.text=message;
    NSString * imgName=[NSString stringWithFormat:@"%d",[object[@"CategoryId"] intValue]];
    cell.iconImg.image=[UIImage imageNamed:imgName];
    cell.gameDelegate=self;
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}
#pragma mark -
#pragma mark Search Bar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"Search Text==%@",searchText);
    
    [searchBar setShowsCancelButton:YES animated:YES];
    [self filterContentForSearchText:searchText scope:@"All"];

}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

//Filter All Message Array on the basis of entered Keyword on Search Bar
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
   // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.DisplayMessage contains[c] %@",searchText];
    
	// Filter the array using NSPredicate
    
 //NSArray *tempArray = [self.allMessageArray filteredArrayUsingPredicate:predicate];
    
    if(![scope isEqualToString:@"All"]) {
        // Further filter the array with the scope
      //  NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",scope];
        //tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
    }
    
    //self.searchArray = [NSMutableArray arrayWithArray:tempArray];
    
}

-(void)gameDetails:(NSDictionary*)details {
    
    GameViewController *objGameVC = [[GameViewController alloc] init];
    objGameVC.arrPlayerDetail=details;
   // NSLog(@"obj Players Details -== %@",objGameVC.arrPlayerDetail);
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    [appdelegate.window addSubview:obj.view];
    [SingletonClass sharedSingleton].gameFromView=true;
    [appdelegate.window setRootViewController:objGameVC];
}
-(void)gameDetailsForChallenge:(NSDictionary*)details
{
    [topViewChallenge removeFromSuperview];
    GameViewControllerChallenge *obj = [[GameViewControllerChallenge alloc] init];
    obj.arrPlayerDetail=details;
    [self presentViewController:obj animated:YES completion:nil];
    self.navigationController.navigationBar.hidden=YES;
//    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appdelegate.window addSubview:obj.view];
}
-(void)backBtnActionC:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fetchDtafromParse
{
    PFQuery * query=[PFQuery queryWithClassName:@"GameResult"];
    [query whereKey:@"UserId"equalTo:[SingletonClass sharedSingleton].objectId];
    [query selectKeys:@[@"CategoryId",@"CategoryName",@"SubCategoryId"]];
     query.limit=10;    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSArray *tempArray = [query findObjects];
    self.arrData = [NSArray arrayWithArray:tempArray];
        NSLog(@"Category Data %@",self.arrData);
         NSMutableArray * temp=[[NSMutableArray alloc]init];
         NSMutableArray * tempAllData=[[NSMutableArray alloc]init];
         for (int i=0; i<[self.arrData count]; i++)
         {
             PFObject * obj=[self.arrData objectAtIndex:i];
             if(![temp containsObject:obj[@"CategoryId"]])
             {
                 [temp addObject:obj[@"CategoryId"]];
                 [tempAllData addObject:[self.arrData objectAtIndex:i]];
             }
         }
         self.arrData=[NSArray arrayWithArray:tempAllData];
         NSLog(@"Data of choose topoic %@",self.arrData);
        if(self.arrData!=nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^(void){
            
           [chooseTopicTable reloadData];
            
        });

         }
        //-----------------
        if([tempArray count]<=0)
        {
        PFQuery *query=[PFQuery queryWithClassName:@"SubCategory"];
        [query orderByDescending:@"createdAt"];
        
        query.limit=10;
            NSArray *tempArray = [query findObjects];
            self.arrData = [NSArray arrayWithArray:tempArray];
            NSLog(@"Category Data %@",self.arrData);
            
            if(self.arrData!=nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    [chooseTopicTable reloadData];
                    
                });
                
            }
        }
    });
}

#pragma mark---
-(void)categoryPickedForChallenge:(UIButton*)button
{
    NSLog(@"category taag%d",button.tag);
    PFObject * obj=[self.arrData objectAtIndex:button.tag];
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
   [self fetchApponentDetailChallenge];
    int connectionStatus = [WarpClient getInstance].getConnectionState;
    
    if (connectionStatus != 0)
    {
        [[WarpClient getInstance] connectWithUserName:[SingletonClass sharedSingleton].objectId];
    }
    
    //------------
    [self challengeScreenUi];
    //------------
    
    
}

-(void)challengeScreenUi
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
    countryName.text=[NSString stringWithFormat:@"에서 재생\n%@",[SingletonClass sharedSingleton].strCountry];
    countryName.textColor=[UIColor blackColor];
    [topViewChallenge addSubview:countryName];
    
    [self performSelector:@selector(startGamePressedOfChallenge:) withObject:[SingletonClass sharedSingleton].strQuestionsId afterDelay:2];
    
}
-(void)startGamePressedOfChallenge:(id) sender
{
    topViewChallenge.hidden=YES;
    [topViewChallenge removeFromSuperview];

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
   // [SingletonClass sharedSingleton].gameFromView=true;
    [self presentViewController:objGameChallenge animated:YES completion:nil];
}
-(void)endGame:(id)sender
{
    topViewChallenge.hidden=YES;
    [topViewChallenge removeFromSuperview];
    if([SingletonClass sharedSingleton].roomId)
    {
        [[WarpClient getInstance]leaveRoom:[SingletonClass sharedSingleton].roomId];
        [[WarpClient getInstance]deleteRoom:[SingletonClass sharedSingleton].roomId];
        
    }
  
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
                 //cancel.frame=CGRectMake(width/2+40, 400, 100, 40);
                 imgViewMobile.frame=CGRectMake(125,280, 70, 70);
                imgViewMobile.image=[UIImage imageNamed:@"clock.png"];
                 description.text=@"먼저 싱글게임을 하면 나중에 상대방의 싱글게임이 반영됩니다";

                  startGame.hidden=FALSE;
             }];
             
             [SingletonClass sharedSingleton].challengeRequestObjId=[challengeRequest objectId];
             NSLog(@"Challenge Request ObjectId %@",challengeReqObjId);
         }
     }
     ];
}

//-(void)playGameChallenge:(NSNotification*)notify
//{
//    [self performSelector:@selector(goToGamePlayView:) withObject:self.mutDict];
//}
-(void)goToGamePlayView:(NSDictionary*)details
{
    GameViewController * objGame=[[GameViewController alloc]init];
    objGame.arrPlayerDetail=details;
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    [appdelegate.window addSubview:obj.view];
    [SingletonClass sharedSingleton].gameFromView=true;
    [appdelegate.window setRootViewController:objGame];
    
    
    //    [self.window.rootViewController presentViewController:obj
    //                                                 animated:NO
    //                                               completion:nil];
    
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
            
            if (checkInternet) {
                
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


-(void)goToGamePlayViewChallenge:(NSDictionary*)details
{
    topViewChallenge.hidden=YES;
    [self gameDetailsForChallenge:details];
    
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
