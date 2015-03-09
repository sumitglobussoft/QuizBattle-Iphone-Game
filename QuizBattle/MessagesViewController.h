//
//  MessagesViewController.h
//  QuizBattle
//
//  Created by GBS-mac on 8/9/14.
//  Copyright (c) 2014 GBS-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
@interface MessagesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,QBChatDelegate,QBActionStatusDelegate>
{
    UITableView *messageTable;
    UITableView *readMessageTable;
    UITableView *unreadMessageTable;
    NSMutableArray *unreadMessages;
    NSMutableArray *readMessages;
    NSMutableArray *senderName;
    NSMutableArray *timeDuration;
    NSMutableArray *playerImages;
    UIImageView *imageVAnim;
    UIView * nomessageView;
     CGSize frameSize;
}
@property (nonatomic,strong)NSArray *dialogIds,*userDetailMessage;
@end
