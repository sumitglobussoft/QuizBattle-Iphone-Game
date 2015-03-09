//
//  ContactsViewController.m
//  QuizBattle
//
//  Created by Sumit Ghosh on 11/09/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "ContactsViewController.h"
#import <Parse/Parse.h>
#import "MessageCustomCell.h"
#import "SingletonClass.h"
@interface ContactsViewController ()

@end

@implementation ContactsViewController

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
    [self fetchDataFromParse];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //-------------
    reqSenderName=[[NSMutableArray alloc]init];
    reqSenderImg=[[NSMutableArray alloc]init];
    reqObjectIds=[[NSMutableArray alloc]init];
    frndreqObjectIds=[[NSMutableArray alloc]init];
    arrUsername=[[NSMutableArray alloc]init];
    //------------
   self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    
}
-(void)createTableUi
{
    currentSelection=-1;
    requestTableView=[[UITableView alloc]initWithFrame:CGRectMake(20,0,self.view.frame.size.width-40,self.view.frame.size.height-80)];
    requestTableView.delegate=self;
    requestTableView.dataSource=self;
    requestTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    requestTableView.backgroundColor=[UIColor clearColor];
    requestTableView.bounces=NO;
    requestTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:requestTableView];

}
-(void)noRequestsToShow
{
    UILabel *lblHeading=[[UILabel alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2-40, self.view.frame.size.width-40,50)];
    lblHeading.textColor=[UIColor blackColor];
    lblHeading.text=@"친구 요청이 없습니다";
    lblHeading.backgroundColor=[UIColor whiteColor];
    //[ViewController languageSelectedStringForKey:@"No Requests To Display"];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:lblHeading];
//    
//    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(110, self.view.frame.size.height/2.0-90, 100,100)];
//    imgView.image=[UIImage imageNamed:@"no_friend"];
//    [self.view addSubview:imgView];
}

 #pragma mark=========================
