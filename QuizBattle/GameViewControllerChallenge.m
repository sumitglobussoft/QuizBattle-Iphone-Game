//
//  GameViewControllerChallenge.m
//  QuizBattle
//
//  Created by GBS-mac on 10/1/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import "GameViewControllerChallenge.h"
#import "SingletonClass.h"
#import <Parse/Parse.h>
#import <AppWarp_iOS_SDK/AppWarp_iOS_SDK.h>
#import "GameOverViewControllerChallenge.h"
#import "ViewController.h"
#import "SaveGameOverData.h"

@interface GameViewControllerChallenge ()

@end

@implementation GameViewControllerChallenge

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
-(void)viewDidDisappear:(BOOL)animated
{
    
    if ([timer isValid])
    {
        [timer invalidate];
        timer=nil;
    }
    if([timerForBombAnimation isValid])
    {
        [timerForBombAnimation invalidate];
        timerForBombAnimation=nil;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    mutArrAnswers = [[NSMutableArray alloc]init];
    answersPlayer2 = [[NSMutableArray alloc]init];
    totalScoreForPlayer2 = [[NSMutableArray alloc]init];
    scoresPlayer2 = [[NSMutableArray alloc]init];
    
    imageVAnim = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-40, 30, 50)];
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
    
    [NSThread detachNewThreadSelector:@selector(fetchQuestions) toTarget:self withObject:nil];
    
    checkAnswer=NO;
    dictQuestions=[[NSMutableDictionary alloc]init];
    arrQues =[[NSArray alloc] init];
    arrScreenshotImages =[[NSMutableArray alloc] init];
    arrPlayer1Scores =[[NSMutableArray alloc] init];
    
//    [self performSelector:@selector(roundSetting) withObject:nil afterDelay:9];
    
     [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)185/255 green:(CGFloat)231/255 blue:(CGFloat)246/255 alpha:1]];
    
    time=11;
    bombImageNumber=40;
    questionNum=1;
    gamePointPlayer1=0;
    numOfCorrectAnswer=1;
    numOfWrongAnswer=1;
    numOfCorrectAnswerPlayer2=1;
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
    
    UILabel * gradeLblPlayerName2=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 95, 60, 10)];
    gradeLblPlayerName2.textAlignment=NSTextAlignmentCenter;
    gradeLblPlayerName2.text=[SingletonClass sharedSingleton].strSecPlayerRank;
    gradeLblPlayerName2.numberOfLines=3;
    gradeLblPlayerName2.lineBreakMode=NSLineBreakByCharWrapping;
    gradeLblPlayerName2.textColor=[UIColor blackColor];
    [gradeLblPlayerName2 setFont:[UIFont fontWithName:@"NanumBarunGothicBold" size:10]];
    [self.view addSubview:lblPlayer1];

    lblPlayer2.text=[NSString stringWithFormat:@"싱글게임"];
    NSLog(@"STRING player second -=-= %@",[SingletonClass sharedSingleton].strSecPlayerName);
}
-(void)fetchQuestions {
    
    NSLog(@"Player details =-= %@",self.arrPlayerDetail);
    
    if ([SingletonClass sharedSingleton].singleGameChallengedPlayer) {
       
        NSString *strQues =[self.arrPlayerDetail objectForKey:@"questionsChall"];
        
        arrQues = [strQues componentsSeparatedByString:@","];

       // answersPlayer2=[self.arrPlayerDetail objectForKey:@"player1ans"];
       // scoresPlayer2=[self.arrPlayerDetail objectForKey:@"scores"];
    }
    else{

         NSString *strQues =[SingletonClass sharedSingleton].strQuestionsId;
        NSLog(@"Question Id %@",strQues);
        arrQues = [strQues componentsSeparatedByString:@","];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Questions"];
    [query whereKey:@"objectId" containedIn:arrQues];
     NSArray *arrDetails = [query findObjects];
    self.questionsData=[NSArray arrayWithArray:arrDetails];
//    for (int i=0; i<[arrDetails count]; i++)
//    {
//        
//       // [query whereKey:@"objectId" equalTo:[arrQues objectAtIndex:i]];
//       
//        PFObject * obj=[arrDetails objectAtIndex:i];
//        [dictQuestions setObject:obj forKey:[NSString stringWithFormat:@"%d",i]];
//    }
   // NSLog(@"Dict details =--= %@",dictQuestions);
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        [self gameUI];
    });
}

