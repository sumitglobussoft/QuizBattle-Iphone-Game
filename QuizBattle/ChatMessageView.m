//
//  ChatMessageView.m
//  QuizBattle
//
//  Created by GLB-254 on 9/22/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import "ChatMessageView.h"
#import "PTSMessagingCell.h"
#import "ViewController.h"
#import "SingletonClass.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface ChatMessageView ()

@end

@implementation ChatMessageView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.arrFetchDetails = [[NSArray alloc] init];
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
}
-(void)goToPreviousView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrNewFetchDetails = [[NSArray alloc] init];
    arrUserIds = [[NSMutableArray alloc] init];
    mutArrUserImages = [[NSMutableArray alloc] init];
    _messages = [[NSMutableArray alloc] init];
    
    [arrUserIds addObject:@"usid"];
    [self.view setBackgroundColor:[UIColor colorWithRed:80.0f/255.0f green:191.0f/255.0f blue:180.0f/255.0f alpha:1.0f]];
    self.lblDiscussionTopic = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, self.view.frame.size.width, 30)];
    self.lblDiscussionTopic.textAlignment=NSTextAlignmentCenter;
    self.lblDiscussionTopic.font=[UIFont boldSystemFontOfSize:20];
    self.lblDiscussionTopic.textColor=[UIColor whiteColor];
  
    [self.view addSubview:self.lblDiscussionTopic];
    
    self.messageTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-190)];
    self.messageTable.delegate=self;
    self.messageTable.dataSource=self;
    self.messageTable.separatorColor=[UIColor clearColor];
    self.messageTable.backgroundColor=[UIColor clearColor];
    UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 12)];
    self.messageTable.tableFooterView=footerView;
     [self.view addSubview:self.messageTable];
    typeMsg=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-190, self.view.bounds.size.width, 50)];
    typeMsg.backgroundColor=[UIColor whiteColor];
    //---------
    self.msgType=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, self.view.bounds.size.width-80, 40)];
    self.msgType.backgroundColor=[UIColor whiteColor];
  
    UIImageView * imgEmail=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"email.png"]];
    imgEmail.frame=CGRectMake(0, 0, imgEmail.image.size.width+20, imgEmail.image.size.height);
    imgEmail.contentMode=UIViewContentModeCenter;
    self.msgType.leftView=imgEmail;
    [self.msgType setLeftViewMode:UITextFieldViewModeAlways];
    self.msgType.layer.cornerRadius=5;
    self.msgType.layer.borderWidth=1;
    self.msgType.layer.borderColor=[UIColor greenColor].CGColor;
    self.msgType.delegate=self;
    [typeMsg addSubview:self.msgType];
   
    
    UIButton * send=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 50, 40)];
    [send setTitle:@"Send" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:typeMsg];
    [typeMsg addSubview:send];
    
   [self fetchDiscussion];
   
