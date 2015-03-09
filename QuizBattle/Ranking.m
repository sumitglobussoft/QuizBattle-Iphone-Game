//
//  Ranking.m
//  QuizBattle
//
//  Created by GLB-254 on 11/3/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import "Ranking.h"
#import "SingletonClass.h"
#import <Parse/Parse.h>
#import "ViewController.h"
#import "ProfileViewController.h"
#import "MessageCustomCell.h"
@interface Ranking ()

@end

@implementation Ranking

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPreviousView:) name:KDismissView object:nil];
    

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KDismissView object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //----
    self.imageArray=[[NSMutableArray alloc]init];
    frndStatus=[[NSMutableArray alloc]init];
    //---
     frameSize = [UIScreen mainScreen].bounds.size;
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    [self fetchDataForRanking];
    
}
-(void)creatTable
{
    if (!self.rankTable) {
        self.rankTable = [[UITableView alloc] initWithFrame:CGRectMake(20, 0, frameSize.width-40, frameSize.height-140) style:UITableViewStylePlain];
       self.rankTable.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:self.rankTable];
       self.rankTable.delegate = self;
        self.rankTable.dataSource = self;
        self.rankTable.backgroundColor=[UIColor clearColor];
        self.rankTable.bounces=NO;
        self.rankTable.showsVerticalScrollIndicator=NO;
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.rankTable.frame.size.width,50)];
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,10,self.rankTable.frame.size.width, 30)];
        headerLabel.text=[NSString stringWithFormat:@"%@",[SingletonClass sharedSingleton].strSelectedSubCat];
        headerLabel.textColor=[UIColor blackColor];
        headerLabel.font=[UIFont boldSystemFontOfSize:18];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        [headerView addSubview:headerLabel];
        self.rankTable.tableHeaderView=headerView;

    }
    else
    {
        [self.rankTable reloadData];
    }
    
}
-(void)backButtonAction:(id)sender
{
    //[self.presentedViewController removeFromParentViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Table Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rankingDetail count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return 48.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell Identifier";

    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell==nil)
    {
        cell=[[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //-------label for name,rank and Xp
    
    cell.contentView.frame=CGRectMake(0,0,280,48.5);
    
    UILabel * rankNumber=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 25, 40)];
    NSLog(@"Index==%ld",(long)indexPath.section);
    rankNumber.text=[NSString stringWithFormat:@"%d.)",indexPath.section+1];
    rankNumber.font=[UIFont boldSystemFontOfSize:10];
    [cell.contentView addSubview:rankNumber];
    
    UILabel * userName=[[UILabel alloc]initWithFrame:CGRectMake(75,5,150,40)];
    userName.font=[UIFont systemFontOfSize:14];
    [cell.contentView addSubview:userName];
    
    UILabel * xP=[[UILabel alloc]initWithFrame:CGRectMake(190, 5, 80, 40)];
    xP.textAlignment=NSTextAlignmentCenter;
    xP.font=[UIFont boldSystemFontOfSize:15];
    [cell.contentView addSubview:xP];
    
    //----------imageView
    UIImageView * userPic=[[UIImageView alloc]initWithFrame:CGRectMake(35, 10, 30, 30)];
    userPic.userInteractionEnabled=YES;
    userPic.layer.cornerRadius=15;
    userPic.layer.borderWidth=2;
    userPic.layer.borderColor=[UIColor blackColor].CGColor;
    userPic.clipsToBounds=YES;
    userPic.image=[self.imageArray objectAtIndex:indexPath.section];
    userPic.tag=indexPath.section;
    UITapGestureRecognizer *tapWall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [userPic addGestureRecognizer:tapWall];

    [cell.contentView addSubview:userPic];
    //---------showing data----
    
    PFObject * obj=[self.rankingDetail objectAtIndex:indexPath.section];
    userName.text=obj[@"username"];
    NSString * strXp=[NSString stringWithFormat:@"Gp%d",[obj[@"gradepoints"] intValue]];
    xP.text=strXp;
    return cell;
}

