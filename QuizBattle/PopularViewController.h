//
//  PopularViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/12/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCustomCell.h"
#import "GamePLayMethods.h"
@interface PopularViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, passingGameDetails,passingGameDetailsAnotherGame> {
    
    UITableView *tableV;
    UILabel * notPlayedLabel;
    NSInteger currentSelection;
    CGRect menuCellFrame;
    NSMutableArray * gradeName;
}
@property (nonatomic, strong) UIView *menuCellView;
@property (nonatomic, strong) UILabel *lblHeader;
@property (nonatomic, strong) UIImage *imageIcon;
@property (nonatomic,strong) NSArray * gradeDataDetail;
@property (nonatomic, strong) NSMutableArray *arrSubCatName;
@property (nonatomic, strong) NSMutableArray *arrSubCatDesc;
@property (nonatomic, strong) NSMutableArray *arrImages;

@end
