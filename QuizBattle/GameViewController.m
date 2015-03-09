    //
//  GameViewController.m
//  QuizBattle
//
//  Created by GBS-mac on 8/21/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "GameViewController.h"
#import "SingletonClass.h"
#import <Parse/Parse.h>
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "GameOverViewController.h"
#import "LogInViewController.h"
#import "ViewController.h"

@interface GameViewController ()<GameOverViewControllerDelegate>

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.arrPlayerDetail = [[NSDictionary alloc] init];
    }
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [SingletonClass sharedSingleton].userLeftRoom=FALSE;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"answerresponse" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startgame" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserLeft" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
 [SingletonClass sharedSingleton].isPlaying=false;
    questionNum=1;
    if([timerForBombAnimation isValid])
    {
        [timerForBombAnimation invalidate];
        timerForBombAnimation=nil;
    }

        [timer invalidate];
        timer=nil;
    
}
-(void) dismissOwnerView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark==========================
#pragma mark Game UI
#pragma mark==========================

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SingletonClass sharedSingleton].isPlaying=TRUE;
    self.imageQuestion=[[NSMutableArray alloc]init];
    userDefault = [NSUserDefaults standardUserDefaults];
    checkVibration = [userDefault boolForKey:@"vibrate"];
    [self fetchQuestions];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userConnectionBreak:) name:@"UserConnectionBreak" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rejectUiFromUser) name:@"UserGiveUp" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLeftYouWin:) name:@"UserLeft" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkAnswerForSecondPlayer:) name:@"answerresponse" object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(roundSetting) name:@"startgame" object:nil];
   
    [NSThread detachNewThreadSelector:@selector(fetchGameResult) toTarget:self withObject:nil];
    
   // [NSThread detachNewThreadSelector:@selector(fetchSubCategoryName) toTarget:self withObject:nil];
    
    dictDetailsPlayer1 = [[NSMutableDictionary alloc]init];
    dictDetailsPlayer2 = [[NSMutableDictionary alloc]init];
    checkAnswer=NO;
    arrOp = [[NSMutableArray alloc] init];
    arrSubCatId =[[NSMutableArray alloc] init];
    arrQues =[[NSArray alloc] init];
    arrCorrAns =[[NSMutableArray alloc] init];
    arrScreenshotImages =[[NSMutableArray alloc] init];
    arrPlayer1Scores =[[NSMutableArray alloc] init];
    arrPlayer2Scores =[[NSMutableArray alloc] init];
    [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)185/255 green:(CGFloat)231/255 blue:(CGFloat)246/255 alpha:1]];
    
    time=11;
    questionNum=1;
    gamePointPlayer1=0;
    gamePointPlayer2=0;
    numOfCorrectAnswer=1;
    numOfCorrectAnswerPlayer2=1;
    numOfWrongAnswer=1;
    numOfWrongAnswerPlayer2=1;
    //-----------------
    UILabel *lblPlayer1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10,80,20)];
    lblPlayer1.textAlignment=NSTextAlignmentLeft;
    lblPlayer1.numberOfLines=3;
    lblPlayer1.lineBreakMode=NSLineBreakByCharWrapping;
    lblPlayer1.textColor=[UIColor blackColor];
    [lblPlayer1 setFont:[UIFont fontWithName:@"NanumBarunGothicBold" size:15]];
    [self.view addSubview:lblPlayer1];
    
    lblPlayer1.text=[NSString stringWithFormat:@"%@",[SingletonClass sharedSingleton].strUserName];
    UILabel *lblPlayer2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-90,10,80,20)];
    lblPlayer2.textAlignment=NSTextAlignmentRight;
    lblPlayer2.numberOfLines=3;
    lblPlayer2.lineBreakMode=NSLineBreakByCharWrapping;
    lblPlayer2.textColor=[UIColor blackColor];
    lblPlayer2.text=[NSString stringWithFormat:@"%@", [SingletonClass sharedSingleton].strSecPlayerName];
    [lblPlayer2 setFont:[UIFont fontWithName:@"NanumBarunGothicBold" size:15]];
    [self.view addSubview:lblPlayer2];
    
    UIImageView *imagePlayer1 = [[UIImageView alloc] init];
    imagePlayer1.frame=CGRectMake(10, 40, 50, 50);
    imagePlayer1.layer.cornerRadius=25;
    imagePlayer1.clipsToBounds=YES;
    imagePlayer1.image=[SingletonClass sharedSingleton].imageUser;
    [self.view addSubview:imagePlayer1];
    
    UIImageView *imagePlayer2 = [[UIImageView alloc] init];
    imagePlayer2.frame=CGRectMake(self.view.frame.size.width-60, 40, 50, 50);
    imagePlayer2.layer.cornerRadius=25;
    imagePlayer2.clipsToBounds=YES;
    imagePlayer2.image=[SingletonClass sharedSingleton].imageSecondPlayer;
    [self.view addSubview:imagePlayer2];
    
    UILabel * gradeLblPlayerName1=[[UILabel alloc]initWithFrame:CGRectMake(10, 95, 50, 10)];
    gradeLblPlayerName1.textAlignment=NSTextAlignmentCenter;
    gradeLblPlayerName1.numberOfLines=3;
    gradeLblPlayerName1.lineBreakMode=NSLineBreakByCharWrapping;
    gradeLblPlayerName1.text=[SingletonClass sharedSingleton].userRank;
    gradeLblPlayerName1.textColor=[UIColor blackColor];
    [gradeLblPlayerName1 setFont:[UIFont fontWithName:@"NanumBarunGothicBold" size:10]];
   // gradeLblPlayerName1.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:gradeLblPlayerName1];
    [self.view addSubview:lblPlayer1];
    
    UILabel * gradeLblPlayerName2=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 95, 60, 10)];
    gradeLblPlayerName2.textAlignment=NSTextAlignmentCenter;
    gradeLblPlayerName2.text=[SingletonClass sharedSingleton].strSecPlayerRank;
    gradeLblPlayerName2.numberOfLines=3;
    gradeLblPlayerName2.lineBreakMode=NSLineBreakByCharWrapping;
    gradeLblPlayerName2.textColor=[UIColor blackColor];
    [gradeLblPlayerName2 setFont:[UIFont fontWithName:@"NanumBarunGothicBold" size:10]];
  //  gradeLblPlayerName2.font=[UIFont systemFontOfSize:10];
    [self.view addSubview:gradeLblPlayerName2];
    [self.view addSubview:lblPlayer1];
    NSLog(@"STRING player second -=-= %@",[SingletonClass sharedSingleton].strSecPlayerName);
    
    [self checkConnection];
}
-(void)checkConnection
{
    checkConnection=1;
    if(!timerCheckConnection)
    {
    timerCheckConnection = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkQuestionNumber) userInfo:nil repeats:YES];
    [timerCheckConnection fire];
    }
}
-(void)checkQuestionNumber
{
    checkConnection++;
    NSLog(@"Check connection Timer %d",checkConnection);
    if(questionNum>1)
    {
        if([timerCheckConnection isValid])
        {
            [timerCheckConnection invalidate];
        }
    }
    else if (checkConnection==15)
    {
        [self serverErrorTimer];
        if([timerCheckConnection isValid])
        {
                [timerCheckConnection invalidate];
        }
    }
    
}
-(void)gameUI{
    
    if ([UIScreen mainScreen].bounds.size.height>500)
    {
        
        lblRound = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 130)];
        batterImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-35, 30,70, 72)];
        //lblTimer = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-60, 30, 90, 50)];
        self.lblQues.userInteractionEnabled = YES;
        self.lblQues = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, self.view.frame.size.width-100, 80)];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rejectUiFromUser)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.lblQues addGestureRecognizer:tapGestureRecognizer];
        
        quesImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 120, self.view.frame.size.width-160, 90)];
        lblOptionA = [[UILabel alloc] initWithFrame:CGRectMake(40, 300, self.view.frame.size.width-80, 40)];
        lblOptionB = [[UILabel alloc] initWithFrame:CGRectMake(40, 350, self.view.frame.size.width-80, 40)];
        lblOptionC = [[UILabel alloc] initWithFrame:CGRectMake(40, 400, self.view.frame.size.width-80, 40)];
        lblOptionD = [[UILabel alloc] initWithFrame:CGRectMake(40, 450, self.view.frame.size.width-80, 40)];        lblPointPlayer1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 50, 30)];
        lblPointPlayer2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 110, 50, 30)];
        imageProgressBarPlayer1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 180, 20, 350)];
        imageProgressBarPlayer2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30, 180, 20, 350)];
    }
    else
    {
        
        lblRound = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 320, 130)];
        batterImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-35, 30, 70, 72)];
       // lblTimer = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-60, 30, 90, 50)];
        self.lblQues = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, self.view.frame.size.width-100, 80)];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rejectUiFromUser)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
       [self.lblQues addGestureRecognizer:tapGestureRecognizer];
        self.lblQues.userInteractionEnabled=YES;
     quesImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 80, self.view.frame.size.width-160, 90)];
        lblOptionA = [[UILabel alloc] initWithFrame:CGRectMake(40, 250, self.view.frame.size.width-80, 40)];
        lblOptionB = [[UILabel alloc] initWithFrame:CGRectMake(40, 300, self.view.frame.size.width-80, 40)];
        lblOptionC = [[UILabel alloc] initWithFrame:CGRectMake(40, 350, self.view.frame.size.width-80, 40)];
        lblOptionD = [[UILabel alloc] initWithFrame:CGRectMake(40, 400, self.view.frame.size.width-80, 40)];
        lblPointPlayer1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 50, 30)];
        lblPointPlayer2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 110, 50, 30)];
        imageProgressBarPlayer1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 140, 20, 300)];
        imageProgressBarPlayer2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30, 140, 20, 300)];
    }
    
    lblRound.textAlignment=NSTextAlignmentCenter;
    lblRound.textColor=[UIColor blackColor];
    lblRound.font=[UIFont fontWithName:@"NanumBarunGothicBold" size:50];
    //lblRound.font=[UIFont boldSystemFontOfSize:50];
    
    [self.view addSubview:lblRound];
    
