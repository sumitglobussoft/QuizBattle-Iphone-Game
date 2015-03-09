//
//  CreateDiscussionViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 9/22/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ViewController.h"
#import "SingletonClass.h"

@interface CreateDiscussionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>
{
    NSMutableArray * compareDate;
    NSMutableArray *mutArrUserImages;
    NSMutableArray *arrObjectIds;
}
@property (nonatomic,retain) UITableView * discussionTable;
@property (nonatomic,retain) UILabel *lblHeader;
@property (nonatomic,strong) NSArray *arrDiscussionDetails;
@end
