//
//  ViewAllViewController.m
//  QuizBattle
//
//  Created by GLB-254 on 9/10/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import "HomeViewAllSubCategories.h"
#import "MessageCustomCell.h"
#import "GamePLayMethods.h"
#import "GameViewController.h"
#import "FriendsViewController.h"
#import "Ranking.h"
#import "DiscussionsViewController.h"
@interface HomeViewAllSubCategories ()

@end

@implementation HomeViewAllSubCategories

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
-(void)viewDidDisappear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:KDismissView object:nil];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentSelection=-1;
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    self.viewAll=[[UITableView alloc]initWithFrame:CGRectMake(20, 20,self.view.frame.size.width-40,self.view.frame.size.height-180) style:UITableViewStylePlain];
    self.viewAll.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.viewAll.delegate=self;
    self.viewAll.dataSource=self;
    self.viewAll.bounces=NO;
    self.viewAll.showsVerticalScrollIndicator=NO;
    self.viewAll.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    [self.view addSubview:self.viewAll];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 40)];
    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, headerView.frame.size.width-40,20)];
    headerLabel.text=self.segName;
    headerLabel.font=[UIFont boldSystemFontOfSize:18];
    headerLabel.textAlignment=NSTextAlignmentCenter;
    headerLabel.textColor=[UIColor blackColor];
    [headerView addSubview:headerLabel];
    self.viewAll.tableHeaderView=headerView;
}
-(void)backBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)goToPreviousView:(id)sender
{
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil];
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark Table Delegates
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(currentSelection==indexPath.section)
    {
        return 120;
    }
    
    return 48.5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewAllDetail count];
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
    static NSString *cellIdentifier = @"Cell Identifier";
    
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.messageLable.font=[UIFont fontWithName:@"BMHANNA" size:15];
    cell.topView.frame =CGRectMake(0, 0, 280,50);
    NSMutableDictionary * dict;
    dict=[self.viewAllDetail objectAtIndex:indexPath.section];
    
    cell.menuView.backgroundColor=[UIColor clearColor];
    //[[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.messageLable.frame = CGRectMake(60,cell.contentView.frame.size.height/2-5, 260, 20);
    //cell.lblDescription.frame = CGRectMake(60, 28, 260, 20);
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

    NSString *titleString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Title"]];
    NSString *descriptionString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Description"]];
    NSString * categoryImageName=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Image"]];
    NSString *batteryImgName=[NSString stringWithFormat:@"%@",[dict objectForKey:@"BatteryImage"]];
    NSString *gradeNameLocal;
    if([dict objectForKey:@"GradeName"])
    {
    gradeNameLocal=[NSString stringWithFormat:@"%@",[dict objectForKey:@"GradeName"]];
    }
    else
    {
          gradeNameLocal=[NSString stringWithFormat:@"베이비"];
    }
    cell.messageLable.text = titleString;
    cell.lblDescription.text = descriptionString;
    cell.picImageView.image = [UIImage imageNamed:categoryImageName];
    cell.batteryImage.image = [UIImage imageNamed:batteryImgName];
    cell.gradeName.text=gradeNameLocal;
    cell.gameDelegate=self;
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"home view all %@",self.viewAllDetail);
   // PFObject * tempObj=[self.viewAllDetail objectAtIndex:indexPath.section];
    NSDictionary *dict = nil;
 dict=[self.viewAllDetail objectAtIndex:indexPath.section];
    [SingletonClass sharedSingleton].selectedSubCat=[dict objectForKey:@"SubCategoryId"];
    [SingletonClass sharedSingleton].strSelectedSubCat=[dict objectForKey:@"Title"];
    [SingletonClass sharedSingleton].strSelectedCategoryId=[dict objectForKey:@"Image"];
    NSLog(@"Selected Subcategory %@ and Id %@", [SingletonClass sharedSingleton].selectedSubCat,[SingletonClass sharedSingleton].strSelectedSubCat);
    if(currentSelection==indexPath.section)
    {
        currentSelection=-1;
        [self.viewAll reloadData];
        return;
    }
    NSInteger row = [indexPath section];
    currentSelection = row;
    [UIView animateWithDuration:1 animations:^{
        [self.viewAll reloadData];
    }];
    
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]initWithFrame:CGRectZero];
}
#pragma mark game play
#pragma mark GameViewController

-(void)playNowButtonAction:(id)sender
{
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
                                    //                 forKey:@"detect"];
    
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
    //NSDictionary* dict = [NSDictionary dictionaryWithObject:
                       //   [NSString stringWithFormat:@"Show"]
                                               //      forKey:@"detect"];
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}

#pragma mark Ranking=====
-(void)rankingAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Home_Again_Ranking"];
    Ranking * ranks=[[Ranking alloc]init];
    [self.navigationController pushViewController:ranks animated:YES];
    
    //--------
   // NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          //[NSString stringWithFormat:@"Show"]
                                                  //   forKey:@"detect"];
    
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
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
