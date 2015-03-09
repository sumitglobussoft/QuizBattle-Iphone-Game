//
//  MessagesViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "MessagesViewController.h"
#import "ViewController.h"
#import "ChatMessageView.h"
#import "ChatScreenMessageViewController.h"
#import "MessageCustomCell.h"
@interface MessagesViewController ()

@end

@implementation MessagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self chatLogin];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    NSArray *arrAnimImages = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"burning_rocket_01.png"],
                              [UIImage imageNamed:@"burning_rocket_02.png"],
                              [UIImage imageNamed:@"burning_rocket_03.png"],
                              [UIImage imageNamed:@"burning_rocket_04.png"],
                              [UIImage imageNamed:@"burning_rocket_05.png"],
                              [UIImage imageNamed:@"burning_rocket_06.png"],
                              [UIImage imageNamed:@"burning_rocket_07.png"],
                              [UIImage imageNamed:@"burning_rocket_08.png"], nil];
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10,100, 30, 50)];
    [self.view addSubview:imageVAnim];

    imageVAnim.animationImages=arrAnimImages;
    imageVAnim.animationDuration=0.5;
    imageVAnim.animationRepeatCount=0;
    [imageVAnim startAnimating];
    
    
    frameSize = [UIScreen mainScreen].bounds.size;
    timeDuration=[[NSMutableArray alloc]initWithObjects:[ViewController languageSelectedStringForKey:@"1 day ago"],[ViewController languageSelectedStringForKey:@"2 day ago"], nil];
    playerImages=[[NSMutableArray alloc]init];
    senderName=[[NSMutableArray alloc]init];
  //  [self fetchFriendsToChat];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatLogin) name:@"ChatDisconnect" object:nil];
    
    [self chatLogin];
    
    
    
}
-(void)createTable
{
    if(!messageTable)
    {
    messageTable=[[UITableView alloc]init];
    }
    messageTable.frame=CGRectMake(20, 0, frameSize.width-40, frameSize.height-140);
    messageTable.delegate=self;
    messageTable.dataSource=self;
    [messageTable setBackgroundColor:[UIColor clearColor]];
    messageTable.separatorColor=[UIColor clearColor];
    messageTable.bounces=NO;
    messageTable.showsVerticalScrollIndicator=NO;
    unreadMessages=[[NSMutableArray alloc]initWithObjects:@"How are you?", nil];
    readMessages=[[NSMutableArray alloc]initWithObjects:@"Hi", nil];
    [self.view addSubview:messageTable];

}
#pragma mark ===============================
#pragma mark Table View delegates Methods
#pragma mark ===============================

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%lu",(unsigned long)[self.dialogIds count]);
    if([self.dialogIds count]>0)
   {
    if(nomessageView)
    {
        [nomessageView removeFromSuperview];
    }
   }
    return [self.dialogIds count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

  
           return 48.5;
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MessageViewCell";
    
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
       
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    @try
    {
        cell.topView.frame =CGRectMake(0, 0, 280,50);
        QBChatDialog * chDialog=[self.dialogIds objectAtIndex:indexPath.section];
        cell.messageLable.frame=CGRectMake(60, 5, 260, 20);
        cell.messageLable.text=[senderName objectAtIndex:indexPath.section];
        NSLog(@"name in message %@",cell.messageLable.text);
        cell.lblDescription.frame=CGRectMake(60, 28, 260, 20);
        cell.lblDescription.text=chDialog.lastMessageText;
        cell.playerImageIcon.image=[playerImages objectAtIndex:indexPath.section];
    }
    @catch (NSException *exception) {
        
    }
   
   
    return cell;
}
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
   ChatScreenMessageViewController * obj=[[ChatScreenMessageViewController alloc]init];
    QBChatDialog * chatDialog=[self.dialogIds objectAtIndex:indexPath.section];
    obj.dialogId=chatDialog.ID;
    obj.reciepentId=[NSString stringWithFormat:@"%ld",(unsigned long)chatDialog.recipientID];
    obj.opponenetImage=[playerImages objectAtIndex:indexPath.section];
    obj.previousView=@"Message";
  //[self presentViewController:obj animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Message_First"];
    [self.navigationController pushViewController:obj animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Retrive Dialogs
-(void)retriveDialogs
{
NSMutableDictionary *extendedRequest = [NSMutableDictionary new];
extendedRequest[@"limit"] = @(10);
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
        self.dialogIds=[NSArray arrayWithArray:dialogs];
        [SingletonClass sharedSingleton].dialogsId=dialogs;
        [self retriveAlluserDetails];
        NSLog(@"Dialogs: %@", dialogs);
    }
}
-(void)retriveAlluserDetails
{
    

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
      
    for(int i=0;i<[self.dialogIds count];i++)
    {
    QBChatDialog * chDialog=[self.dialogIds objectAtIndex:i];
//        chDialog.lastMessageText;
//        chDialog.lastMessageDate;
        
          //retrive user image
       
        PFQuery * query=[PFQuery queryWithClassName:@"_User"];
        
        NSString * strId=[NSString stringWithFormat:@"%ld",(unsigned long)chDialog.recipientID];
        [query whereKey:@"Quickbloxid" equalTo:strId];
            [query selectKeys:@[@"userimage",@"name"]];
        NSLog(@"Reciepent Id %@",strId);
            NSArray * temp=[query findObjects];
        if([temp count]>0)
        {
            
            PFObject * objName=[temp objectAtIndex:0];
        [senderName addObject:objName[@"name"]];
        }
            NSLog(@"message use data%@",temp);
            if([temp count]>0)
            {
             
                PFObject * obj=[temp objectAtIndex:0];
                PFFile  *strImage = obj[@"userimage"];
                NSLog(@"%@ user image url lastmessageText %@",strImage.url,chDialog.lastMessageText);
                NSData *imageData = [strImage getData];
                UIImage *image = [UIImage imageWithData:imageData];
                if(image)
                {
                   [playerImages addObject:image];
                }
                else
                {
                    [playerImages addObject:[UIImage imageNamed:@"1.png"]];
                }
                

            }
        
        }
        
        
         dispatch_async(dispatch_get_main_queue(), ^{
            if([self.dialogIds count])
            {
                if(!messageTable)
                {
                [self createTable];
                }
                else
                {
                    [messageTable reloadData];
                }
            }
             else
             {
                 [self noMessageUI];
             }
             [imageVAnim stopAnimating];
         });
    });
}
-(void)noMessageUI
{
    if (!nomessageView)
    {
          nomessageView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
        [self.view addSubview:nomessageView];

    }
    UILabel *lblHeading=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2+10, self.view.frame.size.width,50)];
    lblHeading.textColor=[UIColor blackColor];
    lblHeading.text=@"받은 편지함 빈";
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.font=[UIFont boldSystemFontOfSize:20];
    [nomessageView addSubview:lblHeading];
    
    UILabel *labelDesc=[[UILabel alloc]initWithFrame:CGRectMake(0,lblHeading.frame.origin.y+10,self.view.frame.size.width, 100)];
    labelDesc.text=@"All your converstions with QuizBattle Players will be stored over here";
    labelDesc.numberOfLines=2;
    labelDesc.lineBreakMode=NSLineBreakByWordWrapping;
    labelDesc.textAlignment=NSTextAlignmentCenter;
    labelDesc.font=[UIFont boldSystemFontOfSize:16];
    labelDesc.textColor=[UIColor blackColor];
    //[self.view addSubview:labelDesc];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-70, self.view.frame.size.height/2.0-100,143,107)];
    imgView.image=[UIImage imageNamed:@"no_message.png"];
    [nomessageView addSubview:imgView];
    
    
    
}
#pragma mark QBChat-----------
-(void)chatLogin
{
QBUUser *currentUser = [QBUUser user];
   // NSLog(@"%d",[[SingletonClass sharedSingleton].quickBloxId intValue]);
    currentUser.ID =[[SingletonClass sharedSingleton].quickBloxId intValue]; // your current user's ID
currentUser.password =@"globussoft123"; // your current user's password

// set Chat delegate
[QBChat instance].delegate = self;
// login to Chat
  if([[QBChat instance]isLoggedIn])
  {
     
      [self retriveDialogs];
 
  }
  else
  {
    [[QBChat instance] loginWithUser:currentUser];
  }

}
#pragma mark -
#pragma mark QBChatDelegate