//    lblTimer.textAlignment=NSTextAlignmentCenter;
//    lblTimer.textColor=[UIColor whiteColor];
//    lblTimer.font=[UIFont boldSystemFontOfSize:35];
    [self.view addSubview:batterImageView];

    //[self.view addSubview:lblTimer];
    
    self.lblQues.textAlignment=NSTextAlignmentCenter;
    self.lblQues.textColor=[UIColor blackColor];
    self.lblQues.numberOfLines=5;
    self.lblQues.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblQues.font=[UIFont fontWithName:@"NanumBarunGothicBold" size:15];
    [self.view addSubview:self.lblQues];
    
    [self.view addSubview:quesImage];
    
  //  NSLog(@"Array Questions =-=- %@",self.arrPlayerDetail);
    
    lblOptionA.textAlignment=NSTextAlignmentCenter;
    lblOptionA.textColor=[UIColor blackColor];
    lblOptionA.numberOfLines=3;
    lblOptionA.lineBreakMode = NSLineBreakByWordWrapping;
    lblOptionA.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"white.png"]];
    lblOptionA.font=[UIFont fontWithName:@"NanumBarunGothicBold" size:15];
    
    lblOptionA.userInteractionEnabled=YES;
    lblOptionA.tag=1;
    lblOptionA.opaque=NO;
    [self.view addSubview:lblOptionA];
    
    UITapGestureRecognizer *tapGestureA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureA:)];
    [lblOptionA addGestureRecognizer: tapGestureA];
    
    lblOptionB.textAlignment=NSTextAlignmentCenter;
    lblOptionB.textColor=[UIColor blackColor];
    lblOptionB.numberOfLines=3;
    lblOptionB.font=[UIFont fontWithName:@"NanumBarunGothicBold" size:15];
    lblOptionB.userInteractionEnabled=YES;
    lblOptionB.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"white.png"]];
    lblOptionB.lineBreakMode = NSLineBreakByWordWrapping;
    lblOptionB.tag=2;
    lblOptionB.opaque=NO;
    [self.view addSubview:lblOptionB];
    
    UITapGestureRecognizer *tapGestureB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureB:)];
    [lblOptionB addGestureRecognizer:tapGestureB];
    
    lblOptionC.textAlignment=NSTextAlignmentCenter;
    lblOptionC.textColor=[UIColor blackColor];
    lblOptionC.numberOfLines=3;
    lblOptionC.lineBreakMode = NSLineBreakByWordWrapping;
    lblOptionC.userInteractionEnabled=YES;
    lblOptionC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"white.png"]];
    lblOptionC.font=[UIFont fontWithName:@"NanumBarunGothicBold" size:15];

    lblOptionC.tag=3;
    [self.view addSubview:lblOptionC];
    
    UITapGestureRecognizer *tapGestureC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureC:)];
    [lblOptionC addGestureRecognizer:tapGestureC];
    
    lblOptionD.textAlignment=NSTextAlignmentCenter;
    lblOptionD.textColor=[UIColor blackColor];
    lblOptionD.numberOfLines=4;
    lblOptionD.font=[UIFont fontWithName:@"NanumBarunGothicBold" size:15];
    lblOptionD.userInteractionEnabled=YES;
    lblOptionD.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"white.png"]];
    lblOptionD.lineBreakMode = NSLineBreakByWordWrapping;
    lblOptionD.tag=4;
    [self.view addSubview:lblOptionD];
    
    UITapGestureRecognizer *tapGestureD = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureD:)];
    [lblOptionD addGestureRecognizer:tapGestureD];
    
    lblPointPlayer1.textAlignment=NSTextAlignmentCenter;
    lblPointPlayer1.textColor=[UIColor blackColor];
    lblPointPlayer1.text=@"0";
    [self.view addSubview:lblPointPlayer1];
    
    lblPointPlayer2.textAlignment=NSTextAlignmentCenter;
    lblPointPlayer2.textColor=[UIColor blackColor];
    lblPointPlayer2.text=@"0";
    [self.view addSubview:lblPointPlayer2];
    
    [imageProgressBarPlayer1 setImage:[UIImage imageNamed:@"blank.png"]];
    [self.view addSubview:imageProgressBarPlayer1];
    
    [imageProgressBarPlayer2 setImage:[UIImage imageNamed:@"blank.png"]];
    [self.view addSubview:imageProgressBarPlayer2];
    [self hideAllLabel];
    //Challenge for main Player.
    
    
}

#pragma mark==========================
#pragma mark Fetch Parse Values
#pragma mark==========================

-(void)fetchQuestions {
    
    NSLog(@"Player details =-= %@",self.arrPlayerDetail);
    
     NSString *strQues =[self.arrPlayerDetail objectForKey:@"questions"];
  //  NSLog(@"StrQues = %@",strQues);
     arrQues = [strQues componentsSeparatedByString:@","];
    NSLog(@"Question id %@",arrQues);
     PFQuery *query = [PFQuery queryWithClassName:@"Questions"];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
            [query whereKey:@"objectId" containedIn:arrQues];
            [query addAscendingOrder:@"objectId"];
            NSArray *arrDetails = [query findObjects];
         NSLog(@"Question Array Details Of Main Game = %@",arrDetails);
        self.gameQuestionsArray = [NSArray arrayWithArray:arrDetails];
        //--Fetch Image---
        for (int i=0; i<[arrDetails count]; i++)
        {
            
            NSDictionary *dict = [self.gameQuestionsArray objectAtIndex:i];
            NSArray *keys = [dict allKeys];
            
            if ([keys containsObject:@"Picture"])
            {
                
                    PFFile  *strImage = [dict objectForKey:@"Picture"];
                    NSData *imageData = [strImage getData];
                   [self.imageQuestion addObject:[UIImage imageWithData:imageData]];
            }

        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self gameUI];
        });
    });
   
}

