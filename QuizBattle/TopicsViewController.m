//
//  TopicsViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "TopicsViewController.h"
#import "HomeViewController.h"
#import "MessageCustomCell.h"
#import "AllTopicsViewController.h"
#import "NewContentViewController.h"
#import "StaffPicksViewController.h"
#import "PopularViewController.h"
#import "RecommendedViewController.h"
#import "ViewController.h"
#import "ProfileViewController.h"
#import "QuizPlusViewController.h"
#import "SubCategoryViewController.h"

@interface TopicsViewController ()
@property (nonatomic, strong) SubCategoryViewController *subCategoryViewController;
@end

@implementation TopicsViewController

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
    
    // Do any additional setup after loading the view from its nib.
    frameSize = [UIScreen mainScreen].bounds.size;
    currentSelection = -1;
    self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];

     [self createTableView];
    [self fetchDataFromParse];
    
    }
-(void)fetchDataFromParse
{
    UIImageView *imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, 100, 30, 50)];
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
    

    PFQuery * query=[PFQuery queryWithClassName:@"Category"];
    [query addAscendingOrder:@"CategoryNameKorean"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSArray *tempArray = [query findObjects];
        self.allTopicArrays = [NSArray arrayWithArray:tempArray];
       // NSLog(@"All Topic Array = %@",self.allTopicArrays);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageVAnim stopAnimating];
            [self.categoryTabelView reloadData];
        });
    });

}
-(void) createTableView
{
    if (!self.categoryTabelView)
    {
        self.categoryTabelView = [[UITableView alloc] initWithFrame:CGRectMake(20, 10, frameSize.width-40, frameSize.height-140) style:UITableViewStylePlain];
        self.categoryTabelView.backgroundColor=[UIColor clearColor];
        self.categoryTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:self.categoryTabelView];
        self.categoryTabelView.delegate = self;
        self.categoryTabelView.dataSource = self;
        self.categoryTabelView.bounces=NO;
        self.categoryTabelView.showsVerticalScrollIndicator=NO;
        UIView * tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 10,self.categoryTabelView.frame.size.width,30)];
        self.categoryTabelView.tableHeaderView=tableHeaderView;
        UIImageView * searchImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon.png"]];
        searchImageView.frame=CGRectMake(0, 0, 20, 20);
        searchImageView.contentMode=UIViewContentModeCenter;
        UITextField * searchTextField=[[UITextField alloc]initWithFrame:CGRectMake(2,0,self.view.frame.size.width-6,30)];
        searchTextField.placeholder=@"검색";
        searchTextField.layer.borderColor=[UIColor whiteColor].CGColor;
        searchTextField.layer.borderWidth=2;
        searchTextField.layer.cornerRadius=2;
        searchTextField.backgroundColor=[UIColor whiteColor];
        searchTextField.delegate=self;
        searchTextField.leftView=searchImageView;
        [searchTextField setLeftViewMode:UITextFieldViewModeAlways];
        [tableHeaderView addSubview:searchTextField];
        UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.categoryTabelView.frame.size.width,30)];
        self.categoryTabelView.tableFooterView=footerView;
        
    }
    else
    {
        [self.categoryTabelView reloadData];
    }
    
}
#pragma mark Table Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if([searchArray count]>0)
  {
      return [searchArray count];
  }
 else
 {
    return [self.allTopicArrays count];
 }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 48.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell Identifier";
    
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
     cell.topView.frame =CGRectMake(0, 0, 280, 48.5);
    cell.topView.image = [UIImage imageNamed:@"topic_bg_sidearrow.png"];
    cell.lblDescription.frame=CGRectMake(60, 28, 260, 10);
    cell.backgroundColor=[UIColor clearColor];
    cell.messageLable.font=[UIFont fontWithName:@"BMHANNA" size:15];
    cell.messageLable.frame = CGRectMake(60, cell.contentView.frame.size.height/2-5, 260, 20);
    if(searchTopic)
    {
        PFObject *object = [searchArray objectAtIndex:indexPath.section];
        NSString *message = object[@"CategoryNameKorean"];
        NSString *catID = [NSString stringWithFormat:@"%@",object[@"CategoryId"]];
        cell.messageLable.text = message;
        cell.picImageView.image = [UIImage imageNamed:catID];
    }
    else
    {
        PFObject *object = [self.allTopicArrays objectAtIndex:indexPath.section];
        NSString *message = object[@"CategoryNameKorean"];
        NSString *catID = [NSString stringWithFormat:@"%@",object[@"CategoryId"]];
        cell.messageLable.text = message;
        cell.picImageView.image = [UIImage imageNamed:catID];
    }
    
    return cell;
}
-(void) setImage:(PFFile*)fileName onCell:(MessageCustomCell*)cell{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [fileName getData];
        if (data != nil) {
            cell.picImageView.image = [UIImage imageWithData:data];
        }
    });

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = [indexPath section];
    currentSelection = row;
    if (self.subCategoryViewController) {
        self.subCategoryViewController = nil;
    }
   [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"SubCategoryView"];
    PFObject *object = [self.allTopicArrays objectAtIndex:indexPath.section];
    NSString *catID  = object[@"CategoryId"];
        self.subCategoryViewController = [[SubCategoryViewController alloc] init];
    
    self.subCategoryViewController.selectedCategoryID = catID;
    [self.navigationController pushViewController:self.subCategoryViewController animated:YES];
      //[self presentViewController:self.subCategoryViewController animated:YES completion:nil];
    
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

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark Text Field Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    searchTopic=false;
    searchArray=nil;
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@""])
    {
        searchTopic=false;
        searchArray=nil;
        [self.categoryTabelView reloadData];
    }
           return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    searchTopic=TRUE;
    if([textField.text isEqualToString:@""])
    {
        
    }
    else
    {
        [self searchInAllCategory:textField.text];
    }

    return YES;
}



