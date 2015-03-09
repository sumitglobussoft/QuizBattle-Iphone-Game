//
//  HomeViewController.m
//  QuizBattle`13j,vZv
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewController.h"
#import "TopicsViewController.h"
#import "HomeViewAllSubCategories.h"
#import "ViewAll.h"
#import "GameViewController.h"
#import "AppDelegate.h"
#import "QuizupCustomTableViewCell.h"
#import "MessageCustomCell.h"
#import "FriendsViewController.h"
#import "CreateDiscussionViewController.h"
#import "Ranking.h"
#import "GameViewControllerChallenge.h"
#import "CustomSegmentController.h"
@interface HomeViewController ()
{
    NSIndexPath *seletedIndexPath;
}

@property (nonatomic, strong) UIView *firstSectionHeaderView;
@property (nonatomic, strong) UIView *secondSectionHeaderView;
@property (nonatomic, strong) UIView *thirdSectionHeaderView;
@property (nonatomic, strong) UIView *forthSectionHeaderView;
//----------------------------
@property (nonatomic, strong) NSArray *firstSectionArray;
@property (nonatomic, strong) NSArray *secondCustomArray;
@property (nonatomic, strong) NSArray *thirdSectionArray;
@property (nonatomic, strong) NSArray *fourthSectionArray;
@property (nonatomic, strong) UITableView *customTableView;
//-----------------------------
@property (nonatomic, strong) UILabel *sectionFirstTitle;
@property (nonatomic, strong) UILabel *sectionSecondTitle;
@property (nonatomic, strong) UILabel *sectionThirdTitle;
@property (nonatomic, strong) UILabel *sectionFourthTitle;
//------MENU CELL VIEW

@end

@implementation HomeViewController

