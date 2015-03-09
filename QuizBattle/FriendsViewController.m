//
//  FriendsViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "FriendsViewController.h"
#import "QuizBattleViewController.h"
#import "FBfriendsViewController.h"
#import "ContactsViewController.h"
#import "ChatScreenMessageViewController.h"
@interface FriendsViewController ()
{
    QuizBattleViewController *quizBattleFriend;
    FBfriendsViewController *fbFriends;
    ContactsViewController *contacts;
    UINavigationController *quizBattleNavi;
    UINavigationController *fbNavi;
    UINavigationController *contactsNavi;
}
@end

@implementation FriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)handleLanguageChangeNotification:(NSNotification*)notify{
    
    id value = [notify object];
    if ([value isKindOfClass:[NSString class]]) {
        [self setTabImages];
    }
    
}
-(void)setTabImages{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        quizBattleFriend.title = [ViewController languageSelectedStringForKey:@"Quizup Battle"];
        //fbFriends.title = [ViewController languageSelectedStringForKey:@"Facebook"];
        contacts.title = [ViewController languageSelectedStringForKey:@"Friend Request"];
    });
}
-(void)viewDidAppear:(BOOL)animated
{
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPreviousView:) name:KDismissView object:nil];
    //[FriendsTabBar setSelectedIndex:0];
