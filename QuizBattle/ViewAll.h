//
//  ViewAllViewController.h
//  QuizBattle
//
//  Created by GLB-254 on 9/10/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewAll : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger  currentSelection;
}
@property (nonatomic) UITableView *viewAll;
@property (nonatomic) UIButton *backbtn;
@end