-(void)fetchSubCategoryName
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"SubCategory"];
    [query whereKey:@"SubCategoryId" equalTo:[SingletonClass sharedSingleton].selectedSubCat];
    
    NSArray *arrDetail = [query findObjects];
   // NSLog(@"arrDetail SubCategoryId--= %@",arrDetail);
    NSDictionary *dict = [arrDetail objectAtIndex:0];
    
    NSString *strSubCatName = [dict objectForKey:@"SubCategoryName"];
    [SingletonClass sharedSingleton].strSelectedSubCat= strSubCatName;
    //NSLog(@"Selected Sub Category Name -==- %@ \n strSubCatName =-=-%@",[SingletonClass sharedSingleton].strSelectedSubCat,strSubCatName );
}
-(void)fetchGameResult
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"GameResult"];
    [query whereKey:@"UserId" equalTo:[SingletonClass sharedSingleton].objectId];
  //  NSLog(@"Second Player Id -=-= %@",[SingletonClass sharedSingleton].secondPlayerObjid);
    
    [query whereKey:@"opponent" equalTo:[SingletonClass sharedSingleton].secondPlayerObjid];
    NSNumber * categoryId=[NSNumber numberWithInt:[[SingletonClass sharedSingleton].strSelectedCategoryId intValue]];
    [query whereKey:@"CategoryId" equalTo:categoryId];
    
    arrTotalWinStat = [query findObjects];
   // NSLog(@"Full Details --= %@\\nn full detatil count -== %lu",arrTotalWinStat, (unsigned long)arrTotalWinStat.count);
    
    arrWinStatCount = [[NSMutableArray alloc]init];
    
    for (int i=0; i<arrTotalWinStat.count; i++) {
        
        NSDictionary *dict = [arrTotalWinStat objectAtIndex:i];
        NSNumber *winningStat = [dict objectForKey:@"winnerstatus"];
        
        if ([winningStat integerValue]==1)
        {
          [arrWinStatCount addObject:@"win"];
        }
    }
   // NSLog(@"Array win Stat -==- %lu \n total win count -==- %lu",(unsigned long)arrWinStatCount.count,(unsigned long)arrTotalWinStat.count);
}

#pragma mark==========================
#pragma mark Game Play Methods
#pragma mark==========================

-(void)roundSetting
{
    batterImageView.hidden=YES;
    if([timerForBombAnimation isValid])
    {
        [timerForBombAnimation invalidate];
        timerForBombAnimation=nil;
    }

    NSLog(@"Round setting called");
    if(questionNum<8)
    {
       
    if(questionNum==7)
    {
        NSString * round=[ViewController languageSelectedStringForKey:@"Last Round"];
        lblRound.text=[NSString stringWithFormat:@"%@ %d",round,questionNum];
        lblRound.font=[UIFont boldSystemFontOfSize:20];
        lblRound.layer.opacity=1;
 
    }
    else
    {
        NSString * round=@"Round";//[ViewController languageSelectedStringForKey:@"Round"];
        lblRound.text=[NSString stringWithFormat:@"%@ %d",round,questionNum];
        lblRound.layer.opacity=1;
    }
    [UIView animateWithDuration:3.5 delay:1 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void){
        lblRound.layer.opacity=0.0;
        
    } completion:nil];
    }
    [self nextQuesView];
    
}
-(void)nextQuesView
{
    
    [timer invalidate];
    timer=nil;
    checkPlayer1Action=NO;
    checkPlayer2Action=NO;
    time=11;
    bombImageNumber=40;
    lblOptionA.hidden=YES;
    lblOptionB.hidden=YES;
    lblOptionC.hidden=YES;
    lblOptionD.hidden=YES;
    self.lblQues.hidden=YES;
    //lblTimer.hidden=YES;
    batterImageView.hidden=YES;
    if (questionNum<8)
    {
        [self performSelector:@selector(displayGame) withObject:nil afterDelay:1.0];
    }
    else
    {
        [self performSelector:@selector(saveGameResult) withObject:nil afterDelay:2.0];
    }
}

