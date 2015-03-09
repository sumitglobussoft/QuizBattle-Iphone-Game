//
//  GameViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/21/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController {
    
    UILabel *lblOptionA;
    UILabel *lblOptionB;
    UILabel *lblOptionC;
    UILabel *lblOptionD;
    UILabel *lblTimer;
    
    UILabel *lblPointPlayer1;
    UILabel *lblPointPlayer2;
    int gamePointPlayer1;
    int gamePointPlayer2;

    UILabel *lblRound;
    
    int time;
    int questionNum;
    int numOfCorrectAnswer;
    int numOfCorrectAnswerPlayer2;
    int numOfWrongAnswer;
    int numOfWrongAnswerPlayer2;
    
    int pointsForAnswerPlayer1;
    int pointsForAnswerPlayer2;
    
    NSTimer *timer,*timerForBombAnimation;
    NSString *strCorrectAns;
    NSMutableArray *arrOp;
    NSMutableArray *arrSubCatId;
    NSArray *arrQues;
    NSMutableArray *arrCorrAns;
    
    UIImageView *imageProgressBarPlayer1;
    UIImageView *imageProgressBarPlayer2;

    UIImageView *quesImage;
    
    BOOL checkPlayer1Action;
    BOOL checkPlayer2Action;
    NSTimer *timerForSecPlayerRes,*timerCheckConnection;
    NSString *strSecPlayerSelAns;
    UILabel *lblSecPlayerOption;
    
    NSString *strFirstPlayerSelAns;
    NSArray *arrOptions;
    NSMutableArray *arrScreenshotImages;
    NSMutableArray *arrPlayer1Scores;
    NSMutableArray *arrPlayer2Scores;
    
    BOOL checkAnswer;
    NSDictionary *dictDetailsPlayer1;
    NSDictionary *dictDetailsPlayer2;
    UIImageView * batterImageView;
    int pointForQues;
    int pointForQuesPlayer2;
    int checkConnection;
    int bombImageNumber;
    NSMutableArray *arrWinStatCount;
    NSArray *arrTotalWinStat;
    NSUserDefaults *userDefault;
    BOOL checkVibration;
    UIView * rejectView;
}

@property (nonatomic, retain)UILabel *lblQues;
@property (nonatomic, strong) NSDictionary *arrPlayerDetail;
@property (assign) SystemSoundID pewPewSound;

//==================================================
@property (nonatomic, strong) NSArray *gameQuestionsArray;
@property (nonatomic, strong) NSMutableArray *imageQuestion;

@end
