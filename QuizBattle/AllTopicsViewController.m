//
//  AllTopicsViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/12/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "AllTopicsViewController.h"
#import "ViewController.h"
#import "SubCategoryViewController.h"
#import <Parse/Parse.h>

@interface AllTopicsViewController ()

@end

@implementation AllTopicsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrTopics = [[NSMutableArray alloc]init];
    searchData = [[NSMutableArray alloc] init];
    topicsTableV = [[UITableView alloc] init];
    
    topicsTableV.frame=CGRectMake(20, 5, self.view.frame.size.width-40, self.view.frame.size.height-85);
    topicsTableV.delegate=self;
    topicsTableV.dataSource=self;
    [topicsTableV setBackgroundView:nil];
    topicsTableV.backgroundColor=[UIColor clearColor];
    topicsTableV.opaque=NO;
    [self.view addSubview:topicsTableV];
    
    searchBar = [[UISearchBar alloc] init];
    searchBar.frame=CGRectMake(20, 0, self.view.frame.size.width-40, 44);
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    
    topicsTableV.tableHeaderView=searchBar;
    
    arrImages=[[NSMutableArray alloc]init];
    
    BOOL checkInternet =  [ViewController networkCheck];
    
    if (checkInternet) {
         [NSThread detachNewThreadSelector:@selector(fetchDataFromParse) toTarget:self withObject:nil];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey: @"OK"] otherButtonTitles: nil] show];
    }
}

-(void)fetchDataFromParse {
    
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
    mutArrCatIds = [[NSMutableArray alloc]init];
    NSMutableArray *mutArrCatName = [[NSMutableArray alloc]init];

    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    
    [query orderByAscending:@"CategoryId"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *arrObjects1 = [query findObjects];
        NSLog(@"Final Objects -=-= %@",arrObjects1);
        NSString *strLan = [[NSUserDefaults standardUserDefaults]objectForKey:@"language"];
        
        for (int i=0; i<[arrObjects1 count]; i++) {
            
            NSDictionary *dict = [arrObjects1 objectAtIndex:i];
            NSNumber *catId = [dict objectForKey:@"CategoryId"];
            
            NSString *strCatName;
            
            if([strLan isEqualToString:@"English"]) {
                strCatName = [dict objectForKey:@"CategoryName"];
            }
            
            else if([strLan isEqualToString:@"Korean"]) {
                strCatName = [dict objectForKey:@"CategoryNameKorean"];
            }
            else {
                strCatName = [dict objectForKey:@"CategoryName"];
            }
            PFFile  *strImage = [dict objectForKey:@"CategoryImage"];
            [mutArrCatIds addObject:catId];
            if (strCatName.length>0) {
                [mutArrCatName addObject:strCatName];
            }
            NSData *imageData = [strImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            [arrImages addObject:image];
        }
        
        NSLog(@"Category Ids -== %@ \n Category Name -== %@",mutArrCatIds, mutArrCatName);
        
        for (int i=0; i<[mutArrCatName count]; i++) {
            
            NSString *strTopic = [ViewController languageSelectedStringForKey:[NSString stringWithFormat:@"%@",[mutArrCatName objectAtIndex:i]]];
            [arrTopics addObject:strTopic];
        }
        
        dispatch_async(dispatch_get_main_queue(),^(void) {
            [topicsTableV reloadData];
            [imageVAnim stopAnimating];
        });
    });
    
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [searchData removeAllObjects];
    /*before starting the search is necessary to remove all elements from the
     array that will contain found items */
    
//    NSArray *group;
    
    /* in this loop I search through every element (group) (see the code on top) in
     the "originalData" array, if the string match, the element will be added in a
     new array called newGroup. Then, if newGroup has 1 or more elements, it will be
     added in the "searchData" array. shortly, I recreated the structure of the
     original array "originalData". */
     NSString *element;
    
    for(element in arrData) //take the n group (eg. group1, group2, group3)
        //in the original data
    {
//        NSMutableArray *newGroup = [[NSMutableArray alloc] init];
       
        
//        for(element in group) //take the n element in the group
//        {                    //(eg. @"Napoli, @"Milan" etc.)
            NSRange range = [element rangeOfString:searchString
                                           options:NSCaseInsensitiveSearch];
            
            if (range.length > 0) { //if the substring match
                [searchData addObject:element]; //add the element to group
            }
//        }
        
//        if ([newGroup count] > 0) {
//            [searchData addObject:newGroup];
//        }
    }
    [topicsTableV reloadData];
    return YES;
}

