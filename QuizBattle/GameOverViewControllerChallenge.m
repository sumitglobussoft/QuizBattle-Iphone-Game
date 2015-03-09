//
//  GameOverViewControllerChallenge.m
//  QuizBattle
//
//  Created by GBS-mac on 10/1/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "GameOverViewControllerChallenge.h"
#import "MessageCustomCell.h"
#import "SingletonClass.h"
#import "Rect1.h"
#import "LogInViewController.h"
#import "GraphView.h"
@interface GameOverViewControllerChallenge ()

@end

@implementation GameOverViewControllerChallenge

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.arrScreenShots  = [[NSMutableArray alloc]init];
        self.arrScorePlayer1 = [[NSMutableArray alloc]init];
        self.arrScorePlayer2 = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blackColor];
    
    [self resetAllSingletonVariables];
    
   if( [SingletonClass sharedSingleton].singleGameChallengedPlayer)
   {
      [self createUi];

   }
    else
    {
       //[self createUi];
        if([SingletonClass sharedSingleton].challStartCase)
        {
            [self checkChallengeStatus];
        }
        else
        {
           [self fetchUserPoint];
        }
        
        
    }
        // Do any additional setup after loading the view.
    
 }
-(void)createUi
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,80)];
    headerView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:headerView];
    UIButton * back=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [back setBackgroundImage:[UIImage imageNamed:@"back_btnForall.png"] forState:UIControlStateNormal];
    [back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    back.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [headerView addSubview:back];
    UILabel * lblResult=[[UILabel alloc]initWithFrame:CGRectMake(40, 10,self.view.frame.size.width-80,30)];
    lblResult.text=[ViewController languageSelectedStringForKey:@"Result"];
    lblResult.textColor=[UIColor whiteColor];
    lblResult.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:lblResult];
  //=========================
    count=0;
    arrColors=[[NSArray alloc]initWithObjects:[UIColor colorWithRed:(CGFloat)191/255 green:(CGFloat)167/255 blue:(CGFloat)238/255 alpha:1], [UIColor colorWithRed:(CGFloat)91/255 green:(CGFloat)16/255 blue:(CGFloat)38/255 alpha:1],[UIColor colorWithRed:(CGFloat)191/255 green:(CGFloat)16/255 blue:(CGFloat)38/255 alpha:1],nil];
    pageControlUsed = NO;
    arrTopics = [[NSMutableArray alloc] initWithObjects:@"Logos",@"Cricket",@"Harry Porter", nil];
    arrImages = [[NSArray alloc]initWithObjects:@"art_icon.png",@"sports.png",@"movies.png", nil];
    
    mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.frame=CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-50);
    mainScrollView.scrollEnabled=YES;
   // mainScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 560);
    [self.view addSubview:mainScrollView];
    
    viewWin = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScrollView.frame.size.width, 520)];
    viewWin.backgroundColor=[UIColor colorWithRed:(CGFloat)37/255 green:(CGFloat)37/255 blue:(CGFloat)37/255 alpha:1];
    [self winLooseUI];
    [mainScrollView addSubview:viewWin];
    viewScore = [[UIView alloc] initWithFrame:CGRectMake(0, viewWin.frame.origin.y+viewWin.frame.size.height+2, mainScrollView.frame.size.width, 200)];
    viewScore.backgroundColor=[UIColor colorWithRed:(CGFloat)253/255 green:(CGFloat)178/255 blue:(CGFloat)23/255 alpha:1];
    
        [mainScrollView addSubview:viewScore];
    [self scoreUI];
    if([SingletonClass sharedSingleton].singleGameChallengedPlayer)
    {
        
        [mainScrollView addSubview:viewMatchdetails];
        viewScreenshot = [[UIView alloc] initWithFrame:CGRectMake(0, viewScore.frame.origin.y+viewScore.frame.size.height+2, mainScrollView.frame.size.width, 400)];
        viewScreenshot.backgroundColor=[UIColor colorWithRed:(CGFloat)21/255 green:(CGFloat)152/255 blue:(CGFloat)191/255 alpha:1];
        [self screenshotUI];
        [mainScrollView addSubview:viewScreenshot];
 
    }
    else
    {
    viewMatchdetails = [[UIView alloc] initWithFrame:CGRectMake(0, viewScore.frame.origin.y+viewScore.frame.size.height+2, mainScrollView.frame.size.width, 520)];
    viewMatchdetails.backgroundColor=[UIColor colorWithRed:(CGFloat)27/255 green:(CGFloat)203/255 blue:(CGFloat)96/255 alpha:1];
    [self matchDetailUI];
    [mainScrollView addSubview:viewMatchdetails];
        viewScreenshot = [[UIView alloc] initWithFrame:CGRectMake(0, viewMatchdetails.frame.origin.y+viewMatchdetails.frame.size.height+2, mainScrollView.frame.size.width, 400)];
        viewScreenshot.backgroundColor=[UIColor colorWithRed:(CGFloat)21/255 green:(CGFloat)152/255 blue:(CGFloat)191/255 alpha:1];
        [self screenshotUI];
        [mainScrollView addSubview:viewScreenshot];

    }
    
    viewTopics = [[UIView alloc] initWithFrame:CGRectMake(0, viewScreenshot.frame.origin.y+viewScreenshot.frame.size.height+2, mainScrollView.frame.size.width, 300)];
    viewTopics.backgroundColor=[UIColor colorWithRed:(CGFloat)133/255 green:(CGFloat)87/255 blue:(CGFloat)224/255 alpha:1];
    //[self extraTopicsUI];
    //[mainScrollView addSubview:viewTopics];
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in mainScrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [mainScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];

}
-(void)resetAllSingletonVariables
{
    [SingletonClass sharedSingleton].userLeftRoom=false;
}
-(void)backAction
{
 
    [[[self presentingViewController]presentingViewController]dismissViewControllerAnimated:YES completion:nil];
    [SingletonClass sharedSingleton].mainPlayerChallenge=false;
    [SingletonClass sharedSingleton].singleGameChallengedPlayer=false;
   
//    CustomMenuViewController *obj = [LogInViewController goTOHomeView];
//    [self presentViewController:obj animated:YES completion:nil];
    
    //[[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];

}
-(void)challengeRequestDelete
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PFQuery * query=[PFQuery queryWithClassName:@"ChallengeRequest"];
        [query whereKey:@"OpponentId" equalTo:[SingletonClass sharedSingleton].objectId];
        [query whereKey:@"SubCategoryId" equalTo:[SingletonClass sharedSingleton].selectedSubCat];
        NSArray * temp=[query findObjects];
        for(int i=0;i<[temp count];i++)
        {
            PFObject * obj=[temp objectAtIndex:i];
            [obj deleteInBackgroundWithBlock:^(BOOL succeded,NSError *error)
             {
                 if(error)
                 {
                     NSLog(@"Error in deletion %@",error);
                 }
             }];
        }
    });
}