#pragma mark==========================
#pragma mark Game Play Methods
#pragma mark==========================

-(void)roundSetting
{
    
        [imageVAnim stopAnimating];
    if(questionNum==7)
    {
        NSString * round=[ViewController languageSelectedStringForKey:@"Last Round"];
        lblRound.text=[NSString stringWithFormat:@"%@ %d",round,questionNum];
        lblRound.font=[UIFont boldSystemFontOfSize:20];
        lblRound.layer.opacity=1;
        
    }
    else
    {
        NSString * round=[ViewController languageSelectedStringForKey:@"Round"];
        lblRound.text=[NSString stringWithFormat:@"%@ %d",round,questionNum];
        lblRound.layer.opacity=1;
    }
    [UIView animateWithDuration:3.5 delay:1 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void){
        lblRound.layer.opacity=0.0;
        
    } completion:nil];
    
    [self performSelector:@selector(displayGame) withObject:nil afterDelay:1.0];
}
-(void)displayGame {
    
    self.view.userInteractionEnabled=YES;
    
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
    
    self.lblQues.hidden=NO;
    batterImageView.hidden=NO;
    
    [lblOptionA setFont:[UIFont fontWithName:@"NanumBarunGothicBold" size:15]];
    [lblOptionB setFont:[UIFont fontWithName:@"NanumBarunGothicBold" size:15]];
    [lblOptionC setFont:[UIFont fontWithName:@"NanumBarunGothicBold" size:15]];
    [lblOptionD setFont:[UIFont fontWithName:@"NanumBarunGothicBold" size:15]];
    
    NSArray *strQues;
    NSDictionary *dict = [self.questionsData objectAtIndex:questionNum-1];
        NSArray *keys = [dict allKeys];
        
        if ([keys containsObject:@"Picture"]) {
            
            PFFile  *strImage = [dict objectForKey:@"Picture"];
            NSData *imageData = [strImage getData];
            quesImage.image = [UIImage imageWithData:imageData];
        }
    else
    {
        quesImage.hidden=YES;
    }
        
        arrOptions = [dict objectForKey:@"Option"];
        strCorrectAns = [dict objectForKey:@"CorrectAnswer"];
        strQues = [dict objectForKey:@"Question"];
      self.lblQues.text=[NSString stringWithFormat:@"%@",strQues];
    
    lblOptionA.text=[NSString stringWithFormat:@"%@",[arrOptions objectAtIndex:0]];
    lblOptionB.text=[NSString stringWithFormat:@"%@",[arrOptions objectAtIndex:1]];
    lblOptionC.text=[NSString stringWithFormat:@"%@",[arrOptions objectAtIndex:2]];
    lblOptionD.text=[NSString stringWithFormat:@"%@",[arrOptions objectAtIndex:3]];
    if(!timer)
    {
       timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [timer fire];
    }

        questionNum++;
}

