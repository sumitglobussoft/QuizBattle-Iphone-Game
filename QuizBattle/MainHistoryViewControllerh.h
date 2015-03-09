//
//  MainHistoryViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/14/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger currentSelection;
    CGRect menuCellFrame;
    UIButton *footerButton;
    NSArray * dataHistory,*imageHistory,*dataDescription,*plyravtrImages;
}
@property(nonatomic,strong) UITableView *tableHistory;
@property(nonatomic,strong) UILabel *heading;
@property(nonatomic,strong) UIButton * backbtn;
@end
