//
//  ChatMessageView.h
//  QuizBattle
//
//  Created by GLB-254 on 9/22/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageView : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIView * typeMsg;
    NSMutableArray *arrUserIds;
    NSMutableArray *mutArrUserImages;
    NSMutableArray *createdDate;
}
@property (nonatomic,retain) UITableView * messageTable;
@property (nonatomic,retain) NSMutableArray * messages;
@property (nonatomic) UITextField * msgType;
@property (nonatomic,retain) UILabel *lblDiscussionTopic;
@property (nonatomic,retain) UILabel *lblHeader;
@property (nonatomic,retain) NSArray *arrFetchDetails;
@property (nonatomic,retain) NSArray *arrNewFetchDetails;
@property (nonatomic,retain) NSString *disTopic,*disName,*imageUrl;
-(void)displayDiscussionChat;
@end