#pragma mark Accept and Reject Action
#pragma mark=========================
-(void)acceptReqAction:(UIButton *)sender
{
    NSString *objId=[reqObjectIds objectAtIndex:sender.tag];
    NSString *frndReqObjId=[frndreqObjectIds objectAtIndex:sender.tag];
    NSString *username=[arrUsername objectAtIndex:sender.tag];
    //NSArray *arr=[[NSArray alloc]initWithObjects:objId, nil];
    NSLog(@"Object Id==%@",objId);
    PFObject *obj=[PFObject objectWithoutDataWithClassName:@"_User" objectId:[SingletonClass sharedSingleton].objectId];
    [obj addObject:objId forKey:@"Friends"];
    [obj saveInBackgroundWithBlock:^(BOOL succed,NSError *error)
     {
         if (succed)
         {
             NSLog(@"Saved in Parse");
             [self callCloudCodeFriend:[SingletonClass sharedSingleton].objectId username:username];
             [self deleteRowFromfrndReq:frndReqObjId indexValue:sender.tag];
         }
         else
         {
             NSLog(@"Error==%@",error);
         }
     }];
}
-(void)callCloudCodeFriend:(NSString *)frndId username:(NSString*)username
{
    
    [PFCloud callFunctionInBackground:@"FriendRequest"
                       withParameters:@{@"id": frndId,@"username":username}
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
-(void)rejectBtnAction:(UIButton *)sender
{
    NSString *objId=[frndreqObjectIds objectAtIndex:sender.tag];
    NSLog(@"Object Id==%@",objId);
    [self deleteRowFromfrndReq:objId indexValue:sender.tag];
    
    
}
-(void)deleteRowFromfrndReq:(NSString *)objId indexValue:(NSUInteger)atIndex
{
    NSLog(@"IndexValue==%lu",(unsigned long)atIndex);
    NSLog(@"deleted Row Object Id==-==%@",objId);
    PFQuery *query=[PFQuery queryWithClassName:@"FriendRequest"];
    [query getObjectInBackgroundWithId:objId block:^(PFObject *object,NSError *error)
     {
         [object deleteInBackgroundWithBlock:^(BOOL suceeed,NSError *error)
          {
              if (suceeed) {
                  NSLog(@"Deleted Sucessfully");
                  [self tablereloadMethod:atIndex];
                  
              }
              else
              {
                  NSLog(@"Error==%@",error);
              }
          }];
     }];
    
}
-(void)tablereloadMethod:(NSUInteger)indexValue
{
    NSLog(@"IndexValue==%lu",(unsigned long)indexValue);
    [reqSenderImg removeObjectAtIndex:indexValue];
    
    [reqSenderName removeObjectAtIndex:indexValue];
    NSLog(@"Request Details==%@",reqSenderName);
    
    [frndreqObjectIds removeObjectAtIndex:indexValue];
    NSLog(@"Object Id of frnd req array==%@",frndreqObjectIds);
    [reqObjectIds removeObjectAtIndex:indexValue];
    NSLog(@"Req Object Id of User==%@",reqObjectIds);
    currentSelection=-1;
    [requestTableView reloadData];
}
 #pragma mark=========================
#pragma mark TableView Methods
#pragma mark=========================


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [reqSenderName count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *message=[reqSenderName objectAtIndex:indexPath.section];
    NSLog(@"Massage==%@",message);
    NSString *descriptionmsg=[NSString stringWithFormat:@"%@ sent a friend request",message];
    static NSString *cellIdentifier = @"RequestCell";
    
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.messageLable.text=message;
    cell.buttonView.hidden=YES;
    NSLog(@"My msg==%@",cell.messageLable.text);
    cell.topView.frame =CGRectMake(0, 0, 280, 60);
    cell.lblDescription.text=descriptionmsg;
    cell.iconImg.image=[reqSenderImg objectAtIndex:indexPath.section];
    cell.iconImg.layer.cornerRadius=cell.playerImageIcon.frame.size.width/2.0;
    cell.iconImg.clipsToBounds=YES;
    cell.btnAccept.tag=indexPath.section;
    [cell.btnAccept addTarget:self action:@selector(acceptReqAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnReject addTarget:self action:@selector(rejectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(20,0, self.view.frame.size.width-40, 40)];
    
    UILabel *headerLabel =[[UILabel alloc]initWithFrame:CGRectMake(80,10, 160, 30)];
    
    headerLabel.textColor=[UIColor darkGrayColor];
    headerLabel.font=[UIFont boldSystemFontOfSize:18];
    headerLabel.text=[ViewController languageSelectedStringForKey:@"Friend Requests"];
    
    if (section==0) {
        [headerview addSubview:headerLabel];
    }
    
    return headerview;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section==0) {
        return 50;
    }
    else
    {
        return 10;
    }
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Indexpath.section==%ld",(long)indexPath.section);
    if(currentSelection==indexPath.section)
    {
        currentSelection=-1;
        [requestTableView reloadData];
        return;
    }
    NSInteger row=[indexPath section];
    currentSelection=row;
    [UIView animateWithDuration:1 animations:^{
        [requestTableView reloadData];
    }];
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(currentSelection==indexPath.section)
    {
        return 110;
    }
    
    return 48.5;
}
#pragma mark-------
 //////////Query to fetch Data
-(void)fetchDataFromParse
{
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
    
       dispatch_async(dispatch_get_global_queue(0,0),^{
           
           PFQuery *query=[PFQuery queryWithClassName:@"FriendRequest"];
           NSLog(@"Onject Id %@",[SingletonClass sharedSingleton].objectId);
           [query whereKey:@"FriendId" equalTo:[SingletonClass sharedSingleton].objectId];
          [query includeKey:@"UserIdPointer"];
           NSArray *arrObject=[query findObjects];
        NSLog(@"Friend Request data %@",arrObject);
        for (int i=0;i<[arrObject count];i++) {
            PFObject *reqObj=[arrObject objectAtIndex:i];
            
            NSString *reqObjIdofUser=[reqObj[@"UserIdPointer"] objectId];
            [reqObjectIds addObject:reqObjIdofUser];
            
            
            NSString *reqSenderNameStr=reqObj[@"UserIdPointer"][@"name"];
            [reqSenderName addObject:reqSenderNameStr];
            [arrUsername addObject:reqObj[@"UserIdPointer"][@"username"]] ;
            NSString *reqobjIdofFriend=[reqObj objectId];
            NSLog(@"Object Id==-==%@",reqobjIdofFriend);
            [frndreqObjectIds addObject:reqobjIdofFriend];
            
            PFFile *strImage=reqObj[@"UserIdPointer"][@"userimage"];
            NSData *data=[strImage getData];
            if (data) {
                
                UIImage *img=[UIImage imageWithData:data];
                [reqSenderImg addObject:img];
                
            }
            
        }
        dispatch_async(dispatch_get_main_queue(),^{
            if([arrObject count]>0)
            {
            [self createTableUi];
                [requestTableView reloadData];
            }
            else
            {
                [self noRequestsToShow];
            }
             [imageVAnim stopAnimating];
        });
        
        
    });
}- (void)didReceiveMemoryWarning
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
