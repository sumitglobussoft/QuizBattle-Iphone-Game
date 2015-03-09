//
//  SubCategoryViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/14/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCustomCell.h"
#import "GamePLayMethods.h"

@interface SubCategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, passingGameDetails,passingGameDetailsAnotherGame> {
    
    NSInteger currentSelection;
    CGRect menuCellFrame;
    UITableView *tableV;
}

@property (nonatomic, strong) NSString *selectedCategoryID;

@property (nonatomic, strong) UIView *menuCellView;
@property (nonatomic, strong) UILabel *lblHeader;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) NSArray *arrDescription;
@property (nonatomic, strong) NSMutableArray *arrSubCatId,*batteryName,*gradeName;
@property (nonatomic, strong) NSArray *arrPopScore;
@property (nonatomic, strong) NSArray *arrObjectId;
@property (nonatomic)   NSArray *arrGradeDetails;

@property (nonatomic, strong) UIImage *imageIcon;

@end