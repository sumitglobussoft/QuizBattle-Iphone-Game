//
//  ContactsViewController.h
//  QuizBattle
//
//  Created by Sumit Ghosh on 11/09/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "ViewController.h"

@interface ContactsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *requestTableView;
    NSMutableArray *reqSenderName;
    NSMutableArray *reqSenderImg;
    NSInteger currentSelection;
    NSMutableArray *reqObjectIds;
    NSMutableArray *frndreqObjectIds;
    NSMutableArray *arrUsername;
    
}

@end
