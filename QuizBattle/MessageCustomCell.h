//
//  MessageCustomCell.h
//  WooSuiteApp
//
//  Created by Sumit Ghosh on 21/10/13.
//  Copyright (c) 2013 Globussoft 1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GamePLayMethods.h"
#import "CreateDiscussionViewController.h"

@class MessageCustomCell;
@protocol passingGameDetails <NSObject>

@optional
-(void)gameDetails:(NSDictionary*)details;
-(void)gameDetailsForChallenge:(NSDictionary*)details;
@end

@interface MessageCustomCell : UITableViewCell<UIScrollViewDelegate,passingGameDetailsAnotherGame> {
    
    UIScrollView *scrollView;
    UIView *containerView;
    UIImageView *backgroundImage;
    UIImageView *image;
    int xAxis;
    NSArray *arrImages;
    int countImage;
    NSTimer *timerForbotPlayer;
    
    UILabel *lblPlayerSelection;
    
    NSString *strObjectId;
    int countTime;
   
    UIButton *cancelBtn;
    UIImageView *imageVAnim;
}


@property (nonatomic, weak) id <passingGameDetails>gameDelegate;
@property (nonatomic,strong) UIButton *btnAccept,*btnReject;
@property (nonatomic, strong) UILabel *messageLable,* gradeName;
@property (nonatomic, strong) UILabel *lblDescription;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic,strong) UIButton *btnRematch,*btnPlay,*btnRanking,*btnResult,*btnChallenge,*btnDiscussion;
@property (nonatomic ,strong) UIImageView *menuView;
@property (nonatomic,strong) UISwitch * aSwitch;
@property (nonatomic,strong) UIImageView * iconImg,* themImgView,* profileImgView;
@property (nonatomic,strong) UIButton *pickCategoryButton;
@property (nonatomic ,strong) UIButton *playNowButton;
@property (nonatomic ,strong) UIButton *challengeButton,*addFriendButton;
@property (nonatomic ,strong) UIButton *rankingButton;
@property (nonatomic ,strong) UIButton *discussionButton,*btnAddQues;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *upperView;
@property (nonatomic,strong) UILabel *message;
@property(nonatomic,strong) UIButton *challengeFriendButton;
@property(nonatomic,strong) UIImageView *playerImageIcon,*batteryImage;
@property (nonatomic, strong) UIView *topViewChallenge;
@property (nonatomic,strong) NSMutableDictionary *mutDict;
@property (nonatomic) BOOL startButtonChallenge;
@property (nonatomic, strong) CreateDiscussionViewController *obj;
@end