-(void)displayGame
{
    self.view.userInteractionEnabled=YES;
    while (self.gameQuestionsArray.count<=0)
    {
        if (self.gameQuestionsArray.count>0) {
            break;
        }
    }
   // NSLog(@"Question Array after while= %@",self.gameQuestionsArray);
    NSArray *strQues;
    
    NSDictionary *dict = [self.gameQuestionsArray objectAtIndex:questionNum-1];
    NSArray *keys = [dict allKeys];
    
    arrOptions = [dict objectForKey:@"Option"];
    strCorrectAns = [dict objectForKey:@"CorrectAnswer"];
    strQues = [dict objectForKey:@"Question"];
    self.lblQues.text=[NSString stringWithFormat:@"%@",strQues];
    if ([keys containsObject:@"Picture"])
    {
        static int i=0;
        if (self.imageQuestion.count<=i) {
            PFFile  *strImage = [dict objectForKey:@"Picture"];
            NSData *imageData = [strImage getData];
            quesImage.image = [UIImage imageWithData:imageData];
        }
        else{
            quesImage.image = [self.imageQuestion objectAtIndex:i];
        }
        quesImage.hidden = NO;
        i++;
        
    }
    else
    {
        quesImage.hidden = YES;
    }
   
     //lblTimer.hidden=NO;
    self.lblQues.hidden=NO;
    
           if ([SingletonClass sharedSingleton].checkBotUser) {
        
        int botTimeForAns = arc4random()%7;
      //  NSLog(@"Bot answer Time -==- %d",botTimeForAns+1);
        [self performSelector:@selector(calculationsForBot) withObject:nil afterDelay:botTimeForAns+1];
    }
    [self performSelector:@selector(timerStart) withObject:nil afterDelay:1];
   
}
-(void)hideAllLabel
{
    lblOptionA.hidden=YES;
    lblOptionB.hidden=YES;
    lblOptionC.hidden=YES;
    lblOptionD.hidden=YES;
}
-(void)timerStart
{
    lblOptionA.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_list view_bg.png"]];
    lblOptionB.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_list view_bg.png"]];
    lblOptionC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_list view_bg.png"]];
    lblOptionD.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_list view_bg.png"]];
    
    lblOptionA.textColor=[UIColor blackColor];
    lblOptionB.textColor=[UIColor blackColor];
    lblOptionC.textColor=[UIColor blackColor];
    lblOptionD.textColor=[UIColor blackColor];
    
    lblOptionA.hidden=NO;
    lblOptionB.hidden=NO;
    lblOptionC.hidden=NO;
    lblOptionD.hidden=NO;
    
       // batterImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_Battery",time]];
    
     batterImageView.hidden=NO;
    lblOptionA.text=[NSString stringWithFormat:@"%@",[arrOptions objectAtIndex:0]];
    lblOptionB.text=[NSString stringWithFormat:@"%@",[arrOptions objectAtIndex:1]];
    lblOptionC.text=[NSString stringWithFormat:@"%@",[arrOptions objectAtIndex:2]];
    lblOptionD.text=[NSString stringWithFormat:@"%@",[arrOptions objectAtIndex:3]];
    
if(!timer)
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
   
}
     [timer fire];
    questionNum++;
    
}
-(void)updateTimer
{
    
    time--;
    if([timerForBombAnimation isValid])
    {
        [timerForBombAnimation invalidate];
        timerForBombAnimation=nil;
    }

    if(!timerForBombAnimation)
    {
        timerForBombAnimation = [NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(changeBombImage) userInfo:nil repeats:YES];
        
    }
    [timerForBombAnimation fire];

      // batterImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_Battery",time]];
    //lblTimer.text=[NSString stringWithFormat:@"%d",time];
    NSLog(@"Timer value %d",time);
    if (time==0)
    {
        [timer invalidate];
        timer=nil;
        //For testing
        //                if ([timer isValid])
        //                    {
        //                        [timer invalidate];
        //                        //timer=nil;
        //                        // time=0;
        //                    }
        
        if (!checkPlayer1Action)
        {
            
            [arrPlayer1Scores addObject:@"0"];
            
            [self animateProgressBarWrongAnswer];
        }
        if (!checkPlayer2Action)
        {
            
            [arrPlayer2Scores addObject:@"0"];
            [self animateProgressBarWrongAnswerPlayer2];
        }
        if (![strFirstPlayerSelAns isEqualToString:strCorrectAns] && ![strSecPlayerSelAns isEqualToString:strCorrectAns])
        {
            
            NSInteger correctAns = [arrOptions indexOfObject:strCorrectAns];
            UILabel *lblCorrectAns = (UILabel*)[self.view viewWithTag:correctAns+1];
            lblCorrectAns.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_no_arrowN.png"]];
            //lblCorrectAns.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        }
        
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenshotImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if(screenshotImage!=nil)
            [arrScreenshotImages addObject:screenshotImage];
        
        // NSLog(@"Add images For second player response in timer-=-== %@",arrScreenshotImages);
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        if([SingletonClass sharedSingleton].checkBotUser)
        {
            if([timerForBombAnimation isValid])
            {
                [timerForBombAnimation invalidate];
                timerForBombAnimation=nil;
            }

            [self performSelector:@selector(roundSetting) withObject:nil    afterDelay:2];
        }
        
        if([SingletonClass sharedSingleton].mainPlayer||[SingletonClass sharedSingleton].mainPlayerChallenge||[SingletonClass sharedSingleton].rematchMain)
        {
            if([timerForBombAnimation isValid])
            {
                [timerForBombAnimation invalidate];
                timerForBombAnimation=nil;
            }

            NSLog(@"Start From timer zero");
            [self performSelector:@selector(sendStartWithDelay) withObject:nil afterDelay:1];
        }
        //
    }//if for time 0
    else
    {
        if(checkPlayer1Action&&checkPlayer2Action)
        {
            //            if ([timer isValid])
            //            {
            [timer invalidate];
            timer=nil;
            // time=0;
            //}
            
            if([SingletonClass sharedSingleton].mainPlayer||[SingletonClass sharedSingleton].mainPlayerChallenge||[SingletonClass sharedSingleton].rematchMain)
            {
                NSLog(@"Start From timer of game");
                //[[WarpClient getInstance] sendChat:@"start"];
            }
            
            
        }
    }
}

-(void)saveGameResult
{
    
       // [SingletonClass sharedSingleton].checkBotUser=NO;
        
        int winningStatus;
        
        GameOverViewController *obj = [[GameOverViewController alloc] init];
        obj.delegate = self;
        obj.gameLeft=NO;
        obj.arrScreenShots=arrScreenshotImages;
        obj.arrScorePlayer1=arrPlayer1Scores;
        obj.arrScorePlayer2=arrPlayer2Scores;
     NSLog(@"Arr Player 1 scores -==- %@ \n Arr Player 2 scores -==- %@",arrPlayer1Scores,arrPlayer2Scores);
        
        
        int lifeCount = (int)[userDefault integerForKey:@"buylife"];
        
        if (gamePointPlayer1>gamePointPlayer2) {
            obj.strStatus=@"YOU WIN!";
            winningStatus=1;
            [arrWinStatCount addObject:@"win"];
        }
        else if (gamePointPlayer1<gamePointPlayer2){
            obj.strStatus=@"YOU LOSE!";
            winningStatus=0;
            
            if (lifeCount>=1) {
                lifeCount --;
                
                [userDefault setInteger:lifeCount forKey:@"buylife"];
                
                if (lifeCount<5)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"lifenotification" object:nil];
                }
            }
        }
        else{
            obj.strStatus=@"MATCH DRAW!";
            winningStatus=1;
        }
        NSInteger lossStat = arrTotalWinStat.count+1-arrWinStatCount.count;
        
        obj.lblPlayersStat=[NSString stringWithFormat:@"%lu - %ld",(unsigned long)arrWinStatCount.count,(long)lossStat];
        
        //  NSLog(@"Label score =-=-- %@",obj.lblPlayersStat);
        
        [self presentViewController:obj animated:NO completion:^{
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"answerresponse" object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startgame" object:nil];
             [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserLeft" object:nil];
            
        }];
        
        //  NSLog(@"Add images Final -=-== %@\n Game over images -=-== %@",arrScreenshotImages,obj.arrScreenShots);
        
        NSLog(@"User ID -==- %@ \n Second Pl Id --= %@ \n 1 Score -==- %@ \n 2 Score %@ \n Winning Status -=-= %@",[SingletonClass sharedSingleton].objectId,[SingletonClass sharedSingleton].secondPlayerObjid, arrPlayer1Scores, arrPlayer2Scores, [NSNumber numberWithInt:winningStatus]);
   
        PFObject *object = [PFObject objectWithClassName:@"GameResult"];
        object[@"UserId"]=[SingletonClass sharedSingleton].objectId;
        object[@"Opponent"]=[PFUser objectWithoutDataWithObjectId:[SingletonClass sharedSingleton].secondPlayerObjid];//(PFUser*)[SingletonClass sharedSingleton].secondPlayerObjid;
        object[@"userscore"]=arrPlayer1Scores;
        object[@"opponentscore"]=arrPlayer2Scores;
        object[@"CategoryId"]=[NSNumber numberWithInt:[[SingletonClass sharedSingleton].strSelectedCategoryId intValue]];
        object[@"CategoryName"]=[SingletonClass sharedSingleton].strSelectedSubCat;
        object[@"winnerstatus"]=[NSNumber numberWithInt:winningStatus];
        object[@"challengestatus"]=@YES;
        object[@"SubCategoryId"]=[SingletonClass sharedSingleton].selectedSubCat;
        UIImage *image1 = [arrScreenshotImages objectAtIndex:0];
        NSData *imageData1 = UIImageJPEGRepresentation(image1, 0.05f);
        
        UIImage *image2 = [arrScreenshotImages objectAtIndex:1];
        NSData *imageData2 = UIImageJPEGRepresentation(image2, 0.05f);
        
        UIImage *image3 = [arrScreenshotImages objectAtIndex:2];
        NSData *imageData3 = UIImageJPEGRepresentation(image3, 0.05f);
        
        UIImage *image4 = [arrScreenshotImages objectAtIndex:3];
        NSData *imageData4 = UIImageJPEGRepresentation(image4, 0.05f);
        
        UIImage *image5 = [arrScreenshotImages objectAtIndex:4];
        NSData *imageData5 = UIImageJPEGRepresentation(image5, 0.05f);
    
        UIImage *image6 = [arrScreenshotImages objectAtIndex:5];
        NSData *imageData6 = UIImageJPEGRepresentation(image6, 0.05f);
    
        UIImage *image7 = [arrScreenshotImages objectAtIndex:6];
        NSData *imageData7 = UIImageJPEGRepresentation(image7, 0.05f);
        PFFile *imageFile1 = [PFFile fileWithName:@"Screenshot1.jpg" data:imageData1];
        PFFile *imageFile2 = [PFFile fileWithName:@"Screenshot2.jpg" data:imageData2];
        PFFile *imageFile3 = [PFFile fileWithName:@"Screenshot3.jpg" data:imageData3];
        PFFile *imageFile4 = [PFFile fileWithName:@"Screenshot4.jpg" data:imageData4];
        PFFile *imageFile5 = [PFFile fileWithName:@"Screenshot5.jpg" data:imageData5];
        PFFile *imageFile6 = [PFFile fileWithName:@"Screenshot6.jpg" data:imageData6];
        PFFile *imageFile7 = [PFFile fileWithName:@"Screenshot7.jpg" data:imageData7];
        object[@"screenshot1"]=imageFile1;
        object[@"screenshot2"]=imageFile2;
        object[@"screenshot3"]=imageFile3;
        object[@"screenshot4"]=imageFile4;
        object[@"screenshot5"]=imageFile5;
        object[@"screenshot6"]=imageFile6;
        object[@"screenshot7"]=imageFile7;
        [object saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
            if (succeed) {
                NSLog(@"Save to Parse");
                
                BOOL checkInternet =  [ViewController networkCheck];
                
                if (checkInternet) {
                    
                    NSLog(@"Message send...");
                }
                else{
                    [[[UIAlertView alloc] initWithTitle:[ViewController languageSelectedStringForKey:@"Error"] message:[ViewController languageSelectedStringForKey:@"Check internet connection."] delegate:nil cancelButtonTitle:[ViewController languageSelectedStringForKey:@"OK"] otherButtonTitles: nil] show];
                }
            }
            if (error) {
                NSLog(@"Error to Save == %@",error.localizedDescription);
            }
        }
         ];
}