//    if (quizController) {
//        [quizController popToRootViewControllerAnimated:NO];
//    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KDismissView object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
       self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
     self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-140);
    //[self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)167/255 green:(CGFloat)252/255 blue:(CGFloat)244/255 alpha:1]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLanguageChangeNotification:) name:KLanguageUpdateNotification object:nil];
    
    FriendsTabBar=[[UITabBarController alloc]init];
    FriendsTabBar.tabBar.frame=CGRectMake(0, self.view.frame.size.height-47, self.view.frame.size.width, 50);
    FriendsTabBar.tabBar.backgroundColor=[UIColor blackColor];
   FriendsTabBar.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"footer_active_friend.png"];
    FriendsTabBar.tabBar.tintColor = [UIColor whiteColor];
    FriendsTabBar.tabBar.barTintColor = [UIColor colorWithRed:(CGFloat)241/255 green:(CGFloat)241/255 blue:(CGFloat)241/255 alpha:1.0];
   [FriendsTabBar.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -15)];
    [self.view addSubview:FriendsTabBar.view];
    [FriendsTabBar.tabBar setBackgroundImage:[UIImage imageNamed:@"footer.png"]];
    NSLog(@"Maine view height =- %f /nTab BAr height -== %f",self.view.frame.size.height-100,FriendsTabBar.tabBar.frame.size.height);
    
 quizBattleFriend=[[QuizBattleViewController alloc]init];
    quizBattleFriend.tabBarItem.image = [UIImage imageNamed:@"quizbattle.png"];
    if(self.previousView)
    quizBattleFriend.previousView=self.previousView;
    
    quizBattleFriend.friendObj=self;
    quizBattleNavi=[[UINavigationController alloc]initWithRootViewController:quizBattleFriend];
     quizBattleNavi.navigationBar.hidden = YES;
    //--------------
    fbFriends=[[FBfriendsViewController alloc]init];
    fbFriends.tabBarItem.image = [UIImage imageNamed:@"addfriend.png"];
    fbFriends.friendObj=self;
    fbNavi.navigationBar.hidden = YES;
    //----------------
    contacts=[[ContactsViewController alloc]init];
    contacts.tabBarItem.image = [UIImage imageNamed:@"contact_usN.png"];
    contactsNavi=[[UINavigationController alloc]initWithRootViewController:contacts];
    contactsNavi.navigationBar.hidden = YES;

    FriendsTabBar.viewControllers = [NSArray arrayWithObjects:quizBattleNavi,contactsNavi,fbFriends, nil];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    
  [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    
    FriendsTabBar.delegate = self;
    
    quizBattleFriend.title = @"친구목록";//[ViewController languageSelectedStringForKey:@"Quizup Battle"];

   fbFriends.title =@"연락처"; //[ViewController languageSelectedStringForKey:@"Contact Us"];
    contacts.title = [ViewController languageSelectedStringForKey:@"Friend Request"];
    
    
    for (UITabBarItem *tbi in FriendsTabBar.tabBar.items)
    {
        tbi.image = [tbi.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //[(UINavigationController *)viewController popToRootViewControllerAnimated:YES];
}
-(void) goToPreviousView:(NSNotification *)notify
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backActionFriend:(id)sender
{
    // [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
        {
            break;
        }
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
    [FriendsTabBar setSelectedIndex:2];

}
//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    if (tabBarController.selectedIndex==0) {
//        imgQuiz.image=[UIImage imageNamed:@"quizbattle_active.png"];
//    }
//    else if(tabBarController.selectedIndex==1)
//    {
//        imgQuiz.image=[UIImage imageNamed:@"quizbattle.png"];
//    }
//}
//    [self.view addSubview:self.friendsTable];
//    NSArray *items=[[NSArray alloc]initWithObjects:@"QuizUp",@"Facebook", nil];
//    self.segments=[[UISegmentedControl alloc]initWithItems:items];
//    self.segments.segmentedControlStyle=UISegmentedControlStyleBar;
//    self.segments.frame=CGRectMake(35, 8, 250, 40);
//    self.segments.tintColor=[UIColor blueColor];
//    self.friendsTable=[[UITableView alloc]initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, self.view.frame.size.height-80)];
//    self.friendsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.friendsTable.delegate=self;
//    self.friendsTable.dataSource=self;
//    self.friendsTable.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:self.friendsTable];
//    self.fbfriendsTable=[[UITableView alloc]initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, self.view.frame.size.height-80)];
//    self.fbfriendsTable.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.fbfriendsTable.delegate=self;
//    self.fbfriendsTable.dataSource=self;
//    self.fbfriendsTable.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:self.fbfriendsTable];
//    self.fbfriendsTable.hidden=YES;
//
//    searchBar = [[UISearchBar alloc] init];
//    searchBar.frame=CGRectMake(20, 0, self.view.frame.size.width-20, 44);
//    searchBar.placeholder=@"Search For Friends";
//    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    searchDisplayController.delegate = self;
//    searchDisplayController.searchResultsDataSource = self;
//    self.friendsTable.tableHeaderView=searchBar;
//    searchDisplayController.searchResultsTitle=@"QuizUp Friends";
//    fbsearchbar = [[UISearchBar alloc] init];
//    fbsearchbar.frame=CGRectMake(20, 0, self.view.frame.size.width-20, 44);
//    fbsearchbar.placeholder=@"Search for facebook friends";
//    fbsearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:fbsearchbar contentsController:self];
//
//    fbsearchDisplayController.delegate = self;
//    fbsearchDisplayController.searchResultsDataSource = self;
//
//    self.fbfriendsTable.tableHeaderView=fbsearchbar;
//
//    [self.segments addTarget:self action:@selector(segmentValue:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:self.segments];
//   searchresults=[[NSMutableArray alloc]initWithCapacity:[name count]];

//-(void)segmentValue:(UISegmentedControl *)segment
//{
//    if (segment.selectedSegmentIndex==1) {
//        self.friendsTable.hidden=YES;
//        self.fbfriendsTable.hidden=NO;
//
//    }
//    else
//    {
//        [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)167/255 green:(CGFloat)252/255 blue:(CGFloat)244/255 alpha:1]];
//        self.friendsTable.hidden=NO;
//        self.fbfriendsTable.hidden=YES;
//            }
//
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if (tableView==self.searchDisplayController.searchResultsTableView) {
//        return [searchresults count];
//    }
//    else
//    {
//    return [name count];
//}
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//
//    return 1;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellIdentifier = @"Cell";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        if (tableView==self.searchDisplayController.searchResultsTableView)
//{
//    for (int i=0; i<[searchresults count]; i++) {
//
//cell.textLabel.text=[searchresults objectAtIndex:i];
//    return cell;
//    }
//}
//else
//{
//    if (indexPath.section==0)
//    {
//        cell.textLabel.text=[name objectAtIndex:indexPath.row];
//        return cell;
//    }
//    if (indexPath.section==1) {
//        cell.textLabel.text=[name objectAtIndex:(indexPath.row+indexPath.section)];
//        return cell;
//    }
//    if (indexPath.section==2) {
//        cell.textLabel.text=[name objectAtIndex:(indexPath.row+indexPath.section)];
//        return cell;
//    }
//
//}
//    [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    }
//    return cell;
//}
//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return 48.5;
//
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,60, self.view.frame.size.width, 30)];
//
//    UILabel *headerLabel =[[UILabel alloc]initWithFrame:CGRectMake(50, -20, self.view.frame.size.width-80, 80)];
//
//    headerLabel.textColor=[UIColor darkGrayColor];
//    headerLabel.font=[UIFont boldSystemFontOfSize:20];
//
//    if (tableView==self.friendsTable) {
//      headerLabel.text=@"QUIZ Battle FRIENDS";
//    }
//    else
//    {
//        headerLabel.text=@"";
//    }
//    if (section==0) {
//        [headerview addSubview:headerLabel];
//    }
//
//    return headerview;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        return 40;
//    }
//    else
//    {
//        return 30;
//    }
//}
//-(void)filterContentForSearchText:(NSString*)searchText
//{
//    NSPredicate *resultPredicate=[NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
//    searchresults=[name filteredArrayUsingPredicate:resultPredicate];
//
//
//}


//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
////  [searchresults removeAllObjects];
//    [self filterContentForSearchText:searchString];
//   [self.friendsTable reloadData];
//
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (text==[name objectAtIndex:0]||text==[name objectAtIndex:1]) {
//    return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
@end
