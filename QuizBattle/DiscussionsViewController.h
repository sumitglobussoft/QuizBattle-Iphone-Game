//
//  DiscussionsViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCustomCell.h"

@interface DiscussionsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, passingGameDetails>
{
    NSMutableArray *arrDiscussionsTopic;
    NSMutableArray *crtdiscussnusrname;
    NSMutableArray *cmpareDate;
    NSMutableArray *mutArrUserImages;
    NSMutableArray *arrObjectIds;
}
@property (nonatomic,retain) NSArray *arrDiscussionDetails;
@property (nonatomic,retain) UITableView * discussionTable;
@end
