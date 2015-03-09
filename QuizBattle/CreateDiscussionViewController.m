//
//  CreateDiscussionViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 9/22/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "CreateDiscussionViewController.h"
#import "AppDelegate.h"
#import "ChatMessageView.h"
#import "MessageCustomCell.h"

@interface CreateDiscussionViewController ()

@end

@implementation CreateDiscussionViewController

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
     [[NSNotificationCenter defaultCenter]removeObserver:self name:KDismissView object:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPreviousView:) name:KDismissView object:nil];
    NSLog(@"Discussoin array %lu",(unsigned long)[self.arrDiscussionDetails count]);
    [self fetchDiscussionFromParse];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    mutArrUserImages = [[NSMutableArray alloc] init];
    [mutArrUserImages addObject:@"image"];
    arrObjectIds = [[NSMutableArray alloc] init];
    compareDate=[[NSMutableArray alloc]init];
    [arrObjectIds addObject:@"ids"];
    self.arrDiscussionDetails =[[NSArray alloc] init];
    
    //[NSThread detachNewThreadSelector:@selector(fetchDiscussionFromParse) toTarget:self withObject:nil];
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [headerV setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
    [self.view addSubview:headerV];
    
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    
    
//    NSString *strBtnTitle = [ViewController languageSelectedStringForKey:@"Back"];
    self.lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 5,self.view.bounds.size.width, 45)];
    self.lblHeader.textAlignment=NSTextAlignmentCenter;
    self.lblHeader.font=[UIFont boldSystemFontOfSize:20];
    self.lblHeader.textColor=[UIColor whiteColor];
    self.lblHeader.text=[[SingletonClass sharedSingleton].strSelectedSubCat uppercaseString];
    [headerV addSubview:self.lblHeader];
    
        
   }
-(void)createTable
{
    if(!self.discussionTable)
    {
    self.discussionTable=[[UITableView alloc]initWithFrame:CGRectMake(20, 70,self.view.frame.size.width-40, self.view.frame.size.height-80)];
    self.discussionTable.backgroundColor=[UIColor clearColor];
    self.discussionTable.delegate=self;
    self.discussionTable.dataSource=self;
    self.discussionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.discussionTable];
    }
}
////////////////Query to fetch Discussion from Parse/////////////////
-(void)fetchDiscussionFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Discussion"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"SubCategoryId" equalTo:[SingletonClass sharedSingleton].selectedSubCat];
    
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        
        NSArray *arrObjects1 = [query findObjects];
        NSLog(@"Final Objects -=-= %@",arrObjects1);
        NSLog(@"Discussion count-==-%lu",(unsigned long)
              [arrObjects1 count]);
        self.arrDiscussionDetails=[NSArray arrayWithArray:arrObjects1];
        //===
        
        for (int i=0; i<[arrObjects1 count]; i++)
        {
            PFObject *disobj=[arrObjects1 objectAtIndex:i];
            NSString *subcatName=disobj[@"SubCategoryName"];
            NSLog(@"SubCategory Name==%@",subcatName);
            NSString *selcellsubCatName=[NSString stringWithFormat:@"%@",[SingletonClass sharedSingleton].strSelectedSubCat];
            NSLog(@"Selected sub Cat==%@",selcellsubCatName);
            
                NSString *disObjId=[disobj objectId];
                NSLog(@"disobjId==%@",disObjId);
                [arrObjectIds addObject:disObjId];
                NSDate *dateCrtd=disobj.createdAt;
                [compareDate addObject:[self compareDate:dateCrtd]];
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
                
                
            }
            
  
        dispatch_async(dispatch_get_main_queue(),^{
            if(!self.discussionTable)
            {
            [self createTable];
            }
            else
            {
                [self.discussionTable reloadData];
            }
        });
        
        
    });
    
}
//-(void)fetchUserImage {
//    
//    PFQuery *query = [PFUser query];
//    
//    for (int i=0; i<[mutArrUserId count]; i++) {
//        
//        if ([[mutArrUserId objectAtIndex:i] isEqualToString:[SingletonClass sharedSingleton].objectId]) {
//            
//            [mutArrUserImages addObject:[SingletonClass sharedSingleton].imageUser];
//        }
//        else{
//        [query whereKey:@"objectId" equalTo:[mutArrUserId objectAtIndex:i]];
//        
//        NSArray *arr = [query findObjects];
//        
//            if (arr.count>0) {
//                NSDictionary *dict = [arr objectAtIndex:0];
//                
//                PFFile  *strImage = [dict objectForKey:@"userimage"];
//                
//                NSData *imageData = [strImage getData];
//                UIImage *image = [UIImage imageWithData:imageData];
//                
//                [mutArrUserImages addObject:image];
//            }
//        }
//    }
//     dispatch_async(dispatch_get_main_queue(),^(void) {
//         [self.discussionTable reloadData];
//     });
//    
//}
-(void)goToPreviousView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backBtnAction:(id)sender
{
    
  [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
}
#pragma mark======
#pragma mark Table Delegates
#pragma mark======
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.arrDiscussionDetails.count>1)
    {
        return self.arrDiscussionDetails.count;
    }
    else
    {
        return 1;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section==0)
//    {
        return 48.5;
