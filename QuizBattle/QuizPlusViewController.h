//
//  QuizPlusViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 9/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCustomCell.h"

@interface QuizPlusViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, passingGameDetails> {
    
    UITableView *subCategoryTable;
    NSArray *gradeTableData;
    UIView * rejectView;
}

@end
