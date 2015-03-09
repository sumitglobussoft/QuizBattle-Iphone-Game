//
//  GameOverViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 9/10/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "GameOverViewController.h"
#import "GameViewController.h"
#import "MessageCustomCell.h"
#import "Rect1.h"
#import "MagicPieLayer.h"
#import "Example1PieView.h"
#import "NSMutableArray+pieEx.h"
#import "CustomMenuViewController.h"
#import "LogInViewController.h"
#import "AppDelegate.h"
#import "GamePLayMethods.h"
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#define LOG_ACTION

@interface GameOverViewController()
@property (nonatomic, weak) Example1PieView* pieView;
@end


@interface GameOverViewController ()

@end

@implementation GameOverViewController

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
-(void)viewDidAppear:(BOOL)animated
{
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPreviousView:) name:@"GameResultDismissNotification" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [arrow_Image removeFromSuperview];
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UserReject" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UserReject" object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rejectUi:) name:@"UserReject" object:nil];
     self.view.backgroundColor=[UIColor blackColor];
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    arrow_Image=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-80, 50, 50)];
    arrow_Image.image=[UIImage imageNamed:@"down_arrow.png"];
    [appdelegate.window addSubview:arrow_Image];
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, 100, 30, 50)];
    [appdelegate.window addSubview:imageVAnim];
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


    count=0;
    //--------
    [self resetValuesForGame];
    //---------
  //  [[WarpClient getInstance] unsubscribeRoom:[SingletonClass sharedSingleton].roomId];
    
    [self retriveUserPreviousScore];
}
-(void)gameoverUi
{
    [imageVAnim stopAnimating];
    arrColors=[[NSArray alloc]initWithObjects:[UIColor colorWithRed:(CGFloat)191/255 green:(CGFloat)167/255 blue:(CGFloat)238/255 alpha:1], [UIColor colorWithRed:(CGFloat)91/255 green:(CGFloat)16/255 blue:(CGFloat)38/255 alpha:1],[UIColor colorWithRed:(CGFloat)191/255 green:(CGFloat)16/255 blue:(CGFloat)38/255 alpha:1],nil];
    pageControlUsed = NO;
    arrTopics = [[NSMutableArray alloc] initWithObjects:@"Logos",@"Cricket",@"Harry Porter", nil];
    arrImages = [[NSArray alloc]initWithObjects:@"art_icon.png",@"sports.png",@"movies.png", nil];
   
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    topView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:topView];
    
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, self.view.frame.size.width-140, 30)];
    lblHeader.text=[ViewController languageSelectedStringForKey:@"Result"];
    lblHeader.textColor=[UIColor whiteColor];
    lblHeader.textAlignment=NSTextAlignmentCenter;
    lblHeader.font=[UIFont boldSystemFontOfSize:15];
    [topView addSubview:lblHeader];
    if(![self.resultFromHistory isEqualToString:@"History"])
    {
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnBack.frame=CGRectMake(5, 5, 55, 30);
        [btnBack setBackgroundImage:[UIImage imageNamed:@"back_btnForall.png"] forState:UIControlStateNormal];
        btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:btnBack];
    }
    
    mainScrollView = [[UIScrollView alloc] init];
    mainScrollView.frame=CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50);
    mainScrollView.scrollEnabled=YES;
    mainScrollView.bounces=NO;
    //mainScrollView.contentSize=CGSizeMake(self.view.frame.size.width, 1950);
    [self.view addSubview:mainScrollView];
    
    viewWin = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScrollView.frame.size.width, 600)];
    viewWin.backgroundColor=[UIColor colorWithRed:(CGFloat)37/255 green:(CGFloat)37/255 blue:(CGFloat)37/255 alpha:1];
    [self winLooseUI];
    [mainScrollView addSubview:viewWin];
    
    viewScore = [[UIView alloc] initWithFrame:CGRectMake(0, viewWin.frame.origin.y+viewWin.frame.size.height+2, mainScrollView.frame.size.width, 200)];
    viewScore.backgroundColor=[UIColor colorWithRed:(CGFloat)253/255 green:(CGFloat)178/255 blue:(CGFloat)23/255 alpha:1];
    [mainScrollView addSubview:viewScore];
    [self scoreUI];
    viewMatchdetails = [[UIView alloc] initWithFrame:CGRectMake(0, viewScore.frame.origin.y+viewScore.frame.size.height+2, mainScrollView.frame.size.width, 520)];
    viewMatchdetails.backgroundColor=[UIColor colorWithRed:(CGFloat)27/255 green:(CGFloat)203/255 blue:(CGFloat)96/255 alpha:1];
    [self matchDetailUI];
    [mainScrollView addSubview:viewMatchdetails];
    
    viewScreenshot = [[UIView alloc] initWithFrame:CGRectMake(0, viewMatchdetails.frame.origin.y+viewMatchdetails.frame.size.height+2, mainScrollView.frame.size.width, 400)];
    viewScreenshot.backgroundColor=[UIColor colorWithRed:(CGFloat)21/255 green:(CGFloat)152/255 blue:(CGFloat)191/255 alpha:1];
    [self screenshotUI];
    [mainScrollView addSubview:viewScreenshot];
    
    viewTopics = [[UIView alloc] initWithFrame:CGRectMake(0, viewScreenshot.frame.origin.y+viewScreenshot.frame.size.height+2, mainScrollView.frame.size.width, 300)];
    viewTopics.backgroundColor=[UIColor colorWithRed:(CGFloat)133/255 green:(CGFloat)87/255 blue:(CGFloat)224/255 alpha:1];
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in mainScrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [mainScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];
    //  [self extraTopicsUI];
   // [mainScrollView addSubview:viewTopics];
}
-(void)goToPreviousView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backBtnAction:(id)sender
{
    if([SingletonClass sharedSingleton].gameFromView)
    {
        
       
        CustomMenuViewController *obj = [LogInViewController goTOHomeView];
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [SingletonClass sharedSingleton].gameFromView=true;
       // [appdelegate.window addSubview:obj.view];
        [appdelegate.window setRootViewController:obj];
         [SingletonClass sharedSingleton].checkBotUser=NO;
        
    }
    else
    {
  [[self.presentingViewController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [SingletonClass sharedSingleton].checkBotUser=NO;
    
    }
//       CustomMenuViewController *obj = [LogInViewController goTOHomeView];
//
//    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
//    [appdelegate.window addSubview:obj.view];
////    [appdelegate.window setRootViewController:obj];
////
//// // [self presentViewController:obj animated:YES completion:nil];
}

#pragma mark ===============================
#pragma mark UI for Different views
#pragma mark ===============================

-(void)winLooseUI {
    
    UILabel *lblMatchDetail = [[UILabel alloc]init];
    lblMatchDetail.frame=CGRectMake(40, 5, self.view.frame.size.width-80, 70);
    lblMatchDetail.text=self.strStatus;
    lblMatchDetail.font=[UIFont boldSystemFontOfSize:30];
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
    [lblPlayer1 sizeToFit];
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
        lblBonus.frame=CGRectMake(25+60*i, lblPlayer2Type.frame.origin.y+lblPlayer2Type.frame.size.height+10, 60, 30);
        lblBonus.text=[ViewController languageSelectedStringForKey:[arrPointsType objectAtIndex:i]];
        lblBonus.font=[UIFont boldSystemFontOfSize:10];
        lblBonus.numberOfLines=2;
        lblBonus.lineBreakMode=NSLineBreakByWordWrapping;
        lblBonus.textColor=[UIColor whiteColor];
        lblBonus.textAlignment=NSTextAlignmentCenter;
        [viewWin addSubview:lblBonus];
    }
    
    NSMutableArray *arrPoints = [[NSMutableArray alloc]init];
    NSMutableArray *arrSumPoints = [[NSMutableArray alloc]init];
    
    NSNumber* sumPlayer1 = [self.arrScorePlayer1 valueForKeyPath: @"@sum.self"];
    NSString *strSumPlayer1 = [NSString stringWithFormat:@"%@",sumPlayer1];
    [arrPoints addObject:strSumPlayer1];
    [arrSumPoints addObject:strSumPlayer1];
    //---------
   
    //---------------
    if(self.gameLeft)
    {
        [arrPoints addObject:@"0"];
        [arrSumPoints addObject:@"0"];
    }
    else
    {
        [arrPoints addObject:@"+40"];
        [arrSumPoints addObject:@"40"];
    }
   
    
    if ([self.strStatus isEqualToString:@"YOU WIN!"] || [self.strStatus isEqualToString:@"MATCH DRAW!"])
    {
        [arrPoints addObject:@"+100"];
        [arrSumPoints addObject:@"100"];
    }
    else{
        [arrPoints addObject:@"0"];
        [arrSumPoints addObject:@"0"];
    }
    NSNumber* totalScore;
    NSString *strTotalScore;
    if([SingletonClass sharedSingleton].boosterEnable)
    {
        [arrPoints addObject:@"x2"];
        totalScore = [arrSumPoints valueForKeyPath: @"@sum.self"];
        [self updateTotalXp:totalScore];
        strTotalScore = [NSString stringWithFormat:@"%d",2*[totalScore integerValue]];
        [arrPoints addObject:strTotalScore];
        NSLog(@"Total Score %@",strTotalScore);
    }
    else
    {
       [arrPoints addObject:@"x1"];
        totalScore = [arrSumPoints valueForKeyPath: @"@sum.self"];
        [self updateTotalXp:totalScore];
        strTotalScore = [NSString stringWithFormat:@"%@",totalScore];
        [arrPoints addObject:strTotalScore];
        NSLog(@"Total Score %@",strTotalScore);
    }
    
    
    NSNumber * totalScoreUsergrade=[NSNumber numberWithInt:[strTotalScore intValue]+[previousPoint intValue]];
     [self userGrade:totalScoreUsergrade];
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
    }//Sukhmeet
    NSString * completedScore=[NSString stringWithFormat:@"%@",totalScoreUsergrade];
    NSLog(@"Completed Score %@",completedScore);
    Rect1 *pieGraph=[[Rect1 alloc]initWithFrame:CGRectMake(0, lblPlayer2Type.frame.origin.y+lblPlayer2Type.frame.size.height+100, self.view.bounds.size.width, 200)];
    pieGraph.points = [NSArray arrayWithObjects:completedScore,@"270",nil];
    pieGraph.flagProfile=TRUE;
    pieGraph.backgroundColor=[UIColor clearColor];
    [viewWin addSubview:pieGraph];
    //-----------Buttons For play...--------
    UIButton * rematch=[UIButton buttonWithType:UIButtonTypeCustom];
    rematch.frame=CGRectMake(15, lblPlayer2Type.frame.origin.y+lblPlayer2Type.frame.size.height+340,140,30);
    [rematch setTitle:[ViewController languageSelectedStringForKey:@"Rematch"] forState:UIControlStateNormal];
    [rematch setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [rematch addTarget:self action:@selector(rematchAction:) forControlEvents:UIControlEventTouchUpInside];
    rematch.backgroundColor=[UIColor whiteColor];
    rematch.layer.cornerRadius=4;
    rematch.clipsToBounds=YES;
    [viewWin addSubview:rematch];
    
    UIButton * playAnother=[UIButton buttonWithType:UIButtonTypeCustom];
    playAnother.frame=CGRectMake(160, lblPlayer2Type.frame.origin.y+lblPlayer2Type.frame.size.height+340,140,30);
    [playAnother setTitle:[ViewController languageSelectedStringForKey:@"Play Another"] forState:UIControlStateNormal];
    [playAnother setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [playAnother addTarget:self action:@selector(playAnother) forControlEvents:UIControlEventTouchUpInside];
    playAnother.backgroundColor=[UIColor whiteColor];
    playAnother.layer.cornerRadius=4;
    playAnother.clipsToBounds=YES;
    [viewWin addSubview:playAnother];
    
    

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
    lblScore.frame=CGRectMake(55, lblSubCat.frame.origin.y+lblSubCat.frame.size.height, self.view.frame.size.width-140, 120);
//    lblScore.text=@"0-1";
    lblScore.text=self.lblPlayersStat;
    NSLog(@"lblScore.text %@ ",lblScore.text);
    lblScore.font=[UIFont boldSystemFontOfSize:65];
    lblScore.textColor=[UIColor blackColor];
    lblScore.textAlignment=NSTextAlignmentCenter;
    [viewScore addSubview:lblScore];
}
-(void)matchDetailUI {
    
    UILabel *lblMatchDetail = [[UILabel alloc]init];
    lblMatchDetail.frame=CGRectMake(70, 5, self.view.frame.size.width-140, 60);
    lblMatchDetail.text=[ViewController languageSelectedStringForKey:@"MATCH DETAILS"];
    lblMatchDetail.font=[UIFont boldSystemFontOfSize:20];
    lblMatchDetail.textColor=[UIColor whiteColor];
    lblMatchDetail.textAlignment=NSTextAlignmentCenter;
    [viewMatchdetails addSubview:lblMatchDetail];

    self.graphView = [[GraphView alloc] initWithFrame:CGRectMake(0, lblMatchDetail.frame.origin.y+lblMatchDetail.frame.size.height+10, self.view.frame.size.width, 300)andDefaultLineColor:[UIColor blackColor]];
    //===============
    self.graphView.coordinateX = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    self.graphView.coordinateY =  [NSArray arrayWithObjects:@"40",@"80",@"120",@"160", nil];
    //------
//    NSArray *firstValueArray =  [NSArray arrayWithObjects:@"15",@"25",@"25",@"25",@"40",@"20",@"60", nil];
//    NSArray *secondValueArray = [NSArray arrayWithObjects:@"25",@"0",@"55",@"55",@"90",@"30",@"70", nil];
    
    NSNumber* sumPlayer1 = [self.arrScorePlayer1 valueForKeyPath: @"@sum.self"];
    NSNumber* sumPlayer2 = [self.arrScorePlayer2 valueForKeyPath: @"@sum.self"];
    
    NSMutableArray *graphValueForPlayer1 = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.arrScorePlayer1.count; i++) {
        
        if(i==7)
            break;
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
        
        if(i==7)
            break;
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
    lblPlayer1.frame=CGRectMake(0, lblXpRound.frame.origin.y+lblXpRound.frame.size.height+5, self.view.frame.size.width, 40);
    lblPlayer1.text=[NSString stringWithFormat:@"------ %@ ------",[SingletonClass sharedSingleton].strUserName];
    lblPlayer1.font=[UIFont boldSystemFontOfSize:15];
    lblPlayer1.textColor=[UIColor blackColor];
    lblPlayer1.textAlignment=NSTextAlignmentCenter;
    [viewMatchdetails addSubview:lblPlayer1];
    
    for (int i=0; i<[self.arrScorePlayer1 count]+1; i++) {
        
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
        else
        {
            if(i<[self.arrScorePlayer1 count])
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
    
    for (int i=0; i<[self.arrScorePlayer2 count]+1; i++) {
        
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
        else
        {
            if(i<[self.arrScorePlayer2 count])
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
    lblPlayer2.frame=CGRectMake(0, lblPlayer1.frame.origin.y+lblPlayer1.frame.size.height+105,self.view.frame.size.width, 40);
    lblPlayer2.text=[NSString stringWithFormat:@"------ %@ ------",[SingletonClass sharedSingleton].strSecPlayerName];
    lblPlayer2.font=[UIFont boldSystemFontOfSize:15];
    lblPlayer2.textColor=[UIColor blackColor];
    lblPlayer2.textAlignment=NSTextAlignmentCenter;
    [viewMatchdetails addSubview:lblPlayer2];

}
-(void)screenshotUI {
    
//    arrScreenShots = [NSArray arrayWithObjects:@"IMG_1411.png",@"IMG_1412.png",@"IMG_1413.png",@"IMG_1414.png",@"IMG_1415.png",@"IMG_1416.png",@"IMG_1417.png", nil];
    
    UILabel *lblMatchDetail = [[UILabel alloc]init];
    lblMatchDetail.frame=CGRectMake(0, 5,self.view.frame.size.width, 40);
    lblMatchDetail.text=[ViewController languageSelectedStringForKey:@"MATCH QUESTIONS"] ;
    lblMatchDetail.font=[UIFont boldSystemFontOfSize:20];
    lblMatchDetail.textColor=[UIColor whiteColor];
    lblMatchDetail.textAlignment=NSTextAlignmentCenter;
    [viewScreenshot addSubview:lblMatchDetail];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *screenshotImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UIImageView *imageVScreenShot = [[UIImageView alloc]init];
//    imageVScreenShot.frame=CGRectMake(50, lblMatchDetail.frame.origin.y+lblMatchDetail.frame.size.height+10, 200, 300);
//    
//    imageVScreenShot.image=screenshotImage;
//    [viewScreenshot addSubview:imageVScreenShot];
    
    NSLog(@"Images Array -=-%@",self.arrScreenShots);
    
    scrollViewPaging = [[UIScrollView alloc] init];
    scrollViewPaging.frame=CGRectMake(0, lblMatchDetail.frame.origin.y+lblMatchDetail.frame.size.height, self.view.frame.size.width, 350);
    [viewScreenshot addSubview:scrollViewPaging];
    
    // a page is the width of the scroll view
    scrollViewPaging.pagingEnabled = YES;
    scrollViewPaging.showsHorizontalScrollIndicator = NO;
    scrollViewPaging.showsVerticalScrollIndicator = NO;
    scrollViewPaging.scrollsToTop = NO;
    scrollViewPaging.backgroundColor=[UIColor clearColor];
    scrollViewPaging.delegate = self;
    
    pageController = [[UIPageControl alloc] init];
    pageController.frame = CGRectMake(120, 350, 100, 30);
    [viewScreenshot addSubview:pageController];
    
    scrollViewPaging.contentSize = CGSizeMake(scrollViewPaging.frame.size.width * self.arrScreenShots.count,scrollViewPaging.frame.size.height);
    pageController.currentPage = 0;
    pageController.numberOfPages = self.arrScreenShots.count;
    
//    self.scrollViewPaging.backgroundColor=[UIColor redColor];
//    self.pageController.backgroundColor=[UIColor yellowColor];
    
    for (int i=0; i<self.arrScreenShots.count; i++) {
        
        CGRect frame;
        frame.origin.x = scrollViewPaging.frame.size.width * i;
        frame.origin.y = 0;
        frame.size =scrollViewPaging.frame.size;
        
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
        [scrollViewPaging addSubview:subView];
    }
   
    
//    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//    
//    self.pageController.dataSource = self;
//    [[self.pageController view] setFrame:CGRectMake(80, lblMatchDetail.frame.origin.y+lblMatchDetail.frame.size.height+30, 200, 200)];
//    
//    NSString *strInitialImage = [arrScreenShots objectAtIndex:0];
//    
//    NSArray *viewControllers = [NSArray arrayWithObject:strInitialImage];
//
//    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    
//    [self addChildViewController:self.pageController];
//    [[self view] addSubview:[self.pageController view]];
//    [self.pageController didMoveToParentViewController:self];
}
-(void)extraTopicsUI {
    
    UILabel *lblMatchDetail = [[UILabel alloc]init];
    lblMatchDetail.frame=CGRectMake(70, 5, 200, 60);
    lblMatchDetail.text=[ViewController languageSelectedStringForKey:@"POPULAR TOPICS"];
    lblMatchDetail.font=[UIFont boldSystemFontOfSize:20];
    lblMatchDetail.textColor=[UIColor whiteColor];
    lblMatchDetail.textAlignment=NSTextAlignmentLeft;
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

#pragma mark ===============================
#pragma mark Scroll view Methods
#pragma mark ===============================

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!pageControlUsed) {
        CGFloat pageWidth = scrollViewPaging.frame.size.width;
        NSInteger pageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if(pageController)
        {
        pageController.currentPage = pageNumber;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}
#pragma mark ===============================
#pragma mark User Grade in Parse
#pragma mark ===============================
-(void)userGrade:(NSNumber*)sum
{
    //[SingletonClass sharedSingleton].selectedSubCat=@101;
    PFQuery * query=[PFQuery queryWithClassName:@"UserGrade"];
    [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
    [query whereKey:@"SubcategoryId" equalTo:[SingletonClass sharedSingleton].selectedSubCat];
    
    [query selectKeys:@[@"gradepoints"]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray * temp=[query findObjects];
    PFObject * obj;
    if([temp count]>=1)
    {
        obj=[temp objectAtIndex:0];
      //  NSNumber * finalGradePoint=[NSNumber numberWithInt:[obj[@"gradepoints"] intValue] +[sum intValue] ];
        obj[@"gradepoints"]=sum;
        
    }
    else
    {
        PFObject * obj=[PFObject objectWithClassName:@"UserGrade"];
        obj[@"gradepoints"]=sum;
        obj[@"UserId"]=[SingletonClass sharedSingleton].objectId;
        obj[@"SubcategoryId"]=[SingletonClass sharedSingleton].selectedSubCat;
        obj[@"SubcategoryName"]=[SingletonClass sharedSingleton].strSelectedSubCat;
        obj[@"CategoryId"]=[NSNumber numberWithInt:[[SingletonClass sharedSingleton].strSelectedCategoryId intValue]];
        obj[@"username"]=[SingletonClass sharedSingleton].strUserName;
        obj[@"userimage"]=[SingletonClass sharedSingleton].imageFileUrl;
         [obj saveInBackground];
    }
        [obj saveInBackground];
    });
}


#pragma mark ===============================
#pragma mark Table View delegates Methods
#pragma mark ===============================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [arrTopics count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"quizplus";
    
    MessageCustomCell *cell = [topicsTableV dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if (cell == nil) {
        cell = [[MessageCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    //    NSLog(@"Sub Category Name print -== %@ \n Sub Cat Desc --= %@",self.arrSubCatName,self.arrSubCatDesc);
    NSString *message = [NSString stringWithFormat:@"%@",[arrTopics objectAtIndex:indexPath.section]];
    cell.backgroundColor=[UIColor clearColor];
    cell.messageLable.frame = CGRectMake(60, 10, 260, 20);
    cell.messageLable.text = message;
    //    cell.lblDescription.frame=CGRectMake(60, 28, 260, 10);
    //    cell.lblDescription.text=[NSString stringWithFormat:@"%@",[self.arrSubCatDesc objectAtIndex:indexPath.section]];
    cell.picImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrImages objectAtIndex:indexPath.section]]];
    //    NSLog(@"Cell text =-=- %@",cell.messageLable.text);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48.5;
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
#pragma mark Play Another
-(void)playAnother
{
    [SingletonClass sharedSingleton].checkBotUser=NO;
    GamePLayMethods * obj=[[GamePLayMethods alloc]init];
    obj.gameDelegate=self;
    [obj playNowButtonAction];
}

-(void)gameDetailsAnotherGame:(NSDictionary *)details
{
    //[SingletonClass sharedSingleton].gameFromView=false;
    GameViewController *obj = [[GameViewController alloc] init];
    obj.arrPlayerDetail=details;
    NSLog(@"obj Players Details -== %@",obj.arrPlayerDetail);
    [self presentViewController:obj animated:YES completion:nil];
}
-(void)rematchOpponentNotificationScreen
{
    //Playing Status Set True
    //  [SingletonClass sharedSingleton].isPlaying=TRUE;
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, appdelegate.window.bounds.size.width,appdelegate.window.bounds.size.height)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [appdelegate.window addSubview:backgroundView];
    upperView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,appdelegate.window.bounds.size.width,appdelegate.window.bounds.size.height/2)];
    upperView.backgroundColor=[UIColor whiteColor];
    [backgroundView addSubview:upperView];
    UIImageView *imageVUser = [[UIImageView alloc]initWithFrame:CGRectMake(appdelegate.window.bounds.size.width/2-30, 80, 60, 60)];
    imageVUser.image=[SingletonClass sharedSingleton].imageUser;
    imageVUser.layer.cornerRadius=30;
    imageVUser.clipsToBounds=YES;
    [upperView addSubview:imageVUser];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(0, 150,appdelegate.window.bounds.size.width, 50)];
    lblName.font=[UIFont boldSystemFontOfSize:15];
    lblName.textColor=[UIColor blackColor];
    lblName.text=[SingletonClass sharedSingleton].strUserName;
    lblName.textAlignment=NSTextAlignmentCenter;
    [upperView addSubview:lblName];
    
    UILabel *gradeName=[[UILabel alloc] initWithFrame:CGRectMake(0, lblName.frame.origin.y+20,appdelegate.window.frame.size.width, 50)];
    gradeName.font=[UIFont boldSystemFontOfSize:15];
    gradeName.textColor=[UIColor blackColor];
    gradeName.text=[SingletonClass sharedSingleton].userRank;
    gradeName.textAlignment=NSTextAlignmentCenter;
    [upperView addSubview:gradeName];
    //seperation line
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor blackColor].CGColor;
    
    border.frame = CGRectMake(0, upperView.frame.size.height - 3, upperView.frame.size.width, 3);
    [upperView.layer addSublayer:border];
    
    UIImageView * clockImageView=[[UIImageView alloc]initWithFrame:CGRectMake(appdelegate.window.bounds.size.width/2-50,appdelegate.window.bounds.size.height-200,100,100)];
    clockImageView.image=[UIImage imageNamed:@"clock.png"];
    [backgroundView addSubview:clockImageView];
    UIButton * cancelBtnL=[[UIButton alloc]initWithFrame:CGRectMake(backgroundView.frame.size.width/2-40,backgroundView.frame.size.height-80,80,40)];
    [cancelBtnL addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtnL.backgroundColor=[UIColor colorWithRed:71.0f/255.0f green:165.0f/255.0f blue:227.0f/255.0f alpha:1.0f];
   
    [cancelBtnL setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtnL setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backgroundView addSubview:cancelBtnL];
    
    //----------------------------
}

-(void)cancelBtnAction:(id)sender
{
    [backgroundView removeFromSuperview];
}

#pragma mark Rematch----
-(void)rematchAction:(UIButton*)button
{
    if([SingletonClass sharedSingleton].checkBotUser)
    {
        [self performSelector:@selector(rematchRejected) withObject:nil afterDelay:3];
        [self rematchOpponentNotificationScreen];
    }
    else
    {
        [self cloudCall:(int)button.tag];
        [SingletonClass sharedSingleton].rematchMain=TRUE;
        
        NSLog(@"Rematch Parameters %@ %@", [SingletonClass sharedSingleton].secondPlayerObjid,[SingletonClass sharedSingleton].secondPlayerInstallationId);
        
                [self rematchOpponentNotificationScreen];
        
 
    }
 }
-(void)resetAllVariables
{
    [SingletonClass sharedSingleton].mainPlayerChallenge=FALSE;
    [SingletonClass sharedSingleton].singleGameChallengedPlayer=FALSE;
    [SingletonClass sharedSingleton].userLeftRoom=FALSE;
}
-(void)cloudCall:(int)index
{
    NSNumber *subCatID = [SingletonClass sharedSingleton].selectedSubCat;
    NSString * subCategoryName=[SingletonClass sharedSingleton].strSelectedSubCat;
    NSString * oppDeviceId=[SingletonClass sharedSingleton].secondPlayerInstallationId;
    NSString * oppUserId=[SingletonClass sharedSingleton].secondPlayerObjid;
    
    NSLog(@"%@ %@ userid%@ installation%@ opponent%@ deviceopp%@",subCatID,subCategoryName,[SingletonClass sharedSingleton].objectId,[SingletonClass sharedSingleton].installationId,oppUserId,oppDeviceId);
    NSNumber * mainId=[NSNumber numberWithInt:[[SingletonClass sharedSingleton].strSelectedCategoryId intValue]];
    [PFCloud callFunctionInBackground:@"Rematch"
                       withParameters:@{@"subcategoryid":subCatID,@"subcategoryname":[SingletonClass sharedSingleton].strSelectedSubCat,@"userid":[SingletonClass sharedSingleton].objectId,@"uniqueid":[SingletonClass sharedSingleton].installationId,@"opppnent":oppUserId,@"uniqueid1":oppDeviceId,@"mainid":mainId,@"username":[SingletonClass sharedSingleton].strUserName}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        
                                        NSLog(@"Response Result -==- %@", result);
                                            [SingletonClass sharedSingleton].strQuestionsId= result;
                                        
                                        //------------------
                                        int connection=[[WarpClient getInstance]getConnectionState];
                                        if(connection==0)
                                        {
                                            time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
                                            NSString *dateStr = [NSString stringWithFormat:@"%ld",unixTime];
                                            [[WarpClient getInstance] createRoomWithRoomName:dateStr roomOwner:@"Girish Tyagi" properties:NULL maxUsers:2];
                                        }
                                        else
                                        {
                                            [SingletonClass sharedSingleton].connectedNot=TRUE;
                                            [[WarpClient getInstance]connectWithUserName:[SingletonClass sharedSingleton].objectId];
                                        }
                                        //--------------------
                                        NSLog(@"Connect to cloud");
                                        
                                    }
                                    else
                                    {
                                        NSLog(@"Error in calling Cloud Code%@",error);
                                    }
                                }];
    
}


-(void)rematchRejected
{
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [appdelegate.window addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 100)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 20)];
    lblReject.text=@"죄송 상대는 거부";
    lblReject.font=[UIFont boldSystemFontOfSize:15];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UIButton * okButton=[UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame=CGRectMake(100,popUpImageview.frame.size.height-40,100, 30);
    okButton.layer.borderWidth=2;
    okButton.layer.borderColor=[UIColor blackColor].CGColor;
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton setTitle:[ViewController languageSelectedStringForKey:@"OK"] forState:UIControlStateNormal];
    okButton.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:okButton];
}
-(void)okButtonAction
{
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject] removeFromSuperview];
    [self cancelBtnAction:nil];
    
}

