//
//  TopicsViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicsViewController : UIViewController< UITabBarDelegate , UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
{
    BOOL searchTopic;
    UITabBarController *topicsTabbar;
    NSInteger currentSelection;
    NSArray * searchArray;
    CGSize frameSize;
}

@property (nonatomic, strong) NSArray *allTopicArrays;
@property (nonatomic) UITableView *categoryTabelView;
@end
