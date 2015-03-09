//
//  ChatScreenMessageViewController.m
//  QuizBattle
//
//  Created by GLB-254 on 11/4/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import "ChatScreenMessageViewController.h"
#import "PTSMessagingCell.h"
#import "SingletonClass.h"
#import "AppDelegate.h"
@interface ChatScreenMessageViewController ()

@end

@implementation ChatScreenMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) goToPreviousView:(NSNotification *)notify
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self createTableandUi];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
   
    
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDismissView object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPreviousView:) name:KDismissView object:nil];
    _messages=[[NSMutableArray alloc]init];
    [self retriveMessagefromHistory];
  //  [self headerForChat];
    self.view.backgroundColor=[UIColor whiteColor];
    //self.view.frame=CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
    if(!messageG)
    {
        messageG = [[QBChatMessage alloc] init];
        [[QBChat instance] setDelegate:self];
    }

   if([[QBChat instance]isLoggedIn])
   {
    
   }
   else
   {
        [self chatLogin];
    }

}
#pragma mark QBChat-----------
-(void)chatLogin
{
    QBUUser *currentUser = [QBUUser user];
     NSLog(@"Quick BloxId of user%d",[[SingletonClass sharedSingleton].quickBloxId intValue]);
    currentUser.ID =[[SingletonClass sharedSingleton].quickBloxId intValue]; // your current user's ID
    currentUser.password =@"globussoft123"; // your current user's password
    
    // set Chat delegate
    [QBChat instance].delegate = self;
    // login to Chat
    [[QBChat instance] loginWithUser:currentUser];
}
#pragma mark -
#pragma mark QBChatDelegate

// Chat delegate
-(void) chatDidLogin
{
    //[self createTableandUi];
    // You have successfully signed in to QuickBlox Chat
    //[self sendMessage];
}

-(void)headerForChat
{
    UIView * headerChat=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerChat.backgroundColor=[UIColor blackColor];
    [self.view addSubview:headerChat];
    UIButton * backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerChat addSubview:backBtn];
    
     // [appdelegate.window addSubview:headerChat];
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-60, 40)];
    titleLabel.text=@"Chatting Screen";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerChat addSubview:titleLabel];
    //AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    //    [appdelegate.window addSubview:obj.view];
    
    
    }
-(void)createTableandUi
{
   // AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [NSTimer scheduledTimerWithTimeInterval:60 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
    messageTable=[[UITableView alloc]init];
    
    if([self.previousView isEqualToString:@"Message"])
    {
        messageTable.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height-80);
    }
    else
    {
      messageTable.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80);
    }
    messageTable.delegate=self;
   messageTable.dataSource=self;
    messageTable.separatorColor=[UIColor clearColor];
    messageTable.backgroundColor=[UIColor clearColor];
    //
   
    [self.view addSubview:messageTable];

    //---------
    typeMsg=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height-80, self.view.bounds.size.width, 70)];
    typeMsg.backgroundColor=[UIColor whiteColor];
  [self.view addSubview:typeMsg];
   if([self.previousView isEqualToString:@"Message"])
    {
        NSLog(@"Frame of this view%f %f",self.view.bounds.size.height,self.view.bounds.size.width);
        typeMsg.frame=CGRectMake(0, 270, self.view.frame.size.width, 70);
    }
//    else
//    {
//        typeMsg.frame=CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 70);
//  
//    }
    

   // [appdelegate.window addSubview:typeMsg];
    msgType=[[UITextField alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-80, 40)];
    msgType.backgroundColor=[UIColor whiteColor];
    UIImageView * imgEmail=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"email.png"]];
    imgEmail.frame=CGRectMake(0, 0, imgEmail.image.size.width+20, imgEmail.image.size.height);
    imgEmail.contentMode=UIViewContentModeCenter;
    msgType.leftView=imgEmail;
    [msgType setLeftViewMode:UITextFieldViewModeAlways];
   msgType.layer.cornerRadius=5;
    msgType.layer.borderColor=[UIColor greenColor].CGColor;
     msgType.layer.masksToBounds=YES;
    msgType.layer.borderWidth=1.5;
    msgType.delegate=self;
    [typeMsg addSubview:msgType];
    UIButton * send=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 20, 50, 40)];
    [send setTitle:@"Send" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [typeMsg addSubview:send];
    //[ self adjustHeightOfTableview];

}
-(void)backBtnAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
    typeMsg=nil;
    typeMsg.hidden=TRUE;
}

#pragma mark Table Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"message count %d",[_messages count]);
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*This method sets up the table-view.*/
    
    static NSString* cellIdentifier = @"messagingCell";
    
    PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor=[UIColor clearColor];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = nil;
    dict=[_messages objectAtIndex:indexPath.row];
    CGSize messageSize = [PTSMessagingCell messageSize:[dict objectForKey:@"message"]];
        return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 20.0f;
}

-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
    //History messages
    NSDictionary *dict = nil;
    dict=[_messages objectAtIndex:indexPath.row];