-(void)sendNotificationToPlayer :(NSString*)position AndPoints:(NSString*)points
{
if(![SingletonClass sharedSingleton].checkBotUser)
{
   // NSDictionary *dictValues = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"type",position,@"position",points,@"score", nil];
   
    //NSDictionary *dictValues = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"type",position,@"position",points,@"score", nil];
   // NSString *strAnswerDetails = [NSString stringWithFormat:@"%@",dictValues];
    //[[WarpClient getInstance]sendChat:strAnswerDetails];
    
    //NSError *error;
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictValues options:0 error:&error];
    
    /*NSString *jsonString = nil;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }*/
    NSNumber *positionsend=[NSNumber numberWithInt:[position intValue]];
    NSLog(@"Dict %@",positionsend);
    NSDictionary *dict = @{
                           @"position":positionsend,
                           @"score":points,
                           @"type":@"10"};
    NSError *error = nil;
    NSData *json;
    
    // Dictionary convertable to JSON ?
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        // Serialize the dictionary
        json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        
        // If no errors, let's view the JSON
        if (json != nil && error == nil)
        {
            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON: %@", jsonString);
             [[WarpClient getInstance]sendChat:jsonString];
        }
    }
    
   
    
}
}


#pragma mark==========================
#pragma mark Player First response
#pragma mark==========================

- (void) handleTapGestureA: (UIGestureRecognizer*) recognizer
{
    strFirstPlayerSelAns = lblOptionA.text;//[lblOptionA.text substringWithRange:NSMakeRange(3, [lblOptionA.text length])];
    [self soundInAnswer];
   NSLog(@"Label -==- %@/n Correct Answer -=-= %@",strFirstPlayerSelAns,strCorrectAns);
    
    if ([strFirstPlayerSelAns isEqualToString:strCorrectAns])
    {
        
         lblOptionA.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_left.png"]];
//        lblOptionA.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        [self animateProgressBar];
        checkAnswer=YES;
    }
    else{
        if (checkVibration)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        [self animateProgressBarWrongAnswer];
        lblOptionA.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_left.png"]];
        //lblOptionA.textColor=[UIColor redColor];
        checkAnswer=NO;
    }
  //  lblOptionA.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_left_player_bg.png"]];
    
    [self calculateTotalScore];
    NSString *strPoints = [NSString stringWithFormat:@"%d,%d",pointForQues,gamePointPlayer1];
    [self sendNotificationToPlayer:@"0" AndPoints:strPoints];
    self.view.userInteractionEnabled=NO;
    
    checkPlayer1Action = YES;
}
- (void) handleTapGestureB: (UIGestureRecognizer*) recognize
{
     [self soundInAnswer];
    strFirstPlayerSelAns =lblOptionB.text;// [lblOptionB.text substringWithRange:NSMakeRange(3, [lblOptionB.text length]-3)];
    NSLog(@"Label -==- %@/n Correct Answer -=-= %@",strFirstPlayerSelAns,strCorrectAns);
    
    if ([strFirstPlayerSelAns isEqualToString:strCorrectAns]) {
        
        lblOptionB.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_left.png"]];
        //lblOptionB.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        [self animateProgressBar];
        checkAnswer=YES;
    }
    else{
        if (checkVibration) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        [self animateProgressBarWrongAnswer];
        lblOptionB.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_left.png"]];
        //lblOptionB.textColor=[UIColor redColor];
        checkAnswer=NO;
    }
    //lblOptionB.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_left_player_bg.png"]];
    
    [self calculateTotalScore];
    NSString *strPoints = [NSString stringWithFormat:@"%d,%d",pointForQues,gamePointPlayer1];
    [self sendNotificationToPlayer:@"1" AndPoints:strPoints];
    self.view.userInteractionEnabled=NO;
    
    checkPlayer1Action = YES;
    
}
- (void) handleTapGestureC: (UIGestureRecognizer*) recognizer {
     [self soundInAnswer];
    strFirstPlayerSelAns =lblOptionC.text;// [lblOptionC.text substringWithRange:NSMakeRange(3, [lblOptionC.text length]-3)];
   NSLog(@"Label -==- %@/n Correct Answer -=-= %@",strFirstPlayerSelAns,strCorrectAns);
    
    if ([strFirstPlayerSelAns isEqualToString:strCorrectAns])
    {
        lblOptionC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_left.png"]];
       // lblOptionC.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        [self animateProgressBar];
        checkAnswer=YES;
    }
    else{
        if (checkVibration) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        [self animateProgressBarWrongAnswer];
        lblOptionC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_left.png"]];
        //lblOptionC.textColor=[UIColor redColor];
        checkAnswer=NO;
    }
    //lblOptionC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_left_player_bg.png"]];
    
    [self calculateTotalScore];
    NSString *strPoints = [NSString stringWithFormat:@"%d,%d",pointForQues,gamePointPlayer1];
    [self sendNotificationToPlayer:@"2" AndPoints:strPoints];
    self.view.userInteractionEnabled=NO;
    
    checkPlayer1Action = YES;
}
- (void) handleTapGestureD: (UIGestureRecognizer*) recognizer{
     [self soundInAnswer];
    strFirstPlayerSelAns =lblOptionD.text;// [lblOptionD.text substringWithRange:NSMakeRange(3, [lblOptionD.text length]-3)];
    NSLog(@"Label -==- %@/n Correct Answer -=-= %@",strFirstPlayerSelAns,strCorrectAns);
    
    if ([strFirstPlayerSelAns isEqualToString:strCorrectAns])
    {
        lblOptionD.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_left.png"]];
        //lblOptionD.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        [self animateProgressBar];
        checkAnswer=YES;
    }
    else
    {
        if (checkVibration)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        lblOptionD.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_left.png"]];
        [self animateProgressBarWrongAnswer];
       // lblOptionD.textColor=[UIColor redColor];
        checkAnswer=NO;
    }
    //lblOptionD.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_left_player_bg.png"]];
    
    [self calculateTotalScore];
    NSString *strPoints = [NSString stringWithFormat:@"%d,%d",pointForQues,gamePointPlayer1];
    [self sendNotificationToPlayer:@"3" AndPoints:strPoints];
    self.view.userInteractionEnabled=NO;
    
    checkPlayer1Action = YES;
}

-(void)calculateTotalScore {
    
    if (checkAnswer) {
        pointForQues = time+10;
        pointsForAnswerPlayer1 = gamePointPlayer1+time+10;
    }
    else{
        pointForQues = 0;
        pointsForAnswerPlayer1 = gamePointPlayer1;
    }
    if(questionNum==8)
    {
        pointForQues=pointForQues*2;
    }
    NSString *strpointForQues = [NSString stringWithFormat:@"%d",pointForQues];
    NSLog(@"strpointFor Ques %@",strpointForQues);
      if(!([arrPlayer1Scores count]>=questionNum))
    [arrPlayer1Scores addObject:strpointForQues];
    
    lblPointPlayer1.text=[NSString stringWithFormat:@"%d",pointsForAnswerPlayer1];
    gamePointPlayer1=pointsForAnswerPlayer1;
}