#pragma mark ===============================
#pragma mark UI for Different views
#pragma mark ===============================

-(void)winLooseUI {
    
    UILabel *lblMatchDetail = [[UILabel alloc]init];
    lblMatchDetail.frame=CGRectMake(40, 5, self.view.frame.size.width-80, 70);
    if(!self.strStatus)
    {
        self.strStatus=@"상대방의 결과를 기다리는 중입니다";
    }
    lblMatchDetail.text=self.strStatus;
    lblMatchDetail.font=[UIFont boldSystemFontOfSize:40];
    lblMatchDetail.textColor=[UIColor whiteColor];
    lblMatchDetail.textAlignment=NSTextAlignmentCenter;
    [viewWin addSubview:lblMatchDetail];
    
    UIImageView *imageVPlayer1 = [[UIImageView alloc] init];
    imageVPlayer1.frame=CGRectMake(80, lblMatchDetail.frame.origin.y+lblMatchDetail.frame.size.height+10, 50, 50);
    imageVPlayer1.image=[SingletonClass sharedSingleton].imageUser;
    imageVPlayer1.layer.borderColor=[UIColor redColor].CGColor;
    imageVPlayer1.layer.borderWidth=3;
    imageVPlayer1.layer.cornerRadius=17;
    imageVPlayer1.clipsToBounds=YES;
    [viewWin addSubview:imageVPlayer1];
    
    UIImageView *imageVPlayer2 = [[UIImageView alloc] init];
    imageVPlayer2.frame=CGRectMake(imageVPlayer1.frame.origin.x+imageVPlayer1.frame.size.width+50, lblMatchDetail.frame.origin.y+lblMatchDetail.frame.size.height+10, 50, 50);
    imageVPlayer2.image=[SingletonClass sharedSingleton].imageSecondPlayer;
    imageVPlayer2.layer.borderColor=[UIColor greenColor].CGColor;
    imageVPlayer2.layer.borderWidth=3;
    imageVPlayer2.layer.cornerRadius=17;
    imageVPlayer2.clipsToBounds=YES;
    
    [viewWin addSubview:imageVPlayer2];
    
    UILabel *lblPlayer1 = [[UILabel alloc]init];
    lblPlayer1.frame=CGRectMake(20, imageVPlayer1.frame.origin.y+imageVPlayer1.frame.size.height+5, 100, 30);
    lblPlayer1.text=[SingletonClass sharedSingleton].strUserName;
    lblPlayer1.font=[UIFont boldSystemFontOfSize:13];
    lblPlayer1.textColor=[UIColor whiteColor];
    lblPlayer1.textAlignment=NSTextAlignmentRight;
    [viewWin addSubview:lblPlayer1];
    
    UILabel *lblPlayer2 = [[UILabel alloc]init];
    lblPlayer2.frame=CGRectMake(lblPlayer1.frame.origin.x+lblPlayer1.frame.size.width+60, imageVPlayer2.frame.origin.y+imageVPlayer2.frame.size.height+5, 100, 30);
    lblPlayer2.text=[SingletonClass sharedSingleton].strSecPlayerName;
    lblPlayer2.font=[UIFont boldSystemFontOfSize:13];
    lblPlayer2.textColor=[UIColor whiteColor];
    lblPlayer2.textAlignment=NSTextAlignmentLeft;
    [viewWin addSubview:lblPlayer2];
    
    UILabel *lblPlayer1Type = [[UILabel alloc]init];
    lblPlayer1Type.frame=CGRectMake(lblPlayer1.frame.origin.x, lblPlayer1.frame.origin.y+lblPlayer1.frame.size.height-5, 100, 20);
    lblPlayer1Type.text=[SingletonClass sharedSingleton].userRank;
    lblPlayer1Type.font=[UIFont boldSystemFontOfSize:10];
    lblPlayer1Type.textColor=[UIColor whiteColor];
    lblPlayer1Type.textAlignment=NSTextAlignmentRight;
    [viewWin addSubview:lblPlayer1Type];
    
    UILabel *lblPlayer2Type = [[UILabel alloc]init];
    lblPlayer2Type.frame=CGRectMake(lblPlayer2.frame.origin.x, lblPlayer2.frame.origin.y+lblPlayer2.frame.size.height-5, 100, 20);
    lblPlayer2Type.text=[SingletonClass sharedSingleton].strSecPlayerRank;
    lblPlayer2Type.font=[UIFont boldSystemFontOfSize:10];
    lblPlayer2Type.textColor=[UIColor whiteColor];
    lblPlayer2Type.textAlignment=NSTextAlignmentLeft;
    [viewWin addSubview:lblPlayer2Type];
    
    NSArray *arrPointsType = [NSArray arrayWithObjects:@"MATCH POINTS",@"FINISH BONUS",@"VICTORY BONUS",@"POWER UP BONUS",@"TOTAL XP", nil];
    
    for (int i=0; i<[arrPointsType count]; i++) {
        
        UILabel *lblBonus = [[UILabel alloc]init];
        if (i==2) {
            lblBonus.frame=CGRectMake(25+60*i, lblPlayer2Type.frame.origin.y+lblPlayer2Type.frame.size.height+10, 45, 30);
        }
        lblBonus.frame=CGRectMake(25+60*i, lblPlayer2Type.frame.origin.y+lblPlayer2Type.frame.size.height+10, 40, 30);
        lblBonus.text=[ViewController languageSelectedStringForKey:[arrPointsType objectAtIndex:i]];
        lblBonus.font=[UIFont boldSystemFontOfSize:10];
        lblBonus.numberOfLines=2;
        lblBonus.lineBreakMode=NSLineBreakByWordWrapping;
        lblBonus.textColor=[UIColor whiteColor];
        lblBonus.textAlignment=NSTextAlignmentLeft;
        [viewWin addSubview:lblBonus];
    }
    
    NSMutableArray *arrPoints = [[NSMutableArray alloc]init];    
    NSNumber* sumPlayer1 = [self.arrScorePlayer1 valueForKeyPath: @"@sum.self"];
    NSString *strSumPlayer1 = [NSString stringWithFormat:@"%@",sumPlayer1];
    
      if([SingletonClass sharedSingleton].singleGameChallengedPlayer)
   {
       [arrPoints addObject:strSumPlayer1];
       [arrPoints addObject:@"+40"];
       [arrPoints addObject:@"?"];
       if([SingletonClass sharedSingleton].boosterEnable)
       {
           [arrPoints addObject:@"x1"];
           
       }
       else
       {
           [arrPoints addObject:@"x2"];
           
       }
       //[arrPoints addObject:@"?"];
   }
    else
    {
        [arrPoints addObject:strSumPlayer1];
        [arrPoints addObject:@"+40"];
        [arrPoints addObject:@"?"];
        if([SingletonClass sharedSingleton].boosterEnable)
        {
            [arrPoints addObject:@"x1"];
            
        }
        else
        {
            [arrPoints addObject:@"x2"];
            
        }
        
    }
    int totalDisplay=[sumPlayer1 intValue]+40;
    NSString * strTotalDisplay=[NSString stringWithFormat:@"%d",totalDisplay];
    [arrPoints addObject:strTotalDisplay];
    for (int j=0; j<arrPoints.count; j++) {
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.frame=CGRectMake(60*j+20, lblPlayer2Type.frame.origin.y+lblPlayer2Type.frame.size.height+45, 50, 35);
        lbl.layer.borderWidth=2;
        lbl.font=[UIFont boldSystemFontOfSize:14];
        lbl.clipsToBounds=YES;
        lbl.text=[arrPoints objectAtIndex:j];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.backgroundColor=[UIColor clearColor];
        lbl.layer.cornerRadius=3;
        [viewWin addSubview:lbl];
        
        if (j==0) {
            lbl.layer.borderColor=[UIColor colorWithRed:(CGFloat)21/255 green:(CGFloat)172/255 blue:(CGFloat)214/255 alpha:1].CGColor;
            lbl.textColor=[UIColor colorWithRed:(CGFloat)21/255 green:(CGFloat)172/255 blue:(CGFloat)214/255 alpha:1];
        }
        else if (j==1 || j==3) {
            lbl.layer.borderColor=[UIColor colorWithRed:(CGFloat)253/255 green:(CGFloat)178/255 blue:(CGFloat)23/255 alpha:1].CGColor;
            lbl.textColor=[UIColor colorWithRed:(CGFloat)253/255 green:(CGFloat)178/255 blue:(CGFloat)23/255 alpha:1];
            
        }
        else if (j==2) {
            lbl.layer.borderColor=[UIColor colorWithRed:(CGFloat)27/255 green:(CGFloat)199/255 blue:(CGFloat)97/255 alpha:1].CGColor;
            lbl.textColor=[UIColor colorWithRed:(CGFloat)27/255 green:(CGFloat)199/255 blue:(CGFloat)97/255 alpha:1];
            
        }
        else {
            
            lbl.layer.borderColor=[UIColor colorWithRed:(CGFloat)133/255 green:(CGFloat)87/255 blue:(CGFloat)85/224 alpha:1].CGColor;
            lbl.textColor=[UIColor colorWithRed:(CGFloat)133/255 green:(CGFloat)87/255 blue:(CGFloat)85/224 alpha:1];
        }
    }
    NSString * totalScore=[NSString stringWithFormat:@"%d",totalDisplay];
    Rect1 *pieGraph=[[Rect1 alloc]initWithFrame:CGRectMake(0, lblPlayer2Type.frame.origin.y+lblPlayer2Type.frame.size.height+100, self.view.bounds.size.width, 200)];
    pieGraph.points = [NSArray arrayWithObjects:totalScore,@"270",nil];
    pieGraph.flagProfile=TRUE;
    pieGraph.backgroundColor=[UIColor clearColor];
    [viewWin addSubview:pieGraph];

    // ========================================================
    
   /* UIButton *btnChallenge = [[UIButton alloc]init];
    btnChallenge.frame=CGRectMake(20, lblPlayer2Type.frame.origin.y+lblPlayer2Type.frame.size.height+150, 130, 46);
    [btnChallenge setTitle:[ViewController languageSelectedStringForKey:@"Rematch"] forState:UIControlStateNormal];
    [btnChallenge addTarget:self action:@selector(challengeActon:) forControlEvents:UIControlEventTouchUpInside];
    btnChallenge.enabled=FALSE;
    btnChallenge.layer.cornerRadius=2;
    btnChallenge.clipsToBounds=YES;
    [viewWin addSubview:btnChallenge];
    
    UIButton *btnPlayAnother = [[UIButton alloc]init];
    btnPlayAnother.frame=CGRectMake(170, lblPlayer2Type.frame.origin.y+lblPlayer2Type.frame.size.height+150, 130, 46);
    [btnPlayAnother setTitle:[ViewController languageSelectedStringForKey:@"Play Another"] forState:UIControlStateNormal];
    [btnPlayAnother addTarget:self action:@selector(playAnother:) forControlEvents:UIControlEventTouchUpInside];
    btnPlayAnother.layer.cornerRadius=2;
    btnPlayAnother.clipsToBounds=YES;
    [viewWin addSubview:btnPlayAnother];*/
}
-(void)scoreUI {
    
    UILabel *lblPlayername = [[UILabel alloc]init];
    lblPlayername.frame=CGRectMake(60, 10, self.view.frame.size.width-140, 50);
    lblPlayername.text=[NSString stringWithFormat:@"YOU VS %@",[SingletonClass sharedSingleton].strSecPlayerName];
    lblPlayername.font=[UIFont boldSystemFontOfSize:20];
    lblPlayername.textColor=[UIColor blackColor];
    lblPlayername.textAlignment=NSTextAlignmentCenter;
    [viewScore addSubview:lblPlayername];
    
    UILabel *lblSubCat = [[UILabel alloc]init];
    lblSubCat.frame=CGRectMake(60, lblPlayername.frame.origin.y+lblPlayername.frame.size.height, self.view.frame.size.width-140, 20);
    lblSubCat.text=[NSString stringWithFormat:@"IN %@",[SingletonClass sharedSingleton].strSelectedSubCat];
    NSLog(@"game over view sub category name =-=- %@",lblSubCat.text);
    lblSubCat.font=[UIFont boldSystemFontOfSize:12];
    lblSubCat.textColor=[UIColor blackColor];
    lblSubCat.textAlignment=NSTextAlignmentCenter;
    [viewScore addSubview:lblSubCat];
    
    lblScore = [[UILabel alloc]init];
    lblScore.frame=CGRectMake(0, lblSubCat.frame.origin.y+lblSubCat.frame.size.height, self.view.frame.size.width, 120);
    //    lblScore.text=@"0-1";
    lblScore.text=@"상대방의 결과를 기다리는 중입니다";
    NSLog(@"lblScore.text %@ ",lblScore.text);
    lblScore.font=[UIFont boldSystemFontOfSize:20];
    lblScore.textColor=[UIColor blackColor];
    lblScore.textAlignment=NSTextAlignmentCenter;
    [viewScore addSubview:lblScore];
}

