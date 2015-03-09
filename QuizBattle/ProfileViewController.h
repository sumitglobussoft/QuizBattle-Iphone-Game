//
//  RecommendedViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/12/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Quickblox/Quickblox.h>
#import "ChatScreenMessageViewController.h"
@interface ProfileViewController : UIViewController<QBActionStatusDelegate,QBChatDelegate>
{
    
    UIScrollView * profileScroll;
    NSInteger currentSelection;
    CGRect menuCellFrame;
    float win,loose,draw;
    UIButton * block;
    float totalScore;
    UIButton * unfriend;
    UIView * showProfileImageMagnifying;
    ChatScreenMessageViewController * gotoChat;
    UIButton * chat;
    UIButton * challenge;
    UITapGestureRecognizer *tapView,*tapProfile;
    UIImageView *imageVAnim;
}
@property (nonatomic, strong) UIView *viewTotalScore;
@property (nonatomic, strong) NSNumber * noOfFriends;
@property (nonatomic, strong) UILabel *lblHeader;
@property (nonatomic) NSString * userType;
@property (nonatomic,strong) PFObject * profileUserdetail;
@property (nonatomic,strong) NSString * frndStatus,*quickBloxId;
@property (nonatomic) BOOL checkBlock,checkFrnReqSend;
@property (nonatomic, strong) UIImageView * themeImageView;
@property (nonatomic, strong) UIImageView * profileImageView;
@property (nonatomic, strong) UIImage * imageUser;
@property (nonatomic, strong) NSMutableArray *arrSubCatName,*totalScorePoints;
@property (nonatomic, strong) NSMutableArray *arrSubCatDesc;
@property (nonatomic, strong) NSMutableArray *arrImages;
@property (nonatomic,strong) NSMutableArray * subCategoryId,*subCategoryName;

@end
