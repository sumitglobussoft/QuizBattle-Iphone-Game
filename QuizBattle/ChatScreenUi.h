//
//  ChatScreenUi.h
//  QuizBattle
//
//  Created by GLB-254 on 12/23/14.
//  Copyright (c) 2014 GLB-254. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatScreenUi : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,QBChatDelegate,QBActionStatusDelegate>
{
    UITableView *messageTable;
}
@end