-(void)challengeActon:(id)sender
{
    
}

-(void)playAnother:(id)sender
{
    
}
-(void)screenshotUI {
    
    UILabel *lblMatchDetail = [[UILabel alloc]init];
    lblMatchDetail.frame=CGRectMake(0, 5, self.view.frame.size.width, 40);
    lblMatchDetail.text=[ViewController languageSelectedStringForKey:@"MATCH QUESTIONS"];
    lblMatchDetail.font=[UIFont boldSystemFontOfSize:20];
    lblMatchDetail.textColor=[UIColor whiteColor];
    lblMatchDetail.textAlignment=NSTextAlignmentCenter;
    [viewScreenshot addSubview:lblMatchDetail];
    
    NSLog(@"Images Array -=-%@",self.arrScreenShots);
    
    self.scrollViewPaging = [[UIScrollView alloc] init];
    self.scrollViewPaging.frame=CGRectMake(0, lblMatchDetail.frame.origin.y+lblMatchDetail.frame.size.height, self.view.frame.size.width, 350);
    [viewScreenshot addSubview:self.scrollViewPaging];
    
    // a page is the width of the scroll view
    self.scrollViewPaging.pagingEnabled = YES;
    self.scrollViewPaging.showsHorizontalScrollIndicator = NO;
    self.scrollViewPaging.showsVerticalScrollIndicator = NO;
    self.scrollViewPaging.scrollsToTop = NO;
    self.scrollViewPaging.backgroundColor=[UIColor clearColor];
    self.scrollViewPaging.delegate = self;
    
    self.pageController = [[UIPageControl alloc] init];
    self.pageController.frame = CGRectMake(120, 350, 100, 30);
    [viewScreenshot addSubview:self.pageController];
    
    self.scrollViewPaging.contentSize = CGSizeMake(self.scrollViewPaging.frame.size.width * self.arrScreenShots.count, self.scrollViewPaging.frame.size.height);
    self.pageController.currentPage = 0;
    self.pageController.numberOfPages = self.arrScreenShots.count;
    
    for (int i=0; i<self.arrScreenShots.count; i++) {
        
        CGRect frame;
        frame.origin.x = self.scrollViewPaging.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollViewPaging.frame.size;
        
        UIView *subView = [[UIView alloc]initWithFrame:frame];
        
        //add imageview
        imageView = [[UIImageView alloc]init];
        CGRect imageFrame;
        imageFrame.origin.x = 70;
        imageFrame.origin.y = 40;
        imageFrame.size.width = 200;
        imageFrame.size.height = 270;
        imageView.frame = imageFrame;
        
        [subView addSubview:imageView];
        
        switch (i) {
            case 0:
                imageView.image =[self.arrScreenShots objectAtIndex:0];
                break;
            case 1:
                imageView.image = [self.arrScreenShots objectAtIndex:1];
                break;
            case 2:
                imageView.image = [self.arrScreenShots objectAtIndex:2];
                break;
            case 3:
                imageView.image = [self.arrScreenShots objectAtIndex:3];
                break;
            case 4:
                imageView.image = [self.arrScreenShots objectAtIndex:4];
                break;
            case 5:
                imageView.image = [self.arrScreenShots objectAtIndex:5];
                break;
            case 6:
                imageView.image = [self.arrScreenShots objectAtIndex:6];
                break;
            default:
                break;
        }
        
        [imageView setBackgroundColor:[UIColor clearColor]];
        [self.scrollViewPaging addSubview:subView];
    }
}
-(void)extraTopicsUI {
    
    UILabel *lblMatchDetail = [[UILabel alloc]init];
    lblMatchDetail.frame=CGRectMake(0, 5, self.view.frame.size.width, 60);
    lblMatchDetail.text=[ViewController languageSelectedStringForKey:@"POPULAR TOPICS"];
    lblMatchDetail.font=[UIFont boldSystemFontOfSize:20];
    lblMatchDetail.textColor=[UIColor whiteColor];
    lblMatchDetail.textAlignment=NSTextAlignmentCenter;
    [viewTopics addSubview:lblMatchDetail];
    
    topicsTableV = [[UITableView alloc] init];
    
    topicsTableV.frame=CGRectMake(20, lblMatchDetail.frame.origin.y+lblMatchDetail.frame.size.height+10, self.view.frame.size.width-40, self.view.frame.size.height-85);
    topicsTableV.delegate=self;
    topicsTableV.dataSource=self;
    [topicsTableV setBackgroundView:nil];
    topicsTableV.backgroundColor=[UIColor clearColor];
    topicsTableV.opaque=NO;
    [viewTopics addSubview:topicsTableV];
}
#pragma mark Save Game Result