-(void)animateProgressBar
{
    
    
    [imageProgressBarPlayer1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"p_%d0.png",numOfCorrectAnswer]]];
    if(numOfCorrectAnswer==7)
    {
        [imageProgressBarPlayer1 setImage:[UIImage imageNamed:@"p_100"]];
    }
    numOfCorrectAnswer++;
   // NSLog(@"Image Nam e=--= %@",[NSString stringWithFormat:@"g_%d.png",questionNum-1]);
}
-(void)animateProgressBarWrongAnswer {
    
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"r_10.png"],
                             [UIImage imageNamed:@"r_20.png"],
                             [UIImage imageNamed:@"r_30.png"],
                             [UIImage imageNamed:@"r_40.png"],
                             [UIImage imageNamed:@"r_50.png"],
                             [UIImage imageNamed:@"r_60.png"],
                             [UIImage imageNamed:@"r_70.png"],
                             [UIImage imageNamed:@"r_80.png"],
                             [UIImage imageNamed:@"r_90.png"],
                             [UIImage imageNamed:@"r_100.png"],
                             nil];
    
    imageProgressBarPlayer1.animationImages=animationArray;
    imageProgressBarPlayer1.animationDuration=1;
    imageProgressBarPlayer1.animationRepeatCount=0;
    [imageProgressBarPlayer1 startAnimating];
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:1];
}

-(void)stopAnimation {
    
    [imageProgressBarPlayer1 stopAnimating];
   // [imageProgressBarPlayer1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"r_%d0.png",numOfWrongAnswer]]];
    numOfWrongAnswer++;
}
-(void)sendStartWithDelay
{
   [[WarpClient getInstance] sendChat:@"start"];
}
#pragma mark==========================
#pragma mark Player Second response
#pragma mark==========================

-(void)displaySecondPlayerResponse
{
    
    if (checkPlayer1Action)
    {
        
        checkPlayer2Action=YES;
        
        lblPointPlayer2.text=[NSString stringWithFormat:@"%d",gamePointPlayer2];
        
        if ([strSecPlayerSelAns isEqualToString:strCorrectAns])
        {
            if ([strSecPlayerSelAns isEqualToString:strFirstPlayerSelAns])
            {
                lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_bothM.png"]];
            }
            else
            {
                lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_rightM.png"]];
            }

            //lblSecPlayerOption.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        }
        else
        {
            if ([strSecPlayerSelAns isEqualToString:strFirstPlayerSelAns])
            {
                lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_bothN.png"]];
            }
            else
            {
                lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_rightN.png"]];
            }

            //lblSecPlayerOption.textColor=[UIColor redColor];
        }
        
        
        [timerForSecPlayerRes invalidate];
        timerForSecPlayerRes = nil;
        
        if (![strFirstPlayerSelAns isEqualToString:strCorrectAns] && ![strSecPlayerSelAns isEqualToString:strCorrectAns])
        {
            NSInteger correctAns = [arrOptions indexOfObject:strCorrectAns];
            UILabel *lblCorrectAns = (UILabel*)[self.view viewWithTag:correctAns+1];
            lblCorrectAns.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_no_arrowN.png"]];
            
            //[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        }
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenshotImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [arrScreenshotImages addObject:screenshotImage];
        //Timer invalidate By Sukhmeet
//        if ([timer isValid]) {
            [timer invalidate];
            timer=nil;
        //}

        
        NSLog(@"Add images For second player response-=-== %@",arrScreenshotImages);
        if([SingletonClass sharedSingleton].mainPlayer||[SingletonClass sharedSingleton].mainPlayerChallenge||[SingletonClass sharedSingleton].rematchMain)
        {
            NSLog(@"Start From Response of second player");
            if(!(time<=0))
 [self performSelector:@selector(sendStartWithDelay) withObject:nil afterDelay:1];        }
        //[self performSelector:@selector(nextQuesView) withObject:nil afterDelay:2];
    }
    else{
        if (time<2) {
            checkPlayer2Action=YES;
            
            lblPointPlayer2.text=[NSString stringWithFormat:@"%d",gamePointPlayer2];
            
            if ([strSecPlayerSelAns isEqualToString:strCorrectAns])
            {
                
                if ([strSecPlayerSelAns isEqualToString:strFirstPlayerSelAns])
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_bothM.png"]];
                }
                else
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_right.png"]];
                }
                

               // lblSecPlayerOption.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
            }
            else
            {
                
                if ([strSecPlayerSelAns isEqualToString:strFirstPlayerSelAns])
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_bothN.png"]];
                }
                else
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_right.png"]];
                }
                

                
                //lblSecPlayerOption.textColor=[UIColor redColor];
            }
          //  lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_rightN.png"]];
            [timerForSecPlayerRes invalidate];
            timerForSecPlayerRes = nil;
            
            if (![strFirstPlayerSelAns isEqualToString:strCorrectAns] && ![strSecPlayerSelAns isEqualToString:strCorrectAns]) {
                
                NSInteger correctAns = [arrOptions indexOfObject:strCorrectAns];
                UILabel *lblCorrectAns = (UILabel*)[self.view viewWithTag:correctAns+1];
                lblCorrectAns.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_no_arrowN.png"]];
                //lblCorrectAns.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
            }
            //        UIGraphicsBeginImageContext(self.view.bounds.size);
            //        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            //        UIImage *screenshotImage=UIGraphicsGetImageFromCurrentImageContext();
            //        UIGraphicsEndImageContext();
            //        [arrScreenshotImages addObject:screenshotImage];
            //        
            //        NSLog(@"Add images For second player response-=-== %@",arrScreenshotImages);
        }
    }
}

-(void)animateProgressbarForSecondPlayer
{
    
    if ([strSecPlayerSelAns isEqualToString:strCorrectAns])
    {
        [self animateProgressBarPlayer2];
    }
    else{
        [self animateProgressBarWrongAnswerPlayer2];
    }
}

-(void)animateProgressBarPlayer2 {
    
    [imageProgressBarPlayer2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"p_%d0.png",numOfCorrectAnswerPlayer2]]];
    numOfCorrectAnswerPlayer2++;
    NSLog(@"Image Nam e=--= %@",[NSString stringWithFormat:@"p_%d0.png",questionNum-1]);
}
-(void)animateProgressBarWrongAnswerPlayer2 {
    
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"r_10.png"],
                             [UIImage imageNamed:@"r_20.png"],
                             [UIImage imageNamed:@"r_30.png"],
                             [UIImage imageNamed:@"r_40.png"],
                             [UIImage imageNamed:@"r_50.png"],
                             [UIImage imageNamed:@"r_60.png"],
                             [UIImage imageNamed:@"r_70.png"],
                             [UIImage imageNamed:@"r_80.png"],
                             [UIImage imageNamed:@"r_90.png"],
                             [UIImage imageNamed:@"r_100.png"],
                             nil];
    
    imageProgressBarPlayer2.animationImages=animationArray;
    imageProgressBarPlayer2.animationDuration=1;
    imageProgressBarPlayer2.animationRepeatCount=0;
    [imageProgressBarPlayer2 startAnimating];
    [self performSelector:@selector(stopAnimationPlayer2) withObject:nil afterDelay:1];
}

