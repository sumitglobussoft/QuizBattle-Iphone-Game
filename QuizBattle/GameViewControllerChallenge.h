//
//  GameViewControllerChallenge.h
//  QuizBattle
//
//  Created by GBS-mac on 10/1/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewControllerChallenge : UIViewController {
    
    UILabel *lblOptionA;
    UILabel *lblOptionB;
    UILabel *lblOptionC;
    UILabel *lblOptionD;
    UILabel *lblTimer;
    UILabel *lblPointPlayer1;
    UILabel *lblPointPlayer2;
    int gamePointPlayer1;
    UILabel *lblRound;
    int time;
    int questionNum;
    int numOfCorrectAnswer;
    int numOfWrongAnswer;
    int numOfCorrectAnswerPlayer2;
    int numOfWrongAnswerPlayer2;
    int pointsForAnswerPlayer1;
    NSTimer *timer,*timerForBombAnimation;
    NSString *strCorrectAns;
    NSArray *arrQues;
    UIImageView *imageProgressBarPlayer1;
    UIImageView *imageProgressBarPlayer2;
    UIImageView *quesImage;
    NSMutableDictionary *dictQuestions;
    UILabel *lblSecPlayerOption;
    NSString *strFirstPlayerSelAns;
    NSString *strSecPlayerSelAns;
    NSArray *arrOptions;
    NSMutableArray *arrScreenshotImages;
    NSMutableArray *arrPlayer1Scores;
    BOOL checkAnswer;
    NSTimer * timerAnimation;
    int pointForQues;
    int xAxis;
    int bombImageNumber;
    UIImageView *imageVAnim;
    NSMutableArray *mutArrAnswers;
    NSMutableArray *answersPlayer2;
    NSMutableArray *scoresPlayer2;
    NSMutableArray *totalScoreForPlayer2;
    UIImageView *batterImageView;
    int sumFirstPlayer,sumSecondPlayer;
}

@property (nonatomic, retain)UILabel *lblQues;
@property (nonatomic, strong) NSDictionary *arrPlayerDetail;
@property (nonatomic,strong) NSNumber *totalScoreOpponent;
@property (nonatomic,strong) NSString * challengeReqObjId,*gameResultObjectId;
@property (nonatomic,strong) NSArray * opponenetScore,*questionsData;
@end
