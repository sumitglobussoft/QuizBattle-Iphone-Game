//
//  GameOverViewControllerChallenge.h
//  QuizBattle
//
//  Created by GBS-mac on 10/1/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
@interface GameOverViewControllerChallenge : UIViewController<UIScrollViewDelegate> {
    
    UITableView *topicsTableV;
    UIScrollView *mainScrollView;
     UIView *viewScore,*viewMatchdetails;
    UIView *viewWin;
    UIView *viewScreenshot;
    UIView *viewTopics;
     UILabel *lblScore;
    NSMutableArray *arrTopics;
    NSArray *arrImages;
    
    BOOL pageControlUsed;
    UIImageView *imageView,*imageVAnim;
    
    int count;
    NSArray *arrColors;
}
@property (nonatomic) GraphView *graphView;
@property (strong, nonatomic) UIPageControl *pageController;
@property (nonatomic, strong) UIScrollView *scrollViewPaging;
@property (nonatomic, strong) NSMutableArray *arrScreenShots;
@property (nonatomic, strong) NSMutableArray *arrScorePlayer1;
@property (nonatomic, strong) NSMutableArray *arrScorePlayer2;
@property (nonatomic, strong) NSString *strStatus;
@property (nonatomic, strong) NSMutableDictionary *gameOverPlayer1Det;

@end