-(void) setImage:(PFFile*)fileName onCell:(UITableViewCell*)cell{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [fileName getData];
        if (data != nil) {
            cell.imageView.image = [UIImage imageWithData:data];
        }
    });
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.contentView.backgroundColor = [UIColor clearColor];
        headerView.backgroundView.backgroundColor = [UIColor clearColor];
    }
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark Fetch Ranking Data
-(void) goToPreviousView:(NSNotification *)notify
{
    // [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)fetchDataForRanking
{
    //[SingletonClass sharedSingleton].selectedSubCat=[NSNumber numberWithInt:101];
    UIImageView *imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-30, 30, 50)];
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

    
    
    PFQuery * query=[PFQuery queryWithClassName:@"UserGrade"];
    [query whereKey:@"SubcategoryId" equalTo:[SingletonClass sharedSingleton].selectedSubCat];
    [query orderByDescending:@"gradepoints"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * temp=[query findObjects];
        NSLog(@"%ld",(unsigned long)[temp count]);
        self.rankingDetail=[NSArray arrayWithArray:temp];
        for(int i=0;i<[self.rankingDetail count];i++)
        {
            PFObject * objectImage=[temp objectAtIndex:i];
            NSString *strUrl=[NSString stringWithFormat:@"%@",objectImage[@"userimage"]];
            NSURL *url=[NSURL URLWithString:strUrl];
            PFObject * objUser=[[SingletonClass sharedSingleton].userDetailinParse objectAtIndex:0];
            NSLog(@"User Detail %@",objUser[@"Friends"]);
            if([objUser[@"Friends"] containsObject:objectImage[@"UserId"]])
            {
                [frndStatus addObject:@"Friend"];
            }
            else
            {
                [frndStatus addObject:@"NotFriend"];
            }
            NSLog(@"image url in ranking%@",url);
            if(url)
            {
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSURLResponse *response;
            NSError *error;
            NSData *data=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
            if (error == nil && data !=nil) {
              [self.imageArray addObject:[UIImage imageWithData:data]];
            }
            else
            {
                NSLog(@"Error in image %@",error);
            }
            }//if of url
            else
            {
                [self.imageArray addObject:[UIImage imageNamed:@"1.png"]];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(),^(void) {
            
            [self creatTable];
            [imageVAnim stopAnimating];
        });
        //for end
    });
}
-(void)checkFriend:(NSString*)objectId
{
    PFQuery * query=[PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"FriendId" equalTo:objectId];
    [query includeKey:@"UserIdPointer"];
    [query whereKey:@"UserIdPointer" equalTo:[PFUser objectWithoutDataWithObjectId:[SingletonClass sharedSingleton].objectId]];
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {

    NSArray * arr=[query findObjects];
            if([arr count]>0)
            {
                profileUser.checkFrnReqSend=TRUE;
            }
            else
            {
              profileUser.checkFrnReqSend=FALSE;
            }
            NSLog(@"detail from friend request %@",arr);
        }
        PFQuery * query=[PFQuery queryWithClassName:@"_User"];
        [query selectKeys:@[@"Quickbloxid"]];
        [query whereKey:@"objectId" equalTo:objectId];
        NSArray * temp=[query findObjects];
        if([temp count]>0)
        {
            @try
            {
                PFObject * obj=[temp objectAtIndex:0];
                profileUser.quickBloxId=obj[@"Quickbloxid"];
            }
            @catch (NSException *exception)
            {
                NSLog(@"Exception in QuickBlox Null")
                ;
            }
            
           
        }
        
        
    });
    
}
#pragma Show Profile from ranking
#pragma mark AddTapGesture
-(void) handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Friends_ProfileImage"];

    
    [SingletonClass sharedSingleton].profileForSecondUser=TRUE;
    NSLog(@"Tag value of image view %ld",(long)tapGesture.view.tag);
    profileUser=[[ProfileViewController alloc]init];
    NSLog(@"Data sent to Profile %@",[self.rankingDetail objectAtIndex:(long)tapGesture.view.tag]);
    profileUser.profileUserdetail=[self.rankingDetail objectAtIndex:(long)tapGesture.view.tag];
    profileUser.frndStatus=[frndStatus objectAtIndex:(long)tapGesture.view.tag];
    profileUser.imageUser=[self.imageArray objectAtIndex:(long)tapGesture.view.tag];
    PFObject * objRank=[self.rankingDetail objectAtIndex:(long)tapGesture.view.tag];
    [self fetrchUserTocheckPrivacy:objRank[@"UserId"]];
    if([objRank[@"UserId"]isEqualToString:[SingletonClass sharedSingleton].objectId])
    {
        [SingletonClass sharedSingleton].profileForSecondUser=FALSE;

    }
    else
    {
        [SingletonClass sharedSingleton].profileForSecondUser=TRUE;
 
    }
    [self checkFriend:objRank[@"UserId"]];
    
}
-(void)fetrchUserTocheckPrivacy:(NSString *)userId
{
    
    PFQuery * queryUsetr=[PFQuery queryWithClassName:@"_User"];
    [queryUsetr whereKey:@"objectId" equalTo:userId];
    
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            NSArray * temp=[queryUsetr findObjects];
            BOOL checkBlock;
            NSLog(@"detail of ranking user %@",temp);
            PFObject * objUserDetail=[temp objectAtIndex:0];
            profileUser.noOfFriends=[NSNumber numberWithInt:[objUserDetail[@"Friends"] count]];
            if(objUserDetail[@"deviceId"])
            {
            [SingletonClass sharedSingleton].secondPlayerInstallationId=objUserDetail[@"deviceId"];
            profileUser.quickBloxId= objUserDetail[@"Quickbloxid"];
            }
            [SingletonClass sharedSingleton].secondPlayerObjid=userId;
           if([objUserDetail[@"BlockUser"] containsObject:[SingletonClass sharedSingleton].objectId ])
           {
               checkBlock=TRUE;
           }
          else
           {
            checkBlock=FALSE;
           }
            
            //objUserDetail[@"PrivacyMode"];

            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               profileUser.checkBlock=checkBlock;
                               @try
                               {
                                   [self.navigationController pushViewController:profileUser animated:YES];
                               } @catch (NSException * e)
                               {
                                   [self.navigationController popToViewController:profileUser animated:NO];
                                                                    NSLog(@"Exception: %@", e);
                               } @finally {
                                   //NSLog(@"finally");
                               }
                               
                           });

        }
    });
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
