//
//  QuizPlusViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 9/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "QuizPlusViewController.h"
#import "AddQuestionViewController.h"

@interface QuizPlusViewController ()

@end

@implementation QuizPlusViewController

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
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFObject *objUsrDetail=[[SingletonClass sharedSingleton].userDetailinParse objectAtIndex:0];
    NSNumber *totalXp=objUsrDetail[@"TotalXP"];
    NSLog(@"%@",totalXp);
    int xp=[totalXp intValue];
    if (xp >15771) {
       self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
        subCategoryTable=[[UITableView alloc]initWithFrame:CGRectMake(20,20,self.view.frame.size.width-40,self.view.frame.size.height-50)];
        subCategoryTable.delegate=self;
        subCategoryTable.dataSource=self;
        subCategoryTable.backgroundColor=[UIColor clearColor];
        subCategoryTable.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:subCategoryTable];
        [self fetchDataFromParseInQuizplus];
        
        
    }
    
    else{
        [self cannotPostQuestionsUI];
        
    }
    
}

-(void)fetchDataFromParseInQuizplus
{
    PFQuery *query=[PFQuery queryWithClassName:@"UserGrade"];
    [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
      dispatch_async(dispatch_get_global_queue(0,0),^{
        
        NSArray *arrObject=[query findObjects];
        NSLog(@"arrr===-==%@",arrObject);
        gradeTableData=[NSArray arrayWithArray:arrObject];
        NSLog(@"Grade==%@",gradeTableData);
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            [subCategoryTable reloadData];
            
        });
        
        
    });
}
#pragma mark ================================
#pragma mark Table View Delegates Methods
#pragma mark ================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [gradeTableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *obj=[gradeTableData objectAtIndex:indexPath.section];
    NSString *message=[NSString stringWithFormat:@"%@",obj[@"SubcategoryName"]];
    
    NSNumber *catId=obj[@"CategoryId"];
    int i=[catId intValue];
    UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
    
    NSNumber *gradePoints=obj[@"gradepoints"];
    NSLog(@"Grade Points==%ld",(long)gradePoints);
    
    NSString *grade=[NSString stringWithFormat:@"%@",[self getGradeFromValue:gradePoints]];
    NSLog(@"Grade==-==%@",grade);
    
    static NSString *CellIdentifier = @"quizplus";
    
    MessageCustomCell *cell = [subCategoryTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.gameDelegate=self;
    cell.backgroundColor=[UIColor clearColor];
    cell.messageLable.frame = CGRectMake(50, 10, 120, 20);
    cell.messageLable.text = message;
    cell.lblDescription.text=grade;
    cell.iconImg.image=img;
    
    cell.btnAddQues.tag=indexPath.section;
    [cell.btnAddQues addTarget:self action:@selector(addQuesBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"Message label text -=-= %@",cell.messageLable.text);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    AddQuestionViewController *obj = [[AddQuestionViewController alloc] init];
    //    obj.strTopic=[gradeTableData objectAtIndex:indexPath.section];
    //    [self presentViewController:obj animated:YES completion:nil];
    
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
-(NSString *)getGradeFromValue:(NSNumber *)gradePoints
{
    int gradevalue=[gradePoints intValue];
    if (gradevalue >15771 && gradevalue <=24120) {
        return @"H1";
    }
    if (gradevalue>=24121 && gradevalue<=34220) {
        return @"H2";
    }
    if (gradevalue>=34221 && gradevalue <=59670) {
        return @"H3";
    }
    if (gradevalue >=59671 && gradevalue <=92120) {
        return @"CS1";
    }
    if (gradevalue >=92121 && gradevalue <=131570) {
        return @"CS2";
    }
    if (gradevalue >=131571 && gradevalue <=178020) {
        return @"CS3";
    }
    if (gradevalue >=178021 && gradevalue<=359370) {
        return @"CS4";
    }
    if (gradevalue >=359371 && gradevalue <=801620) {
        return @"Master";
    }
    if (gradevalue >=801621 && gradevalue <=1418870) {
        return @"Doctor";
    }
    if (gradevalue >=1418871) {
        return @"QuizKing";
    }
    else
    {
        return @"";
    }
}
-(void)addQuesBtnAction:(UIButton *)sender
{
    PFObject *myObj=[gradeTableData objectAtIndex:sender.tag];
    NSString *messsage=myObj[@"SubcategoryName"];
    [SingletonClass sharedSingleton].selectedSubCat=myObj[@"SubcategoryId"];
    NSLog(@"Index Path Section==%ld",(long)sender.tag);
    AddQuestionViewController *obj=[[AddQuestionViewController alloc]init];
    obj.strTopic=messsage;
    
    [self presentViewController:obj animated:YES completion:nil];
    
}
-(void)cannotPostQuestionsUI
{
    [self rejectUi:@""];
    
    //====================
    
}
-(void)rejectUi:(NSString *)request
{
    
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 100)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 20)];
    lblReject.text=[ViewController languageSelectedStringForKey:request ];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(15,popUpImageview.frame.size.height-40,120, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strAccept=[ViewController languageSelectedStringForKey:@"Using"];
    [acceptBtn setTitle:strAccept forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(acceptButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:acceptBtn];
    UIButton * rejectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rejectBtn.frame=CGRectMake(popUpImageview.frame.size.width/2+15,popUpImageview.frame.size.height-40,120,30);
    [rejectBtn setBackgroundImage:[UIImage imageNamed:@"reject_btn.png"] forState:UIControlStateNormal];
    [rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strReject=[ViewController languageSelectedStringForKey:@"Cancel"];
    [rejectBtn setTitle:strReject forState:UIControlStateNormal];
    rejectBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [rejectBtn addTarget:self action:@selector(rejectButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:rejectBtn];
    
}
-(void)acceptButton:(id)sender
{
   
    [rejectView removeFromSuperview];
    
}
-(void)rejectButton:(id)sender
{
    
    [rejectView removeFromSuperview];
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
