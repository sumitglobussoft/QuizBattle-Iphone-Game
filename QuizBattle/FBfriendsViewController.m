//
//  FBfriendsViewController.m
//  QuizBattle
//
//  Created by Sumit Ghosh on 11/09/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "FBfriendsViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import <AddressBook/AddressBook.h>
#import "SingletonClass.h"
#import <Parse/Parse.h>
#import "ChooseTopics.h"
#import "MessageCustomCell.h"

@interface FBfriendsViewController ()

@end

@implementation FBfriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    [self fetchAddressBook];
    // Do any additional setup after loading the view.
}
-(void)createTableUI
{
    UITableView * contactsTable = [[UITableView alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, self.view.frame.size.height-80) style:UITableViewStylePlain];
    contactsTable.separatorStyle = UITableViewCellSelectionStyleNone;
    contactsTable.backgroundView = nil;
    contactsTable.backgroundColor = [UIColor clearColor];
    contactsTable.rowHeight = 60;
    contactsTable.delegate = self;
    contactsTable.dataSource = self;
    contactsTable.bounces=NO;
    [self.view addSubview:contactsTable];
    UIView * footerViewContactTable=[[UIView alloc]initWithFrame:CGRectMake(0, 0, contactsTable.frame.size.width,40)];
    contactsTable.tableFooterView=footerViewContactTable;
    
}
-(void)fetchAddressBook
{
    NSMutableArray *temp=[[NSMutableArray alloc]init];
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
    

    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        if (!granted){
            //4
            NSLog(@"Just denied");
            return;
        }
        
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        for(int i = 0; i < numberOfPeople; i++) {
            NSMutableDictionary * contactInfo=[[NSMutableDictionary alloc]init];
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
          //  NSString *mobileNo = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonPhoneMobileLabel));
            
            NSLog(@"Name:%@ %@ ", firstName, lastName);
            if(firstName)
            {
                [contactInfo setObject:firstName forKey:@"Name"];

            }
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSString *phoneNumber;
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
               phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                NSLog(@"phone:%@", phoneNumber);
                
            }
            @try
            {
                [contactInfo setObject:phoneNumber forKey:@"MobileNumber"];
                
            }
            @catch (NSException * e)
            {
                NSLog(@"Exception: %@", e);
            }
            
            
            NSLog(@"=============================================");
            [temp addObject:contactInfo];
        }
        mobilenfo=[NSArray arrayWithArray:temp];
        NSLog(@"Mobile Info %@",mobilenfo);
        //5
        NSLog(@"Just authorized");
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                            [self createTableUI];
                           [imageVAnim stopAnimating];
                       });

       
    });

}
#pragma mark -
#pragma mark---
#pragma mark Table View Delegates.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mobilenfo count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell Identifier";
    NSDictionary * dict=nil;
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    cell.topView.frame =CGRectMake(0, 0, 280, 60);
    cell.messageLable.frame = CGRectMake(10,cell.contentView.frame.size.height/2-20, 260, 20);
    cell.lblDescription.frame = CGRectMake(10,cell.contentView.frame.size.height/2+2, 260, 20);
    dict=[mobilenfo objectAtIndex:indexPath.section];
    cell.messageLable.text=[dict objectForKey:@"Name"];
    cell.messageLable.font=[UIFont boldSystemFontOfSize:15];
    cell.lblDescription.text=[dict objectForKey:@"MobileNumber"];
    cell.lblDescription.font=[UIFont boldSystemFontOfSize:12];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict=nil;
    dict=[mobilenfo objectAtIndex:indexPath.section];
    [self sendSmS:[dict objectForKey:@"MobileNumber"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.contentView.backgroundColor = [UIColor clearColor];
        headerView.backgroundView.backgroundColor = [UIColor clearColor];
    }
}
-(void)sendSmS:(NSString *)mobileNumber
{
    //check if the device can send text messages
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //set receipients
    NSArray *recipients = [NSArray arrayWithObjects:mobileNumber, nil];
    
    //set message text
    NSString * message = @"친구로부터의 도전장!드루와 드루와~K-POP부터 상식까지, 없는 문제가 없어!없는게 있어? 그럼 만들어줘~";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self.friendObj;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self.friendObj presentViewController:messageController animated:YES completion:nil];
}
#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Oups, error while sendind SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
