//
//  FBfriendsViewController.h
//  QuizBattle
//
//  Created by Sumit Ghosh on 11/09/14.
//  Copyright (c) 2014 Sumit Ghosh. All rights reserved.
//

#import "ViewController.h"
#import "FacebookSDK/FacebookSDK.h"
#import "MessageCustomCell.h"
#import <MessageUI/MessageUI.h>
@interface FBfriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,passingGameDetails,MFMessageComposeViewControllerDelegate>
{
    UITableView *fbTableView;
    UISearchBar *searchFbFriends;
    UISearchDisplayController *displayFbFriends;
    UILabel *isSocialLabel;
    UILabel *ChallengeText;
    UIButton *fbButton;
    NSUserDefaults * userdefault;
    NSMutableArray *friendsObjectId;
    NSArray *mobilenfo;
}
@property(nonatomic,strong) NSMutableArray * fbFriendImg;
@property(nonatomic,strong) NSMutableArray * fbFriendName;
@property (nonatomic,weak) id  friendObj;

@end
