//
//  Ranking.h
//  QuizBattle
//
//  Created by GLB-254 on 11/3/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
@interface Ranking : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CGSize frameSize;
    NSMutableArray *frndStatus;
    ProfileViewController * profileUser;
}
@property (nonatomic,strong) UITableView * rankTable;
@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,strong) NSArray *rankingDetail;
@end