#pragma mark ===============================
#pragma mark Scroll view Methods
#pragma mark ===============================

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!pageControlUsed) {
        CGFloat pageWidth = self.scrollViewPaging.frame.size.width;
        NSInteger pageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageController.currentPage = pageNumber;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

-(void)fetchUserPoint
{
    
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, 100, 30, 50)];
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

    PFQuery * userPoint=[PFQuery queryWithClassName:@"GameResult"];
    [userPoint whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].challengeRequestObjId];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       NSArray * tempUserData=[userPoint findObjects];
        NSLog(@"User Point in Challenge %@",tempUserData);
        if([tempUserData count]>0)
        {
        PFObject * objUserData=[tempUserData objectAtIndex:0];
        self.arrScorePlayer2=objUserData[@"userscore"];
            [self checkWinLoose];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           [imageVAnim stopAnimating];
                           [self createUi];
                       });
    });
    
}
-(void)checkWinLoose
{
    NSNumber* sumPlayer1 = [self.arrScorePlayer1 valueForKeyPath:@"@sum.self"];
    NSNumber* sumPlayer2 = [self.arrScorePlayer2 valueForKeyPath:@"@sum.self"];
    NSLog(@"sum player 1 and sum player 2 %@ %@",sumPlayer1,sumPlayer2);
    int lifeCount = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"buylife"];

    if([sumPlayer1 intValue]>[sumPlayer2 intValue])
    {
        
       self.strStatus=@"YOU WIN!";
    }
    else if([sumPlayer1 intValue]<[sumPlayer2 intValue])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:lifeCount forKey:@"buylife"];

        lifeCount--;
    self.strStatus=@"YOU LOSE!";
    }
    else
    {
         self.strStatus=@"MATCH DRAW!";
    }
        
}

