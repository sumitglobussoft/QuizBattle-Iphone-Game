//
//  HomeViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCustomCell.h"
#import "GamePLayMethods.h"
#import "SettingsViewController.h"
#import "PurchaseView.h"
#import "UIViewController+MJPopupViewController.h"

@class MessageCustomCell;

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, passingGameDetails,passingGameDetailsAnotherGame,PurchaseViewPopupDelegate>
{
    UITableView *homescreen;
    UITableView * rollAndDicetable;
    UITableView * editorialTable;
    UITableView * PersonalizedTable;
    NSInteger editSelection,perSelection,rollSelection;
    NSArray * arrObjectsRecom;
    NSArray *desFirstTable,*desSecondTable,*desThirdTable;
    NSArray *imgFirstTable,*imgSecondTable,*imgThirdTable;
    SettingsViewController * obj;
    UISegmentedControl  *segEditorial,*segPersonalized;
    MessageCustomCell * cell1;
    BOOL per,edit,roll;
    BOOL segmentEdit1,segmentEdit2,segmentEdit3;
    BOOL segmentPer1,segmentPer2;
    CGSize frameSize;
    NSString * gameResultObjId,*challTableObjId;;
    NSString * gradeName,*badgeName;
    NSArray * challUserScore;
    UILabel *headerLabel;
    UILabel *headerLabelRollDice;
    UILabel *headerLabelEdit;
    UIView * rejectView;
    UIImageView * badgeImage;
    int rowSelected;
    float progress;
}

@property (nonatomic,strong) SettingsViewController *settingObjc;
@property (nonatomic,strong) NSArray * rankingDetail;
@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic, strong) NSMutableArray * arrSubCatName;
@property (nonatomic, strong) NSMutableArray * arrSubCatDesc;
@property (nonatomic, strong) NSMutableArray * arrImages;
@property (nonatomic,strong) NSArray * staffPick,* contentNew, * recentlyPlayed,*subCataData;
@property (nonatomic,strong) NSArray * recommend,* popularity;
@property(nonatomic)UINavigationController * navController;
@property(nonatomic)NSMutableDictionary * dictForChallenege;
@end
