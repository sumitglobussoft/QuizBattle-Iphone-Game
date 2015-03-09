//
//  RecommendedViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/12/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "RecommendedViewController.h"
#import "ViewController.h"

@interface RecommendedViewController ()

@end

@implementation RecommendedViewController

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
    // Do any additional setup after loading the view.
    
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet) {
        
        [NSThread detachNewThreadSelector:@selector(fetchDataFromParser) toTarget:self withObject:nil];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
    }
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)167/255 green:(CGFloat)252/255 blue:(CGFloat)244/255 alpha:1]];
    
//    self.arrSubCatDesc = [[NSMutableArray alloc]init];
    self.arrSubCatName = [[NSMutableArray alloc]init];
    self.arrImages = [[NSMutableArray alloc]init];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [headerView setBackgroundColor:[UIColor colorWithRed:(CGFloat)74/255 green:(CGFloat)192/255 blue:(CGFloat)180/255 alpha:1]];
    [self.view addSubview:headerView];
    
    NSString *strBtnTitle = [ViewController languageSelectedStringForKey:@"Back"];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnBack.frame=CGRectMake(5, 5, 70, 35);
    [btnBack setTitle:strBtnTitle forState:UIControlStateNormal];
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btnBack];
    
    self.lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 5, 100, 45)];
    self.lblHeader.textAlignment=NSTextAlignmentCenter;
    self.lblHeader.font=[UIFont boldSystemFontOfSize:20];
    self.lblHeader.textColor=[UIColor whiteColor];
    self.lblHeader.text=[ViewController languageSelectedStringForKey:@"Recommended"];
    [headerView addSubview:self.lblHeader];
    
    currentSelection = -1;
    
    tableV = [[UITableView alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width-40, self.view.frame.size.height-185)];
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.delegate=self;
    tableV.dataSource=self;
    tableV.backgroundColor=[UIColor clearColor];
    [self.view addSubview:tableV];
    
//    tableV.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    tableV.layer.borderColor = [UIColor colorWithRed:(CGFloat)232/255 green:(CGFloat)232/255 blue:(CGFloat)232/255 alpha:1].CGColor;
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:tableV.bounds];
//    tableV.layer.masksToBounds = YES;
//    tableV.layer.shadowColor = [UIColor blackColor].CGColor;
//    tableV.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    tableV.layer.shadowOpacity = 0.5f;
//    tableV.layer.shadowPath = shadowPath.CGPath;
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
    
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"SubCategory"];
        [query whereKey:@"MoreSubCategory" equalTo:@"Recommended"];
        [query orderByAscending:@"SubCategoryId"];
        
        NSArray *arrObjects = [query findObjects];
        NSLog(@"Final Objects -=-= %@",arrObjects);
        
        for (int i=0; i<arrObjects.count; i++) {
            
            NSDictionary *dict = [arrObjects objectAtIndex:i];
            NSString *strName = [dict objectForKey:@"SubCategoryName"];
            //                NSString *strDesc = [dict objectForKey:@"SubCategoryDesc"];
            NSNumber *catId = [dict objectForKey:@"CategoryId"];
            
            [self.arrSubCatName addObject:strName];
            //                [self.arrSubCatDesc addObject:strDesc];
            
            PFQuery *queryCat = [PFQuery queryWithClassName:@"Category"];
            
            [queryCat orderByAscending:@"CategoryId"];
            
            [queryCat whereKey:@"CategoryId" equalTo:catId];
            
            NSArray *arrObjects = [queryCat findObjects];
            NSDictionary *dictCat = [arrObjects objectAtIndex:0];
            
            PFFile  *strImage = [dictCat objectForKey:@"CategoryImage"];
            NSData *imageData = [strImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            [self.arrImages addObject:image];
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^(void){
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
    });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [tableV reloadData];
        [imageVAnim stopAnimating];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrSubCatName count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (currentSelection == indexPath.section) {
        return 148.5;
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
    cell.gameDelegate=self;
    NSString *message = [NSString stringWithFormat:@"%@",[self.arrSubCatName objectAtIndex:indexPath.section]];
    cell.backgroundColor=[UIColor clearColor];
    cell.messageLable.frame = CGRectMake(60, 5, 260, 20);
    cell.messageLable.text = message;
    cell.lblDescription.frame=CGRectMake(60, 28, 260, 10);
//    cell.lblDescription.text=[NSString stringWithFormat:@"%@",[self.arrSubCatDesc objectAtIndex:indexPath.section]];
    cell.picImageView.image=[self.arrImages objectAtIndex:indexPath.section];
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
-(void)playNowButtonAction:(id)sender {
    
}
-(void)challengeButtonAction:(id)sender {
    
}
-(void)rankingButtonAction:(id)sender {
    
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
