//
//  ChatScreenMessageViewController.h
//  QuizBattle
//
//  Created by GLB-254 on 11/4/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
@interface ChatScreenMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,QBChatDelegate,QBActionStatusDelegate>
{
    UIView * typeMsg;
    BOOL senderFlag;
    UITableView * messageTable;
    UITextField * msgType;
   QBChatMessage *messageG;
}
@property (nonatomic,retain) NSMutableArray * messages;
@property (nonatomic,retain) NSArray * historyMessages;
@property (nonatomic,strong) UIImage * opponenetImage;
@property (nonatomic,strong) NSString * dialogId,*reciepentId,*previousView;
@end
