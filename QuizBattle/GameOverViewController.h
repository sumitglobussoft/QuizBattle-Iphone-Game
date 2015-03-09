//
//  GameOverViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 9/10/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "GamePLayMethods.h"
@protocol GameOverViewControllerDelegate <NSObject>

-(void) dismissOwnerView;

@end

@interface GameOverViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,passingGameDetailsAnotherGame>
{
   
    int xAxis;
    UITableView *topicsTableV;
    UIScrollView *mainScrollView;
    NSTimer * timerAnimation;
    UIView *viewWin;
    UIView *viewScore;
    UIView *viewMatchdetails;
    UIView *viewScreenshot;
    UIView *viewTopics;
    NSMutableArray *arrTopics;
    NSArray *arrImages;
     UIScrollView *scrollView;
    UILabel *lblScore;
    UILabel *lblPlayerSelection;
    BOOL pageControlUsed;
    UIImageView *imageView;
     UIImageView *image;
     int countImage;
    int count;
    NSNumber * previousPoint;
    UIButton * cancelBtn;
    NSArray *arrColors;
    UIView * rejectView;
    UIImageView * imageVAnim;
    UIPageControl *pageController;
    UIScrollView *scrollViewPaging;
    UIView * backgroundView,*upperView;
    UIImageView * arrow_Image;
}
@property (nonatomic, weak) id <GameOverViewControllerDelegate> delegate;
@property (nonatomic) GraphView *graphView;
@property (nonatomic) BOOL gameLeft;
@property (nonatomic, strong) NSMutableArray *arrScreenShots;
@property (nonatomic, strong) NSMutableArray *arrScorePlayer1;
@property (nonatomic, strong) NSMutableArray *arrScorePlayer2;
@property (nonatomic, strong) NSString *strStatus;
@property (nonatomic, strong) NSMutableDictionary *gameOverPlayer1Det;
@property (nonatomic, strong) NSMutableDictionary *gameOverPlayer2Det;
@property (nonatomic, strong) NSString *lblPlayersStat,*resultFromHistory;
@end