-(void)checkAnswerForSecondPlayer:(NSNotification *) notification {
    //-------------------
    NSString* str = notification.object;
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error=nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];//response object is your response from server as NSData
    NSLog(@"%@",json);
   if ([json isKindOfClass:[NSDictionary class]]){ //Added instrospection as suggested in comment.
   
       
   }
   NSLog(@"dictionary %@",[json objectForKey:@"position"]);
    NSString *strScore ;//= [arrDetails objectAtIndex:2];
    //strScore = [strScore substringWithRange:NSMakeRange(14, [strScore length]-14)];
    strScore=[json objectForKey:@"score"];
    NSLog(@"Second Player Score -==-  %@",strScore);
    NSArray *arrScores = [strScore componentsSeparatedByString:@","];
    NSString *strPOints = [arrScores objectAtIndex:1];
    //strPOints = [strPOints substringToIndex:[strPOints length]-1];
    NSString *strAnswerPOint = [arrScores objectAtIndex:0];
    NSLog(@"Points in Game Play %@ %@",strPOints,strAnswerPOint);
    if(!(time<=0))
    [arrPlayer2Scores addObject:strAnswerPOint];
    
    gamePointPlayer2 = [strPOints intValue];
    NSLog(@"Second Player Points -==-  %d",gamePointPlayer2);
    
    //NSString *strSelectedOPtion = [[json objectForKey:@"position"] intValue];
   // strSelectedOPtion = [strSelectedOPtion substringWithRange:NSMakeRange(17, [strSelectedOPtion length]-17)];
    int selectedOption = [[json objectForKey:@"position"] intValue];
 //   NSLog(@"Second Player OPtion -==-  %d",selectedOption);
    
    lblSecPlayerOption = (UILabel*)[self.view viewWithTag:selectedOption+1];
    strSecPlayerSelAns = lblSecPlayerOption.text;//[lblSecPlayerOption.text substringWithRange:NSMakeRange(3, [lblSecPlayerOption.text length]-3)];
    
   // NSLog(@"Label -==- %@/n Correct Answer -=-= %@",strSecPlayerSelAns,strCorrectAns);
    
    [self animateProgressbarForSecondPlayer];
    if(!timerForSecPlayerRes)
    {
          timerForSecPlayerRes =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(displaySecondPlayerResponse) userInfo:nil repeats:YES];
    }
  
    [timerForSecPlayerRes fire];
}

-(void)stopAnimationPlayer2 {
    
    [imageProgressBarPlayer2 stopAnimating];
    //[imageProgressBarPlayer2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"r_%d0.png",numOfWrongAnswerPlayer2]]];
    numOfWrongAnswerPlayer2++;
}

#pragma mark==========================
#pragma mark Methods for Bot User
#pragma mark==========================

-(void)calculationsForBot
{

     int randomAns = arc4random()%3;
    
     strSecPlayerSelAns = [arrOptions objectAtIndex:randomAns];
    
     NSLog(@"Label For Bot -==- %@/n Correct Answer -=-= %@",strSecPlayerSelAns,strCorrectAns);
    
    lblSecPlayerOption = (UILabel*)[self.view viewWithTag:randomAns+1];
    
    if ([strSecPlayerSelAns isEqualToString:strCorrectAns])
    {
    
        [self animateProgressbarForSecondPlayer];
        numOfCorrectAnswerPlayer2++;
        
        pointForQuesPlayer2 = time+9;
        pointsForAnswerPlayer2 = gamePointPlayer2+time+9;
    }
    
    else
    {
        
        [self  animateProgressBarWrongAnswerPlayer2];
        numOfWrongAnswerPlayer2++;
        pointForQuesPlayer2 = 0;
        pointsForAnswerPlayer2 = gamePointPlayer2;
    }
    
    NSString *strpointForQues = [NSString stringWithFormat:@"%d",pointForQuesPlayer2];
    [arrPlayer2Scores addObject:strpointForQues];
    
    lblPointPlayer2.text=[NSString stringWithFormat:@"%d",pointsForAnswerPlayer2];
    gamePointPlayer2=pointsForAnswerPlayer2;
    
    timerForSecPlayerRes =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(displayBotPlayerResponse) userInfo:nil repeats:YES];
    [timerForSecPlayerRes fire];
}
-(void)displayBotPlayerResponse {
    
    if (checkPlayer1Action)
    {
        
        checkPlayer2Action=YES;
        
        lblPointPlayer2.text=[NSString stringWithFormat:@"%d",gamePointPlayer2];
        
            if ([strSecPlayerSelAns isEqualToString:strCorrectAns])
            {
                
                if ([strSecPlayerSelAns isEqualToString:strFirstPlayerSelAns])
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_bothM.png"]];
                }
                else
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_rightM.png"]];
                }
    // lblSecPlayerOption.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
            }
            else
            {
                if ([strSecPlayerSelAns isEqualToString:strFirstPlayerSelAns])
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_bothN.png"]];
                }
                else
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_rightN.png"]];
                }
              //lblSecPlayerOption.textColor=[UIColor redColor];
            }
            //lblSecPlayerOption.backgroundColor=[UIColor clearColor];
//            if ([strSecPlayerSelAns isEqualToString:strFirstPlayerSelAns])
//            {
//                lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_both_player_bg.png"]];
//            }
//            else
//            {
//            lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage  imageNamed:@"gameplay_right_player_bg.png"]];
//            }
            [timerForSecPlayerRes invalidate];
            timerForSecPlayerRes = nil;
        
            if (![strFirstPlayerSelAns isEqualToString:strCorrectAns] && ![strSecPlayerSelAns isEqualToString:strCorrectAns])
            {
            
            NSInteger correctAns = [arrOptions indexOfObject:strCorrectAns];
            UILabel *lblCorrectAns = (UILabel*)[self.view viewWithTag:correctAns+1];
                lblCorrectAns.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_no_arrowN.png"]];
           // lblCorrectAns.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
            }
            UIGraphicsBeginImageContext(self.view.bounds.size);
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *screenshotImage=UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [arrScreenshotImages addObject:screenshotImage];
            //Timer invalidate By Sukhmeet
            //if ([timer isValid])
            //{
            [timer invalidate];
            timer=nil;
            //}
            NSLog(@"Add images For second player response bot-=-== %@",arrScreenshotImages);
        if([timerForBombAnimation isValid])
        {
            [timerForBombAnimation invalidate];
            timerForBombAnimation=nil;
        }

            [self performSelector:@selector(roundSetting) withObject:nil afterDelay:2];
    }
    else
    {
        
        if (time<2)
        {
            
            checkPlayer2Action=YES;
            
            lblPointPlayer2.text=[NSString stringWithFormat:@"%d",gamePointPlayer2];
            NSLog(@"Label For Bot Final Color Change-==- %@/n Correct Answer -=-= %@",strSecPlayerSelAns,strCorrectAns);

            if ([strSecPlayerSelAns isEqualToString:strCorrectAns])
            {
                if ([strSecPlayerSelAns isEqualToString:strFirstPlayerSelAns])
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_bothM.png"]];
                }
                else
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_rightM.png"]];
                }

                //lblSecPlayerOption.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
            }
            else
            {
                if ([strSecPlayerSelAns isEqualToString:strFirstPlayerSelAns])
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_bothN.png"]];
                }
                else
                {
                    lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_rightN.png"]];
                }

                //lblSecPlayerOption.textColor=[UIColor redColor];
            }
             // lblSecPlayerOption.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_right_player_bg.png"]];
            [timerForSecPlayerRes invalidate];
            timerForSecPlayerRes = nil;
            
            if (![strFirstPlayerSelAns isEqualToString:strCorrectAns] && ![strSecPlayerSelAns isEqualToString:strCorrectAns])
            {
                
                NSInteger correctAns = [arrOptions indexOfObject:strCorrectAns];
                UILabel *lblCorrectAns = (UILabel*)[self.view viewWithTag:correctAns+1];
                lblCorrectAns.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_no_arrowN.png"]];
                //lblCorrectAns.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
            }