#pragma mark ===============================
#pragma mark Table View delegates Methods
#pragma mark ===============================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [arrTopics count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
   // return [arrTopics count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text=[arrTopics objectAtIndex:indexPath.section];
    UIImage *strImage = [arrImages objectAtIndex:indexPath.section];
    cell.imageView.image=strImage;
   
    cell.imageView.frame =CGRectOffset(cell.frame, 10, 10);
    cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"topic_bg_sidearrow.png"]];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48.5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    SubCategoryViewController *obj = [[SubCategoryViewController alloc]init];
    [self presentViewController:obj animated:YES completion:nil];
    
    NSString *strTitle = [arrTopics objectAtIndex:indexPath.section];
    
    strTitle = [ViewController languageSelectedStringForKey:strTitle];
    obj.lblHeader.text=strTitle;    

    obj.imageIcon=[arrImages objectAtIndex:indexPath.section];

    
        NSNumber *selectedCatId = [mutArrCatIds objectAtIndex:indexPath.section];
    
        NSMutableArray *mutArrSubCatIds = [[NSMutableArray alloc]init];
        NSMutableArray *mutArrSubCatName = [[NSMutableArray alloc]init];
        NSMutableArray *mutArrSubCatDesc = [[NSMutableArray alloc]init];
        NSMutableArray *mutArrPopScore = [[NSMutableArray alloc] init];
        NSMutableArray *mutArrObjectId = [[NSMutableArray alloc] init];
    
        dispatch_async(GCDBackgroundThread, ^{
            @autoreleasepool {
                BOOL checkInternet =  [ViewController networkCheck];
                if (checkInternet) {
                    PFQuery *query = [PFQuery queryWithClassName:@"SubCategory"];
                    
                    [query whereKey:@"CategoryId" equalTo:selectedCatId];
                    [query orderByAscending:@"SubCategoryId"];
                    
                    arrObjects = [query findObjects];
                    NSLog(@"Final Objects All Topics-=-= %@",arrObjects);
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        for (int i=0; i<[arrObjects count]; i++) {
                            
                            PFObject * myObject = [arrObjects objectAtIndex:i];
                            NSString * objectId = [myObject objectId];
                            NSDictionary *dict = [arrObjects objectAtIndex:i];
                            NSString *strSubCatId = [dict objectForKey:@"SubCategoryId"];
                            NSString *strSubCatName = [dict objectForKey:@"SubCategoryName"];
                            NSString *strSubCatDes = [dict objectForKey:@"SubCategoryDesc"];
                            NSString *strPopScore = [dict objectForKey:@"PopularityScore"];
                            
                            [mutArrSubCatIds addObject:strSubCatId];
                            [mutArrSubCatName addObject:strSubCatName];
                            if (strSubCatDes.length>0) {
                                [mutArrSubCatDesc addObject:strSubCatDes];
                            }// End of If statement Internal
                            [mutArrPopScore addObject:strPopScore];
                            [mutArrObjectId addObject:objectId];
                        }// End of For loop
                        NSLog(@"Sub Category Ids -== %@ \n Category Name -== %@ \n Description -==-%@\n Object id -=- %@",mutArrSubCatIds, mutArrSubCatName,mutArrSubCatDesc,mutArrObjectId);
                        obj.arrData=mutArrSubCatName;
                        //        NSLog(@"arrdata Values -==- %@",obj.arrData);
                        obj.arrDescription=mutArrSubCatDesc;
                        obj.arrSubCatId=mutArrSubCatIds;
                        obj.arrPopScore=mutArrPopScore;
                        obj.arrObjectId=mutArrObjectId;
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        
                        //         dispatch_async(dispatch_get_main_queue(), ^(void){
                      //  [obj.tableV reloadData];
                        [imageVAnim stopAnimating];
                    });
                }
                else{
                    
                       dispatch_async(dispatch_get_main_queue(), ^(void){
                           
                           [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];

                       });
                }
    }
});
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.; // you can have your own choice, of course
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.contentView.backgroundColor = [UIColor clearColor];
        headerView.backgroundView.backgroundColor = [UIColor clearColor];
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
