//
//  QuizBattleViewController.h
//  QuizBattle
//
//  Created by Sumit Ghosh on 11/09/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "ViewController.h"
#import "MessageCustomCell.h"
@class MessageCustomCell;

@interface QuizBattleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, passingGameDetails,UITextFieldDelegate>
{
   // UITableView *quizFriends;
    UISearchBar *searchQuizFriends;
    NSInteger *currentSelection;
    UILabel *noFriends;
    UIImageView *imageVAnim;
    NSArray *searchResults,*quzfrndDetails;
    NSString *strsearch,*challengeReqObjId;
    NSMutableArray *friendsImage,*searchImage;
    NSMutableArray *addfrndobjId;
    NSMutableArray *addfrndinstltionId;
    NSMutableDictionary *dictForChallenege;
    UIButton * start,*startGame,*cancel;
    UIView *topViewChallenge;
    UIImageView * profileImgView;
    bool checkSearch;
    UILabel *lblHeading;
    UIImageView * imgViewMobile;
    UILabel * description;
    UILabel *labelDesc;
    UIImageView *imgView;
    UITableView *quizFriends;
     CGFloat width,height;
   
}

@property(nonatomic,strong) UIImage *PlayerIcon;
@property (nonatomic,strong) UIImageView * iconImg,* themImgView;
@property (nonatomic,strong) NSMutableDictionary *mutDict;
@property (nonatomic,strong) NSArray * friendsDetail;
@property (nonatomic,strong) NSString * previousView;
@property (nonatomic) BOOL startButtonChallenge;
@property (nonatomic,weak) id  friendObj;

@end
