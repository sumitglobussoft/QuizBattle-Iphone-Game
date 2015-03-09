//
//  ViewAllViewController.h
//  QuizBattle
//
//  Created by GLB-254 on 9/10/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCustomCell.h"

@interface HomeViewAllSubCategories : UIViewController<UITableViewDataSource,UITableViewDelegate,passingGameDetails,passingGameDetailsAnotherGame>
{
    NSInteger  currentSelection;
}
@property (nonatomic) UITableView *viewAll;
@property (nonatomic) NSArray * viewAllDetail;
@property (nonatomic) UIButton *backbtn;
@property (nonatomic) NSString *segName;
@end