-(void)matchDetailUI {
    
    UILabel *lblMatchDetail = [[UILabel alloc]init];
    lblMatchDetail.frame=CGRectMake(70, 5, self.view.frame.size.width-140, 60);
    lblMatchDetail.text=[ViewController languageSelectedStringForKey:@"MATCH DETAILS"];
    lblMatchDetail.font=[UIFont boldSystemFontOfSize:20];
    lblMatchDetail.textColor=[UIColor whiteColor];
    lblMatchDetail.textAlignment=NSTextAlignmentLeft;
    [viewMatchdetails addSubview:lblMatchDetail];
    
    self.graphView = [[GraphView alloc] initWithFrame:CGRectMake(0, lblMatchDetail.frame.origin.y+lblMatchDetail.frame.size.height+10, self.view.frame.size.width, 300)andDefaultLineColor:[UIColor blackColor]];
    //===============
    self.graphView.coordinateX = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    self.graphView.coordinateY =  [NSArray arrayWithObjects:@"40",@"80",@"120",@"160", nil];
    //------
    //    NSArray *firstValueArray =  [NSArray arrayWithObjects:@"15",@"25",@"25",@"25",@"40",@"20",@"60", nil];
    //    NSArray *secondValueArray = [NSArray arrayWithObjects:@"25",@"0",@"55",@"55",@"90",@"30",@"70", nil];
    
    NSNumber* sumPlayer1 = [self.arrScorePlayer1 valueForKeyPath:@"@sum.self"];
    NSNumber* sumPlayer2 = [self.arrScorePlayer2 valueForKeyPath:@"@sum.self"];
    
    NSMutableArray *graphValueForPlayer1 = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.arrScorePlayer1.count; i++) {
        
        NSString *strValue;
        if (i==0) {
            strValue = [self.arrScorePlayer1 objectAtIndex:0];
        }
        else{
            
            NSString *strValue1 = [self.arrScorePlayer1 objectAtIndex:i];
            NSString *strValue2 = [graphValueForPlayer1 lastObject];
            int value1 = [strValue1 intValue];
            int value2 = [strValue2 intValue];
            
            int totalValue = value1+value2;
            
            strValue = [NSString stringWithFormat:@"%d",totalValue];
            
        }
        [graphValueForPlayer1 addObject:strValue];
    }
    NSLog(@"graphValueForPlayer1 -==-%@",graphValueForPlayer1);
    NSMutableArray *graphValueForPlayer2 = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.arrScorePlayer2.count; i++) {
        
        NSString *strValue;
        if (i==0) {
            strValue = [self.arrScorePlayer2 objectAtIndex:0];
        }
        else{
            
            NSString *strValue1 = [self.arrScorePlayer2 objectAtIndex:i];
            NSString *strValue2 = [graphValueForPlayer2 lastObject];
            int value1 = [strValue1 intValue];
            int value2 = [strValue2 intValue];
            
            int totalValue = value1+value2;
            
            strValue = [NSString stringWithFormat:@"%d",totalValue];
            
        }
        [graphValueForPlayer2 addObject:strValue];
    }
    
    NSLog(@"graphValueForPlayer 2 -==-%@",graphValueForPlayer2);
    self.graphView.graphValueArray = @[graphValueForPlayer1, graphValueForPlayer2];
    
    UIColor *firstColor = [UIColor whiteColor];
    UIColor *secColor = [UIColor blackColor];
    self.graphView.lineColorArray = @[firstColor, secColor];
    //==================
    self.graphView.backgroundColor=[UIColor clearColor];
    
    [viewMatchdetails addSubview:self.graphView];
    
    UILabel *lblXpRound = [[UILabel alloc]init];
    lblXpRound.frame=CGRectMake(90, 260, 150, 40);
    lblXpRound.text=[ViewController languageSelectedStringForKey:@"XP PER ROUND"];
    lblXpRound.font=[UIFont boldSystemFontOfSize:20];
    lblXpRound.textColor=[UIColor whiteColor];
    lblXpRound.textAlignment=NSTextAlignmentLeft;
    [viewMatchdetails addSubview:lblXpRound];
    
    UILabel *lblPlayer1 = [[UILabel alloc]init];
    lblPlayer1.frame=CGRectMake(50, lblXpRound.frame.origin.y+lblXpRound.frame.size.height+5, 250, 40);
    lblPlayer1.text=[NSString stringWithFormat:@"------ %@ ------",[SingletonClass sharedSingleton].strUserName];
    lblPlayer1.font=[UIFont boldSystemFontOfSize:15];
    lblPlayer1.textColor=[UIColor blackColor];
    lblPlayer1.textAlignment=NSTextAlignmentCenter;
    [viewMatchdetails addSubview:lblPlayer1];
    
    for (int i=0; i<8; i++) {
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.frame=CGRectMake(35*i+20, lblPlayer1.frame.origin.y+lblPlayer1.frame.size.height+10, 30, 30);
        lbl.layer.borderWidth=2;
        lbl.font=[UIFont systemFontOfSize:10];
        lbl.layer.borderColor=[UIColor blackColor].CGColor;
        lbl.clipsToBounds=YES;
        lbl.backgroundColor=[UIColor whiteColor];
        
        if (i==7) {
            lbl.text=[NSString stringWithFormat:@"%@",sumPlayer1];
        }
        else{
            lbl.text=[self.arrScorePlayer1 objectAtIndex:i];
        }
        
        lbl.textAlignment=NSTextAlignmentCenter;
        if ([lbl.text isEqualToString:@"0"]) {
            lbl.textColor=[UIColor orangeColor];
        }
        else{
            lbl.textColor=[UIColor blackColor];
        }
        [viewMatchdetails addSubview:lbl];
    }
    
    for (int i=0; i<8; i++) {
        
        UILabel *lblNum = [[UILabel alloc]init];
        lblNum.frame=CGRectMake(35*i+30, lblPlayer1.frame.origin.y+lblPlayer1.frame.size.height+45, 35, 15);
        lblNum.font=[UIFont systemFontOfSize:10];
        if (i==7) {
            lblNum.frame=CGRectMake(35*i+25, lblPlayer1.frame.origin.y+lblPlayer1.frame.size.height+45, 35, 15);
            lblNum.text=[ViewController languageSelectedStringForKey:@"TOTAL"];
        }
        else{
            lblNum.text=[NSString stringWithFormat:@"%d",i+1];
        }
        
        [viewMatchdetails addSubview:lblNum];
    }
    
    for (int i=0; i<8; i++) {
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.frame=CGRectMake(35*i+20, lblPlayer1.frame.origin.y+lblPlayer1.frame.size.height+70, 30, 30);
        lbl.layer.borderWidth=2;
        lbl.font=[UIFont systemFontOfSize:10];
        lbl.layer.borderColor=[UIColor blackColor].CGColor;
        lbl.clipsToBounds=YES;
        lbl.backgroundColor=[UIColor whiteColor];
        lbl.textAlignment=NSTextAlignmentCenter;
        
        if (i==7) {
            lbl.text=[NSString stringWithFormat:@"%@",sumPlayer2];
        }
        else{
            lbl.text=[self.arrScorePlayer2 objectAtIndex:i];
        }
        
        NSLog(@"Label -==- %@",lbl.text);
        if ([lbl.text isEqualToString:@"0"]) {
            lbl.textColor=[UIColor orangeColor];
        }
        else{
            lbl.textColor=[UIColor blackColor];
        }
        [viewMatchdetails addSubview:lbl];
    }
    UILabel *lblPlayer2 = [[UILabel alloc]init];
    lblPlayer2.frame=CGRectMake(50, lblPlayer1.frame.origin.y+lblPlayer1.frame.size.height+105, 250, 40);
    lblPlayer2.text=[NSString stringWithFormat:@"------ %@ ------",[SingletonClass sharedSingleton].strSecPlayerName];
    lblPlayer2.font=[UIFont boldSystemFontOfSize:15];
    lblPlayer2.textColor=[UIColor blackColor];
    lblPlayer2.textAlignment=NSTextAlignmentCenter;
    [viewMatchdetails addSubview:lblPlayer2];
    
}