//    [NSTimer scheduledTimerWithTimeInterval: 15
//                                      target:self
//                                    selector:@selector(fetchDiscussion)
//                                    userInfo:nil
//                                     repeats:YES];
//    [self performSelector:@selector(fetchDiscussion) withObject:nil afterDelay:5];
}
-(void)displayDiscussionChat {
    //changed it to 0 from 1
    NSLog(@"discussionChatArry==%@",self.arrNewFetchDetails);
    if (self.arrNewFetchDetails.count>0)
    {
        
        self.lblHeader.text=[SingletonClass sharedSingleton].strSelectedSubCat;
        self.lblDiscussionTopic.text=self.disTopic;
        NSLog(@"subCategory=-=-%@",self.lblDiscussionTopic.text);
        
        for (int i=0; i<self.arrNewFetchDetails.count; i++)
        {
            PFObject *obj=[self.arrNewFetchDetails objectAtIndex:i];
            NSString *strComment=obj[@"Comment"];
            [_messages addObject:strComment];
            NSString *imgUrl=obj[@"userimage"];
            NSURL *url=[NSURL URLWithString:imgUrl];
            NSLog(@"%@",url);
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSURLResponse *response;
            NSError *error;
            
            NSData *data=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
            if (error == nil && data !=nil) {
                [mutArrUserImages addObject:[UIImage imageWithData:data]];
            }
        }
    }
    [self.messageTable reloadData];
}-(void)fetchUserImage
{
    
    PFQuery *query = [PFUser query];
    
    for (int i=0; i<[arrUserIds count]; i++) {
        
        if ([[arrUserIds objectAtIndex:i] isEqualToString:[SingletonClass sharedSingleton].objectId]) {
            
            [mutArrUserImages addObject:[SingletonClass sharedSingleton].imageUser];
        }
        else{
            [query whereKey:@"objectId" equalTo:[arrUserIds objectAtIndex:i]];
            
            NSArray *arr = [query findObjects];
            
            NSDictionary *dict = [arr objectAtIndex:0];
            
            PFFile  *strImage = [dict objectForKey:@"userimage"];
            
            NSData *imageData = [strImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            if (imageData) {
                [mutArrUserImages addObject:image];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(),^(void) {
        [self.messageTable reloadData];
    });
    
}

-(void)backBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Table Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*This method sets up the table-view.*/
    
    static NSString* cellIdentifier = @"messagingCell";
    
    PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.ballonImageName=@"gameplay_left_player_bg";
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize messageSize = [PTSMessagingCell messageSize:[_messages objectAtIndex:indexPath.row]];
    return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 20.0f;
}

/////////cell configure///////////////
-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
    ccell.messageLabel.text = [_messages objectAtIndex:indexPath.row];
    if([self.arrNewFetchDetails count]>indexPath.row)
    {
       PFObject * objName=[self.arrNewFetchDetails objectAtIndex:indexPath.row];
        NSLog(@"Created At %@  %@",objName.createdAt,objName[@"createdAt"]);
    NSString * createdeAt=[self compareDate:objName.createdAt];
    NSString * strTimelbl=[NSString stringWithFormat:@"%@      %@",objName[@"username"],createdeAt];
        ccell.timeLabel.text=strTimelbl;
    }
    else
    {
        NSDate *currentDate=[NSDate date];
        NSLog(@"Current Date==%@",currentDate);
        NSString * strToShow=[self compareDate:currentDate];
        NSString * strTimelbl=[NSString stringWithFormat:@"%@      %@",[SingletonClass sharedSingleton].strUserName,strToShow];
        ccell.timeLabel.text=strTimelbl;
    }
    //---------------------
    
    
    
    
    //---------------------
    ccell.avatarImageView.image=[mutArrUserImages objectAtIndex:indexPath.row];
    ccell.avatarImageView.layer.cornerRadius=ccell.avatarImageView.frame.size.width/2.0;
    ccell.avatarImageView.clipsToBounds=YES;
    ccell.avatarImageView.layer.borderWidth = 3.0f;
}
#pragma mark-------
#pragma mark Text Field delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    typeMsg.frame=CGRectMake(0, self.view.bounds.size.height-240, self.view.bounds.size.width, 70);
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
   
    typeMsg.frame=CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50);
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

-(void)fetchDiscussion
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIImageView *imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(appdelegate.window.frame.size.width/2-10, appdelegate.window.frame.size.height/2-30, 30, 50)];
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
     dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
   if([[SingletonClass sharedSingleton].discussionObjectId length]>0)
   {
    PFQuery *query = [PFQuery queryWithClassName:@"DiscussionComment"];
    [query whereKey:@"DiscussionId" equalTo:[SingletonClass sharedSingleton].discussionObjectId];
    [query orderByAscending:@"createdAt"];
       
    NSLog(@"Discussion Id -==- %@",[SingletonClass sharedSingleton].discussionObjectId);
    self.arrNewFetchDetails=[query findObjects];
            
            NSLog(@"Array =-=- %@",self.arrNewFetchDetails);
            dispatch_async(dispatch_get_main_queue(),^(void) {
                [imageVAnim stopAnimating];
                [self displayDiscussionChat];
            });
   }
            else
            {
                dispatch_async(dispatch_get_main_queue(),^(void)
                               {
                                   [imageVAnim stopAnimating];
                    [self displayDiscussionChat];
                });
            }
            //[self.messageTable reloadData];
        }
    });
    
    }