//    if([self.historyMessages count]>indexPath.row)
//    {
//        NSLog(@"%lu",(unsigned long)[self.historyMessages count]);
//    QBChatAbstractMessage * msg=[self.historyMessages objectAtIndex:indexPath.row];
//    NSLog(@"Messages: %@ id %lu", msg.text,(unsigned long)msg.recipientID);
// 
//    if([[SingletonClass sharedSingleton].quickBloxId intValue]==msg.senderID)
//    {
//        ccell.sent=YES;
//        ccell.avatarImageView.image=[SingletonClass sharedSingleton].imageUser;
//        ccell.ballonImageName=@"balloon_selected_left.png";
//    }
//    else
//    {
//        ccell.sent=NO;
//        ccell.avatarImageView.image=self.opponenetImage;
//        ccell.ballonImageName=@"balloon_read_right.png";
//    }
//        ccell.messageLabel.text = [_messages objectAtIndex:indexPath.row];
//    }
//    //Normal messages
//    else
//    {
        ccell.messageLabel.text =[dict objectForKey:@"message"];
        if([[dict objectForKey:@"flag"] isEqualToString:@"Yes"])
        {
           ccell.sent=YES;
        }
        else
        {
           ccell.sent=NO;
        }
    
    if(ccell.sent)
    {
         ccell.avatarImageView.image=self.opponenetImage;
        ccell.ballonImageName=@"balloon_read_right.png";
    
    }
    else
    {
        ccell.avatarImageView.image=[SingletonClass sharedSingleton].imageUser;
        ccell.ballonImageName=@"balloon_selected_left.png";
    }
    
    //}

}
#pragma mark -
#pragma mark QBChatDelegate

- (void)chatDidReceiveMessage:(QBChatMessage *)message
{
    if(message.senderID==[self.reciepentId  intValue])
    {
        [self setMessageInDictionary:message.text flag:@"No"];
    }
        NSLog(@"ChatMessage=%@",message);
    NSLog(@"Message in text=%@",message.text);
    [messageTable reloadData];
    
}
- (void)chatDidFailWithError:(NSInteger)code
{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatDisconnect" object:nil];
    
}
-(void)retriveMessagefromHistory
{
    NSMutableDictionary *extendedreq=[NSMutableDictionary new];
    extendedreq[@"limit"]=@50;
    if(self.dialogId)
    {
    [QBChat messagesWithDialogID:self.dialogId extendedRequest:extendedreq delegate:self ];
    }
}

#pragma mark - QBActionStatusDelegate
#pragma mark

- (void)completedWithResult:(Result *)result
{
    if (result.success && [result isKindOfClass:QBChatHistoryMessageResult.class])
    {
        QBChatHistoryMessageResult *res = (QBChatHistoryMessageResult *)result;
        NSArray *messages = res.messages;
        self.historyMessages=[NSArray arrayWithArray:messages];
        for(int i=0;i<[messages count];i++)
        {
        QBChatAbstractMessage * msg=[messages objectAtIndex:i];
            if(msg.text)
            {
                    if([[SingletonClass sharedSingleton].quickBloxId intValue]==msg.senderID)
            {
                [self setMessageInDictionary:msg.text flag:@"Yes"];
            }
            else
            {
                [self setMessageInDictionary:msg.text flag:@"No"];
            }
            }
            
            
        }
        [messageTable reloadData];
        
    }
}
-(void)sendAction:(id)sender
{
    if([msgType.text isEqualToString:@""])
    {
        return;
    }
    senderFlag=FALSE;
    [self setMessageInDictionary:msgType.text flag:@"Yes"];
    NSLog(@"dynamic content height %f %f",messageTable.contentSize.height,messageTable.frame.size.height);
    [messageTable reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0];
    [messageTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    if([[QBChat instance]isLoggedIn])
    {
    messageG.text =msgType.text;
    msgType.text=@"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [messageG setCustomParameters:params];
    NSLog(@"recipent ID %@",self.reciepentId);
    messageG.recipientID =[self.reciepentId intValue];
    messageG.senderID=[[SingletonClass sharedSingleton].quickBloxId intValue];
    NSLog(@"reciepent Id%lu and senderId%d",(unsigned long)messageG.recipientID,messageG.senderID);
    [[QBChat instance] sendMessage:messageG];
    }
    else
    {
        
    }
    
}
#pragma mark-------
#pragma mark Text Field delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    typeMsg.frame=CGRectMake(0, self.view.frame.size.height-290, self.view.bounds.size.width, 70);
    if([self.previousView isEqualToString:@"Message"])
    {
        typeMsg.frame=CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, self.view.frame.size.height-80);
    }
 typeMsg.frame=CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, self.view.frame.size.height-80);
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    typeMsg.frame=CGRectMake(0,self.view.frame.size.height-170, self.view.frame.size.width, 70);
    if([self.previousView isEqualToString:@"Message"])
    {
        typeMsg.frame=CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width, self.view.frame.size.height-80);
    }
 typeMsg.frame=CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width, self.view.frame.size.height-80);
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
-(void)setMessageInDictionary:(NSString*)messageL flag:(NSString*)flag
{
    NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
    [dict setValue:messageL forKey:@"message"];
    [dict setValue:flag forKey:@"flag"];
    [_messages addObject:dict];
}
- (void)adjustHeightOfTableview
{
    CGFloat height = messageTable.contentSize.height;
    CGFloat maxHeight = messageTable.superview.frame.size.height - messageTable.frame.origin.y;
    
    // if the height of the content is greater than the maxHeight of
    // total space on the screen, limit the height to the size of the
    // superview.
    
    if (height > maxHeight)
        height = maxHeight;
    
    // now set the frame accordingly
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = messageTable.frame;
        frame.size.height = height;
        messageTable.frame = frame;
        
        // if you have other controls that should be resized/moved to accommodate
        // the resized tableview, do that here, too
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    
    
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
