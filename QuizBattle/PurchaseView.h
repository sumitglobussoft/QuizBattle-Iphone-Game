//
//  PurchaseView.h
//  QuizBattle
//
//  Created by GBS-mac on 9/18/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PurchaseViewPopupDelegate;

@interface PurchaseView : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    
    UILabel *lblDetailBooster;
    NSString *strSelectedButton;
    UIImageView * purcDescImage;
    UITableView *tableVBooster;
    NSArray *arrDia;
    NSArray *arrBoosters;
    NSArray *arrLife;
    UIButton *btnDiamond;
    UIButton *btnBooster;
    UIButton *btnLife;
    UIImageView * purchaseViewImage;
    NSArray *arrDiaPrice;
    NSArray *arrBoosterDetail;
    NSArray *arrLifeDetail;
    UIActivityIndicatorView *activityInd;
    NSUserDefaults *userDefault;
}
@property (nonatomic,strong) UIButton *btnClose;
@property (assign, nonatomic) id <PurchaseViewPopupDelegate>delegate;

-(id)initWithButton:(NSString*)selectedButton;
-(void)createBoosterUI;
@end


@protocol PurchaseViewPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(PurchaseView*)secondDetailViewController;
@end