-(void)gameUI{
    
    if ([UIScreen mainScreen].bounds.size.height>500) {
        
        lblRound = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 130)];
        batterImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-35, 30,70, 72)];
        //lblTimer = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-60, 30, 90, 50)];
        self.lblQues = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, self.view.frame.size.width-100, 80)];
        quesImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 120, self.view.frame.size.width-160, 90)];
        lblOptionA = [[UILabel alloc] initWithFrame:CGRectMake(40, 250, self.view.frame.size.width-80, 40)];
        lblOptionB = [[UILabel alloc] initWithFrame:CGRectMake(40, 300, self.view.frame.size.width-80, 40)];
        lblOptionC = [[UILabel alloc] initWithFrame:CGRectMake(40, 350, self.view.frame.size.width-80, 40)];
        lblOptionD = [[UILabel alloc] initWithFrame:CGRectMake(40, 400, self.view.frame.size.width-80, 40)];        lblPointPlayer1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 50, 30)];
        lblPointPlayer2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 110, 50, 30)];
        imageProgressBarPlayer1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 180, 20, 350)];
        imageProgressBarPlayer2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30, 180, 20, 350)];
    }
    else{
        
        lblRound = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 320, 130)];
       batterImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-35, 30,70, 72)];
        self.lblQues = [[UILabel alloc] initWithFrame:CGRectMake(50, 160, self.view.frame.size.width-100, 80)];
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
    lblRound.font=[UIFont boldSystemFontOfSize:50];
    [self.view addSubview:lblRound];
    [self.view addSubview:batterImageView];
    
    self.lblQues.textAlignment=NSTextAlignmentCenter;
    self.lblQues.textColor=[UIColor blackColor];
    self.lblQues.numberOfLines=5;
    self.lblQues.lineBreakMode = NSLineBreakByWordWrapping;
    [self.lblQues setFont:[UIFont fontWithName:@"NanumBarunGothicBold" size:15]];
    [self.view addSubview:self.lblQues];
    
    [self.view addSubview:quesImage];
    
    NSLog(@"Array Questions =-=- %@",self.arrPlayerDetail);
    
    lblOptionA.textAlignment=NSTextAlignmentCenter;
    lblOptionA.textColor=[UIColor blackColor];
    lblOptionA.numberOfLines=3;
    lblOptionA.lineBreakMode = NSLineBreakByWordWrapping;
    lblOptionA.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_list view_bg.png"]];
    lblOptionA.font=[UIFont systemFontOfSize:15];
    lblOptionA.userInteractionEnabled=YES;
    lblOptionA.tag=1;
    [self.view addSubview:lblOptionA];
    
    UIGestureRecognizer *tapGestureA = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureA:)];
    [lblOptionA addGestureRecognizer: tapGestureA];
    lblOptionB.textAlignment=NSTextAlignmentCenter;
    lblOptionB.textColor=[UIColor blackColor];
    lblOptionB.numberOfLines=3;
    lblOptionB.font=[UIFont systemFontOfSize:15];
    lblOptionB.userInteractionEnabled=YES;
    lblOptionB.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_list view_bg.png"]];
    lblOptionB.lineBreakMode = NSLineBreakByWordWrapping;
    lblOptionB.tag=2;
    [self.view addSubview:lblOptionB];
    
    UITapGestureRecognizer *tapGestureB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureB:)];
    [lblOptionB addGestureRecognizer:tapGestureB];
    
    lblOptionC.textAlignment=NSTextAlignmentCenter;
    lblOptionC.textColor=[UIColor blackColor];
    lblOptionC.numberOfLines=3;
    lblOptionC.lineBreakMode = NSLineBreakByWordWrapping;
    lblOptionC.userInteractionEnabled=YES;
    lblOptionC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_list view_bg.png"]];
    lblOptionC.font=[UIFont systemFontOfSize:15];
    lblOptionC.tag=3;
    [self.view addSubview:lblOptionC];
    
    UITapGestureRecognizer *tapGestureC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureC:)];
    [lblOptionC addGestureRecognizer:tapGestureC];
    
    lblOptionD.textAlignment=NSTextAlignmentCenter;
    lblOptionD.textColor=[UIColor blackColor];
    lblOptionD.numberOfLines=4;
    lblOptionD.font=[UIFont systemFontOfSize:15];
    lblOptionD.userInteractionEnabled=YES;
    lblOptionD.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_list view_bg.png"]];
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
    if ([SingletonClass sharedSingleton].singleGameChallengedPlayer) {
       
        lblPointPlayer2.text=@"?";
       // arrPlayer1Scores=[self.arrPlayerDetail objectForKey:@"player1ans"];
    }
    else{
        lblPointPlayer2.text=@"?";
    }
    
    [self.view addSubview:lblPointPlayer2];
    
    [imageProgressBarPlayer1 setImage:[UIImage imageNamed:@"blank.png"]];
    [self.view addSubview:imageProgressBarPlayer1];
    
    [imageProgressBarPlayer2 setImage:[UIImage imageNamed:@"blank.png"]];
    [self.view addSubview:imageProgressBarPlayer2];
    
//    [self performSelector:@selector(roundSetting) withObject:nil afterDelay:9];
    [self roundSetting];
}

