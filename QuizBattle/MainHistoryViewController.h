//
//  MainHistoryViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/14/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCustomCell.h"

@interface MainHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, passingGameDetails,passingGameDetailsAnotherGame,UIAlertViewDelegate>
{
    NSInteger currentSelection;
    CGRect menuCellFrame;
    UIButton *footerButton;
    BOOL isDisplayAllHistory;
    UIScrollView *scrollView;
    UIView *containerView;
    UIImageView *backgroundImage;
    UIImageView *image;
    int xAxis;
    NSArray *arrImages;
    int countImage;
    NSTimer *timer;
    NSTimer * timerAnimation;
    UILabel *lblPlayerSelection;
    UIButton * cancelBtn;
    int countTime;
    UITableView *tableHistory;
    UILabel *heading;
     UILabel * description;
    UIView * backgroundView,*upperView;
    CGFloat width,height;
    UIImageView * iconImg,* themImgView,* profileImgView,*imageVAnim,*imgViewMobile;
    UIView * topViewChallenge;
    UIButton * startGame,*cancel;
    NSMutableDictionary *dictForChallenege;
    NSString * userBlockDecStr;
    BOOL checkBot;
    UIView * rejectView;

}
@property(nonatomic,strong) UIView *footerView;
@property(nonatomic,strong) UIButton * backbtn;
@property(nonatomic,strong) NSMutableArray * categoryName,*opponenetId,*opponenetImage,*dataDescription,*categoryId;
@property(nonatomic,strong) NSMutableArray *screenShotImage;
@property(nonatomic,strong) NSArray * historyData;
-(void)backBtnAction:(id)sender;
@end