//            UIGraphicsBeginImageContext(self.view.bounds.size);
//            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage *screenshotImage=UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            [arrScreenshotImages addObject:screenshotImage];
//            
//            NSLog(@"Add images For second player response-=-== %@",arrScreenshotImages);
        }
    }
}
#pragma mark--
-(void)userLeftYouWin:(NSNotification *) notification
{
     rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 150)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 60)];
    lblReject.lineBreakMode=NSLineBreakByWordWrapping;
    lblReject.numberOfLines=0;
    lblReject.text=@"오 없음\n당신의 상대  항복 !\n이것은 당신이 승리를 의미한다!";
    [ViewController languageSelectedStringForKey:@"YOU WIN"];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UIButton * okButton=[UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame=CGRectMake(100,popUpImageview.frame.size.height-40,100, 30);
    //[okButton setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    okButton.layer.borderWidth=2;
     okButton.layer.borderColor=[UIColor blackColor].CGColor;
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton setTitle:[ViewController languageSelectedStringForKey:@"OK"] forState:UIControlStateNormal];
    okButton.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:okButton];
}
-(void)userConnectionBreak:(NSNotification *) notification
{
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 150)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 60)];
    lblReject.lineBreakMode=NSLineBreakByWordWrapping;
    lblReject.numberOfLines=0;
    lblReject.text=@"오 없음\n당신의 상대  항복 !\n이것은 당신이 승리를 의미한다!";
    [ViewController languageSelectedStringForKey:@"YOU WIN"];
    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
    UIButton * okButton=[UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame=CGRectMake(100,popUpImageview.frame.size.height-40,100, 30);
    //[okButton setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    okButton.layer.borderWidth=2;
    okButton.layer.borderColor=[UIColor blackColor].CGColor;
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton setTitle:[ViewController languageSelectedStringForKey:@"OK"] forState:UIControlStateNormal];
    okButton.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [okButton addTarget:self action:@selector(okButtonActionUserConnection) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:okButton];
}
-(void)okButtonActionUserConnection
{
    [rejectView removeFromSuperview];
    GameOverViewController *obj = [[GameOverViewController alloc] init];
    obj.delegate = self;
    obj.arrScreenShots=arrScreenshotImages;
    obj.arrScorePlayer1=arrPlayer1Scores;
    obj.arrScorePlayer2=arrPlayer2Scores;
    obj.strStatus=@"YOU LOSE!";
    obj.gameLeft=YES;
    NSLog(@"Arr Player 1 scores -==- %@ \n Arr Player 2 scores -==- %@",arrPlayer1Scores,arrPlayer2Scores);
    [self presentViewController:obj animated:NO completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"answerresponse" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startgame" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserLeft" object:nil];
        
    }];

}
-(void)okButtonAction
{
    
    GameOverViewController *obj = [[GameOverViewController alloc] init];
    obj.delegate = self;
    obj.arrScreenShots=arrScreenshotImages;
    obj.arrScorePlayer1=arrPlayer1Scores;
    obj.arrScorePlayer2=arrPlayer2Scores;
    obj.strStatus=@"YOU WIN!";
    NSLog(@"Arr Player 1 scores -==- %@ \n Arr Player 2 scores -==- %@",arrPlayer1Scores,arrPlayer2Scores);
    [self presentViewController:obj animated:NO completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"answerresponse" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startgame" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserLeft" object:nil];
        
    }];

    
}

-(void)connectAppWrap
{
    int connectionStatus = [WarpClient getInstance].getConnectionState;
    if (connectionStatus != 0)
    {
        [[WarpClient getInstance]connectWithUserName:[SingletonClass sharedSingleton].objectId];
    }
 
}
#pragma mark Sound
-(void)soundInAnswer
{
    NSString *pewPewPath = [[NSBundle mainBundle]
                            pathForResource:@"Fiverr - In-Game Music - Stab 2 -  For Andy - James Warburton Music" ofType:@"wav"];
    NSLog(@"sound file path %@",pewPewPath);
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL,&(_pewPewSound));
    AudioServicesPlaySystemSound(_pewPewSound);
}

#pragma mark-----
#pragma mark alert view delegates
-(void)rejectUiFromUser
{
    
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 150)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 50)];
    lblReject.text=@"항복\n항복하시겠습니까 ?";
    lblReject.lineBreakMode = NSLineBreakByWordWrapping;
    lblReject.numberOfLines = 0;

    lblReject.textAlignment=NSTextAlignmentCenter;
    lblReject.textColor=[UIColor blackColor];
    [popUpImageview addSubview:lblReject];
       // imgView.image=[UIImage imageNamed:catImage];
   // [popUpImageview addSubview:imgView];
    UIButton * acceptBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptBtn.frame=CGRectMake(15,popUpImageview.frame.size.height-40,120, 30);
    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [acceptBtn setTitle:@"Accept" forState:UIControlStateNormal];
    acceptBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [acceptBtn addTarget:self action:@selector(acceptButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:acceptBtn];
    UIButton * rejectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rejectBtn.frame=CGRectMake(popUpImageview.frame.size.width/2+15,popUpImageview.frame.size.height-40,120,30);
    [rejectBtn setBackgroundImage:[UIImage imageNamed:@"reject_btn.png"] forState:UIControlStateNormal];
    [rejectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rejectBtn setTitle:@"Reject" forState:UIControlStateNormal];
    rejectBtn.titleEdgeInsets=UIEdgeInsetsMake(0.0, 0.0, 0.0, 20.0);
    [rejectBtn addTarget:self action:@selector(rejectButton:) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:rejectBtn];
    
}
-(void)serverErrorTimer
{
    
    rejectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:rejectView];
    rejectView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
    UIImageView *popUpImageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height/2-20, self.view.frame.size.width-20, 150)];
    popUpImageview.image=[UIImage imageNamed:@"small_popup.png"];
    popUpImageview.userInteractionEnabled=YES;
    [rejectView addSubview:popUpImageview];
    UILabel * lblReject=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, popUpImageview.frame.size.width, 50)];
    lblReject.text=@"항복\n항복하시겠습니까 ?";
    lblReject.lineBreakMode = NSLineBreakByWordWrapping;
    lblReject.numberOfLines = 0;
    
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
    [okButton addTarget:self action:@selector(serverErrorOkButton) forControlEvents:UIControlEventTouchUpInside];
    [popUpImageview addSubview:okButton];
    
}
-(void)serverErrorOkButton
{
//    CustomMenuViewController *obj = [LogInViewController goTOHomeView];
//    [self presentViewController:obj animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[WarpClient getInstance] leaveRoom:[SingletonClass sharedSingleton].objectId];
    [[WarpClient getInstance] disconnect];
    [self performSelector:@selector(connectAppWrap) withObject:self afterDelay:4];
}
-(void)acceptButton:(id)sender
{
    [rejectView removeFromSuperview];
    [[WarpClient getInstance]leaveRoom:[SingletonClass sharedSingleton].roomId];
    GameOverViewController *obj = [[GameOverViewController alloc] init];
    obj.delegate = self;
    obj.arrScreenShots=arrScreenshotImages;
    obj.arrScorePlayer1=arrPlayer1Scores;
    obj.arrScorePlayer2=arrPlayer2Scores;
    obj.strStatus=@"YOU LOSE!";
    obj.gameLeft=YES;
    NSLog(@"Arr Player 1 scores -==- %@ \n Arr Player 2 scores -==- %@",arrPlayer1Scores,arrPlayer2Scores);
    [self presentViewController:obj animated:NO completion:^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"answerresponse" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startgame" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserLeft" object:nil];
        
    }];


    
}

-(void)rejectButton:(id)sender
{
  [rejectView removeFromSuperview];
    
}
#pragma mark---
-(void)changeBombImage
{
    batterImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"aaa%d",bombImageNumber]];
    NSLog(@"Bomb image %d",bombImageNumber);
    if(bombImageNumber<0)
    {
        if([timerForBombAnimation isValid])
        {
            [timerForBombAnimation invalidate];
            timerForBombAnimation=nil;
        }

    }
    bombImageNumber--;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