-(void)nextQuesView
{
    
    if ([timer isValid]) {
        [timer invalidate];
        timer=nil;
    }
    
    time=11;
    bombImageNumber=40;

    lblOptionA.hidden=YES;
    lblOptionB.hidden=YES;
    lblOptionC.hidden=YES;
    lblOptionD.hidden=YES;
    self.lblQues.hidden=YES;
    batterImageView.hidden=YES;
    //lblTimer.hidden=YES;
    
    if (questionNum<8) {
        NSLog(@"Question No--- %d",questionNum);
        [self roundSetting];
    }
    else{
        [SingletonClass sharedSingleton].checkBotUser=NO;
        
        GameOverViewControllerChallenge *obj = [[GameOverViewControllerChallenge alloc] init];
        obj.arrScreenShots=arrScreenshotImages;
        obj.arrScorePlayer1=arrPlayer1Scores;
        obj.arrScorePlayer2=scoresPlayer2;
        
        NSLog(@"Arr Player 1 scores -==- %@",arrPlayer1Scores);
//       [self addChildViewController:obj];
//        [obj didMoveToParentViewController:self];
        //[self.view addSubview:obj.view];
       [self presentViewController:obj animated:YES completion:nil];
        
        NSLog(@"Add images Final -=-== %@\n Game over images -=-== %@",arrScreenshotImages,obj.arrScreenShots);
        
        
        NSLog(@"Add images Final -=-== %@\n Game over images -=-== %@",arrScreenshotImages,obj.arrScreenShots);
        
        NSLog(@"User ID -==- %@ \n Second Pl Id --= %@ \n 1 Score -==- %@",[SingletonClass sharedSingleton].objectId,[SingletonClass sharedSingleton].secondPlayerObjid, arrPlayer1Scores);
        
        NSLog(@"First players ANswers -==- %@",mutArrAnswers);
        
        //---------
        SaveGameOverData * saveData=[[SaveGameOverData alloc]init];
        saveData.arrPlayer1Scores=arrPlayer1Scores;
        saveData.arrScreenshotImages=arrScreenshotImages;
        saveData.opponenetScore=self.opponenetScore;
        saveData.challengeReqObjId=self.challengeReqObjId;
        saveData.gameResultObjectId=self.gameResultObjectId;
        [saveData gameOverDataSaved];
        //------------
        
        
        
    }
    
}
#pragma mark Update the Game Result
-(void)updateGameResult
{
    dispatch_async(GCDBackgroundThread, ^{
        @autoreleasepool {
            PFQuery * updateOpponentGameResult=[PFQuery queryWithClassName:@"GameResult"];
            if(self.challengeReqObjId)
            {
                [updateOpponentGameResult whereKey:@"objectId" equalTo:self.challengeReqObjId];
            }
            else
            {
                if([SingletonClass sharedSingleton].challengeRequestObjId)
                {
                [updateOpponentGameResult whereKey:@"objectId" equalTo:[SingletonClass sharedSingleton].challengeRequestObjId];
                }
            }
            NSArray * temp=[updateOpponentGameResult findObjects];
            if([temp count]>0)
            {
                PFObject *updateObj=[temp objectAtIndex:0];
                updateObj[@"opponentscore"]=arrPlayer1Scores;
                [updateObj saveInBackground];
            }
            
        }
        [self callCloudChallenge];
    });

}
-(void)updateGameResultMainPlayer
{
    
}
-(void)callCloudChallenge
{
    [PFCloud callFunctionInBackground:@"update"
                       withParameters:@{@"objectid1": [SingletonClass sharedSingleton].objectId,@"objectid2":[SingletonClass sharedSingleton].secondPlayerObjid}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Response Result -==- %@", result);
                                        NSLog(@"Connect to cloud");
                                    }
                                    else
                                    {
                                        NSLog(@"Error in calling CloudCode %@",error);
                                    }
                                }];

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
   // lblTimer.text=[NSString stringWithFormat:@"%d",time];
    if (time==0) {
        if ([timer isValid]) {
            [timer invalidate];
            timer=nil;
        }
            [arrPlayer1Scores addObject:@"0"];
            [self animateProgressBarWrongAnswer];
        
        /*if ([SingletonClass sharedSingleton].checkChallengedPlayer) {
            
            strSecPlayerSelAns = [answersPlayer2 objectAtIndex:questionNum-1];
            UILabel *lblSecPlayerAns = (UILabel*)[self.view viewWithTag:questionNum];
            
            if ([strSecPlayerSelAns isEqualToString:strCorrectAns]) {
                
                lblSecPlayerAns.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
            }
            else{
                lblSecPlayerAns.textColor = [UIColor redColor];
            }
               lblSecPlayerAns.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_right_player_bg.png"]];
            [self displayScoreForSecondPlayer];
        }*/
        
        NSInteger correctAns = [arrOptions indexOfObject:strCorrectAns];
        UILabel *lblCorrectAns = (UILabel*)[self.view viewWithTag:correctAns+1];
        lblCorrectAns.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_no_arrowN.png"]];
        //lblCorrectAns.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        
        [mutArrAnswers addObject:@"not answered"];
        
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenshotImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [arrScreenshotImages addObject:screenshotImage];
        
        NSLog(@"Add images For second player response in timer-=-== %@",arrScreenshotImages);
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        [self performSelector:@selector(nextQuesView) withObject:nil afterDelay:2];
    }
}
-(void)displayCorrectAnswer {
    
    [mutArrAnswers addObject:strFirstPlayerSelAns];
    
    if (![strFirstPlayerSelAns isEqualToString:strCorrectAns])
    {
   
    NSInteger correctAns = [arrOptions indexOfObject:strCorrectAns];
    UILabel *lblCorrectAns = (UILabel*)[self.view viewWithTag:correctAns+1];
    lblCorrectAns.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_no_arrowN.png"]];
        //lblCorrectAns.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
    }
    
    /*if ([SingletonClass sharedSingleton].checkChallengedPlayer) {
        
        strSecPlayerSelAns = [answersPlayer2 objectAtIndex:questionNum-1];
        UILabel *lblSecPlayerAns = (UILabel*)[self.view viewWithTag:questionNum];
        
        if ([strSecPlayerSelAns isEqualToString:strCorrectAns]) {
            
            lblSecPlayerAns.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        }
        else{
            lblSecPlayerAns.textColor = [UIColor redColor];
        }
        lblSecPlayerAns.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_right_player_bg.png"]];
        [self displayScoreForSecondPlayer];
    }*/
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshotImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [arrScreenshotImages addObject:screenshotImage];
    
    NSLog(@"Add images For second player response in timer-=-== %@",arrScreenshotImages);
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    [self performSelector:@selector(nextQuesView) withObject:nil afterDelay:2];
}
#pragma mark==========================
#pragma mark Player First response
#pragma mark==========================