-(void) settingDetails:(NSArray *)settingDetail{
    NSLog(@"Array = %@",settingDetail);
}

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
-(void)viewWillAppear:(BOOL)animated
{
    if(self.customTableView)
    {
        [self.customTableView reloadData];
    }
}
-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"challengeGameCase" object:nil];
}
-(void)changeTextLanguage {
    
     headerLabel.text=[ViewController languageSelectedStringForKey:@"Personalized"];
     headerLabelRollDice.text=[ViewController languageSelectedStringForKey:@"EVERYBODY WANTS TO BE A CAT"];
     headerLabelEdit.text=[ViewController languageSelectedStringForKey:@"Editorial"];
}
-(void) handleLanguageUpdateNotification:(NSNotification *)notify{
    id value = [notify object];
    if (![value isKindOfClass:[NSString class]]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.customTableView reloadData];

    });
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    gradeName=@"베이비";
    [self fetchDataForAllSubCat];
    self.navController =[[UINavigationController alloc]init];
    self.dictForChallenege=[[NSMutableDictionary alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameViewControllerChallenge) name:@"challengeGameCase" object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLanguageUpdateNotification:) name:KLanguageUpdateNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playGameChallenge) name:@"gameUiChallenge" object:nil];
    self.imageArray=[[NSMutableArray alloc]init];
    [NSThread detachNewThreadSelector:@selector(checkChallengeStatus) toTarget:self withObject:nil];
      segmentEdit1=TRUE;
      segmentPer1=TRUE;
    [self fetchDatafromParseinEdit];
   //[self checkChallengeStatus];
}
-(void)tableHeaderShowingGrade
{
    UIView * tableHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,300)];
    tableHeader.backgroundColor=[UIColor colorWithRed:(CGFloat)53/255 green:(CGFloat)83/255 blue:(CGFloat)119/255 alpha:1];
    UIImageView * userImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 80, 80)];
    userImage.image=[SingletonClass sharedSingleton].imageUser;
    userImage.layer.cornerRadius=40;
    userImage.layer.borderWidth=1;
    userImage.layer.borderColor=[UIColor whiteColor].CGColor;
    userImage.clipsToBounds=YES;
    [tableHeader addSubview:userImage];
    //---
    long totalXp=(long)[[SingletonClass sharedSingleton].totalXp intValue];
    badgeImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150, 70, 125, 125)];
    badgeImage.image=[UIImage imageNamed:[self progress:totalXp]];
     [tableHeader addSubview:badgeImage];
    //--
    UILabel * userName=[[UILabel alloc]initWithFrame:CGRectMake(30, userImage.frame.origin.y+90, 80, 20)];
    userName.text=[SingletonClass sharedSingleton].strUserName;
    userName.textColor=[UIColor whiteColor];
    [userName sizeToFit];
    userName.textAlignment=NSTextAlignmentCenter;
    [tableHeader addSubview:userName];
    //--
    UILabel * gradeLbl=[[UILabel alloc]initWithFrame:CGRectMake(30,userName.frame.origin.y+30, 80, 20)];
    gradeLbl.textAlignment=NSTextAlignmentCenter;
    gradeLbl.textColor=[UIColor whiteColor];
     gradeLbl.text=badgeName;
    [gradeLbl sizeToFit];
    [tableHeader addSubview:gradeLbl];
    //--
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.frame = CGRectMake(30,gradeLbl.frame.origin.y+40,80,20);
    progressView.backgroundColor=[UIColor blueColor];
    progressView.progress=progress;
    progressView.layer.cornerRadius = 5;
    progressView.clipsToBounds = YES;
    progressView.progressTintColor=[UIColor colorWithRed:(CGFloat)97/255 green:(CGFloat)170/255 blue:(CGFloat)235/255 alpha:1];
    [progressView setTransform:CGAffineTransformMakeScale(1.0, 6.0)];
    [tableHeader addSubview:progressView];
    //--
    UILabel * gpLbl=[[UILabel alloc]initWithFrame:CGRectMake(30, progressView.frame.origin.y+30, 80, 20)];
    
        gpLbl.text=[NSString stringWithFormat:@"GP:%ld",totalXp];
        [gpLbl sizeToFit];
    gpLbl.textColor=[UIColor whiteColor];
    [tableHeader addSubview:gpLbl];
    
    self.customTableView.tableHeaderView=tableHeader;
    
}
-(NSString*)progress:(long)points
{
    
       if(points<811)
        {
            if(points==0)
            {
                progress=0;
            }
            else
            {
            progress=.125;
            }
            badgeName=@"알 등급";
            return @"KinderGarten";
            
        }
    
       else if(points>=811&&points<=5150)
        {
            progress=.25;
            badgeName=@"알깨! 등급";
            return @"ElementarySchool";
            
        }
        else if(points>=5151&&points<=15770)
        {
             progress=.375;
            badgeName=@"알깬 등급";
            return @"MiddleSchool";
            
        }
        else if(points>=15771&&points<=59670)
        {
             progress=.5;
            badgeName=@"날개달아 등급";
            return @"HighSchool";
        }
        else if (points>=59671&&points<=359370)
        {
             progress=.625;
            badgeName=@"많이컸네! 등급";
              return @"University";
        
        }
        else if(points>=359371&&points<=801621)
        {
             progress=.75;
            badgeName=@"아이언 등급";
            return @"Master";
        }
        else if(points>=801621&&points<=1418870)
        {
             progress=.875;
            badgeName=@"히어로 등급";
          return @"Doctor";
        }
   
        else if(points>=1418771)
        {
            progress=1;
            badgeName=@"퀴즈대마왕";
            return @"Quiz King";
            
        }
    return @"";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark -
-(void) createCustomTable
{
    seletedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
// self.firstSectionArray = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"30 Rock",@"Title",@"Enjoy the Ride",@"Description",@"100",@"Image", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Horses",@"Title",@"Your favorite odd-toed ungulate mammal!",@"Description",@"100",@"Image", nil], nil];
    //self.secondCustomArray = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"30 Rock",@"Title",@"Enjoy the Ride",@"Description", nil], nil];

    //self.thirdSectionArray = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Nicholas Sparks",@"Title",@"A romantic journey from page to screen",@"Description", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Who am i",@"Title",@"Your favorite",@"Description", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"SciShow Fun Facts",@"Title",@"Learn more at sciShow on YouTube",@"Description", nil], nil];
    
  //  self.fourthSectionArray = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Bollywood",@"Title",@"Where Bombay meets Hollywood",@"Description", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Cricket",@"Title",@"Flannelled fools at the wicket",@"Description", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Name the Bollywood",@"Title",@"Superstars of Hindi cinema",@"Description", nil], nil];
    
    self.customTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.customTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.customTableView.backgroundView = nil;
    self.customTableView.bounces=NO;
    self.customTableView.backgroundColor = [UIColor colorWithRed:(CGFloat)167/255 green:(CGFloat)252/255 blue:(CGFloat)244/255 alpha:1];
    self.customTableView.rowHeight = 60;
    self.customTableView.delegate = self;
    self.customTableView.dataSource = self;
    [self.customTableView setShowsHorizontalScrollIndicator:NO];
    [self.customTableView setShowsVerticalScrollIndicator:NO];
    [self tableHeaderShowingGrade];
    [self.view addSubview:self.customTableView];
    
}
#pragma mark Table Delegates-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return self.firstSectionArray.count;
    }
    else if(section==1){
        return self.secondCustomArray.count;
    }
    else if(section==2)
    {
        if(self.thirdSectionArray.count>3)
        {
            return 3;
        }

        return self.thirdSectionArray.count;
    }
    else if(section==3)
    {
        if(self.fourthSectionArray.count >3)
        {
            return 3;
        }
        return self.fourthSectionArray.count;
    }
    return 0;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 60;
    }
    else if(section==1){
        if (self.secondCustomArray.count<1)
        {
            return 10;
        }
        return 60;
    }
    else if(section==2){
        return 100;
    }
    else if(section==3){
        return 100;
    }
    return 0;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([seletedIndexPath compare:indexPath]==NSOrderedSame) {
        return 145;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 32;
    }
    else if(section==1)
    {
        if (self.secondCustomArray.count<1)
        {
            return 10;
        }
        return 32;
    }
    else if(section==2){
        return 52;
    }
    else if(section==3){
        return 52;
    }
    return 0;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *f  = [[UIView alloc] init];
    CALayer *layer = [CALayer layer];
    if (section==0) {
        
        layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 32);
        layer.backgroundColor = [UIColor colorWithRed:(CGFloat)241/255 green:(CGFloat)222/255 blue:(CGFloat)146/255 alpha:1.0].CGColor;
        
        layer.masksToBounds = NO;
        layer.shadowOffset = CGSizeMake(-15, 20);
        layer.shadowRadius = 2;
        layer.shadowOpacity = 0.7;
        layer.shadowPath = [UIBezierPath bezierPathWithRect:f.bounds].CGPath;
        [f.layer insertSublayer:layer atIndex:0];
        f.frame = CGRectMake(0, 0, self.view.frame.size.width, 32);
       
        //f.backgroundColor = [UIColor colorWithRed:(CGFloat)151/255 green:(CGFloat)51/255 blue:(CGFloat)53/255 alpha:1.0];
        return f;
    }
    else if (section==1){
        if (self.secondCustomArray.count<1)
        {
            layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
            layer.backgroundColor = [UIColor colorWithRed:(CGFloat)241/255 green:(CGFloat)222/255 blue:(CGFloat)146/255 alpha:1.0].CGColor;
            [f.layer insertSublayer:layer atIndex:0];
            f.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
                      return f;
        }
        layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
        layer.backgroundColor = [UIColor colorWithRed:(CGFloat)252/255 green:(CGFloat)86/255 blue:(CGFloat)88/255 alpha:1.0].CGColor;
        [f.layer insertSublayer:layer atIndex:0];
        f.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
        //f.backgroundColor = [UIColor colorWithRed:(CGFloat)252/255 green:(CGFloat)86/255 blue:(CGFloat)88/255 alpha:1.0];
        return f;
    }
    else if (section==2){
        layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        layer.backgroundColor = [UIColor colorWithRed:(CGFloat)198/255 green:(CGFloat)230/255 blue:(CGFloat)245/255 alpha:1.0].CGColor;
        [f.layer insertSublayer:layer atIndex:0];
         f.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        //------
        if([self.thirdSectionArray count]>3)
        {
        UIButton * viewButton=[UIButton buttonWithType:UIButtonTypeCustom];
        viewButton.frame=CGRectMake(120, 10, 80, 30);
        [viewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [viewButton setTitle:[ViewController languageSelectedStringForKey:@"View All"] forState:UIControlStateNormal];
        [viewButton addTarget:self action:@selector(viewAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        viewButton.layer.cornerRadius=5;
        [viewButton setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
            [f addSubview:viewButton];
        }
        
        //----
       
        //f.backgroundColor = [UIColor colorWithRed:(CGFloat)152/255 green:(CGFloat)118/255 blue:(CGFloat)227/255 alpha:1.0];
        return f;
    }
    else if (section==3){
        layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        layer.backgroundColor = [UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0].CGColor;
        [f.layer insertSublayer:layer atIndex:0];
        f.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        if([self.fourthSectionArray count]>3)
        {
            UIButton * viewButton=[UIButton buttonWithType:UIButtonTypeCustom];
            viewButton.frame=CGRectMake(120, 10, 80, 30);
            [viewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [viewButton setTitle:[ViewController languageSelectedStringForKey:@"View All"] forState:UIControlStateNormal];
            [viewButton addTarget:self action:@selector(viewAllBtn:) forControlEvents:UIControlEventTouchUpInside];
            viewButton.layer.cornerRadius=5;
            
            [viewButton setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
            [f addSubview:viewButton];
        }

        //----

        //f.backgroundColor = [UIColor colorWithRed:(CGFloat)34/255 green:(CGFloat)207/255 blue:(CGFloat)119/255 alpha:1.0];
        return f;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section==0)
    {
        //static UILabel *titleLabel = nil;
        if (!self.firstSectionHeaderView)
        {
            self.firstSectionHeaderView = [self initilizeView:self.firstSectionHeaderView];
            self.firstSectionHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
            self.firstSectionHeaderView.backgroundColor = [UIColor colorWithRed:(CGFloat)241/255 green:(CGFloat)222/255 blue:(CGFloat)146/255 alpha:1.0];
            UIButton * allTopicButton=[[UIButton alloc]init];
            allTopicButton.frame=CGRectMake(self.view.frame.size.width/2-80, 8, 160, 30);
            [allTopicButton addTarget:self action:@selector(switchToTopic) forControlEvents:UIControlEventTouchUpInside];
            [allTopicButton setTitle:@"오늘의 퀴즈" forState:UIControlStateNormal];
            [allTopicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            allTopicButton.backgroundColor=[UIColor clearColor];
            [self.firstSectionHeaderView addSubview:allTopicButton];
        }
    
        return self.firstSectionHeaderView;
    }
    else if (section == 1)
    {
        UIView *f  = [[UIView alloc] init];
        CALayer *layer = [CALayer layer];
        if (self.secondCustomArray.count<1) {
            layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
            layer.backgroundColor = [UIColor colorWithRed:(CGFloat)241/255 green:(CGFloat)222/255 blue:(CGFloat)146/255 alpha:1.0].CGColor;
            [f.layer insertSublayer:layer atIndex:0];
            f.frame = CGRectMake(0, 0, self.view.frame.size.width, 10);
            return f;
        }
        //static UILabel *titleLabel = nil;
        if (!self.secondSectionHeaderView)
        {
            self.secondSectionHeaderView = [self initilizeView:self.secondSectionHeaderView];
            self.secondSectionHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
            self.secondSectionHeaderView.backgroundColor = [UIColor colorWithRed:(CGFloat)252/255 green:(CGFloat)86/255 blue:(CGFloat)88/255 alpha:1.0];
            self.sectionSecondTitle = [self initializeLabel:self.sectionSecondTitle];
            self.sectionSecondTitle.frame = CGRectMake(20, 5, self.view.frame.size.width-40, 50);
            [self.secondSectionHeaderView addSubview:self.sectionSecondTitle];
        }
        self.sectionSecondTitle.text = [ViewController languageSelectedStringForKey:@"YOUR TURN"];
        return self.secondSectionHeaderView;
    }
    else if (section == 2)
    {
        if (!self.thirdSectionHeaderView) {
            self.thirdSectionHeaderView = [self initilizeView:self.thirdSectionHeaderView];
            self.thirdSectionHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
            self.thirdSectionHeaderView.backgroundColor = [UIColor colorWithRed:(CGFloat)198/255 green:(CGFloat)230/255 blue:(CGFloat)245/255 alpha:1.0];
            self.sectionThirdTitle = [self initializeLabel:self.sectionThirdTitle];
            self.sectionThirdTitle.frame = CGRectMake(20, 5, self.view.frame.size.width-40, 30);
            self.sectionThirdTitle.textAlignment = NSTextAlignmentCenter;
            [self.thirdSectionHeaderView addSubview:self.sectionThirdTitle];
            segEditorial= [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"New Content", @"Staff Picks", @"Popular", nil]];
            segEditorial.selectedSegmentIndex=0;
            segEditorial.tag=100;
            segEditorial.layer.cornerRadius=5;
            segEditorial.clipsToBounds=YES;
            segEditorial.layer.borderWidth=1.0;
            segEditorial.layer.borderColor=[UIColor colorWithRed:(CGFloat)198/255 green:(CGFloat)230/255 blue:(CGFloat)245/255 alpha:1.0].CGColor;
           // segEditorial.segmentedControlStyle  = UISegmentedControlStyleBar;
            segEditorial.frame= CGRectMake(20, 50, self.view.frame.size.width-40, 30);
            [segEditorial addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
            
            segEditorial.tintColor= [UIColor blackColor];
            
            [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
            segEditorial.backgroundColor=[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f];
            
            //---------------
            CustomSegmentController * segEdit=[[CustomSegmentController alloc]initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, 30)];
            [segEdit drawUi:3];
            
            [segEdit.segButton1 addTarget:self action:@selector(actionSegment1:) forControlEvents:UIControlEventTouchUpInside];
            segEdit.segButton1.tag=51;
            segEdit.segButton1.hidden=NO;
            [segEdit.segButton2 addTarget:self action:@selector(actionSegment1:) forControlEvents:UIControlEventTouchUpInside];
            segEdit.segButton2.hidden=NO;
            segEdit.segButton2.tag=52;
            [segEdit.segButton3 addTarget:self action:@selector(actionSegment1:) forControlEvents:UIControlEventTouchUpInside];
            segEdit.segButton3.hidden=NO;
            segEdit.segButton3.tag=53;
                    //----------------
            [segEdit.segButton1 setTitle:[ViewController languageSelectedStringForKey:@"New Content"] forState:UIControlStateNormal];
             [segEdit.segButton2 setTitle:@"추천" forState:UIControlStateNormal];
             [segEdit.segButton3 setTitle:[ViewController languageSelectedStringForKey:@"Popular"] forState:UIControlStateNormal];
            [self.thirdSectionHeaderView addSubview:segEdit];
        }
        
        [segEditorial setTitle:[ViewController languageSelectedStringForKey:@"New Content"] forSegmentAtIndex:0];
        [segEditorial setTitle:@"추천" forSegmentAtIndex:1];
        [segEditorial setTitle:[ViewController languageSelectedStringForKey:@"Popular"] forSegmentAtIndex:2];
        self.sectionThirdTitle.textColor=[UIColor blackColor];
        self.sectionThirdTitle.text =@"간편보기";//[ViewController languageSelectedStringForKey:@"Editorial"];
        return self.thirdSectionHeaderView;
    }
    else if (section == 3){
        
        ///static UILabel *titleLabel = nil;
        if (!self.forthSectionHeaderView)
        {
            self.forthSectionHeaderView = [self initilizeView:self.forthSectionHeaderView];
            self.forthSectionHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
            self.forthSectionHeaderView.backgroundColor = [UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
            self.sectionFourthTitle = [self initializeLabel:self.sectionFourthTitle];
            self.sectionFourthTitle.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
            self.sectionFourthTitle.textAlignment = NSTextAlignmentCenter;
            [self.forthSectionHeaderView addSubview:self.sectionFourthTitle];
            segPersonalized= [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Recently Played", @"Recommended", nil]];
           // segPersonalized.segmentedControlStyle= UISegmentedControlStyleBar;
             segPersonalized.layer.borderWidth=1.0;
            segPersonalized.layer.borderColor=[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0].CGColor;
            segPersonalized.frame= CGRectMake(20, 50, self.view.frame.size.width-40, 30);
            segPersonalized.selectedSegmentIndex=0;
           [segPersonalized addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
            [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
            segPersonalized.backgroundColor=[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f];
           segPersonalized.tintColor= [UIColor blackColor];
            [self.forthSectionHeaderView addSubview:segPersonalized];
            //-----------
            //---------------
            CustomSegmentController * segPer=[[CustomSegmentController alloc]initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, 30)];
            [segPer drawUi:2];
            
            [segPer.segButton1 addTarget:self action:@selector(actionSegment2:) forControlEvents:UIControlEventTouchUpInside];
            segPer.segButton1.tag=61;
            segPer.segButton1.hidden=NO;
            [segPer.segButton2 addTarget:self action:@selector(actionSegment2:) forControlEvents:UIControlEventTouchUpInside];
            segPer.segButton2.hidden=NO;
            segPer.segButton2.tag=62;
        
            //----------------
            [segPer.segButton1 setTitle:[ViewController languageSelectedStringForKey:@"Recently Played"]  forState:UIControlStateNormal];
            [segPer.segButton2 setTitle:[ViewController languageSelectedStringForKey:@"Recommended"] forState:UIControlStateNormal];
            
            [self.forthSectionHeaderView addSubview:segPer];
            //-----------
            
            
            
        }
        [segPersonalized setTitle:[ViewController languageSelectedStringForKey:@"Recently Played"] forSegmentAtIndex:0];
        [segPersonalized setTitle:[ViewController languageSelectedStringForKey:@"Recommended"] forSegmentAtIndex:1];
        self.sectionFourthTitle.text = @"개인토픽";
        self.sectionFourthTitle.textColor=[UIColor blackColor];
        self.sectionFourthTitle.backgroundColor=[UIColor colorWithRed:244.0f/255.0f green:186.0f/255.0f blue:226.0f/255.0f alpha:1.0f];
        
        return self.forthSectionHeaderView;
    }
    return nil;
}
-(UIView*) initilizeView:(UIView *)aView{

    aView = [[UIView alloc] init];
    aView.userInteractionEnabled = YES;
    return aView;
}
-(UILabel *)initializeLabel:(UILabel *)label{
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font =[UIFont boldSystemFontOfSize:18];
    return label;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell Identifier";
    MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell==nil) {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.challengeButton addTarget:self action:@selector(challengeAction:) forControlEvents:UIControlEventTouchUpInside];
    //-----
    [cell.discussionButton addTarget:self action:@selector(discussionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.playNowButton addTarget:self action:@selector(playNowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.playNowButton.tag=indexPath.section;
    cell.gameDelegate=self;
    //----
    
    cell.topView.frame=CGRectMake(20, 0, cell.contentView.frame.size.width-40, 60);

        cell.messageLable.frame = CGRectMake(60,cell.contentView.frame.size.height/2-5, 260, 20);
  //  cell.lblDescription.frame = CGRectMake(60, 28, 260, 20);
    [cell.rankingButton addTarget:self action:@selector(rankingAction:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *dict = nil;
    if (indexPath.section==0)
    {
        dict = [self.firstSectionArray objectAtIndex:indexPath.row];
        cell.contentView.backgroundColor =[UIColor colorWithRed:(CGFloat)241/255 green:(CGFloat)222/255 blue:(CGFloat)146/255 alpha:1.0];
//      cell.topView.frame =CGRectMake(22, 0, cell.contentView.frame.size.width-45, 48.5);
       
        //cell.batteryImage.frame=CGRectMake( cell.contentView.frame.size.width-90, 5, 21, 40);
       // cell.gradeName.frame=CGRectMake(cell.contentView.frame.size.width-120, 5, 30, 40);
    }
    else if(indexPath.section==1){
        dict = [self.secondCustomArray objectAtIndex:indexPath.row];
        cell.contentView.backgroundColor = [UIColor colorWithRed:(CGFloat)252/255 green:(CGFloat)86/255 blue:(CGFloat)88/255 alpha:1.0];
        //---
        cell.playNowButton.hidden=YES;
        cell.challengeButton.hidden=YES;
        cell.rankingButton.hidden=YES;
        cell.discussionButton.hidden=YES;
       
        //--
        UIButton * accept=[[UIButton alloc]initWithFrame:CGRectMake(10, 20, 110, 42)];
        [accept setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
        [accept setTitle:[ViewController languageSelectedStringForKey:@"Accept"] forState:UIControlStateNormal];
        [accept setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [accept addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.menuView addSubview:accept];
        //--
        UIButton * reject=[[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width/2-20, 20,110, 42)];
        [reject setBackgroundImage:[UIImage imageNamed:@"reject_btn.png"] forState:UIControlStateNormal];
        [reject setTitle:[ViewController languageSelectedStringForKey:@"Reject"] forState:UIControlStateNormal];
        [reject setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [reject addTarget:self action:@selector(rejectAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.menuView addSubview:reject];
        //--
        
    }
    else if(indexPath.section==2)
    {
        dict = [self.thirdSectionArray objectAtIndex:indexPath.row];
        NSLog(@"index path %@",self.thirdSectionArray);
        cell.contentView.backgroundColor = [UIColor colorWithRed:(CGFloat)198/255 green:(CGFloat)230/255 blue:(CGFloat)245/255 alpha:1.0];

        if(segmentEdit1)
        {
            //cell.topView.image = [UIImage imageNamed:@"new_tag.png"];
//            cell.topView.frame =CGRectMake(22, 0, cell.contentView.frame.size.width-45, 56);
//            
          //  cell.batteryImage.frame=CGRectMake( cell.contentView.frame.size.width-90, 5, 21, 40);
           // cell.gradeName.frame=CGRectMake(cell.contentView.frame.size.width-120, 5, 30, 40);
            
        }

    }
    else if(indexPath.section==3)
    {
        dict = [self.fourthSectionArray objectAtIndex:indexPath.row];
        cell.contentView.backgroundColor =[UIColor colorWithRed:(CGFloat)244/255 green:(CGFloat)186/255 blue:(CGFloat)226/255 alpha:1.0];
    }
    NSString *titleString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Title"]];
    NSString *descriptionString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Description"]];
    NSString * categoryImageName=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Image"]];
    NSString *batteryImgName=[NSString stringWithFormat:@"%@",[dict objectForKey:@"BatteryImage"]];
    NSString *gradeNamelocal;
    if(![titleString isEqualToString:@"최근 플레이가 없습니다"])
    {
        if([dict objectForKey:@"GradeName"])
        {
            gradeNamelocal=[NSString stringWithFormat:@"%@",[dict objectForKey:@"GradeName"]];
        }
        else
        {
            gradeNamelocal=[NSString stringWithFormat:@"베이비"];
        }
    }
        cell.messageLable.text = titleString;
    cell.messageLable.font=[UIFont fontWithName:@"BMHANNA" size:15];
    cell.lblDescription.text = descriptionString;
//    if (indexPath.row%2==0) {
        cell.picImageView.image = [UIImage imageNamed:categoryImageName];
    cell.batteryImage.image=[UIImage imageNamed:batteryImgName];
    NSLog(@"grade name Local %@",gradeNamelocal);
    cell.gradeName.text=gradeNamelocal;
  
    if ([seletedIndexPath compare:indexPath]==NSOrderedSame) {
        cell.menuView.hidden = NO;
        cell.menuView.frame = CGRectMake(32, 48, self.view.frame.size.width-60, 75);
        [UIView animateWithDuration:1 animations:^{
            cell.menuView.layer.opacity = 1.0f;
        }];
        

    }
    else{
        cell.menuView.hidden = YES;
        cell.menuView.frame = CGRectZero;
        [UIView animateWithDuration:1 animations:^{
            cell.menuView.layer.opacity = 0.0f;
        }];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView beginUpdates];
    rowSelected=indexPath.section;
    if ([seletedIndexPath compare:indexPath]==NSOrderedSame) {
          MessageCustomCell *cell = (MessageCustomCell*)[tableView cellForRowAtIndexPath:seletedIndexPath];
        seletedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
       cell.menuView.frame = CGRectZero;
        cell.menuView.hidden = YES;
        cell.menuView.layer.opacity = 0.0;
    }
    else{
        MessageCustomCell *cell = (MessageCustomCell*)[tableView cellForRowAtIndexPath:seletedIndexPath];
        seletedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [UIView animateWithDuration:1 animations:^{
            cell.menuView.hidden = NO;
            cell.menuView.layer.opacity = 1.0f;
        }];
    }
     NSDictionary *dict = nil;
    if(indexPath.section==0)
    {
        dict=[self.firstSectionArray objectAtIndex:indexPath.row];
    }
    else if(indexPath.section==1)
    {
         dict=[self.secondCustomArray objectAtIndex:indexPath.row];
       // [SingletonClass sharedSingleton].strQuestionsId=[dict objectForKey:@"Question"];
         [self.dictForChallenege setObject:[dict objectForKey:@"Question"] forKey:@"questionsChall"];
        [SingletonClass sharedSingleton].secondPlayerObjid=[dict objectForKey:@"OpponentId"];
        challTableObjId=[dict objectForKey:@"objectIdChall"];
    }
    else if (indexPath.section==2)
    {
         dict=[self.thirdSectionArray objectAtIndex:indexPath.row];
    }
    else if (indexPath.section==3)
    {
         dict=[self.fourthSectionArray objectAtIndex:indexPath.row];
    }
    [SingletonClass sharedSingleton].selectedSubCat=[dict objectForKey:@"SubCategoryId"];
    [SingletonClass sharedSingleton].strSelectedSubCat=[dict objectForKey:@"Title"];
    [SingletonClass sharedSingleton].strSelectedCategoryId=[dict objectForKey:@"Image"];
    NSLog(@"Selected Subcategory %@ and Id %@", [SingletonClass sharedSingleton].selectedSubCat,[SingletonClass sharedSingleton].strSelectedSubCat);
    [tableView reloadData];
    [tableView endUpdates];
    
}
-(void)segmentAction:(UISegmentedControl*)segment
{
    if(segEditorial==segment)
    {
        if(segment.selectedSegmentIndex==0)
        {
            segmentEdit1=TRUE;
            segmentEdit2=FALSE;
            segmentEdit3=FALSE;
            self.thirdSectionArray=[NSArray arrayWithArray:self.contentNew];
        }
        else if(segment.selectedSegmentIndex==1)
        {
            segmentEdit1=FALSE;
            segmentEdit2=TRUE;
            segmentEdit3=FALSE;
            self.thirdSectionArray=[NSArray arrayWithArray:self.staffPick];
        }
        else if (segment.selectedSegmentIndex==2)
        {
            segmentEdit1=FALSE;
            segmentEdit2=FALSE;
            segmentEdit3=TRUE;

            self.thirdSectionArray=[NSArray arrayWithArray:self.popularity];
            
        }
    }
    if(segment==segPersonalized)
    {
        
        if(segment.selectedSegmentIndex==0)
        {
            segmentPer1=TRUE;
            segmentPer2=FALSE;
            self.fourthSectionArray=[NSArray arrayWithArray:self.recentlyPlayed];
        }
        else if(segment.selectedSegmentIndex==1)
        {
            segmentPer1=FALSE;
            segmentPer2=TRUE;
            self.fourthSectionArray=[NSArray arrayWithArray:self.recommend];
        }
        

    }
    [self.customTableView reloadData];
}
-(void)actionSegment1:(UIButton*)btn
{
    [btn setBackgroundColor:[UIColor blackColor]];
    if(btn.tag==51)
    {
        //----------------
        segmentEdit1=TRUE;
        segmentEdit2=FALSE;
        segmentEdit3=FALSE;
        self.thirdSectionArray=[NSArray arrayWithArray:self.contentNew];
        //----------------
        UIButton * btn=(UIButton*)[self.view viewWithTag:52];
        [btn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
        btn=(UIButton*)[self.view viewWithTag:53];
        [btn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
        //-----------
    }
    else if(btn.tag==52)
    {
        
        segmentEdit1=FALSE;
        segmentEdit2=TRUE;
        segmentEdit3=FALSE;
        self.thirdSectionArray=[NSArray arrayWithArray:self.staffPick];
        //-------------------
        UIButton * btn=(UIButton*)[self.view viewWithTag:53];
        [btn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
        btn=(UIButton*)[self.view viewWithTag:51];
        [btn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
        //--------------
        
    }
    else if(btn.tag==53)
    {
        //-----------
        segmentEdit1=FALSE;
        segmentEdit2=FALSE;
        segmentEdit3=TRUE;
        
        self.thirdSectionArray=[NSArray arrayWithArray:self.popularity];
        //-----------
        UIButton * btn=(UIButton*)[self.view viewWithTag:52];
        [btn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
        btn=(UIButton*)[self.view viewWithTag:51];
        [btn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
        
    }
    [self.customTableView reloadData];
}
-(void)actionSegment2:(UIButton*)btn
{
    [btn setBackgroundColor:[UIColor blackColor]];
    if(btn.tag==61)
    {
        //----------------
        segmentPer1=TRUE;
        segmentPer2=FALSE;
        self.fourthSectionArray=[NSArray arrayWithArray:self.recentlyPlayed];
        //----------------
        UIButton * btn=(UIButton*)[self.view viewWithTag:62];
        [btn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
        
        //-----------
    }
    else if(btn.tag==62)
    {
        
        segmentPer1=FALSE;
        segmentPer2=TRUE;
        self.fourthSectionArray=[NSArray arrayWithArray:self.recommend];        //-------------------
        btn=(UIButton*)[self.view viewWithTag:61];
        [btn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f]];
        //--------------
        
    }
       [self.customTableView reloadData];
}

-(void)viewAllBtn:(id)sender
{
    NSString *strSegName;
    if (segmentEdit1) {
        strSegName=[NSString stringWithFormat:@"%@",[ViewController languageSelectedStringForKey:@"New Content"]];
        
    }
    if (segmentEdit2)
    {
        strSegName=[NSString stringWithFormat:@"%@",[ViewController languageSelectedStringForKey:@"Staff Picks"]];
        
    }
    if (segmentEdit3)
    {
        strSegName=[NSString stringWithFormat:@"%@",[ViewController languageSelectedStringForKey:@"Popular"]];
        
    }
    if (segmentPer1) {
        strSegName=[NSString stringWithFormat:@"%@",[ViewController languageSelectedStringForKey:@"Recently Played"]];
    }
    if (segmentPer2) {
        strSegName=[NSString stringWithFormat:@"%@",[ViewController languageSelectedStringForKey:@"Recommended"]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Home_Again"];
    HomeViewAllSubCategories * homeObj=[[HomeViewAllSubCategories alloc] init];
    homeObj.viewAllDetail=self.thirdSectionArray;
    homeObj.segName=strSegName;
    [self.navigationController pushViewController:homeObj animated:YES];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSString stringWithFormat:@"Show"]
                                                     forKey:@"detect"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}
-(void)switchToTopic
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"All_Topics"];
    TopicsViewController *topic = [[TopicsViewController alloc] initWithNibName:@"TopicsViewController" bundle:nil];
    topic.title = @"토픽";
     [self.navigationController pushViewController:topic animated:YES];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSString stringWithFormat:@"Show"]
                                                     forKey:@"detect"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}
#pragma mark Challenge Action and game methods
-(void)challengeAction:(id)sender
{
//---------
    [SingletonClass sharedSingleton].pickFriendsChallenge=TRUE;
    FriendsViewController *frnd=[[FriendsViewController alloc]init];
    frnd.previousView=@"Challenge";
    [self.navigationController pushViewController:frnd animated:YES];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSString stringWithFormat:@"Show"]
                                                     forKey:@"detect"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
  //[self.navController pushViewController:frnd animated:YES];
  //  [self presentViewController:frnd animated:YES completion:nil];
}
-(void)gameForChallenge:(NSDictionary*)details
{
    [SingletonClass sharedSingleton].strQuestionsId=[details objectForKey:@"questionsChall"];
    GameViewControllerChallenge *challengeGame = [[GameViewControllerChallenge alloc] init];
    challengeGame.opponenetScore=challUserScore;
    [SingletonClass sharedSingleton].challengeRequestObjId=gameResultObjId;
 
    [self presentViewController:challengeGame animated:YES completion:nil];
}
-(void)gameViewControllerChallenge
{
    GameViewControllerChallenge *challengeGame = [[GameViewControllerChallenge alloc] init];
    [SingletonClass sharedSingleton].singleGameChallengedPlayer=NO;
    [SingletonClass sharedSingleton].challStartCase=YES;
     [self presentViewController:challengeGame animated:YES completion:nil];
}
-(void)deleteChallengeRequest
{
    PFQuery * delQuery=[PFQuery queryWithClassName:@"ChallengeRequest"];
    [delQuery whereKey:@"OpponentId" equalTo:[SingletonClass sharedSingleton].objectId];
    [delQuery whereKey:@"objectId" equalTo:challTableObjId];
    NSArray * temp=[delQuery findObjects];
    for (int i=0; i<[temp count]; i++)
    {
        PFObject * delObj=[temp objectAtIndex:i];
        [delObj deleteInBackground];
    }
    
}
#pragma mark Discussion Action
-(void)discussionBtnAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Home_Again_Discussion"];    CreateDiscussionViewController * createDiscussoin = [[CreateDiscussionViewController alloc]init];
    [self.navigationController pushViewController:createDiscussoin animated:YES];
    //--------
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSString stringWithFormat:@"Show"]
                                                     forKey:@"detect"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}

#pragma mark Ranking=====
-(void)rankingAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateBackButtonNotification object:@"Home_Again_Ranking"];
    Ranking * ranks=[[Ranking alloc]init];
    [self.navigationController pushViewController:ranks animated:YES];
    
    //--------
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSString stringWithFormat:@"Show"]
                                                     forKey:@"detect"];

 [[NSNotificationCenter defaultCenter]postNotificationName:@"backButtonHome" object:nil userInfo:dict];
}
-(void)createUi
{
    UIScrollView * ranking=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    ranking.backgroundColor=[UIColor whiteColor];
    ranking.contentSize=CGSizeMake(self.view.bounds.size.width, self.view.frame.size.height+100);
    for(int i=0;i<[self.rankingDetail count];i++)
    {
        PFObject * object=[self.rankingDetail objectAtIndex:i];
        ;
        UILabel * rank=[[UILabel alloc]initWithFrame:CGRectMake(10, 60+(i*40), 20, 20)];
        rank.text=[NSString stringWithFormat:@"%d",i+1];
        [ranking addSubview:rank];
        UIImageView * userImg=[[UIImageView alloc]initWithFrame:CGRectMake(40, 60+(i*40), 30, 30)];
        userImg.backgroundColor=[UIColor redColor];
        userImg.layer.cornerRadius=15;
        userImg.clipsToBounds=YES;
        userImg.image=[self.imageArray objectAtIndex:i];
        [ranking addSubview:userImg];
        UILabel * userName=[[UILabel alloc]initWithFrame:CGRectMake(80, 60+(i*40), 100, 20)];
        userName.text=object[@"name"];
        [ranking addSubview:userName];
        UILabel * userXp=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 60+(i*40), 100, 20)];
        userXp.text=[NSString stringWithFormat:@"%dXp",[object[@"gradepoints"] intValue]];
        
        [ranking addSubview:userXp];
        [self.view addSubview:ranking];
    }
   
}
-(void)fetchDataForRanking
{
    [SingletonClass sharedSingleton].selectedSubCat=[NSNumber numberWithInt:101];
    PFQuery * query=[PFQuery queryWithClassName:@"UserGrade"];
    [query whereKey:@"SubcategoryId" equalTo:@101];
    [query orderByDescending:@"gradepoints"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
           NSArray * temp=[query findObjects];
        NSLog(@"%@",temp);
        self.rankingDetail=[NSArray arrayWithArray:temp];
        for(int i=0;i<[self.rankingDetail count];i++)
        {
        PFObject * objectImage=[temp objectAtIndex:i];
        NSURL *url=[NSURL URLWithString:objectImage[@"imageurl"]];
            NSLog(@"%@",url);
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
            NSURLResponse *response;
            NSError *error;
            
            NSData *data=[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
            if (error == nil && data !=nil) {
                [self.imageArray addObject:[UIImage imageWithData:data]];
            }
            else
            {
                NSLog(@"Error in image %@",error);
            }
            

        }
        dispatch_async(dispatch_get_main_queue(),^(void) {
            
            [self createUi];
        });
//for end
    });
}
#pragma mark Accept Reject Action
-(void)acceptAction:(id)sender
{
    NSLog(@"dictionary for challenge %@",self.dictForChallenege);
    [SingletonClass sharedSingleton].strQuestionsId=[self.dictForChallenege objectForKey:@"questionsChall"];
    NSLog(@"dictionary for challenge %@",[SingletonClass sharedSingleton].strQuestionsId);
    [SingletonClass sharedSingleton].singleGameChallengedPlayer=NO;
    [self gameForChallenge:self.dictForChallenege];
    NSMutableArray * temp=[[NSMutableArray alloc]init];
    [temp removeObjectAtIndex:rowSelected];
    self.secondCustomArray=[NSArray arrayWithArray:temp];
    [self deleteChallengeRequest];
}
-(void)rejectAction:(id)sender
{
    if([self.secondCustomArray count]>0)
    {
        NSMutableArray * tempArray=[[NSMutableArray alloc]initWithArray:self.secondCustomArray];
        [tempArray removeLastObject];
        self.secondCustomArray=[NSArray arrayWithArray:tempArray];
        seletedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];

        [self.customTableView reloadData];
    }
 [self deleteChallengeRequest];
}
#pragma mark---
#pragma mark parse code
-(void)fetchDatafromParseinEdit
{
    UIImageView *imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10,100, 30, 50)];
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
    
    
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            
            PFQuery *query=[PFQuery queryWithClassName:@"SubCategory"];
            [query orderByDescending:@"createdAt"];
            
            query.limit=10;
            NSArray *temp=[query findObjects];
            NSLog(@"NewContent Data %@",temp);
            NSMutableArray * newContent=[[NSMutableArray alloc]init];
            for(int i=0;i<[temp count];i++)
            {
                PFObject * objFirst=[temp objectAtIndex:i];
                NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
                [dict setValue:objFirst[@"SubCategoryName"] forKey:@"Title"];
                [dict setValue:objFirst[@"SubCategoryDesc"] forKey:@"Description"];
                [dict setValue:objFirst[@"CategoryId"] forKey:@"Image"];
                [dict setValue:objFirst[@"SubCategoryId"] forKey:@"SubCategoryId"];
                NSString *batteryImgName=[NSString stringWithFormat:@"0_Battery.png"];
                [dict setValue:batteryImgName forKey:@"BatteryImage"];

                for (int j=0;j<[self.subCataData count];j++)
                {
                    PFObject *objSub=[self.subCataData objectAtIndex:j];
                    if ([dict[@"SubCategoryId"]isEqualToNumber:objSub[@"SubcategoryId"]]) {
                        NSString *batteryImgName=[NSString stringWithFormat:@"%@",[self getProgressFromGradeValue:objSub[@"gradepoints"]]];
                        [dict setValue:batteryImgName forKey:@"BatteryImage"];
                        [dict setValue:gradeName forKey:@"GradeName"];
                    }
                }
                [newContent addObject:dict];
                
            }
            
            self.contentNew=[NSArray arrayWithArray:newContent];
            self.thirdSectionArray=[NSArray arrayWithArray:newContent];
            //------------------StaffPick---------------
            [query whereKey:@"MoreSubCategory" equalTo:@"StaffPick"];
            query.limit=10;
            [query findObjects];
            temp=[query findObjects];
            NSLog(@"StaffPick Data %@",temp);
            NSMutableArray * staffPick=[[NSMutableArray alloc]init];
            for(int i=0;i<[temp count];i++)
            {
                PFObject * objFirst=[temp objectAtIndex:i];
                NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
                [dict setValue:objFirst[@"SubCategoryName"] forKey:@"Title"];
                [dict setValue:objFirst[@"SubCategoryDesc"] forKey:@"Description"];
                [dict setValue:objFirst[@"CategoryId"] forKey:@"Image"];
                [dict setValue:objFirst[@"SubCategoryId"] forKey:@"SubCategoryId"];
                NSString *batteryImgName=[NSString stringWithFormat:@"0_Battery.png"];
                [dict setValue:batteryImgName forKey:@"BatteryImage"];
                
                for (int j=0;j<[self.subCataData count];j++)
                {
                    PFObject *objSub=[self.subCataData objectAtIndex:j];
                    if ([dict[@"SubCategoryId"]isEqualToNumber:objSub[@"SubcategoryId"]]) {
                        NSString *batteryImgName=[NSString stringWithFormat:@"%@",[self getProgressFromGradeValue:objSub[@"gradepoints"]]];
                        [dict setValue:batteryImgName forKey:@"BatteryImage"];
                        [dict setValue:gradeName forKey:@"GradeName"];

                    }
                }

                [staffPick addObject:dict];
                
            }
            
            self.staffPick=[NSArray arrayWithArray:staffPick];
            NSLog(@"Staff pick data %@",self.staffPick);
            //--------------------Recommended-----------------------
            NSMutableArray * recommended=[[NSMutableArray alloc]init];
            
            query=[PFQuery queryWithClassName:@"SubCategory"];
            [query whereKey:@"MoreSubCategory" equalTo:@"Recommended"];
            [query findObjects];
            query.limit=10;
            temp=[query findObjects];
            for(int i=0;i<[temp count];i++)
            {
                PFObject * objFirst=[temp objectAtIndex:i];
                NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
                [dict setValue:objFirst[@"SubCategoryName"] forKey:@"Title"];
                [dict setValue:objFirst[@"SubCategoryDesc"] forKey:@"Description"];
                [dict setValue:objFirst[@"CategoryId"] forKey:@"Image"];
                [dict setValue:objFirst[@"SubCategoryId"] forKey:@"SubCategoryId"];
                NSString *batteryImgName=[NSString stringWithFormat:@"0_Battery.png"];
                [dict setValue:batteryImgName forKey:@"BatteryImage"];
                
                for (int j=0;j<[self.subCataData count];j++)
                {
                    PFObject *objSub=[self.subCataData objectAtIndex:j];
                    if ([dict[@"SubCategoryId"]isEqualToNumber:objSub[@"SubcategoryId"]]) {
                        NSString *batteryImgName=[NSString stringWithFormat:@"%@",[self getProgressFromGradeValue:objSub[@"gradepoints"]]];
                        [dict setValue:batteryImgName forKey:@"BatteryImage"];
                        [dict setValue:gradeName forKey:@"GradeName"];

                    }
                }

                [recommended addObject:dict];
                
            }
            self.recommend=[NSArray arrayWithArray:recommended];
            NSLog(@"Recommended Data %@",self.recommend);
            //------------------Popularity--------------//
            NSMutableArray * popularity=[[NSMutableArray alloc]init];
            PFQuery *queryNewcontent=[PFQuery queryWithClassName:@"SubCategory"];
            //[queryNewcontent whereKey:@"PopularityScore" equalTo:@"NewContent"];
            [queryNewcontent orderByDescending:@"PopularityScore"];
            queryNewcontent.limit=10;
            temp=[queryNewcontent findObjects];
            for(int i=0;i<[temp count];i++)
            {
                PFObject * objFirst=[temp objectAtIndex:i];
                NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
                [dict setValue:objFirst[@"SubCategoryName"] forKey:@"Title"];
                [dict setValue:objFirst[@"SubCategoryDesc"] forKey:@"Description"];
                [dict setValue:objFirst[@"CategoryId"] forKey:@"Image"];
                [dict setValue:objFirst[@"SubCategoryId"] forKey:@"SubCategoryId"];
                NSString *batteryImgName=[NSString stringWithFormat:@"0_Battery.png"];
                [dict setValue:batteryImgName forKey:@"BatteryImage"];
                
                for (int j=0;j<[self.subCataData count];j++)
                {
                    PFObject *objSub=[self.subCataData objectAtIndex:j];
                    if ([dict[@"SubCategoryId"]isEqualToNumber:objSub[@"SubcategoryId"]]) {
                        NSString *batteryImgName=[NSString stringWithFormat:@"%@",[self getProgressFromGradeValue:objSub[@"gradepoints"]]];
                        [dict setValue:batteryImgName forKey:@"BatteryImage"];
                        
                        [dict setValue:gradeName forKey:@"GradeName"];

                    }
                }

                [popularity addObject:dict];
                
            }
            self.popularity=[NSArray arrayWithArray:popularity];
            //  PFQuery * query = [PFQuery orQueryWithSubqueries:@[queryStaff,queryNewcontent,queryRecommended]];
            
            
            
            
            //================Recently Played
            NSMutableArray * recentlyPlayed=[[NSMutableArray alloc]init];
            PFQuery *queryRecentlyPlayed=[PFQuery queryWithClassName:@"UserGrade"];
            [queryRecentlyPlayed whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
            queryRecentlyPlayed.limit=10;
            temp=[queryRecentlyPlayed findObjects];
            NSLog(@"Recently Played %@",temp);
            for(int i=0;i<[temp count];i++)
            {
                PFObject * objFirst=[temp objectAtIndex:i];
                NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
                [dict setValue:objFirst[@"SubcategoryName"] forKey:@"Title"];
                if(objFirst[@"SubCategoryDesc"])
                {
                    [dict setValue:objFirst[@"SubCategoryDesc"] forKey:@"Description"];
                }
                else
                {
                    [dict setValue:@"No Description" forKey:@"Description"];
                }
                NSLog(@"SubCategoryId==%@",objFirst[@"SubcategoryId"]);
                [dict setValue:objFirst[@"CategoryId"] forKey:@"Image"];
                [dict setValue:objFirst[@"SubcategoryId"] forKey:@"SubCategoryId"];
                NSString *batteryImgName=[NSString stringWithFormat:@"%@",[self getProgressFromGradeValue:objFirst[@"gradepoints"]]];
                [dict setValue:batteryImgName forKey:@"BatteryImage"];
                [dict setValue:gradeName forKey:@"GradeName"];

                [recentlyPlayed addObject:dict];
                
        }
            self.recentlyPlayed=[NSArray arrayWithArray:recentlyPlayed];
            self.fourthSectionArray=[NSArray arrayWithArray:recentlyPlayed];
            NSLog(@"Fourth Section Array %@",self.fourthSectionArray);
            if([self.fourthSectionArray count]==0)
            {
                 NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
                [dict setValue:@"최근 플레이가 없습니다" forKey:@"Title"];
                [recentlyPlayed addObject:dict];
                self.recentlyPlayed=[NSArray arrayWithArray:recentlyPlayed];                 self.fourthSectionArray=[NSArray arrayWithArray:recentlyPlayed];
            }
            //========================Featured topic
            [query whereKey:@"MoreSubCategory" equalTo:@"FeatureTopic"];
            query.limit=10;
            [query findObjects];
            temp=[query findObjects];
            NSLog(@"Featuretopic Data %@",temp);
            NSMutableArray * featureTopic=[[NSMutableArray alloc]init];
            for(int i=0;i<[temp count];i++)
            {
                PFObject * objFirst=[temp objectAtIndex:i];
                NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
                [dict setValue:objFirst[@"SubCategoryName"] forKey:@"Title"];
                [dict setValue:objFirst[@"SubCategoryDesc"] forKey:@"Description"];
                [dict setValue:objFirst[@"CategoryId"] forKey:@"Image"];
                [dict setValue:objFirst[@"SubCategoryId"] forKey:@"SubCategoryId"];
                NSString *batteryImgName=[NSString stringWithFormat:@"0_Battery.png"];
                [dict setValue:batteryImgName forKey:@"BatteryImage"];
                
                for (int j=0;j<[self.subCataData count];j++)
                {
                    PFObject *objSub=[self.subCataData objectAtIndex:j];
                    if ([dict[@"SubCategoryId"]isEqualToNumber:objSub[@"SubcategoryId"]]) {
                        NSString *batteryImgName=[NSString stringWithFormat:@"%@",[self getProgressFromGradeValue:objSub[@"gradepoints"]]];
                        [dict setValue:batteryImgName forKey:@"BatteryImage"];
                        [dict setValue:gradeName forKey:@"GradeName"];

                    }
                }
                
                [featureTopic addObject:dict];
                
            }
            
            self.firstSectionArray=[NSArray arrayWithArray:featureTopic];
            NSLog(@"Staff pick data %@",self.staffPick);
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                               [self createCustomTable];
                               [imageVAnim stopAnimating];
                           });
            
        }
    });
    
}

-(void)checkChallengeStatus
{
    PFQuery * chStatus=[PFQuery queryWithClassName:@"ChallengeRequest"];
    [chStatus whereKey:@"OpponentId" equalTo:[SingletonClass sharedSingleton].objectId];
    [chStatus whereKey:@"ChallengeStatus" equalTo:@0];
    [chStatus includeKey:@"userIdPointer"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray * challengeRequest=[[NSMutableArray alloc]init];
        NSArray *temp=[chStatus findObjects];
        for(int i=0;i<[temp count];i++)
        {
            PFObject * objFirst=[temp objectAtIndex:i];
            NSMutableDictionary * dict=[[NSMutableDictionary alloc]init];
            [dict setValue:objFirst[@"SubCategoryName"] forKey:@"Title"];
            [dict setValue:objFirst[@"CategoryId"] forKey:@"Image"];
            [dict setValue:objFirst[@"Question"] forKey:@"Question"];
            [dict setValue:objFirst[@"SubCategoryId"] forKey:@"SubCategoryId"];
            [dict setValue:objFirst.objectId forKey:@"objectIdChall"];
            NSString * desc=[NSString stringWithFormat:@"%@ challenged you",objFirst[@"userIdPointer"][@"name"]];
            [dict setValue:desc forKey:@"Description"];
            [dict setValue:[objFirst[@"userIdPointer"] objectId] forKey:@"OpponentId"];
            PFFile  *strImage =objFirst[@"userIdPointer"][@"userimage"];
            NSData *imageData = [strImage getData];
            UIImage *image1 = [UIImage imageWithData:imageData];
            [SingletonClass sharedSingleton].imageSecondPlayer=image1;
            [SingletonClass sharedSingleton].strSecPlayerName=objFirst[@"userIdPointer"][@"name"];
            if(objFirst[@"UserGameResult"])
            {
            gameResultObjId=objFirst[@"UserGameResult"];
                //-----------Game Result Query----------
                PFQuery * queryGameResult=[PFQuery queryWithClassName:@"GameResult"];
                [queryGameResult whereKey:@"objectId" equalTo:objFirst[@"UserGameResult"]];
                NSArray * tempGameResult=[queryGameResult findObjects];
                if([tempGameResult count]>0)
                {
                    PFObject * objGameResult=[tempGameResult objectAtIndex:0];
                    challUserScore=[NSArray arrayWithArray:objGameResult[@"userscore"]];
                    [challengeRequest addObject:dict];

                }

            }
            else
            {
                //[self deleteChallengeRequest];
            }
        }
        self.secondCustomArray=[NSArray arrayWithArray:challengeRequest];
       
       // [self.dictForChallenege setObject:player1Scores forKey:@"scores"];
        //[self.dictForChallenege setObject:player1Ans forKey:@"player1ans"];
//            PFFile *imageFile = objch[@"userIdPointer"][@"userimage"];
//            NSData *imageData = [imageFile getData];
//            UIImage *image = [UIImage imageWithData:imageData];
//            //[self.opponenetImage addObject:image];
//            
//            dispatch_async(dispatch_get_main_queue(),^(void)
//                           {
//                               [homescreen reloadData];
//                           });
//            
//            
//            [userId addObject:objch[@"UserId"]];
       
    });
    //---------------------------
}
#pragma mark GameViewController

-(void)playNowButtonAction:(id)sender {
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playNowButtonAction:) name:@"PlayAnother" object:nil];
    //    [self displaySelectFriendsUI];
    //
    //    [self performSelector:@selector(selectionFriendMethod) withObject:nil afterDelay:2];
    
    NSLog(@"buy life %ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"buylife"]);
    if([[NSUserDefaults standardUserDefaults]integerForKey:@"buylife"]>0)
    {
    GamePLayMethods * objMethod=[[GamePLayMethods alloc]init];
    objMethod.gameDelegate=self;
    [objMethod playNowButtonAction];
    }
    else
    {
        NSString * buyLifeStr=@"There is no life item. Do You want to Purchase life with dia?";
        [self buyLifePopUp:buyLifeStr];
    }
}
-(void)buyLifePopUp:(NSString *)request
{
    
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 100)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 15)];
    lblReject.text=[ViewController languageSelectedStringForKey:request ];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.numberOfLines=0;
    lblReject.lineBreakMode=NSLineBreakByWordWrapping;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(15,popUpImageview.frame.size.height-40,120, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"btnpopup.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strAccept=@"구입";//[ViewController languageSelectedStringForKey:@"Buy"];
    [acceptBtn setTitle:strAccept forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(acceptButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:acceptBtn];
    UIButton * rejectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rejectBtn.frame=CGRectMake(popUpImageview.frame.size.width/2+15,popUpImageview.frame.size.height-40,120,30);
    [rejectBtn setBackgroundImage:[UIImage imageNamed:@"btn_2.png"] forState:UIControlStateNormal];
    [rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strReject=[ViewController languageSelectedStringForKey:@"Cancel"];
    [rejectBtn setTitle:strReject forState:UIControlStateNormal];
    rejectBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [rejectBtn addTarget:self action:@selector(rejectButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:rejectBtn];
    
}
-(void)acceptButton:(id)sender
{
    PurchaseView *objPurchase = [[PurchaseView alloc]initWithButton:@"life"];
    objPurchase.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    objPurchase.delegate=self;
    
    [self presentViewController:objPurchase animated:YES completion:nil];
    [rejectView removeFromSuperview];
    
}
- (void)cancelButtonClicked:(PurchaseView *)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}
-(void)rejectButton:(id)sender
{
    
    [rejectView removeFromSuperview];
}


-(void)gameDetailsAnotherGame:(NSDictionary *)details
{
    
    GameViewController *objGame = [[GameViewController alloc] init];
    objGame.arrPlayerDetail=details;
    NSLog(@"obj Players Details -== %@",objGame.arrPlayerDetail);
    [self presentViewController:objGame animated:YES completion:nil];
}
-(void)fetchDataForAllSubCat
{
    PFQuery *query=[PFQuery queryWithClassName:@"UserGrade"];
    [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        NSArray *arr=[query findObjects];
        self.subCataData=[NSArray arrayWithArray:arr];
       
        
    });
    
}

-(NSString*)getProgressFromGradeValue:(NSNumber *)gradePoints
{
    int gradevalue=[gradePoints intValue];
    if (gradevalue >=0 && gradevalue<=810)
    {
        gradeName=@"베이비";
        return @"0_Battery.png";
    }
    else if (gradevalue >=811 && gradevalue <=1220)
    {
        gradeName=@"초1";
        return @"1_Battery.png";
    }
    else if (gradevalue >=1221 && gradevalue <=1700)
    {
        gradeName=@"초2 ";
        return @"1_Battery.png";
    }
    else if (gradevalue>=1701 && gradevalue <=2250)
    {
        gradeName=@"초3";
        return @"2_Battery.png";
    }
    else if (gradevalue >=2251 && gradevalue <=2870)
    {
        gradeName=@"초4";
        return @"2_Battery.png";
    }
    else if (gradevalue >=2871 && gradevalue <=3560)
    {
        gradeName=@"초5";
        return @"3_Battery.png";
    }
    else if (gradevalue >=3561 && gradevalue <=5150)
    {
        gradeName=@"초6";
        return @"3_Battery.png";
    }
    else if (gradevalue >=5151 && gradevalue<=7020)
    {
        gradeName=@"중1";
        return @"4_Battery.png";
    }
    else if (gradevalue >=7021 && gradevalue <=9170)
    {
        gradeName=@"중2";
        return @"4_Battery.png";
    }
    else if (gradevalue >=9171 && gradevalue <=15770)
    {
        gradeName=@"중3";
        return @"5_Battery.png";
    }
    else  if (gradevalue >=15771 && gradevalue <=24120)
    {
        gradeName=@"고1";
        return @"5_Battery.png";
    }
    else if (gradevalue >=24121 && gradevalue<=34220)
    {
        gradeName=@"고2";
        return @"6_Battery.png";
    }
    else if (gradevalue >=34221 && gradevalue <=59670)
    {
        gradeName=@"고3";
        return @"6_Battery.png";
    }
    else if (gradevalue >=59671 && gradevalue <=92120)
    {
        gradeName=@"대1";
        return @"7_Battery.png";
    }
    else if (gradevalue >=92121 && gradevalue <=131570)
    {
        gradeName=@"대2";
        return @"7_Battery.png";
    }
    else if (gradevalue >=131571 && gradevalue <=178020)
    {
        gradeName=@"대3";
        return @"8_Battery.png";
    }
    else if (gradevalue >=178021 && gradevalue <=359370)
    {
        gradeName=@"대4";
        return @"8_Battery.png";
    }
    else if (gradevalue >=359371 && gradevalue <=801620)
    {
        gradeName=@"석사";
        return @"9_Battery.png";
    }
    else if (gradevalue >=801621 && gradevalue <=1418870)
    {
        gradeName=@"박사";
        return @"10_Battery.png";
    }
    else if (gradevalue>=1418871)
    {
        gradeName=@"퀴즈왕";
        return @"11_Battery.png";
    }
    else
    {
        return nil;
    }
    
    
}
#pragma mark Go To GameView
-(void)playGameChallenge
{
    NSMutableDictionary *mutDict=[[NSMutableDictionary alloc]init];
    [mutDict setObject:[SingletonClass sharedSingleton].strQuestionsId forKey:@"questions"];
    [mutDict setObject:[SingletonClass sharedSingleton].secondPLayerDetail forKey:@"oponentPlayerDetail"];
    
    [self performSelector:@selector(goToGamePlayView:) withObject:mutDict];
}
-(void)goToGamePlayView:(NSDictionary*)details
{
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
    [SingletonClass sharedSingleton].gameFromView=true;
    GameViewController * objGame=[[GameViewController alloc]init];
    objGame.arrPlayerDetail=details;
    [self presentViewController:objGame animated:YES completion:nil];
    //    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    //    [appdelegate.window addSubview:obj.view];
    //    [appdelegate.window setRootViewController:objGame];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/*
-(void)gameDetails:(NSDictionary*)details {
    
    GameViewController *objGameVC = [[GameViewController alloc] init];
    objGameVC.arrPlayerDetail=details;
    // NSLog(@"obj Players Details -== %@",objGameVC.arrPlayerDetail);
    [self presentViewController:objGameVC animated:YES completion:nil];
}
*/

@end
