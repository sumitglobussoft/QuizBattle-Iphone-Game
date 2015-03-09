//
//  LanguageViewController.m
//  QuizBattle
//
//  Created by Sumit Ghosh on 04/09/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "LanguageViewController.h"
#import "ViewController.h"
@interface LanguageViewController ()

@end

@implementation LanguageViewController

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
    
    userDefault =[NSUserDefaults standardUserDefaults];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)167/255 green:(CGFloat)252/255 blue:(CGFloat)244/255 alpha:1]];
    [self createUI];
    languageTable=[[UITableView alloc]initWithFrame:CGRectMake(20, 80,self.view.frame.size.width-40 , 100)];
  languageTable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    languageTable.backgroundColor=[UIColor clearColor];
languageTable.dataSource=self;
    
    [self.view addSubview:languageTable];
    langarr = [[NSArray alloc] initWithObjects:@"English",@"Korean", nil];
}
-(void)createUI
{
    chooselanguage=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 50)];
    chooselanguage.textColor=[UIColor blackColor];
    NSString *str=[ViewController languageSelectedStringForKey:@"Choose Language"];
    chooselanguage.text=str;
    [self.view addSubview:chooselanguage];
    backbtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 13, 50,50)];
    [backbtn setTitle:[ViewController languageSelectedStringForKey:@"Back"] forState:UIControlStateNormal];
    [backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if (indexPath.row==0)
    {
        
      cell.textLabel.text=[langarr objectAtIndex:indexPath.row];
       pickbtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        pickbtn.frame=CGRectMake(210, 5, 80, 30);
        pickbtn.backgroundColor=[UIColor whiteColor];
        [pickbtn setTitle:[ViewController languageSelectedStringForKey:@"PICK"] forState:UIControlStateNormal];
        [pickbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [pickbtn addTarget:self action:@selector(pickbtnEnglish) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:pickbtn];
        return cell;
       
 
    }
    if (indexPath.row==1) {
        
        cell.textLabel.text=[langarr objectAtIndex:indexPath.row];
        UIButton *pickbtn1;
        pickbtn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        pickbtn1.frame=CGRectMake(210, 5, 80, 30);
        pickbtn1.backgroundColor=[UIColor whiteColor];
        [pickbtn1 setTitle:[ViewController languageSelectedStringForKey:@"PICK"]  forState:UIControlStateNormal];
        [pickbtn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [pickbtn1 addTarget:self action:@selector(pickbtnKorean) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:pickbtn1];
    }
    
//    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
//   [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    return cell;
}
-(void)pickbtnEnglish
{
    
    [userDefault setObject:@"English" forKey:@"language"];
    [userDefault synchronize];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"language"]);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"languagechange" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KLanguageUpdateNotification object:@"changeLanguage"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)pickbtnKorean
{
    [userDefault setObject:@"Korean" forKey:@"language"];
    [userDefault synchronize];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"language"]);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"languagechange" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:KLanguageUpdateNotification object:@"Korean"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)backBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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