#pragma mark searc
-(void)searchInAllCategory:(NSString *)searchText
{
    NSMutableArray * searchTopicsTemp=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[self.allTopicArrays count];i++)
    {
        PFObject *object = [self.allTopicArrays objectAtIndex:i];
        NSString *message = object[@"CategoryName"];
        searchText=[searchText lowercaseString];
        message=[message lowercaseString];
    if([message hasPrefix:searchText])
    {
        NSLog(@"search string %@",message);
        [searchTopicsTemp addObject:[self.allTopicArrays objectAtIndex:i]];
    }
    }
    searchArray=[NSArray arrayWithArray:searchTopicsTemp];
    if([searchArray count]>0)
    {
    [self.categoryTabelView reloadData];
    }
    
}
//-(UIImage *)fetchImage:(int)categoryId
//{
//    if (categoryId==100) {
//        UIImage *image=[UIImage imageNamed:@"art_icon.png"];
//        return image;
//    }
//    else if (subcategoryId>=200 && subcategoryId<300)
//    {
//        UIImage *image=[UIImage imageNamed:@"business.png"];
//        return image;
//    }
//    else if (subcategoryId>=300 && subcategoryId<400)
//    {
//        UIImage *image=[UIImage imageNamed:@"math.png"];
//        return image;
//    }
//    else if (subcategoryId>=400 && subcategoryId<500)
//    {
//        UIImage *image=[UIImage imageNamed:@"game.png"];
//        return image;
//    }
//    else if (subcategoryId>=500 && subcategoryId<600)
//    {
//        UIImage *image=[UIImage imageNamed:@"geography.png"];
//        return image;
//    }
//    else if (subcategoryId>=600 && subcategoryId<700)
//    {
//        UIImage *image=[UIImage imageNamed:@"history.png"];
//        return image;
//    }
//    else if (subcategoryId>=700 && subcategoryId<800)
//    {
//        UIImage *image=[UIImage imageNamed:@"lifestyle.png"];
//        return image;
//    }
//    else if (subcategoryId>=800 && subcategoryId<900)
//    {
//        UIImage *image=[UIImage imageNamed:@"litrature.png"];
//        return image;
//    }
//    else if (subcategoryId>=900 && subcategoryId<1000)
//    {
//        UIImage *image=[UIImage imageNamed:@"movies.png"];
//        return image;
//    }
//    else if (subcategoryId>=1000 && subcategoryId<1100)
//    {
//        UIImage *image=[UIImage imageNamed:@"music.png"];
//        return image;
//    }
//    else if (subcategoryId>=1100 && subcategoryId<1200)
//    {
//        UIImage *image=[UIImage imageNamed:@"nature.png"];
//        return image;
//    }
//    else if (subcategoryId>=1200 && subcategoryId<1300)
//    {
//        UIImage *image=[[UIImage alloc]init];
//        image=[UIImage imageNamed:@"science.png"];
//        return image;
//    }
//    else if (subcategoryId>=1300 && subcategoryId<1400)
//    {
//        UIImage *image=[UIImage imageNamed:@"sports.png"];
//        return image;
//    }
//    else if (subcategoryId>=1400 && subcategoryId<1500)
//    {
//        UIImage *image=[UIImage imageNamed:@"tv.png"];
//        return image;
//    }
//    else
//    {
//        UIImage *image=[UIImage imageNamed:@"art.png"];
//        return image;
//    }
//    
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