//    }
//    else
//    return 65;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-40, 50)];
        headerLabel.textColor=[UIColor blackColor];
        headerLabel.text=[ViewController languageSelectedStringForKey:@"DISCUSSIONS"];
        headerLabel.font=[UIFont boldSystemFontOfSize:20];
        headerLabel.textAlignment=NSTextAlignmentCenter;
        [headerview addSubview:headerLabel];
        
        return headerview;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        return 50;
    }
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Discussion";
    
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    NSLog(@"IndexPathSectionbeforeIf==%ld",(long)indexPath.section);
    
    if (cell == nil) {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.topView.frame =CGRectMake(0, 0, 280,50);
        if(indexPath.section==0)
        {
            
            cell.iconImg.image=[UIImage imageNamed:@"discussion_icon.png"];
            
            
            //cell.message.frame=CGRectMake(60, 10, 260, 30);
            cell.message.text=[ViewController languageSelectedStringForKey:@"New Discussion"];
            cell.lblDescription.text=@"";
            cell.messageLable.text=@"";
            
        }
        
        else{
            
            PFObject * objDiscussion=[self.arrDiscussionDetails objectAtIndex:indexPath.section-1];
            if (self.arrDiscussionDetails.count>1)
            {
                
                NSLog(@"Index Path section == %ld",(long)indexPath.section);
                cell.message.frame=CGRectMake(60, 2, 260, 20);
                cell.message.text=objDiscussion[@"UserName"];
                
                cell.lblDescription.text=objDiscussion[@"Topic"];
                NSLog(@"Label Description in cell==%@",cell.lblDescription.text);
                cell.messageLable.text=[compareDate objectAtIndex:indexPath.section];
                NSLog(@"Message Label in Cell==%@",cell.messageLable.text);
                cell.iconImg.image=[mutArrUserImages objectAtIndex:indexPath.section];
                cell.iconImg.layer.cornerRadius=cell.iconImg.frame.size.width/2.0;
                cell.iconImg.clipsToBounds=YES;
            }
        }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (indexPath.section==0) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Enter Topic"] message:nil delegate:self cancelButtonTitle:[ViewController languageSelectedStringForKey:@"Cancel"] otherButtonTitles:[ViewController languageSelectedStringForKey:@"Add"], nil];
        [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *textFieldFileName = [message textFieldAtIndex:0];
        [message addSubview:textFieldFileName];
        [message show];
    }
    else {
        
        dispatch_async(GCDBackgroundThread, ^{
            @autoreleasepool {
        PFQuery *query = [PFQuery queryWithClassName:@"DiscussionComment"];
        NSLog(@"Index PATH SECtion =-=- %ld",(long)indexPath.section);
        [query whereKey:@"DiscussionId" equalTo:[arrObjectIds objectAtIndex:indexPath.section]];
        NSLog(@"Discussion Id -==- %@",[arrObjectIds objectAtIndex:indexPath.section]);
                [SingletonClass sharedSingleton].discussionObjectId=[arrObjectIds objectAtIndex:indexPath.section];
        NSArray * temp= [query findObjects];
                
                dispatch_async(dispatch_get_main_queue(),^(void) {
                   [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"ChatScreenDiscussion"];
                    ChatMessageView *obj = [[ChatMessageView alloc]init];
                    obj.arrFetchDetails=temp;
                    [self.navigationController pushViewController:obj animated:YES];
                    //[self presentViewController:obj animated:YES completion:nil];
                    [obj displayDiscussionChat];
                    NSLog(@"Final Objects Discussion 333-=-= %@",obj.arrFetchDetails);
                });
                            }
        });
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.contentView.backgroundColor = [UIColor clearColor];
        headerView.backgroundView.backgroundColor = [UIColor clearColor];
    }
}
#pragma mark===
#pragma mark AlertView
//make sure file description is long enoguh
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    
    if( [inputText length] <= 50 && [inputText length] >= 4)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//handle add button
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"추가"])
    {
      
        UITextField *fileName = [alertView textFieldAtIndex:0];
        NSLog(@"Name: %@", fileName.text);
        [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"ChatScreenDiscussion"];
        ChatMessageView *obj = [[ChatMessageView alloc]init];
        [self.navigationController pushViewController:obj animated:YES];

        //[self presentViewController:obj animated:YES completion:nil];
      
        obj.lblDiscussionTopic.text=fileName.text;
        obj.lblHeader.text=fileName.text;
        
        PFObject *object = [PFObject objectWithClassName:@"Discussion"];
        object[@"Topic"]=fileName.text;
        object[@"SubCategoryId"]=[SingletonClass sharedSingleton].selectedSubCat;
        object[@"UserId"]=[SingletonClass sharedSingleton].objectId;
        object[@"SubCategoryName"]=[SingletonClass sharedSingleton].strSelectedSubCat;
        object[@"UserName"]=[SingletonClass sharedSingleton].strUserName;
        object[@"userimage"]=[SingletonClass sharedSingleton].imageFileUrl;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [object saveEventually:^(BOOL succeed, NSError *error){
                
                if (succeed) {
                    NSLog(@"Save to Parse");
                    BOOL checkInternet =  [ViewController networkCheck];
                    
                    if (checkInternet) {
                        NSString * objectId = [object objectId];
                        
                        [SingletonClass sharedSingleton].discussionObjectId=objectId;
                         NSLog(@"Discussion Id Create Discussion-==- %@",[SingletonClass sharedSingleton].discussionObjectId);
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
}
///////////////Method For Date Comparision/////////////
-(NSString*)compareDate:(NSDate*)oldDate
{
    NSDate *currentDate = [NSDate date];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDate  toDate:currentDate  options:0];
    
    int months =(int)[conversionInfo month];
    int days =(int) [conversionInfo day];
    int hours =(int) [conversionInfo hour];
    int minutes =(int) [conversionInfo minute];
    int seconds =(int) [conversionInfo second];
    
    NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
    if(days>1)
    {
        return [NSString stringWithFormat:@"%d days ago",days];
    }
    else if(hours>=1)
    {
        return [NSString stringWithFormat:@"%d hours ago",hours];
        
    }
    else if(minutes>=1)
    {
        return [NSString stringWithFormat:@"%d minutes ago",minutes];
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