#pragma mark reset----------
-(void)resetValuesForGame
{
    [SingletonClass sharedSingleton].isPlaying=false;
    [[WarpClient getInstance] leaveRoom:[SingletonClass sharedSingleton].roomId];
    [SingletonClass sharedSingleton].roomId=@"";
    [SingletonClass sharedSingleton].secondPlayer=false;
    [SingletonClass sharedSingleton].mainPlayer=false;
    [SingletonClass sharedSingleton].rematchMain=false;
    [SingletonClass sharedSingleton].rematchSecond=false;
    [SingletonClass sharedSingleton].mainPlayerChallenge=false;
    [SingletonClass sharedSingleton].singleGameChallengedPlayer=FALSE;
    [SingletonClass sharedSingleton].userLeftRoom=FALSE;
    [SingletonClass sharedSingleton].strQuestionsId=@"";
}
-(void)retriveUserPreviousScore
{
    if([SingletonClass sharedSingleton].selectedSubCat)
    {
    PFQuery * queryUserGrade=[PFQuery queryWithClassName:@"UserGrade"];
    [queryUserGrade whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
    [queryUserGrade whereKey:@"SubcategoryId" equalTo:[SingletonClass sharedSingleton].selectedSubCat];
    [queryUserGrade findObjectsInBackgroundWithBlock:^(NSArray * objects,NSError * error)
    {
    if(error)
     {
         
     }
    else
    {
        if([objects count]>0)
        {
        PFObject * obj=[objects objectAtIndex:0];
        previousPoint=obj[@"gradepoints"];
            [self gameoverUi];
        }
        else
        {
            [self gameoverUi];
        }
    }
    }];
    }
}
-(void)updateTotalXp:(NSNumber*)scoreGained
{
    PFObject *objUsrDetail=[[SingletonClass sharedSingleton].userDetailinParse objectAtIndex:0];
    NSNumber *totalXp=objUsrDetail[@"TotalXP"];
    int sum=[totalXp intValue]+[scoreGained intValue];
    PFObject * objUpdateXp=[PFUser currentUser];
    objUpdateXp[@"TotalXP"]=[NSNumber numberWithInt:sum];
    objUpdateXp[@"Rank"]=[self getProgressFromGradeValue:sum];
    [objUpdateXp saveInBackgroundWithBlock:^(BOOL success,NSError * error){
       
        if(error)
        {
            NSLog(@"error in updating total Xp %@",error);
        }
    }];
}
-(NSString*)getProgressFromGradeValue:(int)gradevalue
{
    if (gradevalue >=0 && gradevalue<=810)
    {
        
        return @"베이비";
    }
    else if (gradevalue >=811 && gradevalue <=1220)
    {
        return @"초1";
    }
    else if (gradevalue >=1221 && gradevalue <=1700)
    {
       
        return @"초2";
    }
    else if (gradevalue>=1701 && gradevalue <=2250)
    {
              return @"초3";
    }
    else if (gradevalue >=2251 && gradevalue <=2870)
    {
       
        return @"초4";
    }
    else if (gradevalue >=2871 && gradevalue <=3560)
    {
       
        return @"초5";
    }
    else if (gradevalue >=3561 && gradevalue <=5150)
    {
      
       return @"초6";
    }
    else if (gradevalue >=5151 && gradevalue<=7020)
    {
        
        return @"중1";
    }
    else if (gradevalue >=7021 && gradevalue <=9170)
    {
               return @"중2";
    }
    else if (gradevalue >=9171 && gradevalue <=15770)
    {
       
        return @"중3";

    }
    else  if (gradevalue >=15771 && gradevalue <=24120)
    {
        
        return @"고1";
    }
    else if (gradevalue >=24121 && gradevalue<=34220)
    {
       
        return @"고2";
    }
    else if (gradevalue >=34221 && gradevalue <=59670)
    {
       
        return @"고3";
    }
    else if (gradevalue >=59671 && gradevalue <=92120)
    {
      
        return @"대1";
    }
    else if (gradevalue >=92121 && gradevalue <=131570)
    {
        return @"대2";
    }
    else if (gradevalue >=131571 && gradevalue <=178020)
    {
      
        return @"대3";    }
    else if (gradevalue >=178021 && gradevalue <=359370)
    {
       
        return @"대4";
    }
    else if (gradevalue >=359371 && gradevalue <=801620)
    {
       
        return @"석사";
    }
    else if (gradevalue >=801621 && gradevalue <=1418870)
    {
        
        return @"박사";
    }
    else if (gradevalue>=1418871)
    {
    
        return @"퀴즈왕";
    }
    else
    {
        return nil;
    }
    
    
}

#pragma mark-----
#pragma mark alert view delegates
-(void)rejectUi:(NSString *)request
{
    
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 100)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 20)];
    lblReject.text=@"죄송합니다 사용자 는 거부";
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UIButton * okBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame=CGRectMake(120,popUpImageview.frame.size.height-40,120, 30);
    [okBtn setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSString * strAccept=[ViewController languageSelectedStringForKey:@"Ok"];
    [okBtn setTitle:strAccept forState:UIControlStateNormal];
    okBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [okBtn addTarget:self action:@selector(acceptButtonOk:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:okBtn];
    
}
-(void)acceptButtonOk:(id)sender
{
    
    [rejectView removeFromSuperview];
}
-(void)dealloc
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
