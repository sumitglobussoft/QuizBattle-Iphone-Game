//
//  AllTopicsViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/12/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllTopicsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    
    UITableView *topicsTableV;
    NSMutableArray *arrTopics;
    NSMutableArray *arrImages;
    NSArray *arrData;
    NSMutableArray *searchData;
    NSArray *arrObjects;
    
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    NSMutableArray *mutArrCatIds;
}

@end