-(void)displayNewDiscussionChat {
    
    if (self.arrNewFetchDetails.count>1) {
        
        if (self.arrNewFetchDetails.count>self.arrFetchDetails.count) {
           
            for (NSInteger i=self.arrFetchDetails.count; i<self.arrNewFetchDetails.count; i++)
            {
                
                    NSDictionary *dict = [self.arrNewFetchDetails objectAtIndex:i];
                    NSString *strComment = [dict objectForKey:@"Comment"];
                    
                    [_messages addObject:strComment];
                    
                    NSString *strUserId = [dict objectForKey:@"UserId"];
                    [arrUserIds addObject:strUserId];
            }
        }
    }
    [NSThread detachNewThreadSelector:@selector(fetchUserImage) toTarget:self withObject:nil];
}
-(void)sendAction
{
    NSString *strMessage = self.msgType.text;
    if([self.msgType.text isEqualToString:@""])
    {
        return;
    }
    [_messages addObject:self.msgType.text];
    self.msgType.text=@"";
    
    PFObject *object = [PFObject objectWithClassName:@"DiscussionComment"];
    object[@"Comment"]=strMessage;
    object[@"DiscussionId"]=[SingletonClass sharedSingleton].discussionObjectId;
    object[@"UserId"]=[SingletonClass sharedSingleton].objectId;
    object[@"SubCategoryName"]=[SingletonClass sharedSingleton].strSelectedSubCat;
    if(self.disName)
    {
        object[@"username"]=self.disName;
        object[@"userimage"]=self.imageUrl;
    }
    else
    {
        object[@"username"]=[SingletonClass sharedSingleton].strUserName;
        object[@"userimage"]=[SingletonClass sharedSingleton].imageFileUrl;
    }
   
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [object saveEventually:^(BOOL succeed, NSError *error){
            
            if (succeed) {
                NSLog(@"Save to Parse");
                [mutArrUserImages addObject:[SingletonClass sharedSingleton].imageUser];
                [self.messageTable reloadData];
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
        }];
    });
}

-(NSString*)compareDate:(NSDate*)oldDate
{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSString *strCurrentDate = [formatter stringFromDate:currentDate];
    
    currentDate=[formatter dateFromString:strCurrentDate];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
     NSString *strOldDate = [formatter1 stringFromDate:oldDate];
    NSDate *oldDateFormatted = [formatter1 dateFromString:strOldDate];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDateFormatted  toDate:currentDate  options:0];
    
   int months = (int)[conversionInfo month];
    int days = (int)[conversionInfo day];
    int hours = (int)[conversionInfo hour];
    int minutes = (int)[conversionInfo minute];
    int seconds = (int)[conversionInfo second];
    

    
    NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
    NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
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
        return [NSString stringWithFormat:@"Just Now"];
    }
}
- (void)adjustHeightOfTableview
{
    CGFloat height = self.messageTable.contentSize.height;
    CGFloat maxHeight = self.messageTable.superview.frame.size.height - self.messageTable.frame.origin.y;
    
    // if the height of the content is greater than the maxHeight of
    // total space on the screen, limit the height to the size of the
    // superview.
    
    if (height > maxHeight)
        height = maxHeight;
    
    // now set the frame accordingly
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.messageTable.frame;
        frame.size.height = height;
        self.messageTable.frame = frame;
        
        // if you have other controls that should be resized/moved to accommodate
        // the resized tableview, do that here, too
    }];
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