-(void)checkChallengeStatus
{
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, 100, 30, 50)];
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
    [self performSelector:@selector(fetchUserScorewithDelay) withObject:nil afterDelay:2];
        //---------------------------
}
-(void)fetchUserScorewithDelay
{
    PFQuery * chStatus=[PFQuery queryWithClassName:@"ChallengeRequest"];
    [chStatus whereKey:@"OpponentId" equalTo:[SingletonClass sharedSingleton].objectId];
    
    [chStatus whereKey:@"ChallengeStatus" equalTo:@0];
    [chStatus includeKey:@"userIdPointer"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray * temp=[chStatus findObjects];
        NSLog(@"Challenge Status %@",temp);
        if([temp count]>0)
        {
            PFObject * objGame=[temp objectAtIndex:0];
            if(objGame[@"UserGameResult"])
            {
                PFQuery * userPoint=[PFQuery queryWithClassName:@"GameResult"];
                [userPoint whereKey:@"objectId" equalTo:objGame[@"UserGameResult"]];
                [SingletonClass sharedSingleton].challengeRequestObjId=objGame[@"UserGameResult"];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSArray * tempUserData=[userPoint findObjects];
                    NSLog(@"User Point in Challenge %@",tempUserData);
                    PFObject * objUserData=[tempUserData objectAtIndex:0];
                    self.arrScorePlayer2=objUserData[@"userscore"];
                    [self checkWinLoose];
                    dispatch_async(dispatch_get_main_queue(), ^(void)
                                   {
                    [SingletonClass sharedSingleton].challStartCase=false;
                                       [imageVAnim stopAnimating];
                                        [self challengeRequestDelete];
                                       [self createUi];
                                   });
                    [self updateGameResult];
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^(void)
                               {
   [SingletonClass sharedSingleton].challStartCase=false;
   [SingletonClass sharedSingleton].singleGameChallengedPlayer=YES;
   [imageVAnim stopAnimating];
   [self createUi];
                               });
                
            }

        }
          });

}

-(void)updateGameResult
{
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            PFQuery * updateOpponentGameResult=[PFQuery queryWithClassName:@"GameResult"];
                            [updateOpponentGameResult whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].challengeRequestObjId];
             NSArray * temp=[updateOpponentGameResult findObjects];
            if([temp count]>0)
            {
                PFObject *updateObj=[temp objectAtIndex:0];
                updateObj[@"opponentscore"]=self.arrScorePlayer2;
                [updateObj saveInBackground];
            }
            
        }
});
    
}
-(void)dealloc
{
    
}

@end
