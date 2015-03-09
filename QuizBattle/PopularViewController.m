//
//  PopularViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/12/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "PopularViewController.h"
#import "ViewController.h"
#import <Parse/Parse.h>
#import "GameViewController.h"
#import "FriendsViewController.h"
#import "GamePLayMethods.h"
#import "Ranking.h"

@interface PopularViewController ()

@end

@implementation PopularViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)noGradeUI
{
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    notPlayedLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2-40, self.view.frame.size.width-40,50)];
    notPlayedLabel.textColor=[UIColor blackColor];
    notPlayedLabel.backgroundColor=[UIColor whiteColor];
    notPlayedLabel.text=@"그러나 게임이 없습니다";
    notPlayedLabel.textAlignment=NSTextAlignmentCenter;
    notPlayedLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:notPlayedLabel];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    gradeName=[[NSMutableArray alloc]init];
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet) {
         [self fetchDataFromParser];
//        [NSThread detachNewThreadSelector:@selector(fetchDataFromParser) toTarget:self withObject:nil];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
    }

    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    
    self.arrSubCatDesc = [[NSMutableArray alloc]init];
    self.arrSubCatName = [[NSMutableArray alloc]init];
    self.arrImages = [[NSMutableArray alloc]init];
  
  
}
-(void)createTable
{
    currentSelection = -1;
    tableV = [[UITableView alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width-40, self.view.frame.size.height-40)];
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.bounces=NO;
   [tableV setShowsVerticalScrollIndicator:NO];
    tableV.delegate=self;
    tableV.dataSource=self;
    tableV.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tableV];
    UIView * tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width-40 ,40)];
    UILabel * headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width-40, 40)];
    headerLabel.text=@"토픽별 등급";
    headerLabel.textAlignment=NSTextAlignmentCenter;
    [tableHeaderView addSubview:headerLabel];
    tableV.tableHeaderView=tableHeaderView;
    tableV.translatesAutoresizingMaskIntoConstraints = NO;
}
-(void)fetchDataFromParser {
    
    //    dispatch_async(GCDBackgroundThread, ^{
    //        @autoreleasepool {
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
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL checkInternet =  [ViewController networkCheck];
        
        if (checkInternet) {
            
            PFQuery *query = [PFQuery queryWithClassName:@"UserGrade"];
            
            [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
            [query orderByDescending:@"gradepoints"];
            
            NSArray *arrObjects = [query findObjects];
            NSLog(@"Final Objects POpular-=-= %@",arrObjects);
            self.gradeDataDetail=[NSArray arrayWithArray:arrObjects];
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self createTable];
            [imageVAnim stopAnimating];
        });
        
        
    });
}
-(void)backBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([self.gradeDataDetail count]==0)
    {
        [self noGradeUI];
    }
    return [self.gradeDataDetail count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (currentSelection == indexPath.section) {
        return 120;
    }
    
    return 48.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell Identifier";
    
    MessageCustomCell *cell = [tableV dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    if (currentSelection == indexPath.section) {
        
        cell.menuView.hidden=NO;
        
        [UIView animateWithDuration:1 animations:^{
            cell.menuView.layer.opacity = 1.0f;
        }];
    }
    else{
        cell.menuView.layer.opacity = 0.0f;
        cell.menuView.hidden=YES;
        
    }
    
    //------------Button Actions---
    [cell.rankingButton addTarget:self action:@selector(rankingAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.discussionButton addTarget:self action:@selector(discussionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.challengeButton addTarget:self action:@selector(challengeAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.playNowButton addTarget:self action:@selector(playNowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //------------
    cell.messageLable.font=[UIFont fontWithName:@"BMHANNA" size:15];
    PFObject * data=[self.gradeDataDetail objectAtIndex:indexPath.section];
    cell.topView.frame =CGRectMake(0, 0, 280, 50);
    cell.gameDelegate=self;
    cell.backgroundColor=[UIColor clearColor];
    cell.messageLable.frame = CGRectMake(50,15, 260, 20);
    cell.messageLable.text = data[@"SubcategoryName"];
    cell.lblDescription.frame=CGRectMake(50, 28, 260, 10);
    // cell.lblDescription.text=[NSString stringWithFormat:@"%@",[self.arrSubCatDesc objectAtIndex:indexPath.section]];
    NSString *getBatteryName=[NSString stringWithFormat:@"%@",[self getProgressFromGradeValue:data[@"gradepoints"]]];
    NSString * imgname=[NSString stringWithFormat:@"%@",data[@"CategoryId"]];
    cell.picImageView.image=[UIImage imageNamed:imgname];
    cell.gradeName.frame=CGRectMake(180, 5, 60,40);
    cell.gradeName.text=[gradeName objectAtIndex:indexPath.section];
    cell.batteryImage.image=[UIImage imageNamed:getBatteryName];

    cell.messageLable.text = data[@"SubcategoryName"];
    cell.lblDescription.frame=CGRectMake(60, 28, 260, 10);
   // cell.lblDescription.text=[NSString stringWithFormat:@"%@",[self.arrSubCatDesc objectAtIndex:indexPath.section]];
    NSLog(@"Cell text =-=- %@",cell.messageLable.text);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (currentSelection == indexPath.section) {
        currentSelection = -1;
        [tableView reloadData];
        return;
    }
    NSInteger row = [indexPath section];
    currentSelection = row;
    
    [UIView animateWithDuration:1 animations:^{
        [tableV reloadData];
    }];
    PFObject * objGradeDetail=[self.gradeDataDetail objectAtIndex:indexPath.section];
    [SingletonClass sharedSingleton].selectedSubCat=objGradeDetail[@"SubcategoryId"];
    [SingletonClass sharedSingleton].strSelectedSubCat=objGradeDetail[@"SubcategoryName"];
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.contentView.backgroundColor = [UIColor clearColor];
        headerView.backgroundView.backgroundColor = [UIColor clearColor];
    }
}
#pragma mark GameViewController

-(void)playNowButtonAction:(id)sender {
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playNowButtonAction:) name:@"PlayAnother" object:nil];
    //    [self displaySelectFriendsUI];
    //
    //    [self performSelector:@selector(selectionFriendMethod) withObject:nil afterDelay:2];
    
    GamePLayMethods * obj=[[GamePLayMethods alloc]init];
    obj.gameDelegate=self;
    [obj playNowButtonAction];
}


-(void)gameDetailsAnotherGame:(NSDictionary *)details
{
    
    GameViewController *obj = [[GameViewController alloc] init];
    obj.arrPlayerDetail=details;
    NSLog(@"obj Players Details -== %@",obj.arrPlayerDetail);
    [self presentViewController:obj animated:YES completion:nil];
}

//-(void)gameDetails:(NSDictionary*)details {
//
//    GameViewController *obj = [[GameViewController alloc] init];
//    obj.arrPlayerDetail=details;
//    NSLog(@"obj Players Details -== %@",obj.arrPlayerDetail);
//    [self presentViewController:obj animated:YES completion:nil];
//}

#pragma mark Challenge Action and game methods
-(void)challengeAction:(id)sender
{
    //---------
    [SingletonClass sharedSingleton].pickFriendsChallenge=TRUE;
    FriendsViewController *frnd=[[FriendsViewController alloc]init];
    frnd.previousView=@"Challenge";
    [self.navigationController pushViewController:frnd animated:YES];
    
   // NSDictionary* dict = [NSDictionary dictionaryWithObject:
                         // [NSString stringWithFormat:@"Show"]
                                                  //   forKey:@"detect"];
    
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
    //[self.navController pushViewController:frnd animated:YES];
    //  [self presentViewController:frnd animated:YES completion:nil];
}
#pragma mark Discussion Action
-(void)discussionBtnAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Home_Again_Discussion"];    CreateDiscussionViewController * createDiscussoin = [[CreateDiscussionViewController alloc]init];
    [self.navigationController pushViewController:createDiscussoin animated:YES];
    //--------
   // NSDictionary* dict = [NSDictionary dictionaryWithObject:
                        //  [NSString stringWithFormat:@"Show"]
                          //                           forKey:@"detect"];
    
  //  [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}

#pragma mark Ranking=====
-(void)rankingAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Home_Again_Ranking"];
    Ranking * ranks=[[Ranking alloc]init];
    [self.navigationController pushViewController:ranks animated:YES];
    
    //--------
//    NSDictionary* dict = [NSDictionary dictionaryWithObject:
//                          [NSString stringWithFormat:@"Show"]
//                                                     forKey:@"detect"];
    
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}

-(void) goToPreviousView:(NSNotification *)notify
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gameDetails:(NSDictionary*)details {
    
    GameViewController *obj = [[GameViewController alloc] init];
    obj.arrPlayerDetail=details;
  //  NSLog(@"obj Players Details -== %@",obj.arrPlayerDetail);
    [self presentViewController:obj animated:YES completion:nil];
}
-(NSString*)getProgressFromGradeValue:(NSNumber *)gradePoints
{
    int gradevalue=[gradePoints intValue];
    NSString * grade;
    if (gradevalue >=0 && gradevalue<=810)
    {
        grade=@"베이비";
        [gradeName addObject:grade];
        return @"0_Battery.png";
    }
    else if (gradevalue >=811 && gradevalue <=1220)
    {
        grade=@"초1";
        [gradeName addObject:grade];
        return @"1_Battery.png";
    }
    else if (gradevalue >=1221 && gradevalue <=1700)
    {
        grade=@"초2";
        [gradeName addObject:grade];
        return @"1_Battery.png";
    }
    else if (gradevalue>=1701 && gradevalue <=2250)
    {
        grade=@"초3";
        [gradeName addObject:grade];
        return @"1_Battery.png";
    }
    else if (gradevalue >=2251 && gradevalue <=2870)
    {
        grade=@"초4";
        [gradeName addObject:grade];
        return @"2_Battery.png";
    }
    else if (gradevalue >=2871 && gradevalue <=3560)
    {
        grade=@"초5";
        [gradeName addObject:grade];
        return @"2_Battery.png";
    }
    else if (gradevalue >=3561 && gradevalue <=5150)
    {
        grade=@"초6";
        [gradeName addObject:grade];
        return @"2_Battery.png";
    }
    else if (gradevalue >=5151 && gradevalue<=7020)
    {
        grade=@"중1";
        [gradeName addObject:grade];
        return @"3_Battery.png";
    }
    else if (gradevalue >=7021 && gradevalue <=9170)
    {
        grade=@"중2";
        [gradeName addObject:grade];
        return @"3_Battery.png";
    }
    else if (gradevalue >=9171 && gradevalue <=15770)
    {
        grade=@"중3";
        [gradeName addObject:grade];
        return @"4_Battery.png";
    }
    else  if (gradevalue >=15771 && gradevalue <=24120)
    {
        grade=@"고1";
        [gradeName addObject:grade];
        return @"4_Battery.png";
    }
    else if (gradevalue >=24121 && gradevalue<=34220)
    {
        grade=@"고2";
        [gradeName addObject:grade];
        return @"5_Battery.png";
    }
    else if (gradevalue >=34221 && gradevalue <=59670)
    {
        grade=@"고3";
        [gradeName addObject:grade];
        return @"5_Battery.png";
    }
    else if (gradevalue >=59671 && gradevalue <=92120)
    {
        grade=@"대1";
        [gradeName addObject:grade];
        return @"6_Battery.png";
    }
    else if (gradevalue >=92121 && gradevalue <=131570)
    {   grade=@"대2";
        [gradeName addObject:grade];
        return @"6_Battery.png";
    }
    else if (gradevalue >=131571 && gradevalue <=178020)
    {
        grade=@"대3";
        [gradeName addObject:grade];
        return @"7_Battery.png";
    }
    else if (gradevalue >=178021 && gradevalue <=359370)
    {
        grade=@"대4";
        [gradeName addObject:grade];
        return @"7_Battery.png";
    }
    else if (gradevalue >=359371 && gradevalue <=801620)
    {
        grade=@"석사";
        [gradeName addObject:grade];
        return @"8_Battery.png";
    }
    else if (gradevalue >=801621 && gradevalue <=1418870)
    {
        grade=@"박사";
        [gradeName addObject:grade];
        return @"9_Battery.png";
    }
    else if (gradevalue>=1418871)
    {
        grade=@"퀴즈왕";
        [gradeName addObject:grade];
        return @"10_Battery.png";
    }
    else
    {
        return nil;
    }
    
    
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
