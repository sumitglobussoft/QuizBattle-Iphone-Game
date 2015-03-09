//
//  ViewAllViewController.m
//  QuizBattle
//
//  Created by GLB-254 on 9/10/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import "ViewAll.h"
#import "MessageCustomCell.h"
@interface ViewAll ()

@end

@implementation ViewAll

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
    currentSelection=-1;
    self.viewAll=[[UITableView alloc]initWithFrame:CGRectMake(20, 50,self.view.frame.size.width-40,self.view.frame.size.height-40) style:UITableViewStyleGrouped];
    self.viewAll.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.viewAll.delegate=self;
    self.viewAll.dataSource=self;
    self.viewAll.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.viewAll];
    
    self.backbtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 13, 50,50)];
    [self.backbtn setTitle:[ViewController languageSelectedStringForKey:@"Back"] forState:UIControlStateNormal];
    [self.backbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backbtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backbtn];

   
}
-(void)backBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(currentSelection==indexPath.section)
    {
        return 150;
    }
    
    return 48.5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 20;
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
    static NSString *cellIdentifier = @"Cell";
    
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        
    }
    //[cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    //[[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(currentSelection==indexPath.section)
    {
        
        cell.messageLable.text=@"hunny";
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(currentSelection==indexPath.section)
    {currentSelection=-1;
        [self.viewAll reloadData];
        return;
    }
    NSInteger row = [indexPath section];
    currentSelection = row;
    [UIView animateWithDuration:1 animations:^{
        [self.viewAll reloadData];
    }];
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