- (void) handleTapGestureA: (UIGestureRecognizer*) recognizer {
    
    strFirstPlayerSelAns =lblOptionA.text;
    
    NSLog(@"Label -==- %@/n Correct Answer -=-= %@",strFirstPlayerSelAns,strCorrectAns);
    
    if ([strFirstPlayerSelAns isEqualToString:strCorrectAns]) {
        
        //lblOptionA.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        lblOptionA.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_left.png"]];
        [self animateProgressBar];
        checkAnswer=YES;
    }
    else{
        [self animateProgressBarWrongAnswer];
         lblOptionA.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_left.png"]];
       // lblOptionA.textColor=[UIColor redColor];
        checkAnswer=NO;
    }
  //  lblOptionA.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_left_player_bg.png"]];
    
    [self calculateTotalScore];
    [self displayCorrectAnswer];
    self.view.userInteractionEnabled=NO;
}
- (void) handleTapGestureB: (UIGestureRecognizer*) recognize
{
    strFirstPlayerSelAns =lblOptionB.text;
    NSLog(@"Label -==- %@/n Correct Answer -=-= %@",strFirstPlayerSelAns,strCorrectAns);
    
    if ([strFirstPlayerSelAns isEqualToString:strCorrectAns]) {
         lblOptionB.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_left.png"]];
       // lblOptionB.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        [self animateProgressBar];
        checkAnswer=YES;
    }
    else{
        [self animateProgressBarWrongAnswer];
         lblOptionB.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_left.png"]];
        //lblOptionB.textColor=[UIColor redColor];
        checkAnswer=NO;
    }
   // lblOptionB.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_left_player_bg.png"]];
    [self calculateTotalScore];
    [self displayCorrectAnswer];
    self.view.userInteractionEnabled=NO;
}
- (void) handleTapGestureC: (UIGestureRecognizer*) recognizer
{
    
    strFirstPlayerSelAns =lblOptionC.text;
    NSLog(@"Label -==- %@/n Correct Answer -=-= %@",strFirstPlayerSelAns,strCorrectAns);
    
    if ([strFirstPlayerSelAns isEqualToString:strCorrectAns]) {
         lblOptionC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_left.png"]];
       //lblOptionC.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        [self animateProgressBar];
        checkAnswer=YES;
    }
    else{
        [self animateProgressBarWrongAnswer];
         lblOptionC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_left.png"]];
        //lblOptionC.textColor=[UIColor redColor];
        checkAnswer=NO;
    }
   // lblOptionC.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_left_player_bg.png"]];
    [self calculateTotalScore];
    [self displayCorrectAnswer];
    self.view.userInteractionEnabled=NO;
}
- (void) handleTapGestureD: (UIGestureRecognizer*) recognizer{
    
    strFirstPlayerSelAns =lblOptionD.text;
    NSLog(@"Label -==- %@/n Correct Answer -=-= %@",strFirstPlayerSelAns,strCorrectAns);
    
    if ([strFirstPlayerSelAns isEqualToString:strCorrectAns])
    {
         lblOptionD.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_left.png"]];
        //lblOptionD.textColor=[UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)204/255 blue:(CGFloat)0/255 alpha:1];
        [self animateProgressBar];
        checkAnswer=YES;
    }
    else{
        [self animateProgressBarWrongAnswer];
         lblOptionD.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_left.png"]];
       // lblOptionD.textColor=[UIColor redColor];
        checkAnswer=NO;
    }
    //lblOptionD.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gameplay_left_player_bg.png"]];
    [self calculateTotalScore];
    [self displayCorrectAnswer];
    self.view.userInteractionEnabled=NO;
}

