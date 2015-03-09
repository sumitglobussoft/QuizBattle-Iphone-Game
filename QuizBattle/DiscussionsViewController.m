//
//  DiscussionsViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "DiscussionsViewController.h"
#import "ChatMessageView.h"
@interface DiscussionsViewController ()

@end

@implementation DiscussionsViewController

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
    [self fetchDiscussionFromParseInDis];
}
-(void)viewDidDisappear:(BOOL)animated
{
   
    [self.discussionTable removeFromSuperview];
    self.discussionTable=nil;
    [arrDiscussionsTopic removeAllObjects];
    [crtdiscussnusrname removeAllObjects];
    [cmpareDate removeAllObjects];
    [mutArrUserImages removeAllObjects];
    [arrObjectIds removeAllObjects];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //=====
    arrDiscussionsTopic=[[NSMutableArray alloc]init];
    crtdiscussnusrname=[[NSMutableArray alloc]init];
    cmpareDate=[[NSMutableArray alloc]init];
    mutArrUserImages=[[NSMutableArray alloc]init];
    arrObjectIds=[[NSMutableArray alloc]init];
        //====
        //category=[[NSArray alloc]initWithObjects:@"Cricket", nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)noDiscussionUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0]];
    UILabel *lblHeading=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2+60, self.view.frame.size.width,50)];
    lblHeading.textColor=[UIColor blackColor];
    lblHeading.text=[ViewController languageSelectedStringForKey:@"NO RECENT DISCUSSIONS"];
    lblHeading.textAlignment=NSTextAlignmentCenter;
    lblHeading.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:lblHeading];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-65, self.view.frame.size.height/2.0-80, 137,136)];
    imgView.image=[UIImage imageNamed:@"no_discussion.png"];
    [self.view addSubview:imgView];
    
    
}
-(void)createTableUI
{
    if(!self.discussionTable)
    {
    self.discussionTable=[[UITableView alloc]initWithFrame:CGRectMake(20, 10,self.view.frame.size.width-40, self.view.frame.size.height-20) style:UITableViewStylePlain];
   self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    self.discussionTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.discussionTable.backgroundColor=[UIColor clearColor];
        self.discussionTable.bounces=NO;
    self.discussionTable.delegate=self;
    self.discussionTable.dataSource=self;
    self.discussionTable.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.discussionTable];
    
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, 40)];
    headerLabel.textColor=[UIColor blackColor];
    headerLabel.text=[ViewController languageSelectedStringForKey:@"Recent Discussion"];
    headerLabel.font=[UIFont boldSystemFontOfSize:20];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    [headerview addSubview:headerLabel];
    self.discussionTable.tableHeaderView=headerview;
    }
}
#pragma mark Table Delegates
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    return [[UIView alloc]initWithFrame:CGRectZero];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
        return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrDiscussionsTopic count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"Discussion";
    
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
         cell.topView.frame =CGRectMake(0, 0, 280, 50);
        cell.message.text=[crtdiscussnusrname objectAtIndex:indexPath.section];
        cell.lblDescription.text=[arrDiscussionsTopic objectAtIndex:indexPath.section];
        cell.messageLable.text=[cmpareDate objectAtIndex:indexPath.section];
        cell.iconImg.image=[mutArrUserImages objectAtIndex:indexPath.section];
        cell.iconImg.layer.cornerRadius=cell.iconImg.frame.size.width/2.0;
        cell.iconImg.clipsToBounds=YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //    cell.gameDelegate=self;
    
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SingletonClass sharedSingleton].discussionObjectId=[arrObjectIds objectAtIndex:indexPath.section];
    PFObject * objDis=[self.arrDiscussionDetails objectAtIndex:indexPath.section];
    [SingletonClass sharedSingleton].strSelectedSubCat=objDis[@"SubCategoryName"];
[[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"ChatScreenDiscussion"];
    ChatMessageView * obj=[[ChatMessageView alloc]init];
    [self.navigationController pushViewController:obj animated:YES];
    //[self presentViewController:obj animated:YES completion:nil];
    obj.disName=objDis[@"UserName"];
    obj.imageUrl=objDis[@"userimage"];
}
#pragma mark Fetch Data From Parse
-(void)fetchDiscussionFromParseInDis
{
    UIImageView *imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10,100, 30, 50)];
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
    

    PFQuery *query = [PFQuery queryWithClassName:@"Discussion"];
    [query orderByDescending:@"createdAt"];
    query.limit=10;
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        
        NSArray *arrObjects1 = [query findObjects];
        self.arrDiscussionDetails=[NSArray arrayWithArray:arrObjects1];
        NSLog(@"Final Objects -=-= %@",arrObjects1);
        NSLog(@"Discussion count-==-%lu",(unsigned long)
              [arrObjects1 count]);
        for (int i=0; i<[arrObjects1 count]; i++)
        {
            PFObject *disobj=[arrObjects1 objectAtIndex:i];
            NSDate *crtdDate=disobj.createdAt;
            NSLog(@"createdDate==%@",crtdDate);
            NSDate *currentDate=[NSDate date];
            NSLog(@"Current Date==%@",currentDate);
            
            NSCalendar *calendar=[NSCalendar currentCalendar];
            NSInteger comp=(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit);
            NSDateComponents *components1=[calendar components:comp fromDate:crtdDate];
            NSDateComponents *component2=[calendar components:comp fromDate:currentDate];
            crtdDate=[calendar dateFromComponents:components1];
            currentDate=[calendar dateFromComponents:component2];
//            if ([crtdDate compare:currentDate] == NSOrderedSame)
//            {
                NSLog(@"Yes It is today's discussion");
                NSString *disObjId=[disobj objectId];
                NSLog(@"disobjId==%@",disObjId);
                [arrObjectIds addObject:disObjId];
                NSString *strTopic=disobj[@"Topic"];
                [arrDiscussionsTopic addObject:strTopic];
                
                NSString *CmpareDate=[self compareDate:crtdDate];
                NSString *comparedateString=[NSString stringWithFormat:@"%@ ago",CmpareDate];
                NSLog(@"Compare Date==%@",CmpareDate);
                [cmpareDate addObject:comparedateString];
                
                NSString *disCreatedUsrname=disobj[@"UserName"];
                [crtdiscussnusrname addObject:disCreatedUsrname];
                NSString *imgUrl=disobj[@"userimage"];
                NSURL *url=[NSURL URLWithString:imgUrl];
                NSLog(@"%@",url);
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                NSURLResponse *response;
                NSError *error;
                
                NSData *data=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
                if (error == nil && data !=nil) {
                    [mutArrUserImages addObject:[UIImage imageWithData:data]];
                }
                
                
            //}
            NSLog(@"No doesnot enter in the loop");
            
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [imageVAnim stopAnimating];
            if ([self.arrDiscussionDetails count]>0)
            {
                if(!self.discussionTable)
                {
                [self createTableUI];
                }
                else
                {
                    [self.discussionTable reloadData];
                }
            }
            else
            {
                [self noDiscussionUI];
                
            }

           // [self createTableUI];
            
        });
        
        
    });
    
}
-(NSString*)compareDate:(NSDate*)oldDate
{
    NSDate *currentDate = [NSDate date];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDate  toDate:currentDate  options:0];
    
    int months =(int)[conversionInfo month];
    int days = (int)[conversionInfo day];
    int hours = (int)[conversionInfo hour];
    int minutes =(int) [conversionInfo minute];
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
        return [NSString stringWithFormat:@""];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
