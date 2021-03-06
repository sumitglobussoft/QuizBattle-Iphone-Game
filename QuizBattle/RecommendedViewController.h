//
//  RecommendedViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/12/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MessageCustomCell.h"

@interface RecommendedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, passingGameDetails> {
    
    UITableView *tableV;
    NSInteger currentSelection;
    CGRect menuCellFrame;
}
@property (nonatomic, strong) UIView *menuCellView;
@property (nonatomic, strong) UILabel *lblHeader;
@property (nonatomic, strong) UIImage *imageIcon;

@property (nonatomic, strong) NSMutableArray *arrSubCatName;
@property (nonatomic, strong) NSMutableArray *arrSubCatDesc;
@property (nonatomic, strong) NSMutableArray *arrImages;

@end