-(void)calculateTotalScore {
    
    if ([timer isValid]) {
        [timer invalidate];
        timer=nil;
    }
    
    if (checkAnswer) {
        pointForQues = time+10;
        pointsForAnswerPlayer1 = gamePointPlayer1+time+10;
    }
    else{
        pointForQues = 0;
        pointsForAnswerPlayer1 = gamePointPlayer1;
    }
    
    NSString *strpointForQues = [NSString stringWithFormat:@"%d",pointForQues];
    [arrPlayer1Scores addObject:strpointForQues];
    
    lblPointPlayer1.text=[NSString stringWithFormat:@"%d",pointsForAnswerPlayer1];
    gamePointPlayer1=pointsForAnswerPlayer1;
}

-(void)animateProgressBar {
    
    [imageProgressBarPlayer1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"p_%d0.png",numOfCorrectAnswer]]];
    numOfCorrectAnswer++;
    NSLog(@"Image Nam e=--= %@",[NSString stringWithFormat:@"p_%d.png",questionNum-1]);
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
    [imageProgressBarPlayer1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"r_%d0.png",numOfWrongAnswer]]];
    numOfWrongAnswer++;
}

#pragma mark==========================
#pragma mark Player Second response
#pragma mark==========================
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

/*
-(void) displayScoreForSecondPlayer {
    
    NSString *strValue;
    if (questionNum-1==0) {
        strValue = [scoresPlayer2 objectAtIndex:questionNum-1];
    }
    else{
        
        NSString *strValue1 = [scoresPlayer2 objectAtIndex:questionNum-1];
        NSString *strValue2 = [totalScoreForPlayer2 lastObject];
        int value1 = [strValue1 intValue];
        int value2 = [strValue2 intValue];
        
        int totalValue = value1+value2;
        
        strValue = [NSString stringWithFormat:@"%d",totalValue];
    }
    [totalScoreForPlayer2 addObject:strValue];
    lblPointPlayer2.text = [NSString stringWithFormat:@"%@",strValue];
}

-(void)animateProgressBarPlayer2 {
    
    [imageProgressBarPlayer2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"g_%d0.png",numOfCorrectAnswerPlayer2]]];
    numOfCorrectAnswerPlayer2++;
    NSLog(@"Image Nam e=--= %@",[NSString stringWithFormat:@"g_%d0.png",questionNum-1]);
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
-(void)stopAnimationPlayer2 {
    
    [imageProgressBarPlayer2 stopAnimating];
    [imageProgressBarPlayer2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"r_%d0.png",numOfWrongAnswerPlayer2]]];
    numOfWrongAnswerPlayer2++;
}*/
-(void)dealloc
{
    self.view=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
