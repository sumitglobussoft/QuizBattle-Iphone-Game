//
//  StoreViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseView.h"
@interface StoreViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSString *strSelectedButton;
    NSArray *arrDia;
    NSArray *arrBoosters;
    NSArray *arrLife;
    NSArray *arrDiaPrice;
    NSArray *arrBoosterDetail;
    NSArray *arrLifeDetail;
    NSUserDefaults *userDefault;
    UITableView *tableVBooster;
    UIButton *btnDiamond;
    UIButton *btnBooster;
    UIButton *btnLife;
    UIImageView * purchaseViewImage;
    UIImageView * purcDescImage;
    UIActivityIndicatorView *activityInd;
}

@end