// Chat delegate
-(void) chatDidLogin
{
       [self retriveDialogs];
    // You have successfully signed in to QuickBlox Chat
    //[self sendMessage];
}
//#pragma mark -
//#pragma mark QBActionStatusDelegate
//
//- (void)completedWithResult:(Result *)result{
//    if (result.success && [result isKindOfClass:[QBChatDialogResult class]]) {
//        QBChatDialogResult *res = (QBChatDialogResult *)result;
//        QBChatDialog *dialog = res.dialog;
//        NSLog(@"Dialog: %@", res.dialog);
//    }
//    else if (result.success && [result isKindOfClass:[QBDialogsPagedResult class]])
//    {
//        QBDialogsPagedResult *pagedResult = (QBDialogsPagedResult *)result;
//        NSArray *dialogs = pagedResult.dialogs;
//        //        NSSet *dialogIds=pagedResult.dialogsUsersIDs;
//        NSLog(@"Dialogs: %@", dialogs);
//    }
//}
#pragma mark====
-(void)fetchFriendsToChat
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        PFQuery * query=[PFQuery queryWithClassName:@"_User"];
        [query whereKey:@"Friends" equalTo:[SingletonClass sharedSingleton].objectId];
        NSArray * temp=[query findObjects];
        NSLog(@"%@",temp);
    });
}


@end
